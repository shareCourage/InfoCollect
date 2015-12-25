//
//  PHUseInfo.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
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
 *  从服务器获取的当前的版本号
 */
@property (nonatomic, copy) NSString *appVersion;

/**
 *  点击登录，登录成功保存的时间
 */
@property (nonatomic, strong) NSDate *loginDate;
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
/**
 *  扫描身份证获取的信息
 *  姓名 : ..
 *  性别 :
 *  民族 :
 *  出生 :
 *  住址 :
 *  公民身份证号码 :
 */
@property (nonatomic, strong) NSArray *identityInfo;

/**
 *  高德地图
 */
@property (nonatomic, strong, readonly) MAMapView *maMapView;
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;


@end
