//
//  PHHomeController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHHomeController.h"
#import "PHZBarViewController.h"
#import "PHInfoCollectController.h"

#import "PHCourier.h"
#import "PHLabelView.h"
#import "PHSettingController.h"
#import "PHAnouncementController.h"

@interface PHHomeController () <UIAlertViewDelegate>
{
    BOOL _executed;//判断judgeVersion是否已经执行
}
@property (nonatomic, weak) UIImageView *courierIcon;
@property (nonatomic, weak) UIImageView *companyIcon;
@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation PHHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的信息";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCourierInfoNotification) name:PHLoadedCourierInfoNotification object:nil];
    [self layerInitial];
    self.navigationController.navigationBar.translucent = YES;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_setting"] style:UIBarButtonItemStyleDone target:self action:@selector(settingClick)];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.leftBarButtonItem = nil;
    [self loadCourierInfoNotification];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - Common Init
- (void)layerInitial {
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = self.view.bounds;
    bgLayer.contents = (__bridge id)[UIImage imageNamed: @"login_bg"].CGImage;
    [self.view.layer addSublayer:bgLayer];
    
    UIImageView *decorateView = [[UIImageView alloc] init];
    decorateView.layer.cornerRadius = 10;
    decorateView.layer.masksToBounds = YES;
    decorateView.userInteractionEnabled = YES;
//    decorateView.backgroundColor = [UIColor redColor];
    decorateView.contentMode = UIViewContentModeScaleToFill;
    CGFloat width = kWidthOfScreen - ([PHTool isiPhone4s] ? 70 : 80);
    CGFloat height = kHeightOfScreen - ([PHTool isiPhone4s] ? 160 : 200);
    decorateView.frame = CGRectMake(0, 0, width, height);
    decorateView.center = CGPointMake(kWidthOfScreen / 2, kHeightOfScreen / 2);
    decorateView.image = [UIImage imageNamed: @"home_decorate"];
    [self.view addSubview:decorateView];
    [self contentInitial:decorateView];
    
    UIButton *annouce = [UIButton buttonWithType:UIButtonTypeCustom];
    [annouce addTarget:self action:@selector(announceMent) forControlEvents:UIControlEventTouchUpInside];
    [annouce.titleLabel setSystemFontOfValue:[PHTool lowerThaniPhone5s] ? 11 : 13];
    [annouce setTitle:@"公告：公安局最新规定要求快递必须实名认证" forState:UIControlStateNormal];
    annouce.frame = CGRectMake(0, 0, kWidthOfScreen, 30);
    CGFloat pad = [PHTool isiPhone4s] ? 8 : 20;
    annouce.center = CGPointMake(kWidthOfScreen / 2, CGRectGetMaxY(decorateView.frame) + pad);
    [self.view addSubview:annouce];
    
    UIButton *get = [UIButton buttonWithType:UIButtonTypeSystem];
    [get setTitle:@"揽件" forState:UIControlStateNormal];
    [get setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    get.backgroundColor = kSystemeColor;
    CGFloat getH = 40;
    get.frame = CGRectMake(0, 0, width, getH);
    get.center = CGPointMake(kWidthOfScreen / 2, kHeightOfScreen - getH / 2 - 20);
    get.layer.cornerRadius = 5;
    [get addTarget:self action:@selector(getClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:get];
    
}

- (void)contentInitial:(UIImageView *)decorateView {
    CGFloat height = decorateView.height;
    CGFloat leftPadding = 25;
    CGFloat topPadding = height / 4.67;
    CGFloat bottomPadding = height * 0.07;
    CGFloat contentW = decorateView.width - leftPadding * 2;
    CGFloat contentH = decorateView.height - bottomPadding - topPadding;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentW, contentH)];
    contentView.backgroundColor = [UIColor clearColor];
    CGFloat centerY = topPadding + contentH / 2;
    contentView.center = CGPointMake(decorateView.width / 2, centerY);
    [decorateView addSubview:contentView];
    
    
    CGFloat oneH = contentH / 2;
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentW, oneH)];
    CGFloat oneY = oneH / 2;
    oneView.center = CGPointMake(contentW / 2, oneY);
    [contentView addSubview:oneView];
    
    CGFloat iconW = oneH / 2 + 30;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconW, oneH - 5)];
    icon.layer.cornerRadius = 10;
    icon.layer.masksToBounds = YES;
    icon.backgroundColor = [UIColor clearColor];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.center = CGPointMake(contentW / 2, oneY);
    icon.image = [UIImage imageNamed:@"home_per"];
    [oneView addSubview:icon];
    self.courierIcon = icon;
    
    CGFloat companyPadding = 5;
    CGFloat companyX = CGRectGetMaxX(icon.frame) + companyPadding;
    CGFloat companyW = contentW - CGRectGetMaxX(icon.frame) - 2 * companyPadding;
    CGFloat companyH = companyW;
    CGFloat companyY = CGRectGetMaxY(icon.frame) - companyH;
    UIImageView *companyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(companyX, companyY, companyW, companyH)];
    self.companyIcon = companyIcon;
    companyIcon.backgroundColor = [UIColor redColor];
    [oneView addSubview:companyIcon];
    
    CGFloat twoH = contentH - oneH;
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentW, twoH)];
    twoView.layer.cornerRadius = 5;
    twoView.layer.masksToBounds = YES;
    twoView.backgroundColor = [UIColor whiteColor];
    CGFloat twoY = oneH + twoH / 2;
    twoView.center = CGPointMake(contentW / 2, twoY);
    [contentView addSubview:twoView];
    
    NSMutableArray *labels = [NSMutableArray array];
    NSArray *strs = @[@"快递公司：",@"网  点：",@"电  话：",@"姓  名："];
    for (NSInteger i = 0; i < 4; i ++) {
        PHLabelView *labelView = [[PHLabelView alloc] init];
        CGFloat lx = 5;
        CGFloat lw = contentW - lx;
        CGFloat lh = twoH / 4;
        CGFloat ly = lh * i;
        labelView.frame = CGRectMake(lx, ly, lw, lh);
        labelView.contentStr = strs[i];
        [twoView addSubview:labelView];
        [labels addObject:labelView];
    }
    self.labels = labels;
}
#pragma mark - Target

