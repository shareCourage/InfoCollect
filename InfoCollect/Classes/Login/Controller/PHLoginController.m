//
//  PHLoginController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHLoginController.h"
#import "PHCourier.h"

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
    self.accountTF.text = @"test";
    self.codeTF.text = @"jxea";
    self.leftRightD = 30;
    self.loginBtn.layer.cornerRadius = 5;
    self.selBtn.selected = YES;
    kWS(ws);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [ws.view endEditing:YES];
    }];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)selClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [PHUseInfo sharedPHUseInfo].saveToLocal = sender.selected;
}

- (IBAction)loginClick:(UIButton *)sender {
    if (self.accountTF.text.length == 0 || self.codeTF.text.length == 0) return;
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (self.accountTF.text) {
        [para setObject:self.accountTF.text forKey:kArgu_identityCardId];
    }
    if (self.codeTF.text) {
        [para setObject:self.codeTF.text forKey:kArgu_pwd];
    }
    [self loginRequest:para];
    [MBProgressHUD showMessage:@"正在登录..." toView:self.view];
}

- (void)loginState:(BOOL)success {
    if (success) {
        [PHTool setHomeViewControllerForRoot];
    } else {
    
    }
}


#pragma mark - loginRequest 
- (void)loginRequest:(NSDictionary *)param {
    [EBNetworkRequest GET:kUrl_login parameters:param dictBlock:^(NSDictionary *dict) {
//        PHLog(@"%@",dict);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *resultD = [dict objectForKey:kArgu_result];
        NSNumber *value = [resultD objectForKey:kArgu_success];
        if ([value boolValue]) {
            [PHUseInfo sharedPHUseInfo].userName = [param objectForKey:kArgu_identityCardId];
            [PHUseInfo sharedPHUseInfo].userCode = [param objectForKey:kArgu_pwd];
            [[PHUseInfo sharedPHUseInfo] setPropertyValue:dict];
            [self loginState:YES];
        } else {
            [MBProgressHUD showError:@"登录失败" toView:self.view];
            [[PHUseInfo sharedPHUseInfo] setPropertyNil];
        }
    } errorBlock:^(NSError *error) {
        if (error) [MBProgressHUD showError:@"登录失败" toView:self.view];
    }];
}
@end





