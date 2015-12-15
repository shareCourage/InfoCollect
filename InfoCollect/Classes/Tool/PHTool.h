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
#import "UIGestureRecognizer+YYAdd.h"
#import "UIControl+YYAdd.h"

@interface PHTool : NSObject

+ (BOOL)loginEnable;

+ (void)setRootViewController:(UIViewController *)vc;
+ (void)setHomeViewControllerForRoot;
+ (void)setLoginViewControllerForRoot;

@end
