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
@property (nonatomic, copy) void (^completion) (NSString *province, NSString *city, NSString *town, NSString *code);
@property (nonatomic, copy) NSString *proviceStr;
@property (nonatomic, copy) NSString *cityStr;
@property (nonatomic, copy) NSString *townStr;

@property (nonatomic, assign, getter=isHideRemove) BOOL hideRemove;

@end

@implementation PHCityPickerView

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)provinceArray {
    if (!_provinceArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"newCity" ofType:@"plist"];
        _pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
//        PHLog(@"---------> \n %@", _pickerDic);
        _provinceArray = [_pickerDic allKeys];//所有的省份名字
        NSString *firstProvice = [_provinceArray objectAtIndex:0];//第0个省份名字
        _selectedArray = [_pickerDic objectForKey:firstProvice];//将第0个省份的具体信息取出来
        if (_selectedArray.count > 0) {
            NSDictionary *cityDict = [_selectedArray objectAtIndex:0];//将该省份的信息取出来
            _cityArray = [cityDict allKeys];//再取出key，就是该省份的所有城市列表
        }
        if (_cityArray.count > 0) {
            _townArray = [[_selectedArray objectAtIndex:0] objectForKey:[_cityArray objectAtIndex:0]];
        }
        self.proviceStr = [self.provinceArray firstObject];
        self.cityStr = [self.cityArray firstObject];
        self.townStr = [self.townArray firstObject];
    }
    return _provinceArray;
}

- (IBAction)saveBtnClick:(UIButton *)sender {
    NSArray *array = [self.townStr componentsSeparatedByString:@":"];
    NSString *town = [array firstObject];
    NSString *code = [array lastObject];
    if (self.completion) self.completion(self.proviceStr ? : @"", self.cityStr ? : @"", town ? : @"", code ? : @"");
    [self hide];
}

+ (instancetype)cityPickerAddToView:(UIView *)view completion:(void (^)(NSString *, NSString *, NSString *, NSString *))option{
    PHCityPickerView *picker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    picker.completion = option;
    picker.frame = CGRectMake(0, view.height, view.width, kHeight);
    picker.contentView = view;
    [view addSubview:picker];
    [picker show];
    return picker;
}
+ (instancetype)cityPickerAddToView:(UIView *)view hideRemove:(BOOL)remove completion:(void (^)(NSString *province, NSString *city, NSString *town, NSString *code))option {
    PHCityPickerView *picker = [self cityPickerAddToView:view completion:option];
    picker.hideRemove = remove;
    return picker;
}
- (void)show {
    [self observeNotification];
    [UIView animateWithDuration:kAnimatedTime animations:^{
        self.backgroundColor = kGrayColor;
        self.frame = CGRectMake(0, self.contentView.height - kHeight, self.width, self.height);
    } completion:nil];
}

- (void)hide {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:kAnimatedTime animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, self.contentView.height, self.width, self.height);
    } completion:^(BOOL finished) {
        self.isHideRemove ? [self removeFromSuperview] : nil;
    }];
}

- (void)awakeFromNib {
    self.cityTF.placeholder = @"请输入省、市、区（县）";
    self.cityTF.rightViewMode = UITextFieldViewModeAlways;
    self.cityPickerView.dataSource = self;
    self.cityPickerView.delegate = self;
    self.saveBtn.backgroundColor = kSystemeColor;
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveBtn.titleLabel setSystemFontOf18];
    [self observeNotification];
}

