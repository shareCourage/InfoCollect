//
//  PHCompanyInfo.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHCompanyInfo.h"
#import <MJExtension/MJExtension.h>

@implementation PHCompanyInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        [PHCompanyInfo setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
    }
    return self;
}

@end
