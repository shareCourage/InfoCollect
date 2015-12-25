//
//  PHInfo.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#ifndef PHInfo_h
#define PHInfo_h

static NSString * const PHLoadedCourierInfoNotification = @"PHLoadedCourierInfoNotification";
static NSString * const PHSaveIdentifyInfoNotification = @"PHSaveIdentifyInfoNotification";

static NSString *kUrl_Host    = @"http://61.164.44.165:39175";
#define kUrl_appRequest         [kUrl_Host stringByAppendingPathComponent:@"appRequest"]
#define kUrl_login              [kUrl_appRequest stringByAppendingPathComponent:@"login"]
#define kUrl_uploadInfo         [kUrl_appRequest stringByAppendingPathComponent:@"uploadExpressInfo"]
#define kUrl_getMessage         [kUrl_appRequest stringByAppendingPathComponent:@"getUnreadMessage"]
#define KUrl_DownLoadNewestVersion @""

static NSString *kArgu_identityCardId       = @"identityCardId";
static NSString *kArgu_pwd                  = @"pwd";
static NSString *kArgu_loginedCourierInfo   = @"loginedCourierInfo";
static NSString *kArgu_courier              = @"courier";
static NSString *kArgu_result               = @"result";
static NSString *kArgu_success              = @"success";
static NSString *kArgu_token                = @"token";
static NSString *kArgu_appVersion           = @"appVersion";
static NSString *kArgu_messageInfos         = @"messageInfos";
static NSString *kArgu_content              = @"content";
static NSString *kArgu_title                = @"title";
static NSString *kArgu_time                 = @"time";

static NSString *kArgu_courierIdentityCardId    = @"courierIdentityCardId";
static NSString *kArgu_expressNo                = @"expressNo";
static NSString *kArgu_materialType             = @"materialType";
static NSString *kArgu_packageCount             = @"packageCount";
static NSString *kArgu_postPersonName           = @"postPersonName";
static NSString *kArgu_postPersonPhone          = @"postPersonPhone";
static NSString *kArgu_postPersonIdentityCardId = @"postPersonIdentityCardId";
static NSString *kArgu_receiveDistrictid        = @"receiveDistrictid";
static NSString *kArgu_receiveAddr              = @"receiveAddr";
static NSString *kArgu_provincename             = @"provincename";
static NSString *kArgu_cityname                 = @"cityname";
static NSString *kArgu_districtname             = @"districtname";
static NSString *kArgu_receivePersonName        = @"receivePersonName";
static NSString *kArgu_receivePersonPhone       = @"receivePersonPhone";
static NSString *kArgu_takeAddr                 = @"takeAddr";
static NSString *kArgu_takeTime                 = @"takeTime";
static NSString *kArgu_longitude                = @"longitude";
static NSString *kArgu_latitude                 = @"latitude";
static NSString *kArgu_wupinImg                 = @"wupinImg";

#endif /* PHInfo_h */
