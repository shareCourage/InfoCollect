//
//  PHTextHeaderView.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHTextHeaderView.h"
#import "PHSettingGroup.h"
#import "PHRightViewGroup.h"

@interface PHTextHeaderView ()

@property (nonatomic, weak) UIButton *rightBtn;

@end

@implementation PHTextHeaderView


+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString *ID = @"PHTextHeaderView";
    PHTextHeaderView *headerV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!headerV) {
        headerV = [[PHTextHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return headerV;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rightBtn];
        self.rightBtn = rightBtn;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = self.height;
    CGFloat widht = height;
    CGFloat x = self.width - widht - 3;
    self.rightBtn.frame = CGRectMake(x, 0, widht, height);
}

- (void)setGroup:(PHSettingGroup *)group {
    _group = group;
    if (!group) return;
    self.textLabel.text = group.header;
    if ([group isKindOfClass:[PHRightViewGroup class]]) {
        self.rightBtn.enabled = YES;
        PHRightViewGroup *rightGroup = (PHRightViewGroup *)group;
        [self.rightBtn setImage:[UIImage imageNamed:rightGroup.rightIcon] forState:UIControlStateNormal];
    } else {
        self.rightBtn.enabled = NO;
        [self.rightBtn setImage:nil forState:UIControlStateNormal];
    }
}

- (void)rightBtnClick {
    PHLog(@"rightBtnClick");
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickRightBtn:)]) {
        [self.delegate headerViewDidClickRightBtn:self];
    }
}
@end




