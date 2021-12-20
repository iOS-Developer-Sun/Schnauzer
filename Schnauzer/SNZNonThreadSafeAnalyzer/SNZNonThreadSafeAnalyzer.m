//
//  SNZNonThreadSafeAnalyzer.m
//  Schnauzer
//
//  Created by Schnauzer on 2021/12/17.
//  Copyright © 2019 Schnauzer. All rights reserved.
//

#import "SNZNonThreadSafeAnalyzer.h"
#import "PDLNonThreadSafeObserver.h"
#import "PDLNonThreadSafePropertyObserver.h"
#import "PDLNonThreadSafeDictionaryObserver.h"
#import "NSObject+PDLAssociation.h"

@interface SNZNonThreadSafeAnalyzerObserverChecker : PDLNonThreadSafeObserverChecker

@end

@implementation SNZNonThreadSafeAnalyzerObserverChecker

- (void)recordAction:(PDLNonThreadSafeObserverAction *)action {
    [super recordAction:action];

    static const void *key = &key;
    PDLBacktrace *bt = [[PDLBacktrace alloc] init];
    [bt record];
    [action pdl_setAssociatedObject:bt forKey:key policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

@end

@implementation SNZNonThreadSafeAnalyzer

static BOOL _logEnabled = NO;
+ (BOOL)logEnabled {
    return _logEnabled;
}
+ (void)setLogEnabled:(BOOL)logEnabled {
    _logEnabled = logEnabled;
}

static NSMutableDictionary *SNZNonThreadSafeAnalyzerMap(void) {
    static NSMutableDictionary *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NSMutableDictionary dictionary];
        [PDLNonThreadSafeObserver setIgnored:YES forObject:_instance];
    });
    return _instance;
}

+ (NSArray *)suspiciousItems {
    NSArray *array = [[SNZNonThreadSafeAnalyzerMap() allKeys] sortedArrayUsingSelector:@selector(compare:)];
    return array;
}

+ (NSDictionary *)suspiciousItemsMap {
    return [SNZNonThreadSafeAnalyzerMap() copy];
}

NSMutableSet *PDLDebugNonThreadSafeDictionaries(void) {
    static NSMutableSet *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NSMutableSet set];
    });
    return _instance;
}

+ (void)report:(PDLNonThreadSafeObserverCriticalResource *)resource {
    @synchronized (self) {
        if ([resource isKindOfClass:[PDLNonThreadSafePropertyObserverProperty class]]) {
            PDLNonThreadSafePropertyObserverProperty *property = (PDLNonThreadSafePropertyObserverProperty *)resource;
            NSMutableDictionary *dictionary = SNZNonThreadSafeAnalyzerMap();
            NSMutableSet *set = dictionary[property.identifier];
            if (!set) {
                set = [NSMutableSet set];
                dictionary[property.identifier] = set;
                if ([self logEnabled]) {
                    NSLog(@"[SNZNonThreadSafeAnalyzer][Properties]\n%@", property);
                    NSLog(@"\n");
                }
            }
            if (![set containsObject:property]) {
                if ([self logEnabled]) {
                    NSLog(@"[SNZNonThreadSafeAnalyzer][Property Object]\n%@", property);
                    NSLog(@"\n");
                }
            }
            [set addObject:property];
        } else if ([resource isKindOfClass:[PDLNonThreadSafeDictionaryObserverDictionary class]]) {
            if ([self logEnabled]) {
                NSLog(@"[SNZNonThreadSafeAnalyzer][Dictionary]\n%@", resource);
                NSLog(@"\n");
            }
            PDLNonThreadSafeDictionaryObserverDictionary *dictionary = (PDLNonThreadSafeDictionaryObserverDictionary *)resource;
            [PDLDebugNonThreadSafeDictionaries() addObject:dictionary];
        }
    }
}

+ (void)preload {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PDLNonThreadSafeObserver registerQueueCheckerEnabled:YES];

        [PDLNonThreadSafeObserver registerReporter:^(PDLNonThreadSafeObserverCriticalResource * _Nonnull resource) {
            [self report:resource];
        }];

        [PDLNonThreadSafeObserver registerCheckerClass:[SNZNonThreadSafeAnalyzerObserverChecker class]];
    });
}

+ (void)checkProperties:(BOOL(^)(NSString *className, NSString *propertyName))exclusion {
    [self preload];

    NSMutableArray *imageArray = [NSMutableArray array];
    const char *image = class_getImageName(self);
    NSString *imageName = @(image);
    [imageArray addObject:imageName];

    NSString *prefix = imageName.stringByDeletingLastPathComponent;
    unsigned int outCount = 0;
    const char **imageNames = objc_copyImageNames(&outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        NSString *name = @(imageNames[i]);
        if ([name hasPrefix:prefix]) {
            [imageArray addObject:name];
        }
    }
    free(imageNames);

    for (NSString *image in imageArray) {
        [PDLNonThreadSafePropertyObserver observerClassesForImage:image.UTF8String classFilter:^BOOL(NSString * _Nonnull className) {
            return exclusion(className, nil);
        } classPropertyFilter:^PDLNonThreadSafePropertyObserver_PropertyFilter _Nullable(NSString * _Nonnull className) {
            BOOL excluded = exclusion(className, nil);
            if (excluded) {
                return ^BOOL (NSString *propertyName) {
                    return YES;
                };
            }
            return ^BOOL (NSString *propertyName) {
                return exclusion(className, propertyName);
            };
        } classPropertyMapFilter:nil];
    }
}

+ (void)checkDictionary {
    [self preload];

    NSArray *dictionaryFilter = @[
        @"__34+[BSServiceManager sharedInstance]_block_invoke",
        @"_CFNetworkHTTPConnectionCacheSetLimit",

        @"_dispatch_client_callout",
        @"_dispatch_client_callout3",
        @"CFNetServiceBrowserSearchForServices",
        @"_CFURLCachePersistMemoryToDiskNow",
        @"-[FBSWorkspaceScenesClient initWithEndpoint:queue:calloutQueue:workspace:]",
        @"+[BSXPCServiceConnectionPeer peerOfConnection:]",
    ];

    NSArray *invalidFrames = @[
        @"<redacted>",
        @"+[NSDictionary dictionary]",
        @"+[NSDictionary dictionaryWithObject:forKey:]",
        @"__createDictionary",
    ];

    [PDLNonThreadSafeDictionaryObserver enableWithFilter:^BOOL(PDLBacktrace *backtrace, NSString **name) {
        __block NSString *firstFrame = nil;
        [backtrace enumerateFrames:^(NSInteger index, void *address, NSString *symbol, NSString *image, BOOL *stops) {
            if (symbol.length > 0 && ![invalidFrames containsObject:symbol]) {
                firstFrame = symbol;
                *stops = YES;
            }
        }];
        if (firstFrame.length > 0 && [dictionaryFilter containsObject:firstFrame]) {
            return YES;
        }

        if (name) {
            *name = firstFrame;
        }
        return NO;
    }];
}

@end

