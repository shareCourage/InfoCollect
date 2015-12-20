//
//  PHImagesViewCell.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/20.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHImagesViewCell.h"

@interface PHImagesViewCell ()

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation PHImagesViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PHImagesViewCell";
    PHImagesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PHImagesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageViews = [NSMutableArray array];
        for (NSInteger i = 0; i < kMaxImages; i ++) {
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.tag = i;
            imageV.userInteractionEnabled = YES;
            [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapClick:)]];
            [self.imageViews addObject:imageV];
            [self.contentView addSubview:imageV];
            
        }
    }
    return self;
}
- (void)imageTapClick:(UIGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    if ([self.delegate respondsToSelector:@selector(imagesViewCell:didSelectImageTag:)]) {
        [self.delegate imagesViewCell:self didSelectImageTag:view.tag];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.images.count == 0) return;
    CGFloat height = kPhotoHeight;
    CGFloat width = height;
    CGFloat padding = (self.width - width * 3) / 4;
    CGFloat y = padding;
    CGFloat x = padding;
    for (NSInteger i = 0; i < kMaxImages; i ++) {
        UIImageView *imageV = [self.imageViews objectAtIndex:i];
        CGFloat a = i / 3.f;
        if (a < 1) {
            y = padding;
            x = padding + i * (width + padding);
            imageV.frame = CGRectMake(x, y, width, height);
        } else if ( a < 2) {
            y = padding * 2 + height;
            x = padding + (i - 3) * (width + padding);
            imageV.frame = CGRectMake(x, y, width, height);
        }else if (a < 3) {
            y = padding * 3 + height * 2;
            x = padding + (i - 6) * (width + padding);
            imageV.frame = CGRectMake(x, y, width, height);
        }
    }
}

- (void)setImages:(NSArray *)images {
    _images = images;
    NSUInteger i = 0;
    for (UIImage *image in images) {
        UIImageView *imageV = i < self.imageViews.count ? [self.imageViews objectAtIndex:i] : nil;
        imageV.image = image;
        i ++;
    }
}

@end




