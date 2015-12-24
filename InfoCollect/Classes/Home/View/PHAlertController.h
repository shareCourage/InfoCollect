//
//  PHAlertController.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/24.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAlertController;

@protocol PHAlertControllerDelegate <NSObject>

@optional
- (void)alertController:(PHAlertController *)alertConroller didClickNextWithContentStr:(NSString *)string;

@end


@interface PHAlertController : UIView


@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *alertColor;

@property (nonatomic, assign) id <PHAlertControllerDelegate> delegate;
+ (instancetype)alertControllerWithcompletion:(void (^)(NSString *contentString))completion;
+ (instancetype)alertController;
@end
