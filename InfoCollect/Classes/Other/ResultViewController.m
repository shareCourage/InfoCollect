//
//  ResultViewController.m
//  IDCardDemo
//
//  Created by wintone on 15/6/18.
//  Copyright (c) 2015年 wintone. All rights reserved.
//

#import "ResultViewController.h"
#import "PHLabelView.h"

@interface ResultViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *baseInfoView;

@property (weak, nonatomic) IBOutlet UIView *partOne;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UIView *partTwo;

@property (weak, nonatomic) IBOutlet UIView *btnView;

@property (nonatomic, strong) NSMutableArray *partOnes;
@property (nonatomic, strong) NSMutableArray *partTwos;
@property (nonatomic, strong) NSMutableArray *parts;
@end

@implementation ResultViewController
- (NSMutableArray *)parts {
    if (!_parts) {
        _parts = [NSMutableArray array];
    }
    return _parts;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"识别结果";
    self.topView.backgroundColor = [UIColor clearColor];
    self.baseInfoView.backgroundColor = [UIColor clearColor];
    self.partOne.backgroundColor = [UIColor clearColor];
    self.partTwo.backgroundColor = [UIColor clearColor];
    self.btnView.backgroundColor = [UIColor clearColor];
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = self.view.bounds;
    bgLayer.contents = (__bridge id)[UIImage imageNamed: @"login_bg"].CGImage;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    
    [self addInit];
    
    
    NSArray *btns = @[@"确定", @"重新识别"];
    for (NSInteger i = 0; i < btns.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.layer.cornerRadius = 10;
        CGFloat lw = [PHTool lowerThaniPhone5s] ? 100 : 150;
        CGFloat lh = self.btnView.height;
        btn.frame = CGRectMake(0, 0, lw, lh);
        CGFloat padding = 30;
        CGFloat distance = self.btnView.width - lw * 2 - padding;
        CGFloat lx = distance / 2 + lw / 2 + i * (lw + padding);
        CGFloat ly = self.btnView.height / 2;
        btn.center = CGPointMake(lx, ly);
        [btn setTitle:btns[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = kSystemeColor;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnView addSubview:btn];
    }
    [self loadData];
}

- (void)btnClick:(UIButton *)sender {
    if (sender.tag == 0) {//点击确定按钮保存为单例
        [PHUseInfo sharedPHUseInfo].identityInfo = self.resultArray;
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:vc animated:YES];
    } else if (sender.tag == 1) {//点击重新识别按钮
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)loadData {
    if (self.resultArray.count == 0) return;
    for (NSDictionary *dict in self.resultArray) {
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"姓名"]) {
                PHLabelView *label = (PHLabelView *)self.partOnes[0];
                label.contentStr = [label.contentStr stringByAppendingString:obj];
            } else if ([key isEqualToString:@"公民身份号码"] || [key isEqualToString:@"证号"]) {
                PHLabelView *label = (PHLabelView *)self.partOnes[1];
                label.contentStr = [label.contentStr stringByAppendingString:obj];
            }
        }];
    }
}


- (void)addInit {
    for (UIView *objV in self.baseInfoView.subviews) {
        objV.hidden = YES;
    }
    NSMutableArray *ones = [NSMutableArray array];
    NSArray *strs = @[@"姓  名：",@"身份证号：",];
    for (NSInteger i = 0; i < strs.count; i ++) {
        PHLabelView *labelView = [[PHLabelView alloc] init];
        labelView.contentLabel.font = [UIFont systemFontOfSize:20];
        labelView.labelTextColor = [UIColor whiteColor];
        labelView.backgroundColor = [UIColor clearColor];
        CGFloat lx = 20;
        CGFloat lw = self.baseInfoView.width - lx;
        CGFloat lh = 60;
        CGFloat ly = lh * i;
        labelView.frame = CGRectMake(lx, ly, lw, lh);
        labelView.contentStr = strs[i];
        [self.baseInfoView addSubview:labelView];
        [ones addObject:labelView];
        [self.parts addObject:labelView];
    }
    self.partOnes = ones;
}


#pragma mark - deleteInit 
- (void)commonInit {
    self.iconImageV.image = [UIImage imageNamed:@"home_per"];
    self.iconImageV.layer.cornerRadius = 10;
    self.iconImageV.layer.masksToBounds = YES;
    
    NSMutableArray *ones = [NSMutableArray array];
    NSArray *strs = @[@"姓  名：",@"性  别：",@"民  族：",];
    for (NSInteger i = 0; i < strs.count; i ++) {
        PHLabelView *labelView = [[PHLabelView alloc] init];
        labelView.labelTextColor = [UIColor whiteColor];
        labelView.backgroundColor = [UIColor clearColor];
        CGFloat lx = 5;
        CGFloat lw = self.partOne.width - lx;
        CGFloat lh = self.partOne.height / strs.count;
        CGFloat ly = lh * i;
        labelView.frame = CGRectMake(lx, ly, lw, lh);
        labelView.contentStr = strs[i];
        [self.partOne addSubview:labelView];
        [ones addObject:labelView];
        [self.parts addObject:labelView];
    }
    self.partOnes = ones;
    
    NSMutableArray *twos = [NSMutableArray array];
    NSArray *strs2 = @[@"家庭住址：",@"身份证号："];
    for (NSInteger i = 0; i < strs2.count; i ++) {
        PHLabelView *labelView = [[PHLabelView alloc] init];
        labelView.labelTextColor = [UIColor whiteColor];
        labelView.backgroundColor = [UIColor clearColor];
        CGFloat lx = 5;
        CGFloat lw = self.partTwo.width - lx;
        CGFloat lh = self.partTwo.height / strs2.count;
        CGFloat ly = lh * i;
        labelView.frame = CGRectMake(lx, ly, lw, lh);
        labelView.contentStr = strs2[i];
        [self.partTwo addSubview:labelView];
        [twos addObject:labelView];
        [self.parts addObject:labelView];
    }
    self.partTwos = twos;
}
- (void)loadDataDelete {
    if (self.resultArray.count == 0) return;
    __block NSUInteger i = 0;
    for (NSDictionary *dict in self.resultArray) {
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if (![key isEqualToString:@"出生"]) {
                PHLabelView *label = (PHLabelView *)self.parts[i];
                label.contentStr = [label.contentStr stringByAppendingString:obj];
                i ++;
            }
        }];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *caches = paths[0];
    //    NSString *imagepath = [caches stringByAppendingPathComponent:@"image.jpg"];
    NSString *headImagePath = [caches stringByAppendingPathComponent:@"head.jpg"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:headImagePath];
    self.iconImageV.image = savedImage;
}
@end












