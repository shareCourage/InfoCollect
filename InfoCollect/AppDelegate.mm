//
//  AppDelegate.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

//高德地图
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

//UMeng
#import "MobClick.h"
#import "MobClickSocialAnalytics.h"

#import "AppDelegate.h"
#import "PHCourier.h"

@interface AppDelegate ()
{
    BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self UMengSetUp];
    [self BMKSetUp];
    [self AMapSetUp];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self rootViewControllerInitial];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}

- (void)rootViewControllerInitial {
    if ([PHTool loginEnable]) {
        [PHTool setHomeViewControllerForRoot];
        [self loginInitial];
    } else {
        [[PHUseInfo sharedPHUseInfo] setPropertyNil];
        [PHTool setLoginViewControllerForRoot];
    }
}

- (void)loginInitial {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([PHUseInfo sharedPHUseInfo].userName) {
        [param setObject:[PHUseInfo sharedPHUseInfo].userName forKey:kArgu_identityCardId];
    }
    if ([PHUseInfo sharedPHUseInfo].userCode) {
        [param setObject:[PHUseInfo sharedPHUseInfo].userCode forKey:kArgu_pwd];
    }
    [self loginRequest:param];
}

- (void)loginRequest:(NSDictionary *)param {
    [EBNetworkRequest GET:kUrl_login parameters:param dictBlock:^(NSDictionary *dict) {
        NSDictionary *resultD = dict[kArgu_result];
        NSNumber *value = resultD[kArgu_success];
        if ([value boolValue]) {
            [[PHUseInfo sharedPHUseInfo] setPropertyValue:dict];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PHLoadedCourierInfoNotification object:nil];
            });
        } else {
            [[PHUseInfo sharedPHUseInfo] setPropertyNil];
        }
    } errorBlock:nil];
}

- (void)UMengSetUp {
    [MobClick startWithAppkey:Argu_KeyOfUMeng reportPolicy:BATCH channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setEncryptEnabled:YES];
    [MobClick setBackgroundTaskEnabled:YES];
}

- (void)BMKSetUp {
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:Argu_KeyOfBMK  generalDelegate:nil];
    if (!ret) {
        PHLog(@"manager start failed!");
    } else {
        PHLog(@"manager start success!");
    }
}

- (void)AMapSetUp {
    [MAMapServices sharedServices].apiKey = Argu_KeyOfAMap;//高德地图key验证
    [AMapSearchServices sharedServices].apiKey = Argu_KeyOfAMap;//高德地图key验证
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
