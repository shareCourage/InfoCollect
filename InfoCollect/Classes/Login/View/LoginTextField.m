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
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame leftImageName:(NSString *)imageName selName:(NSString *)selName{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineColor = kSystemeColor;
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.keyboardType = UIKeyboardTypeDefault;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)setLeftBtnValue:(BOOL)value {
    if (value) {
        self.leftBtn.selected = YES;
        self.lineColor = [UIColor whiteColor];
    } else {
        self.leftBtn.selected = NO;
        self.lineColor = kSystemeColor;
    }
}

- (void)textDidChangeNotification {
    if (self.text.length != 0) {
        [self setLeftBtnValue:YES];
    } else {
        [self setLeftBtnValue:NO];
    }
}
- (instancetype)initWithLeftImageName:(NSString *)imageName selName:(NSString *)selName{
    return [self initWithFrame:CGRectZero leftImageName:imageName selName:selName];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftW = 25;
    CGFloat leftH = self.height;
    CGFloat leftY = 0;
    CGFloat leftX = 3;
    self.leftBtn.frame = CGRectMake(leftX, leftY, leftW, leftH);
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (text.length != 0) {
        [self setLeftBtnValue:YES];
    } else {
        [self setLeftBtnValue:NO];
    }
}

- (BOOL)isEditing {
    BOOL value = [super isEditing];
    return value;
}

#define kDistance 5
#if 1
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x -= kDistance;
    return iconRect;
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super placeholderRectForBounds:bounds];
    iconRect.origin.x -= kDistance;
    return iconRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super editingRectForBounds:bounds];
    iconRect.origin.x -= kDistance;
    return iconRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super textRectForBounds:bounds];
    iconRect.origin.x -= kDistance;
    return iconRect;
}
#endif

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    if (lineColor) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    //获得处理的上下文
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,1.f);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,0, rect.size.height);
    //下一点
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    //绘制完成
    CGContextStrokePath(context);
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
