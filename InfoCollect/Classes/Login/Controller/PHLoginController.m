//
//  PHLoginController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define kPadding 80

#import "PHLoginController.h"
#import "PHCourier.h"
#import "LoginTextField.h"

@interface PHLoginController ()

@property (nonatomic, weak) LoginTextField *userNameTF;
@property (nonatomic, weak) LoginTextField *userCodeTF;
@property (nonatomic, weak) UIButton *sureBtn;

@end

@implementation PHLoginController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layerInitial];
    [self centerViewInitial];
    kWS(ws);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [ws.view endEditing:YES];
    }];
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textTFDidChangeNotification) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)centerViewInitial {
    CGFloat centerW = kWidthOfScreen - kPadding - 60;
    UIView *centerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, centerW, centerW)];
    centerV.backgroundColor = [UIColor clearColor];
    centerV.center = CGPointMake(kWidthOfScreen / 2, kHeightOfScreen / 2);
    [self.view addSubview:centerV];
    
    CGFloat height = 35;
    
    LoginTextField *userNameTF = [[LoginTextField alloc] initWithFrame:CGRectMake(0, 0, centerW, height) leftImageName:@"login_userSL" selName:@"login_user"];
    CGFloat userNameY = centerW / 2 - height - height / 2;
    userNameTF.center = CGPointMake(centerW / 2, userNameY);
    userNameTF.text = @"JDY0105";
    userNameTF.textAlignment = NSTextAlignmentCenter;
    userNameTF.placeholder = @"用户名";
    [centerV addSubview:userNameTF];
    self.userNameTF = userNameTF;
    
    CGFloat codeY = userNameTF.centerY + height + height / 2;
    LoginTextField *userCodeTF = [[LoginTextField alloc] initWithFrame:CGRectMake(0, 0, centerW, height) leftImageName:@"login_codeSL" selName:@"login_code"];
    userCodeTF.secureTextEntry = YES;
    userCodeTF.center = CGPointMake(centerW / 2, codeY);
    userCodeTF.text = @"111111";
    userCodeTF.textAlignment = NSTextAlignmentCenter;
    userCodeTF.placeholder = @"密码";
    [centerV addSubview:userCodeTF];
    self.userCodeTF = userCodeTF;
    
    CGFloat sureX = 0;
    CGFloat sureY = 0;
    CGFloat sureW = 60;
    CGFloat sureH = sureW;
    UIButton *sureBtn = [UIButton buttonWithFrame:CGRectMake(sureX, sureY, sureW, sureH) target:self action:@selector(loginClick) normalImage:[UIImage imageNamed:@"login_rightSL"] selectedImage:[UIImage imageNamed:@"login_right"]];
    sureBtn.center = CGPointMake(centerW / 2, CGRectGetMaxY(userCodeTF.frame) + 30 + sureW / 2);
    [centerV addSubview:sureBtn];
    self.sureBtn = sureBtn;
}

- (void)textTFDidChangeNotification {
    if (self.userNameTF.text.length == 0 || self.userCodeTF.text.length == 0) {
        self.sureBtn.selected = NO;
        self.sureBtn.enabled = NO;
    } else {
        self.sureBtn.selected = YES;
        self.sureBtn.enabled = YES;
    }
}

- (void)loginClick {
    if (self.userNameTF.text.length == 0 || self.userCodeTF.text.length == 0) return;
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (self.userNameTF.text) {
        [para setObject:self.userNameTF.text forKey:kArgu_identityCardId];
    }
    if (self.userCodeTF.text) {
        [para setObject:self.userCodeTF.text forKey:kArgu_pwd];
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
            [PHUseInfo sharedPHUseInfo].loginDate = [NSDate date];
            [self loginState:YES];
        } else {
            [MBProgressHUD showError:@"登录失败" toView:self.view];
            [[PHUseInfo sharedPHUseInfo] setPropertyNil];
        }
    } errorBlock:^(NSError *error) {
        if (error) [MBProgressHUD showError:@"登录失败" toView:self.view];
    }];
}

- (void)layerInitial {
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = self.view.bounds;
    bgLayer.contents = (__bridge id)[UIImage imageNamed: @"login_bg"].CGImage;
    [self.view.layer addSublayer:bgLayer];
    
    CALayer *logLayer = [CALayer layer];
    logLayer.frame = CGRectMake(0, 0, kWidthOfScreen, 45);
    logLayer.position = CGPointMake(kWidthOfScreen / 2, 60);
    logLayer.contents = (__bridge id)[UIImage imageNamed: @"login_log"].CGImage;
    
    [bgLayer addSublayer:logLayer];
    
    
    CALayer *centerLayer = [CALayer layer];
    CGFloat padding = kPadding;
    CGFloat centerW = kWidthOfScreen - padding;
    centerLayer.frame = CGRectMake(0, 0, centerW, centerW);
    centerLayer.position = CGPointMake(kWidthOfScreen / 2, kHeightOfScreen / 2);
    centerLayer.contents = (__bridge id)[UIImage imageNamed:@"login_circle"].CGImage;
    [bgLayer addSublayer:centerLayer];
    
    CALayer *personLayer = [CALayer layer];
    CGFloat pW = 40;
    personLayer.frame = CGRectMake(0, 0, pW, pW);
    CGFloat pX = padding / 2;
    CGFloat pY = kHeightOfScreen / 2;
    CGPoint pPoint = CGPointMake(pX, pY);
    personLayer.position = pPoint;
    personLayer.contents = (__bridge id)[UIImage imageNamed:@"login_pep"].CGImage;
    [bgLayer addSublayer:personLayer];
    
    CALayer *vehLayer = [CALayer layer];
    CGFloat vW = pW;
    vehLayer.frame = CGRectMake(0, 0, vW, vW);
    CGFloat vX = kWidthOfScreen - padding / 2;
    CGFloat vY = kHeightOfScreen / 2;
    CGPoint vPoint = CGPointMake(vX, vY);
    vehLayer.position = vPoint;
    vehLayer.contents = (__bridge id)[UIImage imageNamed:@"login_ver"].CGImage;
    [bgLayer addSublayer:vehLayer];
    
    
    CATextLayer *companyN = [CATextLayer layer];
    [companyN setFont:@"Helvetica-Bold"];
    [companyN setFontSize:17];
    [companyN setString:@"北京东华宏泰科技股份有限公司"];
    [companyN setAlignmentMode:kCAAlignmentCenter];
    [companyN setForegroundColor:[UIColor whiteColor].CGColor];
    companyN.frame = CGRectMake(0, 0, kWidthOfScreen, 40);
    companyN.position = CGPointMake(kWidthOfScreen / 2, kHeightOfScreen - 25);
    [bgLayer addSublayer:companyN];
}
@end





