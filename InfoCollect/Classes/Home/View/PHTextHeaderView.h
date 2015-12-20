//
//  PHTextHeaderView.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHSettingGroup, PHTextHeaderView;

@protocol PHTextHeaderViewDelegate <NSObject>

@optional
- (void)headerViewDidClickRightBtn:(PHTextHeaderView *)headerView;

@end

@interface PHTextHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id <PHTextHeaderViewDelegate>delegate;
@property (nonatomic, strong) PHSettingGroup *group;
+ (instancetype)headerWithTableView:(UITableView *)tableView;

@end
