//
//  SNZNonThreadSafeAnalyzer.h
//  Schnauzer
//
//  Created by Schnauzer on 2021/12/17.
//  Copyright © 2019 Schnauzer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNZNonThreadSafeAnalyzer : NSObject

@property (nonatomic, assign, class) BOOL logEnabled;

+ (NSArray *)suspiciousItems;
+ (NSDictionary *)suspiciousItemsMap;

+ (void)checkProperties:(BOOL(^_Nullable)(NSString *className, NSString *_Nullable propertyName))exclusion;
+ (void)checkDictionary;

@end

NS_ASSUME_NONNULL_END
