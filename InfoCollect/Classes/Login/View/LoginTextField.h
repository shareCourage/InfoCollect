//
//  LoginTextField.h
//  BusOnline
//
//  Created by Kowloon on 15/12/14.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTextField : UITextField

@property (nonatomic, strong, readonly) NSString *leftImageName;
@property (nonatomic, strong, readonly) NSString *leftSelImageName;
@property (nonatomic, strong) UIColor *lineColor;

- (instancetype)initWithLeftImageName:(NSString *)imageName selName:(NSString *)selName;
- (instancetype)initWithFrame:(CGRect)frame leftImageName:(NSString *)imageName selName:(NSString *)selName;

@end
