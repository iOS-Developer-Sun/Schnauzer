//
//  SchnauzerToolKit.m
//  SchnauzerToolKit
//
//  Created by Poodle on 6/5/22.
//  Copyright © 2022 Poodle. All rights reserved.
//

#import "SchnauzerToolKit.h"
#import "SNZNonThreadSafeAnalyzer.h"

@interface SchnauzerToolKit : NSObject

@end

@implementation SchnauzerToolKit

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SNZNonThreadSafeAnalyzer checkProperties:nil];
    });
}

@end
