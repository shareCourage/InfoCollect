//
//  PHSettingController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHSettingController.h"
#import "PHSettingGroup.h"
#import "PHSettingItem.h"
#import "PHSettingArrowItem.h"


@interface PHSettingController () <UIAlertViewDelegate>

@end

@implementation PHSettingController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = kGrayColor;
    PHSettingItem *logout = [PHSettingArrowItem itemWithTitle:@"退出登录" destVcClass:nil];
    logout.option = ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出登录?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    };
    PHSettingGroup *group = [[PHSettingGroup alloc] init];
    group.items = @[logout];
    [self.dataSource addObject:group];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [PHTool setLoginViewControllerForRoot];
        [[PHUseInfo sharedPHUseInfo] setPropertyNil];
    }
}
@end



