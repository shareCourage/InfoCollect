//
//  PHCourier.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHCourier.h"

@implementation PHCourier

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [PHCourier setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        self = [PHCourier objectWithKeyValues:dict];
    }
    return self;
}


@end
