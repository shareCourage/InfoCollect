//
//  PHRightViewGroup.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHRightViewGroup.h"

@implementation PHRightViewGroup

+ (instancetype)groupWithIcon:(NSString *)icon {
    PHRightViewGroup *right = [[PHRightViewGroup alloc] init];
    right.rightIcon = icon;
    return right;
}

@end
