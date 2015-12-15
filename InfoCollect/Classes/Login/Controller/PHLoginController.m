//
//  PHLoginController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHLoginController.h"

@interface PHLoginController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingD;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingD;
@property (nonatomic, assign) CGFloat leftRightD;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)selClick:(UIButton *)sender;
- (IBAction)loginClick:(UIButton *)sender;

@end

@implementation PHLoginController

- (void)setLeftRightD:(CGFloat)leftRightD {
    _leftRightD = leftRightD;
    self.trailingD.constant = leftRightD;
    self.leadingD.constant = leftRightD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftRightD = 30;
    self.loginBtn.layer.cornerRadius = 5;
    self.selBtn.selected = YES;
    PH_WS(ws);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [ws.view endEditing:YES];
    }];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)selClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)loginClick:(UIButton *)sender {
    [self loginState:YES];
}

- (void)loginState:(BOOL)success {
    if (success) {
        [PHTool setHomeViewControllerForRoot];
    } else {
    
    }
}
@end





