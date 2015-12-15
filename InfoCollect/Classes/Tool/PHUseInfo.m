//
//  PHUseInfo.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHUseInfo.h"

@implementation PHUseInfo
@synthesize userName = _userName;
@synthesize userCode = _userCode;
singleton_implementation(PHUseInfo)


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

@end