- (void)getClick {
//    PHZBarViewController *zbar = [[PHZBarViewController alloc] init];
//    NSMutableArray * viewControllers = [self.navigationController.viewControllers mutableCopy];
//    [viewControllers insertObject:infoCollect atIndex:1];
//    [viewControllers insertObject:zbar atIndex:2];
//    [self.navigationController setViewControllers:viewControllers animated:YES];
    PHInfoCollectController *infoCollect = [[PHInfoCollectController alloc] init];
    [self.navigationController pushViewController:infoCollect animated:YES];
}


- (void)loadCourierInfoNotification {
    NSString *dataStr = [PHUseInfo sharedPHUseInfo].courier.photo;
    if (dataStr) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:dataStr options:0];
        UIImage *image = [UIImage imageWithData:data];
        if (!image) return;
        self.courierIcon.image = image;
    }
    
    PHLabelView *labelView = 0;
    for (NSUInteger i = 0; i < 4; i ++) {
        labelView = i < self.labels.count ? [self.labels objectAtIndex:i] : nil;
        switch (i) {
            case 0:
                labelView.contentStr = [labelView.contentStr stringByAppendingString:[PHUseInfo sharedPHUseInfo].courier.companyName ? : @""];
                break;
            case 1:
                labelView.contentStr = [labelView.contentStr stringByAppendingString:[PHUseInfo sharedPHUseInfo].courier.branch ? : @""];
                break;
            case 2:
                labelView.contentStr = [labelView.contentStr stringByAppendingString:[PHUseInfo sharedPHUseInfo].courier.phone ? : @""];
                break;
            case 3:
                labelView.contentStr = [labelView.contentStr stringByAppendingString:[PHUseInfo sharedPHUseInfo].courier.name ? : @""];
                break;
            default:
                break;
        }
    }
    
    if (!_executed) {
        [self judgeVersion];
    }
}

- (void)announceMent {
    PHLog(@"announceMent");
    PHAnouncementController *setting = [[PHAnouncementController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];

}

- (void)settingClick {
    PHLog(@"settingClick");
    PHSettingController *setting = [[PHSettingController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)judgeVersion {
    NSString *serverAppVersion = [PHUseInfo sharedPHUseInfo].appVersion;
    NSString *currentAppVersion = [PHTool currentAppVersion];
#if DEBUG
    serverAppVersion = @"1.0.1";
#endif
    if (serverAppVersion) {
        NSArray *servers = [serverAppVersion componentsSeparatedByString:@"."];
        NSArray *currents = [currentAppVersion componentsSeparatedByString:@"."];
        if (servers.count == 3 && currents.count == 3) {
            NSUInteger oneS = [servers[0] integerValue];
            NSUInteger oneC = [currents[0] integerValue];
            
            NSUInteger twoS = [servers[1] integerValue];
            NSUInteger twoC = [currents[1] integerValue];
            
            NSUInteger threeS = [servers[2] integerValue];
            NSUInteger threeC = [currents[2] integerValue];
            
            if (oneS > oneC || twoS > twoC || threeS > threeC) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"有新版本，需要更新吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }
    _executed = YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {//点击确定了，需要跳到浏览器去下载新版本的app
        NSString *url = KUrl_DownLoadNewestVersion;
#if DEBUG
        url = @"http://www.baidu.com";
#endif
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

    }
}

@end




