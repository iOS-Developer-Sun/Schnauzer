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
#import "PDLFileSystemViewController.h"
#import "UIViewController+PDLNavigationBar.h"

@implementation SNZCrashAnalyzer

static __weak UIViewController *_currentViewController = nil;
static void (^_presenter)(NSArray <__kindof UIViewController *> *)  = nil;
+ (void (^)(NSArray <__kindof UIViewController *> *))presenter {
    return _presenter;
}
+ (void)setPresenter:(void (^)(NSArray <__kindof UIViewController *> *))presenter {
    _presenter = [presenter copy];
}

+ (void)present:(NSArray <UIViewController *>*)viewControllers {
    if (self.presenter) {
        self.presenter(viewControllers);
        return;
    }

    if (viewControllers.count == 0) {
        return;
    }

    UINavigationController *nav = [[UINavigationController alloc] init];
    nav.viewControllers = viewControllers;

    UIViewController *root = viewControllers.firstObject;
    [root pdl_setLeftButtonWithTitle:@"Exit" target:self action:@selector(exitViewController)];
    _currentViewController = root;

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:nav animated:YES completion:nil];
}

+ (void)exitViewController {
    [_currentViewController dismissViewControllerAnimated:YES completion:nil];
    _currentViewController = nil;
}

+ (void)handleCrashFile:(NSString *)path {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"File Saved" message:path.lastPathComponent preferredStyle:UIAlertControllerStyleAlert];
    if ([path.pathExtension isEqualToString:@"ips"] || [path.pathExtension isEqualToString:@"synced"]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"Analyze" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            PDLFileSystemViewController *fs = [[PDLFileSystemViewController alloc] init];
            PDLDirectoryViewController *dir = [[PDLDirectoryViewController alloc] initWithDirectory:[path stringByDeletingLastPathComponent]];
            PDLCrashViewController *viewController = [[PDLCrashViewController alloc] initWithPath:path];
            [self present:@[fs, dir, viewController]];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"Locate" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PDLFileSystemViewController *fs = [[PDLFileSystemViewController alloc] init];
        PDLDirectoryViewController *dir = [[PDLDirectoryViewController alloc] initWithDirectory:[path stringByDeletingLastPathComponent]];
        [self present:@[fs, dir]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

@end
