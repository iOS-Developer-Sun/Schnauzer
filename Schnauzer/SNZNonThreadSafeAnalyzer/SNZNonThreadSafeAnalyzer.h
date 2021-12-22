//
//  SNZNonThreadSafeAnalyzer.h
//  Schnauzer
//
//  Created by Schnauzer on 2021/12/17.
//  Copyright © 2019 Schnauzer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNZNonThreadSafeAnalyzer : NSObject

@property (nonatomic, assign, class) BOOL logEnabled;

+ (NSArray *)suspiciousProperties;
+ (NSDictionary *)suspiciousPropertiesMap;

+ (NSArray *)suspiciousDictionaries;

+ (void)checkProperties:(BOOL(^_Nullable)(NSString *className, NSString *_Nullable propertyName))exclusion;
+ (void)checkDictionary:(BOOL(^_Nullable)(NSString *_Nullable frame))exclusion;

@end

NS_ASSUME_NONNULL_END
