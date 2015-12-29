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
@synthesize loginDate = _loginDate;
singleton_implementation(PHUseInfo)

- (instancetype)init {
    self = [super init];
    if (self) {
        _maMapView = [[MAMapView alloc] init];
        _maMapView.showsUserLocation = YES;
//        _maMapView.allowsBackgroundLocationUpdates = YES;
        _maMapView.userTrackingMode = MAUserTrackingModeFollow;
        _userLocation = kCLLocationCoordinate2DInvalid;

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
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userNameForKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *)userCode {
    if (!_userCode) {
        _userCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCodeForKey"];
    }
    return _userCode;
}

- (void)setUserCode:(NSString *)userCode {
    _userCode = userCode;
    [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCodeForKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *)token {
    if (!_token) {
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenForKey"];
    }
    return _token;
}

- (void)setToken:(NSString *)token {
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"tokenForKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLoginDate:(NSDate *)loginDate {
    _loginDate = loginDate;
    [[NSUserDefaults standardUserDefaults] setObject:loginDate forKey:@"loginDateForKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)loginDate {
    if (!_loginDate) {
        _loginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginDateForKey"];
    }
    return _loginDate;
}

- (void)setIdentityInfo:(NSArray *)identityInfo {
    _identityInfo = identityInfo;
    if (identityInfo.count == 0) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:PHSaveIdentifyInfoNotification object:nil];
}

- (void)setPropertyNil {
    self.userName = nil;
    self.userCode = nil;
    self.token = nil;
    self.courier = nil;
    self.loginDate = nil;
}

- (void)setPropertyValue:(NSDictionary *)value {
    if (value.count == 0) return;
    NSDictionary *courierInfoD = value[kArgu_loginedCourierInfo];
    NSString *token = courierInfoD[kArgu_token];
    token ? ([PHUseInfo sharedPHUseInfo].token = token) : nil;
    NSDictionary *courierD = courierInfoD[kArgu_courier];
    PHCourier *courier = [[PHCourier alloc] initWithDict:courierD];
    self.courier = courier;
    self.appVersion = courierInfoD[kArgu_appVersion];
}

@end








