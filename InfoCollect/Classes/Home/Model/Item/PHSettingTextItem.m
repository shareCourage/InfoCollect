//
//  PHSettingTextItem.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHSettingTextItem.h"

@implementation PHSettingTextItem

- (instancetype)initWithLabelTitle:(NSString *)labelTitle accessoryName:(NSString *)accessoryName {
    self = [super init];
    if (self) {
        _labelTitle = labelTitle;
        _accessoryName = accessoryName;
        _keyboardType = UIKeyboardTypeDefault;
    }
    return self;
}

+ (instancetype)itemWithLabelTitle:(NSString *)labelTitle accessoryName:(NSString *)accessoryName {
    return [[self alloc] initWithLabelTitle:labelTitle accessoryName:accessoryName];
}

+ (instancetype)itemWithLabelTitle:(NSString *)labelTitle {
    return [self itemWithLabelTitle:labelTitle accessoryName:nil];
}
@end
