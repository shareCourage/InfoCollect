//
//  PHTextViewCell.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHTextViewCell.h"
#import "PHSettingTextItem.h"

@interface PHTextViewCell ()

@property (nonatomic, weak) UILabel *leftL;
@property (nonatomic, weak) UITextField *textView;

@property (nonatomic, weak) UIButton *control;
@end


@implementation PHTextViewCell
@synthesize textVTitle = _textVTitle;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTextVTitle:(NSString *)textVTitle {//这个方法是给从textField外部赋值用的
    _textVTitle = textVTitle;
    self.textView.text = textVTitle;
    self.textItem.textFTitle = textVTitle;
}

- (NSString *)textVTitle {
    return self.textView.text;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UILabel *leftL = [[UILabel alloc] init];
    leftL.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.6f];
    [leftL setSystemFontOf15];
    [self.contentView addSubview:leftL];
    self.leftL = leftL;
    
    UITextField *textView = [[UITextField alloc] init];
    textView.font = [UIFont systemFontOfSize:16];
    textView.textAlignment = NSTextAlignmentNatural;
//    textView.scrollEnabled = NO;
    textView.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:textView];
    self.textView = textView;
    
    UIButton *control = [UIButton buttonWithType:UIButtonTypeCustom];
    control.backgroundColor = [UIColor clearColor];
    control.hidden = YES;
    [textView addSubview:control];
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    self.control = control;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tfDidChangedNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [self.leftL boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height)].width;
    self.leftL.frame = CGRectMake(3, 0, width, self.height);
    CGFloat tvx = CGRectGetMaxX(self.leftL.frame) + 5;
    CGFloat tvy = 0;
    CGFloat tvw = self.width - width - (self.textItem.accessoryName ? 40 : 0);
    CGFloat tvh = self.height;
    self.textView.frame = CGRectMake(tvx, tvy, tvw, tvh);
    self.control.frame = self.textView.bounds;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"PHTextViewCell";
    PHTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PHTextViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - Setter方法
- (void)setTextItem:(PHSettingTextItem *)textItem {
    _textItem = textItem;
    if (!textItem) return;
//    self.textView.editable = !textItem.option ? YES : NO;
    self.textView.enabled = textItem.isTextFEnable;
    [self setupUI];
    [self setupData];
}
- (void)setupUI {
    self.textView.keyboardType = self.textItem.keyboardType;
    if (self.textItem.accessoryName.length != 0) {
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.textItem.accessoryName]];
        imageV.userInteractionEnabled = YES;
        [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            if (self.textItem.option) self.textItem.option();
        }]];
        self.accessoryView = imageV;
    } else {
        self.accessoryView = nil;
    }
    NSString *string = self.textItem.labelTitle;
    BOOL value = [string isEqualToString:@"物品类型"] || [string isEqualToString:@"寄件人电话"] || [string isEqualToString:@"收件人电话"] || [string isEqualToString:@"收件人姓名"];
    if (value) {
        self.control.hidden = NO;
    } else {
        self.control.hidden = YES;
    }
}

- (void)setupData {
    self.leftL.text = self.textItem.labelTitle;
    
    self.textView.text = self.textItem.textFTitle;//为了处理因为UITextField复用的问题
}

#pragma mark - Target
- (void)controlClick {
    if ([self.delegate respondsToSelector:@selector(textViewCellControlDidClick:)]) {
        [self.delegate textViewCellControlDidClick:self];
    }
    [self.control removeFromSuperview];
    PHLog(@"controlClick %@", self.textItem.labelTitle);
}

#pragma mark - Notification
- (void)tfDidChangedNotification:(NSNotification *)notification {
    id obj = notification.object;
    if ([obj isKindOfClass:[UITextField class]] && obj == self.textView) {//必须要先判断是否是该类的UITextField
        self.textItem.textFTitle = self.textView.text;//将数据保存到该模型当中，上下拉的时候可以复用
    }
}

@end




