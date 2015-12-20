//
//  PHRightViewGroup.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHSettingGroup.h"

@interface PHRightViewGroup : PHSettingGroup

@property (nonatomic, copy) NSString *rightIcon;

+ (instancetype)groupWithIcon:(NSString *)icon;

@end
