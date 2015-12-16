//
//  OverView.m
//  TestCamera
//
//  Created by wintone on 14/11/25.
//  Copyright (c) 2014年 zzzili. All rights reserved.
//

#import "OverView.h"
#import <CoreText/CoreText.h>

#define kProduct @"com.wintone.BankCardRecog.product"
@implementation OverView{
    
    CGPoint ldown;
    CGPoint rdown;
    CGPoint lup;
    CGPoint rup;
    CGRect pointRect;
    CGRect textRect;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rect_screen = [[UIScreen mainScreen]bounds];
        CGSize size_screen = rect_screen.size;
        CGFloat width = size_screen.width;
        CGFloat height = size_screen.height;
        if (width==375 && height== 667) {//苹果6
            //横屏预览视图 左下角 右下角 左上角 右上角 顶点
            ldown = CGPointMake(45*1.174, 100*1.174);
            rdown = CGPointMake(45*1.174, 455*1.174);
            lup = CGPointMake(275*1.174, 100*1.174);
            rup = CGPointMake(275*1.174, 455*1.174);
            self.smallrect = CGRectMake(45*1.174, 100*1.174, 230*1.174, 355*1.174);
            pointRect = CGRectMake(CGRectGetMidX(self.smallrect)-7*1.174, CGRectGetMidY(self.smallrect)-140*1.174, 14*1.174,280*1.174);
            textRect = CGRectMake(CGRectGetMinX(self.smallrect)-33*1.174, CGRectGetMidY(self.smallrect)-90*1.174, 12*1.174,177*1.174);
            
        }else if (width==320&&height==568){//苹果5
            ldown = CGPointMake(50-5, 100);
            rdown = CGPointMake(50-5, 455);
            lup = CGPointMake(280-5, 100);
            rup = CGPointMake(280-5, 455);
            self.smallrect = CGRectMake(50-5, 100, 230, 355);
            pointRect = CGRectMake(CGRectGetMidX(self.smallrect)-7, CGRectGetMidY(self.smallrect)-140, 14,280);
            textRect = CGRectMake(CGRectGetMinX(self.smallrect)-33, CGRectGetMidY(self.smallrect)-90, 12,177);
            
        }else if (width==320&&height==480){//苹果4
            ldown = CGPointMake(50-5, 100-44);
            rdown = CGPointMake(50-5, 455-44);
            lup = CGPointMake(280-5, 100-44);
            rup = CGPointMake(280-5, 455-44);
            self.smallrect = CGRectMake(50-5, 100-44, 230, 355);
            pointRect = CGRectMake(CGRectGetMidX(self.smallrect)-7, CGRectGetMidY(self.smallrect)-140, 14,280);
            textRect = CGRectMake(CGRectGetMinX(self.smallrect)-33, CGRectGetMidY(self.smallrect)-90, 12,177);
            

        }else if (height == 736){//6plus
            
            ldown = CGPointMake(45*1.295, 100*1.295);
            rdown = CGPointMake(45*1.295, 455*1.295);
            lup = CGPointMake(275*1.295, 100*1.295);
            rup = CGPointMake(275*1.295, 455*1.295);
            self.smallrect = CGRectMake(45*1.295, 100*1.295, 230*1.295, 355*1.295);
            pointRect = CGRectMake(CGRectGetMidX(self.smallrect)-7*1.295, CGRectGetMidY(self.smallrect)-140*1.295, 14*1.295,280*1.295);
            textRect = CGRectMake(CGRectGetMinX(self.smallrect)-33*1.295, CGRectGetMidY(self.smallrect)-90*1.295, 12*1.295,177*1.295);
        }
        //识别MRZ的方框
        self.mrzSmallRect = CGRectMake(ldown.x+50, ldown.y-25, rup.x-ldown.x-100,rdown.y-ldown.y+25);

        
    }
    return self;
}


- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIColor orangeColor] set];
    //获得当前画布区域
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置线的宽度
    CGContextSetLineWidth(currentContext, 2.0f);
    
    //mrz边框
    if (_mrz) {
        CGContextMoveToPoint(currentContext, ldown.x+50, ldown.y-25);
        CGContextAddLineToPoint(currentContext, ldown.x+50, rdown.y);
        CGContextAddLineToPoint(currentContext, rup.x-50, rdown.y);
        CGContextAddLineToPoint(currentContext, rup.x-50, lup.y-25);
        CGContextAddLineToPoint(currentContext, ldown.x+50, ldown.y-25);
        
    }else{
        /*画线*/
        //起点--左下角
        CGContextMoveToPoint(currentContext,ldown.x, ldown.y+25);
        CGContextAddLineToPoint(currentContext, ldown.x, ldown.y);
        CGContextAddLineToPoint(currentContext, ldown.x+25, ldown.y);
        
        //右下角
        CGContextMoveToPoint(currentContext, rdown.x,rdown.y-25);
        CGContextAddLineToPoint(currentContext, rdown.x,rdown.y);
        CGContextAddLineToPoint(currentContext, rdown.x+25,rdown.y);
        
        //左上角
        CGContextMoveToPoint(currentContext, lup.x-25,lup.y);
        CGContextAddLineToPoint(currentContext, lup.x,lup.y);
        CGContextAddLineToPoint(currentContext, lup.x,lup.y+25);
        
        //右上角
        CGContextMoveToPoint(currentContext, rup.x, rup.y-25);
        CGContextAddLineToPoint(currentContext, rup.x, rup.y);
        CGContextAddLineToPoint(currentContext, rup.x-25, rup.y);
        
        //四条线
        if (!_leftHidden) {
            CGContextMoveToPoint(currentContext, ldown.x+25, ldown.y);
            CGContextAddLineToPoint(currentContext, lup.x-25,lup.y);
        }
        if (!_rightHidden) {
            CGContextMoveToPoint(currentContext, rdown.x+25,rdown.y);
            CGContextAddLineToPoint(currentContext, rup.x-25, rup.y);
        }
        
        if (!_topHidden) {
            CGContextMoveToPoint(currentContext, lup.x,lup.y+25);
            CGContextAddLineToPoint(currentContext, rup.x, rup.y-25);
        }
        if (!_bottomHidden) {
            CGContextMoveToPoint(currentContext, ldown.x, ldown.y+25);
            CGContextAddLineToPoint(currentContext, rdown.x,rdown.y-25);
        }
    }
    
    CGContextStrokePath(currentContext);
}

/*
 设置四条线的显隐
 */
- (void) setTopHidden:(BOOL)topHidden
{
    if (_topHidden == topHidden) {
        return;
    }
    _topHidden = topHidden;
    [self setNeedsDisplay];
}

- (void) setLeftHidden:(BOOL)leftHidden
{
    if (_leftHidden == leftHidden) {
        return;
    }
    _leftHidden = leftHidden;
    [self setNeedsDisplay];
}

- (void) setBottomHidden:(BOOL)bottomHidden
{
    if (_bottomHidden == bottomHidden) {
        return;
    }
    _bottomHidden = bottomHidden;
    [self setNeedsDisplay];
}

- (void) setRightHidden:(BOOL)rightHidden
{
    if (_rightHidden == rightHidden) {
        return;
    }
    _rightHidden = rightHidden;
    [self setNeedsDisplay];
}

//设置mrz边框
- (void) setMRZBolder
{
    [self setNeedsDisplay];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
