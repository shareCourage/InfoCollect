//
//  PHAlertController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/24.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHAlertController.h"


@interface PHAlertController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewcenterY;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextClick:(UIButton *)sender;

@property (nonatomic, copy) void (^completion) (NSString *contentString);

@end

@implementation PHAlertController

+ (instancetype)alertControllerWithcompletion:(void (^)(NSString *))completion {
    PHAlertController *alert = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    alert.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    alert.backView.layer.cornerRadius = 5;
    alert.completion = completion;
    return alert;
}


- (void)awakeFromNib {
    self.titleLabel.text = @"标题";
    [self observeNotification];
}
- (void)observeNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Notification
- (void)keyBoardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSValue *frameValue = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [frameValue CGRectValue].size;
    CGFloat keyBoardH = keyboardSize.height;//186
    
    CGFloat heightFromBottom = self.height - CGRectGetMaxY(self.backView.frame);
    CGFloat value = keyBoardH - heightFromBottom;
    if (value > 0) {
        [UIView animateWithDuration:0.3f animations:^{
            self.backViewcenterY.constant =- value;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
- (void)keyBoardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3f animations:^{
        self.backViewcenterY.constant = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)nextClick:(UIButton *)sender {
    if (self.completion) self.completion(self.inputTextField.text);
}


- (void)setTitle:(NSString *)title {
    _title = title;
    if (title) self.titleLabel.text = title;
    
}

- (void)setAlertColor:(UIColor *)alertColor {
    _alertColor = alertColor;
    if (alertColor) {
        self.inputTextField.layer.borderWidth = 0.3f;
        self.inputTextField.layer.borderColor = alertColor.CGColor;
        self.inputTextField.layer.cornerRadius = 5.f;
        [self.nextBtn setTitleColor:alertColor forState:UIControlStateNormal];
    }
}


@end
