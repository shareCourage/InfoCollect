//
//  PHTool.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PHUseInfo.h"
#import "PHKeyValueObserver.h"

#import "UIGestureRecognizer+YYAdd.h"
#import "UIControl+YYAdd.h"
#import "NSArray+MySeperateString.h"
#import "NSDictionary+PHCategory.h"
#import "UIButton+PHCategory.h"
#import "UIButton+EBButton.h"
#import "UILabel+PHCategory.h"
#import "NSDate+PHCategory.h"
#import "UIProgressView+PHCategory.h"
#import "UISlider+PHCategory.h"
#import "NSNumber+PHCategory.h"
#import "UIImage+PHCategory.h"
#import "UITextField+PHCategory.h"
#import "NSString+PHCategory.h"
#import "MBProgressHUD+MJ.h"
#import "UIViewController+PHCategory.h"
#import "UIView+PHLayout.h"
#import "MBProgressHUD+MJ.h"
#import "UIColor+PHCategory.h"

@interface PHTool : NSObject


+ (BOOL)locationEnable;

/**
 *  登录成功返回YES,反之返回NO
 *
 */
+ (BOOL)loginEnable;

+ (void)setRootViewController:(UIViewController *)vc;
+ (void)setHomeViewControllerForRoot;
+ (void)setLoginViewControllerForRoot;

/**
 *  根据高度判断是否是iPhone4s以下版本
 *
 */
+ (BOOL)isiPhone4s;
+ (BOOL)lowerThaniPhone5s;

/**
 *  当前app版本号
 *
 */
+ (NSString *)currentAppVersion;
@end
