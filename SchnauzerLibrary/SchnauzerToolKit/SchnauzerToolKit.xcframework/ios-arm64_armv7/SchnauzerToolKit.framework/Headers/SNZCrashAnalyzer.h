//
//  SNZCrashAnalyzer.h
//  Schnauzer
//
//  Created by Schnauzer on 2021/12/17.
//  Copyright © 2019 Schnauzer. All rights reserved.
//

#import <UIKit/UIKit.h>

/*

// Info.plist

<key>CFBundleDocumentTypes</key>
<array>
<dict>
<key>CFBundleTypeName</key>
<string>crash</string>
<key>LSHandlerRank</key>
<string>Default</string>
<key>LSItemContentTypes</key>
<array>
<string>public.data</string>
</array>
</dict>
</array>

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if ([url isFileURL] && options[UIApplicationOpenURLOptionsOpenInPlaceKey]) {
        [SNZCrashAnalyzer handleCrashFile:url.path];
    }
    return YES;
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    for (UIOpenURLContext *context in URLContexts) {
        NSURL *url = context.URL;
        if ([url isFileURL]) {
            [SNZCrashAnalyzer handleCrashFile:url.path];
        }
    }
}

 */

@interface SNZCrashAnalyzer : NSObject

@property (nonatomic, copy, class) void(^presenter)(NSArray <__kindof UIViewController *> *viewControllers);

+ (void)handleCrashFile:(NSString *)path;
+ (void)present:(NSArray <__kindof UIViewController *> *)viewControllers;

@end