- (void)observeNotification {
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
    NSString *textStr = self.cityTF.text;
    if ([textStr isContainChinese]) {
        __block NSString *foundProvnice = nil;
        __block NSUInteger provinceIndex = 0;
        __block NSUInteger cityIndex = 0;
        __block NSUInteger townIndex = 0;
        [self.pickerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *provinceKey = (NSString *)key;
            NSRange range = [provinceKey rangeOfString:textStr];
            if (range.location != NSNotFound) {
                foundProvnice = provinceKey;
                *stop = YES;//走到这里，说明找到了
            }
            provinceIndex ++;
        }];
        __block NSString *foundCity = nil;
        if (!foundProvnice) {//说明没找到，需要去城市列表找
            provinceIndex = 0;//省份重新计算，清零
            [self.pickerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSArray *provinceObj = (NSArray *)obj;//省份列表
                __block BOOL status = NO;
                [provinceObj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    cityIndex = 0;//城市清零
                    NSDictionary *cityInfo = (NSDictionary *)obj;//城市列表
                    [cityInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        NSString *cityKey = (NSString *)key;
                        NSRange range = [cityKey rangeOfString:textStr];
                        if (range.location != NSNotFound) {
                            foundCity = cityKey;
                            *stop = YES;
                            status = YES;
                        }
                        cityIndex ++;
                    }];
                    *stop = status;//等于YES，这个循环就停止
                }];
                *stop = status;//等于YES，这个循环就停止
                provinceIndex ++;//找到那个省份
            }];
            __block NSString *foundTown = nil;
            if (!foundCity) {//在城市列表中没找到，就要去城镇列表寻找
                provinceIndex = 0;
                cityIndex = 0;
                [self.pickerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSArray *provinceObj = (NSArray *)obj;//省份列表
                    __block BOOL status = NO;
                    [provinceObj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSDictionary *cityInfo = (NSDictionary *)obj;//城市列表
                        cityIndex = 0;
                        [cityInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            NSArray *townInfo = (NSArray *)obj;
                            [townInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSString *townStr = (NSString *)obj;
                                NSRange range = [townStr rangeOfString:textStr];
                                if (range.location != NSNotFound) {
                                    foundTown = townStr;
                                    *stop = YES;
                                    status = YES;
                                }
                                townIndex = idx + 1;
                            }];
                            *stop = status;//等于YES，这个循环就停止
                            cityIndex ++;
                        }];
                        *stop = status;//等于YES，这个循环就停止
                    }];
                    *stop = status;//等于YES，这个循环就停止
                    provinceIndex ++;//找到那个省份
                }];
                if (!foundTown) {
                    PHLog(@"没有找到任何配对的城区");
                } else {
                    PHLog(@"找到了城镇 -> %@",foundTown);
                    NSUInteger provinceRow = provinceIndex - 1;
                    NSUInteger cityRow = cityIndex - 1;
                    NSUInteger townRow = townIndex - 1;
                    [self reloadPickerViewAtProviceRow:provinceRow cityRow:cityRow];
                    [self selectProvinceRow:provinceRow cityRow:cityRow townRow:townRow];
                }
            } else {
                PHLog(@"找到了城市 -> %@",foundCity);
                NSUInteger provinceRow = provinceIndex - 1;
                NSUInteger cityRow = cityIndex - 1;
                [self reloadPickerViewAtProviceRow:provinceRow cityRow:cityRow];
                [self selectProvinceRow:provinceRow cityRow:cityRow townRow:0];
            }
            
        } else {
            PHLog(@"找到了省份 -> %@",foundProvnice);
            NSUInteger row = provinceIndex - 1;
            [self reloadPickerViewAtProviceRow:row cityRow:0];
            [self selectProvinceRow:row cityRow:0 townRow:0];
        }
        PHLog(@"pro -> %@, city -> %@, town -> %@", @(provinceIndex), @(cityIndex), @(townIndex));
    }
}

- (void)reloadPickerViewAtProviceRow:(NSUInteger)row cityRow:(NSUInteger)cityRow{
    NSArray *array = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
    self.cityArray =  [[array objectAtIndex:0] allKeys];
    self.townArray = [[array objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:cityRow]];
    [self.cityPickerView reloadComponent:1];
    [self.cityPickerView reloadComponent:2];
    
    self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
    self.proviceStr = [self.provinceArray objectAtIndex:row];

}

- (void)selectProvinceRow:(NSUInteger)proRow cityRow:(NSUInteger)cityRow townRow:(NSUInteger)townRow {
    [self.cityPickerView selectRow:proRow inComponent:0 animated:YES];
    [self.cityPickerView selectRow:cityRow inComponent:1 animated:YES];
    [self.cityPickerView selectRow:townRow inComponent:2 animated:YES];
    self.cityStr = [self.cityArray objectAtIndex:cityRow];
    self.townStr = [self.townArray objectAtIndex:townRow];
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
        NSString *string = [self.townArray objectAtIndex:row];
        NSArray *array = [string componentsSeparatedByString:@":"];
        return [array firstObject];
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
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        self.proviceStr = [self.provinceArray objectAtIndex:row];
        self.cityStr = [self.cityArray objectAtIndex:0];
        self.townStr = [self.townArray objectAtIndex:0];
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
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        self.cityStr = [self.cityArray objectAtIndex:row];
        self.townStr = [self.townArray objectAtIndex:0];
    }
    
    [pickerView reloadComponent:2];
    
    if (component == 2) {
        self.townStr = [self.townArray objectAtIndex:row];
    }
}


@end
