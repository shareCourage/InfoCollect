//
//  PHAlertController.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/24.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHAlertController : UIView


@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *alertColor;
+ (instancetype)alertControllerWithcompletion:(void (^)(NSString *contentString))completion;

@end
