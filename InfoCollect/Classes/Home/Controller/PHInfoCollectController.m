//
//  PHInfoCollectController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/16.
//  Copyright © 2015年 Goome. All rights reserved.
//
#import "PHInfoCollectController.h"
#import "PHSettingGroup.h"
#import "PHRightViewGroup.h"
#import "PHSettingTextItem.h"
#import "PHTextViewCell.h"
#import "PHTextHeaderView.h"
#import "PHImagesViewCell.h"
#import "PHCityPickerView.h"
#import "PHAlertController.h"

#import "PHZBarViewController.h"
#import "CameraViewController.h"
#import "EBSelectPositionController.h"

#import "PHCourier.h"

@interface PHInfoCollectController () <UITableViewDataSource, UITableViewDelegate, PHTextHeaderViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHImagesViewCellDelegate, UIScrollViewDelegate, PHTextViewCellDelegate, PHAlertControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *groupHeader;

@property (nonatomic, copy) NSString *orderNumer;//扫描获取的订单号
@property (nonatomic, copy) NSString *senderAddress;//寄件人位置
@property (nonatomic, assign) CLLocationCoordinate2D senderCoord;//寄件人经纬度

@property (nonatomic, strong) NSMutableArray *goodsImages;//拍照返回照片数组

@property (nonatomic, assign) CGRect selectCellFrame;//当前编辑的cell frame值
@property (nonatomic, strong) PHCityPickerView *cityPicker;
@property (nonatomic, weak) PHAlertController *alert;

@property (nonatomic, strong) NSArray *textItemArray;//几个需要显示PHAlertController的行列数组

@property (nonatomic, strong) NSMutableArray *allOfTheModel;

@property (nonatomic, copy) NSString *reProvince;//收件人省份
@property (nonatomic, copy) NSString *reCity;//收件人城市
@property (nonatomic, copy) NSString *reTown;//收件人城区
@property (nonatomic, copy) NSString *reCode;//邮编地址

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) UIBarButtonItem *rightItem;

@end
/**
 *  必须的参数
 快件单号   寄件人电话    收件人姓名   收件人电话   收件人地址   物品类型
 */
@implementation PHInfoCollectController
- (void)dealloc {
    self.tableView.delegate = nil;//处理因为scrollViewDelegate引发的野指针的问题
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [PHUseInfo sharedPHUseInfo].identityInfo = nil;//离开这个界面，扫描保存的信息，也应该清空
}
- (NSMutableArray *)allOfTheModel {
    if (!_allOfTheModel) {
        _allOfTheModel = [NSMutableArray array];
        for (PHSettingGroup *group in self.dataSource) {
            for (id obj in group.items) {
                if ([obj isKindOfClass:[PHSettingTextItem class]]) {
                    PHSettingTextItem *item = (PHSettingTextItem *)obj;
                    [_allOfTheModel addObject:item];
                }
            }
        }
    }
    return _allOfTheModel;
}

- (PHCityPickerView *)cityPicker {
    if (!_cityPicker) {
        kWS(ws);
        _cityPicker = [PHCityPickerView cityPickerAddToView:self.view completion:^(NSString *province, NSString *city, NSString *town, NSString *code) {
            PHLog(@"%@%@%@%@",province,city,town,code);
            NSString *string = [NSString stringWithFormat:@"%@ %@ %@",province,city,town];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
            PHTextViewCell *cell = [ws.tableView cellForRowAtIndexPath:indexPath];
            cell.textVTitle = string;
            PHSettingTextItem *item = [self textItemAtIndexPath:indexPath];
            item.textFTitle = string;//这个目的是为了确保模型能被赋值，防止复用的问题,cell可能会为nil
            [ws.view endEditing:YES];
            
            ws.reProvince = province;
            ws.reCity = city;
            ws.reTown = town;
            ws.reCode = code;
        }];
    }
    return _cityPicker;
}

