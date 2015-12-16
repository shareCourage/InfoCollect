//
//  PHCompanyInfo.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHCompanyInfo : NSObject

/**
 *  
 "addr": "金东区金港大道东688号",
 "artifPersonAddr": "金东区金港大道东688号",
 "artifPersonName": "黄伟民",
 "artifPersonPhone": "13738956002",
 "businessCertificate": "330703000077557",
 "companyType": "KDQY",
 "id": "75955c44775146fd8d715c23e6c2fe9a",
 "isDeleted": false,
 "kdybCode": "yuantong",
 "name": "金华市华飞速递有限公司",
 "no": "JDQ01",
 "parentName": "----",
 "state": "closed",
 "text": "金华市华飞速递有限公司",
 "userPassword": "****",
 "username": "U001"
 */

@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *artifPersonAddr;
@property (nonatomic, copy) NSString *artifPersonName;
@property (nonatomic, copy) NSString *artifPersonPhone;
@property (nonatomic, copy) NSString *businessCertificate;
@property (nonatomic, copy) NSString *companyType;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSNumber *isDeleted;
@property (nonatomic, copy) NSString *kdybCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *parentName;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *userPassword;
@property (nonatomic, copy) NSString *username;

@end





