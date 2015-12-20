//
//  PHCityPickerView.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHCityPickerView : UIView

@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UIPickerView *cityPickerView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)saveBtnClick:(UIButton *)sender;

+ (instancetype)showPickerAddToView:(UIView *)view completion:(void (^)(NSString *province, NSString *city, NSString *town))option;
+ (instancetype)showPickerAddToView:(UIView *)view;

@end
