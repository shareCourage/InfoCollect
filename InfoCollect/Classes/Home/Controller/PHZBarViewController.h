//
//  PHZBarViewController.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHViewController.h"

@interface PHZBarViewController : PHViewController

- (instancetype)initWithOption:(void (^)(NSString *orderNum))option;


@end
