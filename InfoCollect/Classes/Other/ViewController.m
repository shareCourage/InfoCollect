//
//  ViewController.m
//  IDCardDemo
//
//  Created by wintone on 15/6/2.
//  Copyright (c) 2015年 wintone. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"
#import "Type.h"
#import "WintoneCardOCR.h"
#import "ResultViewController.h"

@interface ViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSString *_imagePath;
}

@property (strong, nonatomic) NSMutableArray *types;

@property (assign, nonatomic) int cardType;

@property (assign, nonatomic) int resultCount;

@property (strong, nonatomic) NSString *typeName;

@property (strong, nonatomic) WintoneCardOCR *cardRecog;

@end

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //默认证件类型为二代证正面
    self.cardType = 2;
    self.resultCount = 7;
    self.typeName = @"二代证身份证";
    //初始化证件类型
    [self setCardTypes];
}

- (void) setCardTypes
{
    self.types = [NSMutableArray array];
    
    Type *mrz = [[Type alloc] init];
    mrz.typeName = @"机读码";
    mrz.typeCode = 3000;
    mrz.count = 4;
    [self.types addObject:mrz];
    
    Type *passport = [[Type alloc] init];
    passport.typeName = @"护照";
    passport.typeCode = 13;
    passport.count = 17;
    [self.types addObject:passport];
    
    Type *IDCard = [[Type alloc] init];
    IDCard.typeName = @"二代身份证";
    IDCard.typeCode = 2;
    IDCard.count = 7;
    [self.types addObject:IDCard];
    
    Type *drivingLicense1 = [[Type alloc] init];
    drivingLicense1.typeName = @"中国驾照";
    drivingLicense1.typeCode = 5;
    drivingLicense1.count = 6;
    [self.types addObject:drivingLicense1];
    
    Type *drivingLicense2 = [[Type alloc] init];
    drivingLicense2.typeName = @"中国行驶证";
    drivingLicense2.typeCode = 6;
    drivingLicense2.count = 11;
    [self.types addObject:drivingLicense2];
    
    Type *eep = [[Type alloc] init];
    eep.typeName = @"港澳通行证";
    eep.typeCode = 9;
    eep.count = 17;
    [self.types addObject:eep];
    
    /*新版港澳通行证 、台湾通行证、港澳回乡证、台胞证、中国签证*/
    Type *newEEP = [[Type alloc] init];
    newEEP .typeName = @"新版港澳通行证";
    newEEP.typeCode = 22;
    newEEP.count = 9;
    [self.types addObject:newEEP];
    
    Type *taiwanPass = [[Type alloc] init];
    taiwanPass.typeName = @"台湾通行证";
    taiwanPass.typeCode = 11;
    taiwanPass.count = 16;
    [self.types addObject:taiwanPass];
    
    Type *homeReturnObverse = [[Type alloc] init];
    homeReturnObverse.typeName = @"回乡证正面";
    homeReturnObverse.typeCode = 14;
    homeReturnObverse.count = 11;
    [self.types addObject:homeReturnObverse];
    
    Type *homeReturnReverse = [[Type alloc] init];
    homeReturnReverse.typeName = @"回乡证背面";
    homeReturnReverse.typeCode = 15;
    homeReturnReverse.count = 13;
    [self.types addObject:homeReturnReverse];
    
    Type *toMainland = [[Type alloc] init];
    toMainland.typeName = @"台胞证";
    toMainland.typeCode = 10;
    toMainland.count = 15;
    [self.types addObject:toMainland];
    
    Type *visa = [[Type alloc] init];
    visa.typeName = @"中国签证";
    visa.typeCode = 12;
    visa.count = 19;
    [self.types addObject:visa];
}

//选择证件类型
- (IBAction)selectCardType:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = @"选择证件类型";
    for (Type *type in self.types) {
        [actionSheet addButtonWithTitle:type.typeName];
    }
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet setCancelButtonIndex:self.types.count];
    actionSheet.delegate = self;
    
    [actionSheet showInView:self.view.window];
}
//拍照识别
- (IBAction)recogImage:(id)sender
{
    CameraViewController *cameraVC = [[CameraViewController alloc] init];
    cameraVC.recogType = self.cardType;
    cameraVC.resultCount = self.resultCount;
    cameraVC.typeName = self.typeName;
    [self.navigationController pushViewController:cameraVC animated:YES];
}
//选择识别
- (IBAction)selectToRecog:(id)sender
{
    [self performSelectorInBackground:@selector(initRecog) withObject:nil];
    //初始化相册
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    picker.sourceType=sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

//初始化核心
- (void) initRecog
{
    self.cardRecog = [[WintoneCardOCR alloc] init];
    /*提示：该开发码和项目中的授权仅为演示用，客户开发时请替换该开发码及项目中Copy Bundle Resources 中的.lsc授权文件*/
    int intRecog = [self.cardRecog InitIDCardWithDevcode:Argu_KeyOfIDCard];
    NSLog(@"intRecog = %d",intRecog);
}

#pragma mark--选取相册图片

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSelectorInBackground:@selector(didFinishedSelect:) withObject:image];
}

//存储照片
-(void)didFinishedSelect:(UIImage *)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    UIImage *saveImage = image;
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"WintoneIDCardFree.jpg"];
    
    //压缩图片
    UIGraphicsBeginImageContext(CGSizeMake(1280, 960));
    [saveImage drawInRect:CGRectMake(0, 0, 1280, 960)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //存储图片
    [UIImageJPEGRepresentation(reSizeImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    _imagePath = imageFilePath;
    [self performSelectorInBackground:@selector(recog) withObject:nil];
}

//取消选择
-(void)imagePickerControllerDIdCancel:(UIImagePickerController*)picker

{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)recog
{
    int loadImage = [self.cardRecog LoadImageToMemoryWithFileName:_imagePath Type:0];
        
    NSLog(@"loadImage = %d", loadImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *caches = paths[0];
    NSString *imagepath = [caches stringByAppendingPathComponent:@"image.jpg"];
    NSString *headImagePath = [caches stringByAppendingPathComponent:@"head.jpg"];
    
    [self.cardRecog saveImage:imagepath];
    
    if (self.cardType != 3000) {//***注意：机读码需要自己重新设置类型来识别
        if (self.cardType == 2) {
            //自动分辨二代证正反面
            [self.cardRecog autoRecogChineseID];
        }else{
            //其他证件
            [self.cardRecog recogIDCardWithMainID:self.cardType];
        }
        //非机读码，保存头像
        [self.cardRecog saveHeaderImage:headImagePath];
        
        //获取识别结果
        NSString *allResult = @"";
        for (int i = 1; i < self.resultCount; i++) {
            //获取字段值
            NSString *field = [self.cardRecog GetFieldNameWithIndex:i];
            //获取字段结果
            NSString *result = [self.cardRecog GetRecogResultWithIndex:i];
            NSLog(@"%@:%@\n",field, result);
            if(field != NULL){
                allResult = [allResult stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n", field, result]];
            }
        }
        if (![allResult isEqualToString:@""]) {
            //识别结果不为空，跳转到结果展示页面
            ResultViewController *rvc = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
            NSLog(@"allresult = %@", allResult);
            rvc.resultArray = nil;
            [self.navigationController pushViewController:rvc animated:YES];
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    Type *type = self.types[buttonIndex];
    self.cardType = type.typeCode;
    self.resultCount = type.count;
    self.typeName = type.typeName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
