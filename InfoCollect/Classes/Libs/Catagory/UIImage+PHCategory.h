//
//  UIImage+PHCategory.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/18.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PHCategory)
/**
 *  图片拉伸
 *
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

/**
 *  @brief  将一个 CIImage 的图片 替换为指定大小 UIImage 的方法
 *
 *  @param image 需要替换的 CIImage 的实例
 *  @param size  指定的 宽/高
 *
 *  @return 返回得到的额 UIImage 的实例
 */
- (UIImage *)nonInouterpolatedUIImageFromCIImage:(CIImage *)image withSize:(CGFloat)size;

/**
 *  @brief  生成一个 CIImage 的二维码
 *
 *  @param qrString 二维码包含的信息字符串
 *
 *  @return 返回创建的二维码
 */
- (CIImage *)creatQRForString:(NSString *)qrString;

/**
 *  等比率缩放
 *
 */
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;


@end
