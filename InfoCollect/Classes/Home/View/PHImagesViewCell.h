//
//  PHImagesViewCell.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHImagesViewCell;

@protocol PHImagesViewCellDelegate <NSObject>

@optional
- (void)imagesViewCell:(PHImagesViewCell *)cell didDoubleClickImageTag:(NSUInteger)tag;

@end

@interface PHImagesViewCell : UITableViewCell

@property (nonatomic, weak) id <PHImagesViewCellDelegate> delegate;
@property (nonatomic, strong) NSArray *images;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
