//
//  PHLabelView.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/18.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHLabelView.h"

@interface PHLabelView ()

@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation PHLabelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        [label setSystemFontOfValue:[PHTool lowerThaniPhone5s] ? 11 : 14];
        [self addSubview:label];
        self.contentLabel = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentLabel.frame = CGRectMake(0, 0, self.width, self.height - 1);
}

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:[PHTool lowerThaniPhone5s] ? 13 : 15]
                          range:NSMakeRange(0, 5)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[[UIColor grayColor] colorWithAlphaComponent:0.6f]
                          range:NSMakeRange(0, 5)];
    self.contentLabel.attributedText = AttributedStr;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,0.3f);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, kSystemeColor.CGColor);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,0, rect.size.height);
    //下一点
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    //绘制完成
    CGContextStrokePath(context);
    
}

@end
