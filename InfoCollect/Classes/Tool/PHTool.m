//
//  PHTool.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHTool.h"
#import "AppDelegate.h"
#import "PHNavigationController.h"
#import "PHLoginController.h"
#import "PHHomeController.h"

@implementation PHTool

+ (BOOL)loginEnable {
    NSString *userName = [PHUseInfo sharedPHUseInfo].userName;
    NSString *userCode = [PHUseInfo sharedPHUseInfo].userCode;
    if (userName.length != 0 && userCode.length != 0) {
        return YES;
    }
    return NO;
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

@end