- (NSMutableArray *)goodsImages {
    if (!_goodsImages) {
        _goodsImages = [NSMutableArray array];
    }
    return _goodsImages;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        _groupHeader = @[@"物品信息", @"寄件人信息", @"收件人信息", @"物品照片"];
    }
    return _dataSource;
}
- (void)commonInitial {
    [self.dataSource addObject:[self one]];;
    [self.dataSource addObject:[self two]];
    [self.dataSource addObject:[self three]];
    [self.dataSource addObject:[self four]];
}
- (void)alertInitial {
    PHAlertController *alert = [PHAlertController alertController];
    alert.hidden = YES;
    alert.delegate = self;
    alert.alertColor = kSystemeColor;
    alert.frame = self.view.bounds;
    [self.view addSubview:alert];
    self.alert = alert;
    
}
- (PHSettingGroup *)one {
    PHSettingGroup *group = [PHSettingGroup group];
    group.header = self.groupHeader[0];
    NSArray *goods = @[@"快递单号", @"物品类型", @"物品数量"];
    PHSettingTextItem *a = [PHSettingTextItem itemWithLabelTitle:goods[0] accessoryName:@"home_scan"];
    a.keyboardType = UIKeyboardTypeNumberPad;
    a.keyOfTitle = kArgu_expressNo;
    kWS(ws);
    a.option = ^{
        //...
        PHZBarViewController *zbar = [[PHZBarViewController alloc] initWithOption:^(NSString *orderNum) {
            PHTextViewCell *cell = [ws.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.textVTitle = orderNum;
            ws.orderNumer = orderNum;
        }];
        [ws.navigationController pushViewController:zbar animated:YES];
    };
    PHSettingTextItem *b = [PHSettingTextItem itemWithLabelTitle:goods[1]];
    b.keyOfTitle = kArgu_materialType;
    PHSettingTextItem *c = [PHSettingTextItem itemWithLabelTitle:goods[2]];
    c.keyOfTitle = kArgu_packageCount;
    c.keyboardType = UIKeyboardTypeNumberPad;
    group.items = @[a,b,c];
    return group;
}
- (PHSettingGroup *)two {
    PHSettingGroup *group = [PHSettingGroup group];
    group.header = self.groupHeader[1];
    NSArray *senders = @[@"寄件人姓名",@"寄件人位置",@"寄件人具体位置",@"寄件人电话"];
    PHSettingTextItem *a = [PHSettingTextItem itemWithLabelTitle:senders[0] accessoryName:@"home_scan"];
    a.textFEnable = NO;
    a.keyOfTitle = kArgu_postPersonName;
    kWS(ws);
    a.option = ^{
        //...
        CameraViewController *vc = [[CameraViewController alloc] init];
        [ws.navigationController pushViewController:vc animated:YES];
        
    };
    PHSettingTextItem *b = [PHSettingTextItem itemWithLabelTitle:senders[1] accessoryName:@"home_location"];
    b.textFEnable = NO;
    b.option = ^{
        EBSelectPositionController *position = [[EBSelectPositionController alloc] initWithExtraOption:^(NSString *title, NSString *district, CLLocationCoordinate2D coord) {
            __strong typeof(&*self) strongSelf = ws;
            PHTextViewCell *cell = [ws.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            cell.textVTitle = title;
            strongSelf.senderAddress = title;
            strongSelf.senderCoord = coord;
        }];
        [ws.navigationController pushViewController:position animated:YES];
    };
    PHSettingTextItem *c = [PHSettingTextItem itemWithLabelTitle:senders[2]];
    PHSettingTextItem *d = [PHSettingTextItem itemWithLabelTitle:senders[3]];
    d.keyOfTitle = kArgu_postPersonPhone;
    d.keyboardType = UIKeyboardTypeNumberPad;
    group.items = @[a,b,c,d];
    return group;
}

- (PHSettingGroup *)three {
    PHSettingGroup *group = [PHSettingGroup group];
    group.header = self.groupHeader[2];
    NSArray *recipers = @[@"收件人姓名",@"收件人地址",@"收件人具体位置",@"收件人电话"];
    PHSettingTextItem *a = [PHSettingTextItem itemWithLabelTitle:recipers[0]];
    a.keyOfTitle = kArgu_receivePersonName;
    PHSettingTextItem *b = [PHSettingTextItem itemWithLabelTitle:recipers[1] accessoryName:@"home_arrow"];
    b.textFEnable = NO;//b 收件人位置
    b.keyOfTitle = kArgu_receiveAddr;
    kWS(ws);
    b.option = ^{
        [ws.cityPicker show];
    };
    PHSettingTextItem *c = [PHSettingTextItem itemWithLabelTitle:recipers[2]];//c 收件人具体位置
    c.keyOfTitle = kArgu_receiveAddr;
    PHSettingTextItem *d = [PHSettingTextItem itemWithLabelTitle:recipers[3]];
    d.keyboardType = UIKeyboardTypeNumberPad;
    d.keyOfTitle = kArgu_receivePersonPhone;
    group.items = @[a,b,c,d];
    return group;
}

- (PHSettingGroup *)four {
    PHSettingGroup *group = [PHRightViewGroup groupWithIcon:@"home_add"];
    group.header = self.groupHeader[3];
    group.items = @[@"a"];
    return group;
}

- (void)tableViewInitial {
    CGFloat commitH = [PHTool isiPhone4s] ? 40 : 50;
    CGFloat tvX = 0;
    CGFloat tvY = 0;
    CGFloat tvW = kWidthOfScreen;
    CGFloat tvH = kHeightOfScreen - commitH;
    CGRect tvF = CGRectMake(tvX, tvY, tvW, tvH);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tvF style:UITableViewStyleGrouped];
//    tableView.allowsSelection = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    if (kiOS7) [tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *commit = [UIButton buttonWithType:UIButtonTypeSystem];
    [commit.titleLabel setSystemFontOf19];
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commit.backgroundColor = kSystemeColor;
    CGFloat commitY = self.view.height - commitH;
    commit.frame = CGRectMake(0, commitY, kWidthOfScreen, commitH);
    [commit addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commit];
}


#pragma mark - Super
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"识别结果";
    self.senderCoord = kCLLocationCoordinate2DInvalid;
    self.view.backgroundColor = kSystemeColor;
    [self tableViewInitial];
    [self commonInitial];
    [self alertInitial];
    kWS(ws);
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [ws.view endEditing:YES];
        __strong typeof(&*self) strongSelf = ws;
        (strongSelf -> _cityPicker) ? [ws.cityPicker hide] : nil;
    }]];
    [self.navigationController.navigationBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [ws.view endEditing:YES];
        __strong typeof(&*self) strongSelf = ws;
        (strongSelf -> _cityPicker) ? [ws.cityPicker hide] : nil;
    }]];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(getIdentityNotification) name:PHSaveIdentifyInfoNotification object:nil];
    [center addObserver:self selector:@selector(textFieldDidBeginNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [center addObserver:self selector:@selector(textFieldDidEndNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, 0, 100, 30);
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消上传" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.rightItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Target
- (void)commitClick {
    PHSettingTextItem *aitem1 = [self.allOfTheModel objectAtIndex:1];
    PHLog(@"物品类型1label -> %@, key -> %@, title -> %@",aitem1.labelTitle, aitem1.keyOfTitle, aitem1.textFTitle);
    PHSettingTextItem *aitem6 = [self.allOfTheModel objectAtIndex:6];
    PHLog(@"寄件人电话6label -> %@, key -> %@, title -> %@",aitem6.labelTitle, aitem6.keyOfTitle, aitem6.textFTitle);
    PHSettingTextItem *aitem7 = [self.allOfTheModel objectAtIndex:7];
    PHLog(@"收件人姓名7label -> %@, key -> %@, title -> %@",aitem7.labelTitle, aitem7.keyOfTitle, aitem7.textFTitle);
    PHSettingTextItem *aitem10 = [self.allOfTheModel objectAtIndex:10];
    PHLog(@"收件人电话10label -> %@, key -> %@, title -> %@",aitem10.labelTitle, aitem10.keyOfTitle, aitem10.textFTitle);

    
    PHLog(@"commitClick");
    BOOL needBreak = NO;
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    for (PHSettingTextItem *item in self.allOfTheModel) {
        if (item.textFTitle.length != 0) {
            if (item.keyOfTitle) {//有key才加入
                if ([item.keyOfTitle isEqualToString:kArgu_receiveAddr]) {//如果是收件人地址这个key
                    NSString *string = [para objectForKey:kArgu_receiveAddr];
                    string = (string ? [string stringByAppendingString:item.textFTitle] : item.textFTitle);
                    [para setObject:string forKey:item.keyOfTitle];
                } else {
                    [para setObject:item.textFTitle forKey:item.keyOfTitle];
                }
            }
        } else {
            BOOL value = [item.keyOfTitle isEqualToString:kArgu_packageCount] || !item.keyOfTitle;//没有key不提示
            if (value) {
                //暂时什么事都不做
            } else {
                [self showError:item.labelTitle];
                needBreak = YES;
                break;
            }
        }
    }
    if (needBreak) return;//有break操作，就不能执行下去
    if ([PHUseInfo sharedPHUseInfo].courier.identityCardId.length != 0) {
        [para setObject:[PHUseInfo sharedPHUseInfo].courier.identityCardId forKey:kArgu_courierIdentityCardId];
    } else {
        [MBProgressHUD showError:@"缺少必要参数" toView:self.view];
        return;
    }
    if (self.reProvince) {
        [para setObject:self.reProvince forKey:kArgu_provincename];
    } else {
        [MBProgressHUD showError:@"缺少必要参数" toView:self.view];
        return;
    }
    if (self.reCity) {
        [para setObject:self.reCity forKey:kArgu_cityname];
    } else {
        [MBProgressHUD showError:@"缺少必要参数" toView:self.view];
        return;
    }
    if (self.reTown) {
        [para setObject:self.reTown forKey:kArgu_districtname];
    } else {
        [MBProgressHUD showError:@"缺少必要参数" toView:self.view];
        return;
    }
    if (CLLocationCoordinate2DIsValid(self.senderCoord)) {
        [para setObject:@(self.senderCoord.longitude) forKey:kArgu_longitude];
        [para setObject:@(self.senderCoord.latitude) forKey:kArgu_latitude];
    } else {
        [MBProgressHUD showError:@"请输入寄件人地址" toView:self.view];
        return;
    }
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:1];//寄件人位置
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:1];//寄件人具体位置
    NSString *senderLocation = nil;
    PHSettingTextItem *item1 = [self textItemAtIndexPath:indexPath1];
    senderLocation = item1.textFTitle;
    PHSettingTextItem *item2 = [self textItemAtIndexPath:indexPath2];
    senderLocation = (senderLocation ? [senderLocation stringByAppendingString:item2.textFTitle] : item2.textFTitle);
    if (senderLocation) {
        [para setObject:senderLocation forKey:kArgu_takeAddr];
    }
    NSDate *nowDate = [NSDate date];
    NSTimeInterval time = [nowDate timeIntervalSince1970];
    [para setObject:@(time * 1000) forKey:kArgu_takeTime];
    
    __block NSString *identityNumber = nil;
    for (NSDictionary *identityD in [PHUseInfo sharedPHUseInfo].identityInfo) {
        [identityD enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"公民身份号码"]) {
                identityNumber = obj;
            }
        }];
    }
    
    if ([PHUseInfo sharedPHUseInfo].token.length != 0) {//令牌
        [para setObject:[PHUseInfo sharedPHUseInfo].token forKey:kArgu_token];
    } else {
        [MBProgressHUD showError:@"缺少必要参数" toView:self.view];
        return;
    }
    
    //这里要填写寄件人身份证号
    if (identityNumber.length != 0) {
        [para setObject:identityNumber forKey:kArgu_postPersonIdentityCardId];
    } else {
        [MBProgressHUD showError:@"缺少必要参数" toView:self.view];
        return;
    }
    
    //收件地区id
    if (self.reCode.length != 0) {
        [para setObject:@([self.reCode integerValue]) forKey:kArgu_receiveDistrictid];
    } else {
        [MBProgressHUD showError:@"缺少必要参数" toView:self.view];
        return;
    }
    
    [self requestWithPara:para];
}

