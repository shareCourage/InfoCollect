//
//  PHSettingTextItem.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^PHSettingItemOption)();

@interface PHSettingTextItem : NSObject

@property (nonatomic, copy) PHSettingItemOption option;
@property (nonatomic, copy, readonly) NSString *labelTitle;
@property (nonatomic, copy, readonly) NSString *accessoryName;
@property (nonatomic, assign) UIKeyboardType keyboardType;

- (instancetype)initWithLabelTitle:(NSString *)labelTitle accessoryName:(NSString *)accessoryName;
+ (instancetype)itemWithLabelTitle:(NSString *)labelTitle accessoryName:(NSString *)accessoryName;
+ (instancetype)itemWithLabelTitle:(NSString *)labelTitle;

@end
