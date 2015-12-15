//
//  PHHomeController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHHomeController.h"
#import "PHZBarViewController.h"

@interface PHHomeController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shortBtn_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shortBtn_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shortBtn_H;
@property (weak, nonatomic) IBOutlet UIButton *shortBtn;
- (IBAction)shortBtnClick:(id)sender;

@end

@implementation PHHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shortBtn_H.constant = 50;
    self.shortBtn.layer.cornerRadius = 5;
}
- (IBAction)shortBtnClick:(id)sender {
    PHZBarViewController *zbar = [[PHZBarViewController alloc] init];
    [self.navigationController pushViewController:zbar animated:YES];
}
@end
