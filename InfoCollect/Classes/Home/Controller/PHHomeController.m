//
//  PHHomeController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHHomeController.h"
#import "PHZBarViewController.h"
#import "CameraViewController.h"
#import "PHInfoCollectController.h"


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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)shortBtnClick:(id)sender {
    PHZBarViewController *zbar = [[PHZBarViewController alloc] init];
    PHInfoCollectController *infoCollect = [[PHInfoCollectController alloc] init];
    NSMutableArray * viewControllers = [self.navigationController.viewControllers mutableCopy];
    [viewControllers insertObject:infoCollect atIndex:1];
    [viewControllers insertObject:zbar atIndex:2];
    [self.navigationController setViewControllers:viewControllers animated:YES];
    
//    [self pushToCamerVC];
}


- (void)pushToCamerVC {
    CameraViewController *vc = [[CameraViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end