- (void)showError:(NSString *)title {
    NSString *info = [@"请输入" stringByAppendingString:title];
    [MBProgressHUD showError:info toView:self.view];
}

- (void)cancelBtnClick {
    [self.manager.operationQueue cancelAllOperations];
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Request
- (void)requestWithPara:(NSDictionary *)parameters {
    self.navigationItem.rightBarButtonItem = self.rightItem;
    [MBProgressHUD showMessage:@"上传中..." toView:self.view];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    self.manager = manager;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:kUrl_uploadInfo parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *mime = @"image/jpeg";
        NSUInteger index = 1;
        for (UIImage *image in self.goodsImages) {
            NSString *name = @"wupinImg";//[NSString stringWithFormat:@"%@name",@(index)];
            NSString *fileName = [NSString stringWithFormat:@"file%@.jpg",@(index)];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:mime];
            index ++;
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.navigationItem.rightBarButtonItem = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        PHLog(@"%@",dict);
        NSNumber *value = dict[kArgu_success];
        if ([value boolValue]) {
            [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
        } else {
            [MBProgressHUD showError:@"上传失败" toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"上传失败" toView:self.view];
        PHLog(@"%@",error);
    }];

}

#pragma mark - Notification
- (void)textFieldDidBeginNotification:(NSNotification *)notification {
    UITextField *tf = (UITextField *)notification.object;
    CGPoint pnt = [self.tableView convertPoint:tf.bounds.origin fromView:tf];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:pnt];
    PHTextViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    CGRect frame = [cell convertRect:cell.bounds toView:nil];
    self.selectCellFrame = frame;
}

