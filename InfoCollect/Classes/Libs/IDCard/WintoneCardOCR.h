//
//  WintoneCardOCR.h
//  WintoneCardOCR
//
//  Created by wintone on 15/6/23.
//  Copyright (c) 2015年 wintone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlideLine.h"

@interface WintoneCardOCR : NSObject

//初始化核心
-(int)InitIDCardWithDevcode:(NSString *)devcode;
// 设置感兴趣区域
- (int) setROIWithLeft: (int)nLeft Top: (int)nTop Right: (int)nRight Bottom: (int)nBottom;
//根据证件类型设置剪边
-(int) setConfirmSideMethodWithType:(int) aType;
// 找边
- (SlideLine *) confirmSlideLineWithBuffer:(UInt8 *)buffer Width:(int)width Height:(int)height;
//检测图片是否清晰
- (int) checkPicIsClearWithBuffer:(UInt8 *)buffer width:(int)width height:(int)height;
//机读码
- (int) GetAcquireMRZSignal:(UInt8 *)buffer Width:(int)width Height:(int)height Left:(int)left Right:(int)right Top:(int)top Bottom:(int)bottom RotateType:(int)rotatetype;
//加载机读码
- (int) loadMRZImageWithBuffer:(UInt8 *)buffer Width:(int)width Height:(int)height;
// 导入内存
- (int) loadImageWithBuffer:(UInt8 *)buffer Width:(int)width Height:(int)height;
// 导入路径图片
-(int)LoadImageToMemoryWithFileName:(NSString *)lpImageFileName Type:(int)type;
// 裁边 自动识别用
- (int) CropBySideLine;
//保存裁切后的整幅图片
- (int) saveImage:(NSString *)path;
//保存头像
- (int) saveHeaderImage: (NSString *)path;
//识别二代证正反面，需要时调用
- (int) autoRecogChineseID;
//识别
- (int) recogIDCardWithMainID: (int) nMainID;
//取字段名
-(NSString *)GetFieldNameWithIndex:(int) nIndex;
//取识别结果
-(NSString *)GetRecogResultWithIndex:(int) nIndex;
//释放核心
-(void)recogFree;

@end
