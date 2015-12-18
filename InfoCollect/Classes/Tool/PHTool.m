//
//  PHTool.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define kLoginExperiedTime (12 * 60 * 60)
#import "PHTool.h"
#import "AppDelegate.h"
#import "PHNavigationController.h"
#import "PHLoginController.h"
#import "PHHomeController.h"

@implementation PHTool

+ (BOOL)loginEnable {
    NSDate *loginDate = [PHUseInfo sharedPHUseInfo].loginDate;
    if (!loginDate) return NO;//表示从来没有登录过
    NSDate *nowDate = [NSDate date];
    NSTimeInterval value = [nowDate timeIntervalSinceDate:loginDate];
    PHLog(@"%@",@(value));
    if (value > kLoginExperiedTime) {
        return NO;
    } else {
        return YES;
    }
}

+ (void)setRootViewController:(UIViewController *)vc {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = vc;
}

+ (void)setHomeViewControllerForRoot {
    PHHomeController *home = [[PHHomeController alloc] init];
    home.title = @"信息录入";
    PHNavigationController *navi = [[PHNavigationController alloc] initWithRootViewController:home];
    [self setRootViewController:navi];
}

+ (void)setLoginViewControllerForRoot {
    PHLoginController *login = [[PHLoginController alloc] init];
    login.title = @"登录";
    [self setRootViewController:login];
}

+ (BOOL)isiPhone4s {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height > 480) return NO;
    return YES;
}

+ (BOOL)lowerThaniPhone5s {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (width > 320) return NO;
    return YES;
}

@end