- (void)textFieldDidEndNotification:(NSNotification *)notification {
//    PHLog(@"%@",notification.object);
}

- (void)keyBoardWillShow:(NSNotification *)notification {
    CGFloat cellMaxY = CGRectGetMaxY(self.selectCellFrame);
    CGFloat heightFromBottom = kHeightOfScreen - cellMaxY;
    NSDictionary *userInfo = notification.userInfo;
    NSValue *frameValue = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [frameValue CGRectValue].size;
    CGFloat keyBoardH = keyboardSize.height;//186
    CGFloat value = keyBoardH - heightFromBottom;
    CGFloat height = 0;
    if (value > 0) height = value;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.bounds = CGRectMake(0, height, self.view.width, self.view.height);
    }];
    
}
- (void)keyBoardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3f animations:^{
        self.view.bounds = CGRectMake(0, 0, self.view.width, self.view.height);
    }];
}

- (void)getIdentityNotification {
    PHTextViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    for (NSDictionary *dict in [PHUseInfo sharedPHUseInfo].identityInfo) {
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"姓名"]) {
                cell.textVTitle = obj;
                if (!cell) {//有时候会因为复用的问题导致cell不可见为空，这时可以采用赋值给Model形式，保证数据不会丢失
                    PHSettingTextItem *item = [self textItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                    item.textFTitle = obj;
                }
                return;
            }
        }];
    }
    
}
#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PHTextHeaderView *headerV = [PHTextHeaderView headerWithTableView:tableView];
    headerV.delegate = self;
    PHSettingGroup *group = [self.dataSource objectAtIndex:section];
    headerV.group = group;
    return headerV;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PHSettingGroup *group = [self.dataSource objectAtIndex:section];
    return group.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        if (self.goodsImages.count == 0) {
            return 0;
        } else {
            CGFloat totalH = 0;
            CGFloat f = self.goodsImages.count / 3.f;
            CGFloat padding = (kWidthOfScreen - 3 * kPhotoHeight) / 4;
            CGFloat height = kPhotoHeight;
            if (f > 2) {
                totalH = 3 * (height + padding) + padding;
            } else if (f > 1) {
                totalH =  2 * (height + padding) + padding;
            } else {
                totalH =  height + padding + padding;
            }
            return totalH;
        }
    } else {
        return 50.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        PHImagesViewCell *cell = [PHImagesViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.images = self.goodsImages;
        return cell;
    } else {
        PHTextViewCell *cell = [PHTextViewCell cellWithTableView:tableView];
        cell.delegate = self;
        PHSettingGroup *group = [self.dataSource objectAtIndex:indexPath.section];
        PHSettingTextItem *item = [group.items objectAtIndex:indexPath.row];
        cell.textItem = item;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - PHTextHeaderViewDelegate
- (void)headerViewDidClickRightBtn:(PHTextHeaderView *)headerView {
    if (self.goodsImages.count >= kMaxImages) {
        [MBProgressHUD showError:@"图片已经达到最大数量" toView:self.view];
        return;
    }
    [self presentImagePickerController];
}
- (void)presentImagePickerController {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePicker.delegate = self;
    // 设置允许编辑
    imagePicker.allowsEditing = YES;
#if TARGET_IPHONE_SIMULATOR
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#elif TARGET_OS_IPHONE
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *newImage = [image scaleImage:image toScale:0.8];
    NSData * imageData = UIImageJPEGRepresentation(newImage,1);
    CGFloat length = [imageData length] / 1000;
    if (length > 500) {
        newImage = [image scaleImage:image toScale:0.7];
        PHLog(@"执行了这句，那说明要出问题了");
    }
    PHLog(@"%@",@(length));
    if (self.goodsImages.count < kMaxImages)  [self.goodsImages addObject:newImage];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

#pragma mark - PHImagesViewCellDelegate
- (void)imagesViewCell:(PHImagesViewCell *)cell didDoubleClickImageTag:(NSUInteger)tag {
    PHLog(@"%@", @(tag));
    [self.goodsImages removeObjectAtIndex:tag];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - PHTextViewCellDelegate
- (void)textViewCellControlDidClick:(PHTextViewCell *)textView {
    NSString *title = textView.textItem.labelTitle;
    self.alert.title = title;
    self.alert.hidden = NO;
}
#pragma mark - PHAlertControllerDelegate
- (void)alertController:(PHAlertController *)alertConroller didClickNextWithContentStr:(NSString *)string {
    if ([alertConroller.title isEqualToString:@"收件人电话"] && string.length != 0) {
        if ([string isPureTelephoneNumber]) {
            PHSettingTextItem *item = [self textItemAtIndexPath:[self.textItemArray objectAtIndex:3]];
            item.textFTitle = string;
            alertConroller.hidden = YES;
            [alertConroller removeFromSuperview];
            [self.tableView reloadRowsAtIndexPaths:@[[self.textItemArray objectAtIndex:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        }
        
    } else if ([alertConroller.title isEqualToString:@"物品类型"] && string.length != 0) {
        PHSettingTextItem *item = [self textItemAtIndexPath:[self.textItemArray objectAtIndex:0]];
        item.textFTitle = string;
        alertConroller.title = @"寄件人电话";
        [self.tableView reloadRowsAtIndexPaths:@[[self.textItemArray objectAtIndex:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

    } else if ([alertConroller.title isEqualToString:@"寄件人电话"] && string.length != 0) {
        if ([string isPureTelephoneNumber]) {
            PHSettingTextItem *item = [self textItemAtIndexPath:[self.textItemArray objectAtIndex:1]];
            item.textFTitle = string;
            alertConroller.title = @"收件人姓名";
            [self.tableView reloadRowsAtIndexPaths:@[[self.textItemArray objectAtIndex:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        }
    } else if ([alertConroller.title isEqualToString:@"收件人姓名"] && string.length != 0) {
        PHSettingTextItem *item = [self textItemAtIndexPath:[self.textItemArray objectAtIndex:2]];
        item.textFTitle = string;
        alertConroller.title = @"收件人电话";
        [self.tableView reloadRowsAtIndexPaths:@[[self.textItemArray objectAtIndex:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
    }
}
#pragma mark - Private Method
- (NSArray *)textItemArray {
    if (!_textItemArray) {
        NSIndexPath *index1 = [NSIndexPath indexPathForRow:1 inSection:0];//物品类型
        NSIndexPath *index2 = [NSIndexPath indexPathForRow:3 inSection:1];//寄件人电话
        NSIndexPath *index3 = [NSIndexPath indexPathForRow:0 inSection:2];//收件人姓名
        NSIndexPath *index4 = [NSIndexPath indexPathForRow:3 inSection:2];//收件人电话
        _textItemArray = @[index1, index2, index3, index4];
    }
    return _textItemArray;
}
- (PHSettingTextItem *)textItemAtIndexPath:(NSIndexPath *)indexPath {
    PHSettingGroup *group = [self.dataSource objectAtIndex:indexPath.section];
    PHSettingTextItem *item = [group.items objectAtIndex:indexPath.row];
    return item;
}

@end
