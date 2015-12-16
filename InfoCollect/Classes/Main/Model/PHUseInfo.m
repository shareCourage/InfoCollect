//
//  PHUseInfo.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHUseInfo.h"
#import "PHCourier.h"

@implementation PHUseInfo
@synthesize userName = _userName;
@synthesize userCode = _userCode;
@synthesize token = _token;
singleton_implementation(PHUseInfo)

- (instancetype)init {
    self = [super init];
    if (self) {
        _saveToLocal = YES;
    }
    return self;
}

- (NSString *)userName {
    if (!_userName) {
        _userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNameForKey"];
    }
    return _userName;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    if (self.isSaveToLocal) {
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userNameForKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (NSString *)userCode {
    if (!_userCode) {
        _userCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCodeForKey"];
    }
    return _userCode;
}

- (void)setUserCode:(NSString *)userCode {
    _userCode = userCode;
    if (self.isSaveToLocal) {
        [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCodeForKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (NSString *)token {
    if (!_token) {
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenForKey"];
    }
    return _token;
}

- (void)setToken:(NSString *)token {
    _token = token;
    if (self.isSaveToLocal) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"tokenForKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)setPropertyNil {
    self.userName = nil;
    self.userCode = nil;
    self.token = nil;
    self.courier = nil;
}

- (void)setPropertyValue:(NSDictionary *)value {
    if (value.count == 0) return;
    NSDictionary *courierInfoD = value[kArgu_loginedCourierInfo];
    NSString *token = courierInfoD[kArgu_token];
    token ? ([PHUseInfo sharedPHUseInfo].token = token) : nil;
    NSDictionary *courierD = courierInfoD[kArgu_courier];
    PHCourier *courier = [[PHCourier alloc] initWithDict:courierD];
    self.courier = courier;
}

@end








