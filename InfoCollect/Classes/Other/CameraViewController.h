//
//  CameraViewController.h
//  BankCardRecog
//
//  Created by wintone on 15/1/22.
//  Copyright (c) 2015年 wintone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AudioToolbox/AudioToolbox.h>


@interface CameraViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, retain) CALayer *customLayer;
@property (nonatomic,assign) BOOL isProcessingImage;

@property (strong, nonatomic) AVCaptureSession *session;

@property (strong, nonatomic) AVCaptureDeviceInput *captureInput;

@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

//识别证件类型及结果个数
@property (assign, nonatomic) int recogType;
@property (assign, nonatomic) int resultCount;
@property (strong, nonatomic) NSString *typeName;

@end
