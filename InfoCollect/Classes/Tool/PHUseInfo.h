//
//  PHUseInfo.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface PHUseInfo : NSObject
singleton_interface(PHUseInfo)

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userCode;

@end
