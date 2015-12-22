//
//  PHCityPickerView.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/20.
//  Copyright © 2015年 Goome. All rights reserved.
//
#define kAnimatedTime 0.3f
#define kHeight ([PHTool isiPhone4s] ? 220 : 270)
#import "PHCityPickerView.h"

@interface PHCityPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, copy) void (^completion) (NSString *province, NSString *city, NSString *town);
@property (nonatomic, copy) NSString *proviceStr;
@property (nonatomic, copy) NSString *cityStr;
@property (nonatomic, copy) NSString *townStr;

@end

@implementation PHCityPickerView

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)provinceArray {
    if (!_provinceArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        _pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
        _provinceArray = [_pickerDic allKeys];
        _selectedArray = [_pickerDic objectForKey:[[_pickerDic allKeys] objectAtIndex:0]];
        if (_selectedArray.count > 0) {
            _cityArray = [[_selectedArray objectAtIndex:0] allKeys];
        }
        if (_cityArray.count > 0) {
            _townArray = [[_selectedArray objectAtIndex:0] objectForKey:[_cityArray objectAtIndex:0]];
        }

    }
    return _provinceArray;
}

- (IBAction)saveBtnClick:(UIButton *)sender {
    if (self.completion) self.completion(self.proviceStr, self.cityStr, self.townStr);
    [self hide];
}

+ (instancetype)showPickerAddToView:(UIView *)view completion:(void (^)(NSString *, NSString *, NSString *))option{
    PHCityPickerView *picker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    picker.completion = option;
    picker.frame = CGRectMake(0, view.height, view.width, kHeight);
    picker.contentView = view;
    [view addSubview:picker];
    [picker show];
    return picker;
}

+ (instancetype)showPickerAddToView:(UIView *)view {
    return [self showPickerAddToView:view completion:nil];
}

- (void)show {
    [UIView animateWithDuration:kAnimatedTime animations:^{
        self.backgroundColor = kGrayColor;
        self.frame = CGRectMake(0, self.contentView.height - kHeight, self.width, self.height);
    } completion:nil];
}

- (void)hide {
    [UIView animateWithDuration:kAnimatedTime animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, self.contentView.height, self.width, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)awakeFromNib {
    self.cityTF.placeholder = @"请输入省、市、区（县）";
    self.cityPickerView.dataSource = self;
    self.cityPickerView.delegate = self;
    self.saveBtn.backgroundColor = kSystemeColor;
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveBtn.titleLabel setSystemFontOf18];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Notification
- (void)keyBoardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSValue *frameValue = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [frameValue CGRectValue].size;
    CGFloat keyBoardH = keyboardSize.height;//186
    [self animatedWithHeight:self.contentView.height - kHeight - keyBoardH];
}
- (void)keyBoardWillHide:(NSNotification *)notification {
    [self animatedWithHeight:self.contentView.height - kHeight];
}

- (void)textFieldDidChangeNotification:(NSNotification *)notification {
    NSString *city = self.cityTF.text;
    
}

- (void)animatedWithHeight:(CGFloat)height {
    [UIView animateWithDuration:kAnimatedTime animations:^{
        self.frame = CGRectMake(0, height, self.width, self.height);
    } completion:nil];
}
#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
        self.proviceStr = [self.provinceArray objectAtIndex:row];
        
        
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
        
        self.cityStr = [self.cityArray objectAtIndex:row];
    }
    
    [pickerView reloadComponent:2];
    
    if (component == 2) {
        self.townStr = [self.townArray objectAtIndex:row];
    }
    
//    [self saveRow:row component:component];
}

- (void)saveRow:(NSInteger)row component:(NSInteger)component {
    NSString *key = [@"pickerRowForKey" stringByAppendingString:[NSString stringWithFormat:@"%@",@(component)]];
    [[NSUserDefaults standardUserDefaults] setInteger:row forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
