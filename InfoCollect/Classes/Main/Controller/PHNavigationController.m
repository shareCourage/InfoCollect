//
//  PHNavigationController.m
//  FamilyCare
//
//  Created by Kowloon on 15/2/27.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHNavigationController.h"

@interface PHNavigationController ()

@end

@implementation PHNavigationController
- (void)dealloc
{
    PHLog(@"%@->dealloc",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
/**
 *  系统在第一次使用这个类的时候调用(1个类只会调用一次)
 */
+ (void)initialize
{
    
    // 设置导航栏主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 设置背景图片
    NSString *bgName = nil;
    if (kiOS7) { // 至少是iOS 7.0
        bgName = @"naviBg";
        navBar.tintColor = [UIColor whiteColor];// [UIColor grayColor];//改变返回键的颜色
    } else { // 非iOS7
        bgName = @"naviBg";
    }
    [navBar setBackgroundImage:[UIImage resizedImageWithName:bgName] forBarMetrics:UIBarMetricsDefault];
    
    // 设置标题文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    if (kiOS7) {
        attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    }
    else{
#ifndef __IPHONE_5_0
        attrs[UITextAttributeTextColor] = [UIColor grayColor];
        attrs[UITextAttributeFont] = [UIFont systemFontOfSize:18];
#endif
    }
    [navBar setTitleTextAttributes:attrs];
    
    // 2.设置BarButtonItem的主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置文字颜色
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    [item setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

/**
 *  重写这个方法,能拦截所有的push操作
 *
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

@end





