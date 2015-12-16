//
//  PHUseInfo.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class PHCourier;

@interface PHUseInfo : NSObject
singleton_interface(PHUseInfo)

/**
 *  用户名
 */
@property (nonatomic, copy) NSString *userName;
/**
 *  用户密码
 */
@property (nonatomic, copy) NSString *userCode;
/**
 *  用户token
 */
@property (nonatomic, copy) NSString *token;
/**
 *  是否保存到本地
 */
@property (nonatomic, assign, getter = isSaveToLocal) BOOL saveToLocal;
/**
 *  网络获取的快递员信息
 */
@property (nonatomic, strong) PHCourier *courier;

/**
 *  将上述信息置位nil
 */
- (void)setPropertyNil;

- (void)setPropertyValue:(NSDictionary *)value;

/**
 *  快递单号
 */
@property (nonatomic, copy) NSString *courierNo;

@end
