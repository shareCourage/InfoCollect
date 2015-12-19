//
//  PHZBarViewController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHZBarViewController.h"
#import <ZBarSDK/ZBarSDK.h>
#define VIEW_WIDTH  [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCANVIEW_EdgeTop 40.0
#define SCANVIEW_EdgeLeft 50.0
#define TINTCOLOR_ALPHA 0.2  //浅色透明度
#define DARKCOLOR_ALPHA 0.5  //深色透明度
@interface PHZBarViewController ()<ZBarReaderViewDelegate>
{
    UIView *_QrCodeline;
    NSTimer *_timer;
    //设置扫描画面
    UIView *_scanView;
    ZBarReaderView *_readerView;
}
@property (nonatomic, copy) void (^option) (NSString *orderNum);
@end

@implementation PHZBarViewController
- (instancetype)initWithOption:(void (^)(NSString *))option {
    self = [super init];
    if (self) {
        self.option = option;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"二维码/条形码";
    //初始化扫描界面
    [self setScanView];
    _readerView= [[ZBarReaderView alloc] init];
    _readerView.frame =CGRectMake(0,64, VIEW_WIDTH, VIEW_HEIGHT -64);
    _readerView.tracksSymbols = NO;
    _readerView.readerDelegate = self;
    [_readerView addSubview:_scanView];
    //关闭闪光灯
    _readerView.torchMode =0;
    [self.view addSubview:_readerView];
    [_readerView start];
    [self createTimer];
}


#pragma mark -- ZBarReaderViewDelegate

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image

{
    const zbar_symbol_t *symbol =zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    [PHUseInfo sharedPHUseInfo].courierNo = symbolStr;
    if (self.option) self.option(symbolStr);
    [self.navigationController popViewControllerAnimated:YES];
    
    //判断是否包含 头'http:'
    NSString *regex =@"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //判断是否包含 头'ssid:'
    NSString *ssid =@"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    if ([predicate evaluateWithObject:symbolStr]) {//如果带http
    }
    else if([ssidPre evaluateWithObject:symbolStr]){//如果带ssid
        NSArray *arr = [symbolStr componentsSeparatedByString:@";"];
        NSArray * arrInfoHead = [[arr objectAtIndex:0]componentsSeparatedByString:@":"];
        NSArray * arrInfoFoot = [[arr objectAtIndex:1]componentsSeparatedByString:@":"];
        symbolStr = [NSString stringWithFormat:@"ssid: %@ \n password:%@",
                     [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        //然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        pasteboard.string = [arrInfoFoot objectAtIndex:1];
    }
}



//二维码的扫描区域

- (void)setScanView {
    
    _scanView=[[UIView alloc] initWithFrame:CGRectMake(0,0, VIEW_WIDTH,VIEW_HEIGHT-64)];
    _scanView.backgroundColor=[UIColor clearColor];
    //最上部view
    UIView * upView = [[UIView alloc] initWithFrame:CGRectMake(0,0, VIEW_WIDTH,SCANVIEW_EdgeTop)];
    upView.alpha =TINTCOLOR_ALPHA;
    upView.backgroundColor = [UIColor purpleColor];
    [_scanView addSubview:upView];
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,VIEW_WIDTH-2*SCANVIEW_EdgeLeft)];
    leftView.alpha =TINTCOLOR_ALPHA;
    leftView.backgroundColor = [UIColor purpleColor];
    [_scanView addSubview:leftView];
    /******************中间扫描区域****************************/
    
    UIImageView *scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft,VIEW_WIDTH-2*SCANVIEW_EdgeLeft)];
    //scanCropView.image=[UIImage imageNamed:@""];
    scanCropView.layer.borderColor=[UIColor redColor].CGColor;
    scanCropView.layer.borderWidth=2.0;
    scanCropView.backgroundColor=[UIColor clearColor];
    [_scanView addSubview:scanCropView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH-SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,VIEW_WIDTH-2*SCANVIEW_EdgeLeft)];
    rightView.alpha =TINTCOLOR_ALPHA;
    rightView.backgroundColor = [UIColor purpleColor];
    [_scanView addSubview:rightView];
    

    //底部view
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0,VIEW_WIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop,VIEW_WIDTH, VIEW_HEIGHT-(VIEW_WIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop)-64)];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:TINTCOLOR_ALPHA];
    [_scanView addSubview:downView];
    
    
    
    //用于说明的label
    
    UILabel *labIntroudction= [[UILabel alloc] init];
    
    labIntroudction.backgroundColor = [UIColor clearColor];
    
    labIntroudction.frame=CGRectMake(0,5, VIEW_WIDTH,20);
    
    labIntroudction.numberOfLines=1;
    
    labIntroudction.font=[UIFont systemFontOfSize:15.0];
    
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    
    labIntroudction.textColor=[UIColor whiteColor];
    
    labIntroudction.text=@"将二维码/条形码放入方框内，即可自动扫描";
    
    [downView addSubview:labIntroudction];
    
    
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, downView.frame.size.height-100.0,VIEW_WIDTH, 100.0)];
    
    darkView.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:DARKCOLOR_ALPHA];
    
    [downView addSubview:darkView];
    
    
    
    //用于开关灯操作的button
    
    UIButton *openButton=[[UIButton alloc] initWithFrame:CGRectMake(10,20, 300.0, 40.0)];
    
    openButton.layer.cornerRadius = 5;
    
    [openButton setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    
    [openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    openButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    openButton.backgroundColor = kRedColor;
    
    openButton.titleLabel.font=[UIFont systemFontOfSize:22.0];
    
    [openButton addTarget:self action:@selector(openLight) forControlEvents:UIControlEventTouchUpInside];
    
    [darkView addSubview:openButton];
    
    
    
    //画中间的基准线
    
    _QrCodeline = [[UIView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft,2)];
    _QrCodeline.backgroundColor = [UIColor redColor];
    [_scanView addSubview:_QrCodeline];
    
}

- (void)openLight {
    if (_readerView.torchMode ==0) {
        _readerView.torchMode =1;
    } else {
        _readerView.torchMode =0;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_readerView.torchMode ==1) {
        _readerView.torchMode =0;
    }
    [self stopTimer];
    [_readerView stop];
}

//二维码的横线移动

- (void)moveUpAndDownLine {
    CGFloat Y = _QrCodeline.frame.origin.y;
    //CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft, 1)]
    if (VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop == Y){
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:1];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft,1);
        [UIView commitAnimations];
    }else if(SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:1];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, VIEW_WIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft,1);
        [UIView commitAnimations];
    }
}


- (void)createTimer {
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer =nil;
    }
}

@end



