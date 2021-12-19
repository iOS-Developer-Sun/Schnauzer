//
//  SNZCrashAnalyzer.m
//  Schnauzer
//
//  Created by Schnauzer on 2021/12/17.
//  Copyright © 2019 Schnauzer. All rights reserved.
//

#import "SNZCrashAnalyzer.h"
#import "PDLCrashViewController.h"
#import "PDLDirectoryViewController.h"
#import "UIViewController+PDLNavigationBar.h"

@implementation SNZCrashAnalyzer

+ (void)present:(UIViewController *)viewController {
    if (self.presenter) {
        self.presenter(viewController);
        return;
    }

    if (!viewController) {
        return;
    }

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [nav pdl_setRightButtonWithTitle:@"Exit" target:self action:@selector(exitViewController:)];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:nav animated:YES completion:nil];
}

+ (void)exitViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

static void (^_presenter)(UIViewController *)  = nil;
+ (void (^)(UIViewController *))presenter {
    return _presenter;
}
+ (void)setPresenter:(void (^)(UIViewController *))presenter {
    _presenter = [presenter copy];
}

+ (void)handleCrashFile:(NSString *)path {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"File Saved" message:path.lastPathComponent preferredStyle:UIAlertControllerStyleAlert];
    if ([path.pathExtension isEqualToString:@"ips"] || [path.pathExtension isEqualToString:@"synced"]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"Analyze" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            PDLCrashViewController *viewController = [[PDLCrashViewController alloc] initWithPath:path];
            [self present:viewController];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"Locate" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PDLDirectoryViewController *viewController = [[PDLDirectoryViewController alloc] initWithDirectory:[path stringByDeletingLastPathComponent]];
        [self present:viewController];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

@end
