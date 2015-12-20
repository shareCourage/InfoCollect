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

#import "PHZBarViewController.h"
#import "CameraViewController.h"


@interface PHInfoCollectController () <UITableViewDataSource, UITableViewDelegate, PHTextHeaderViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHImagesViewCellDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *groupHeader;

@property (nonatomic, copy) NSString *orderNumer;

@property (nonatomic, strong) NSMutableArray *goodsImages;
@end

@implementation PHInfoCollectController
- (void)dealloc {
    self.tableView.delegate = nil;//处理因为scrollViewDelegate引发的野指针的问题
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
- (PHSettingGroup *)one {
    PHSettingGroup *group = [PHSettingGroup group];
    group.header = self.groupHeader[0];
    NSArray *goods = @[@"快递单号", @"物品类型", @"物品数量"];
    PHSettingTextItem *a = [PHSettingTextItem itemWithLabelTitle:goods[0] accessoryName:@"home_scan"];
    a.keyboardType = UIKeyboardTypeNumberPad;
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
    PHSettingTextItem *c = [PHSettingTextItem itemWithLabelTitle:goods[2]];
    group.items = @[a,b,c];
    return group;
}
- (PHSettingGroup *)two {
    PHSettingGroup *group = [PHSettingGroup group];
    group.header = self.groupHeader[1];
    NSArray *senders = @[@"寄件人姓名",@"寄件人位置",@"寄件人具体位置",@"寄件人电话"];
    PHSettingTextItem *a = [PHSettingTextItem itemWithLabelTitle:senders[0] accessoryName:@"home_scan"];
    kWS(ws);
    a.option = ^{
        //...
        CameraViewController *vc = [[CameraViewController alloc] init];
        [ws.navigationController pushViewController:vc animated:YES];
        
    };
    PHSettingTextItem *b = [PHSettingTextItem itemWithLabelTitle:senders[1] accessoryName:@"home_location"];
    b.option = ^{
    
    };
    PHSettingTextItem *c = [PHSettingTextItem itemWithLabelTitle:senders[2]];
    PHSettingTextItem *d = [PHSettingTextItem itemWithLabelTitle:senders[3]];
    d.keyboardType = UIKeyboardTypeNumberPad;
    group.items = @[a,b,c,d];
    return group;
}

- (PHSettingGroup *)three {
    PHSettingGroup *group = [PHSettingGroup group];
    group.header = self.groupHeader[2];
    NSArray *recipers = @[@"收件人姓名",@"收件人地址",@"收件人具体位置",@"收件人电话"];
    PHSettingTextItem *a = [PHSettingTextItem itemWithLabelTitle:recipers[0]];
    PHSettingTextItem *b = [PHSettingTextItem itemWithLabelTitle:recipers[1] accessoryName:@"home_arrow"];
    kWS(ws);
    b.option = ^{
        [PHCityPickerView showPickerAddToView:ws.view completion:^(NSString *province, NSString *city, NSString *town) {
            PHLog(@"%@%@%@",province,city,town);
        }];
    };
    PHSettingTextItem *c = [PHSettingTextItem itemWithLabelTitle:recipers[2]];
    PHSettingTextItem *d = [PHSettingTextItem itemWithLabelTitle:recipers[3]];
    d.keyboardType = UIKeyboardTypeNumberPad;
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
    CGFloat commitH = 50;
    CGFloat tvX = 0;
    CGFloat tvY = 0;
    CGFloat tvW = kWidthOfScreen;
    CGFloat tvH = kHeightOfScreen - commitH;
    CGRect tvF = CGRectMake(tvX, tvY, tvW, tvH);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tvF style:UITableViewStyleGrouped];
    tableView.allowsSelection = NO;
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
#pragma mark - Target
- (void)commitClick {
    PHLog(@"commitClick");
}

- (void)getIdentityNotification {
    PHTextViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    for (NSDictionary *dict in [PHUseInfo sharedPHUseInfo].identityInfo) {
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"姓名"]) {
                cell.textVTitle = obj;
                return;
            }
        }];
    }
}

#pragma mark - Super
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"识别结果";
    self.view.backgroundColor = kSystemeColor;
    [self tableViewInitial];
    [self commonInitial];
    kWS(ws);
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [ws.view endEditing:YES];
    }]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIdentityNotification) name:PHSaveIdentifyInfoNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
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
    if (self.goodsImages.count < kMaxImages)  [self.goodsImages addObject:image];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PHImagesViewCellDelegate
- (void)imagesViewCell:(PHImagesViewCell *)cell didSelectImageTag:(NSUInteger)tag {

}


@end
