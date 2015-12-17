//
//  LoginTextField.m
//  BusOnline
//
//  Created by Kowloon on 15/12/14.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "LoginTextField.h"

@interface LoginTextField ()

@property (nonatomic, weak) UIButton *leftBtn;

@end

@implementation LoginTextField

- (instancetype)initWithFrame:(CGRect)frame leftImageName:(NSString *)imageName selName:(NSString *)selName{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeAlways;
        if (imageName.length != 0) {
            _leftImageName = imageName;
            _leftSelImageName = selName;
            UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
            leftView.userInteractionEnabled = NO;
            leftView.imageView.contentMode = UIViewContentModeCenter;
            UIImage *normalImage = [UIImage imageNamed:imageName];
            [leftView setImage:normalImage forState:UIControlStateNormal];
            if (selName) {
                UIImage *selImage = [UIImage imageNamed:selName];
                [leftView setImage:selImage forState:UIControlStateSelected];
            }
            self.leftView = leftView;
            self.leftBtn = leftView;
        }
    }
    return self;
}

- (instancetype)initWithLeftImageName:(NSString *)imageName selName:(NSString *)selName{
    return [self initWithFrame:CGRectZero leftImageName:imageName selName:selName];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftW = 15;
    CGFloat leftH = 20;
    CGFloat selfH = self.height;
    CGFloat leftY = (selfH - leftH) / 2;
    self.leftView.frame = CGRectMake(0, leftY - 2, leftW, leftH);
}

- (BOOL)isEditing {
    BOOL value = [super isEditing];
    self.leftBtn.selected = value;
    return value;
}

#if 0
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 5;
    return iconRect;
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super placeholderRectForBounds:bounds];
    iconRect.origin.x += 5;
    return iconRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super editingRectForBounds:bounds];
    iconRect.origin.x += 5;
    return iconRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super textRectForBounds:bounds];
    iconRect.origin.x += 5;
    return iconRect;
}
#endif



- (void)drawRect:(CGRect)rect {
    //获得处理的上下文
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,1.f);
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
