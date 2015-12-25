//
//  PHAnouncementController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/25.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHAnouncementController.h"
#import "PHLabel.h"

@interface PHAnouncementController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet PHLabel *contentLabel;
@end

@implementation PHAnouncementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    self.contentLabel.verticalAlignment = VerticalAlignmentTop;
    [self request];
}

#pragma mark - Request 

- (void)request {
    if ([PHUseInfo sharedPHUseInfo].token) {
        NSDictionary *para = @{kArgu_token : [PHUseInfo sharedPHUseInfo].token};
        [EBNetworkRequest GET:kUrl_getMessage parameters:para dictBlock:^(NSDictionary *dict) {
            PHLog(@"%@",dict);
            NSDictionary *message = dict[kArgu_messageInfos];
            NSString *content = message[kArgu_content];
            NSString *title = message[kArgu_title];
            self.titleLabel.text = title ? : @"标题";
            self.contentLabel.text = content ? : @"消息内容";
            
        } errorBlock:^(NSError *error) {
            
        }];
        
    }
}

@end
