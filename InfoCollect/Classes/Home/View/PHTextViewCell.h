//
//  PHTextViewCell.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/19.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHSettingTextItem, PHTextViewCell;


@protocol PHTextViewCellDelegate <NSObject>

@optional
- (void)textViewCellControlDidClick:(PHTextViewCell *)textView;

@end

@interface PHTextViewCell : UITableViewCell

@property (nonatomic, strong) PHSettingTextItem *textItem;
@property (nonatomic, strong) NSString *textVTitle;
@property (nonatomic, assign) id <PHTextViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
