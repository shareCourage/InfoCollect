//
//  PHCourier.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
@class PHCompanyInfo;

@interface PHCourier : NSObject

@property (nonatomic, strong) PHCompanyInfo *company;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *branch;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *identityCardId;
@property (nonatomic, strong) NSNumber *isDeleted;
@property (nonatomic, strong) NSNumber *isLocked;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *photo;//base64
@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *userPassword;
@property (nonatomic, copy) NSString *username;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
