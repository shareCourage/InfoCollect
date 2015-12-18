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

static NSString *kUrl_Host    = @"http://61.164.44.165:39175";
#define kUrl_appRequest         [kUrl_Host stringByAppendingPathComponent:@"appRequest"]
#define kUrl_login              [kUrl_appRequest stringByAppendingPathComponent:@"login"]


static NSString *kArgu_identityCardId       = @"identityCardId";
static NSString *kArgu_pwd                  = @"pwd";
static NSString *kArgu_loginedCourierInfo   = @"loginedCourierInfo";
static NSString *kArgu_courier              = @"courier";
static NSString *kArgu_result               = @"result";
static NSString *kArgu_success              = @"success";
static NSString *kArgu_token                = @"token";


#endif /* PHInfo_h */
