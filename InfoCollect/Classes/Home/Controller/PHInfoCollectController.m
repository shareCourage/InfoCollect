//
//  PHInfoCollectController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHInfoCollectController.h"
#import "PHSettingGroup.h"
#import "PHSettingTextItem.h"
#import "PHTextViewCell.h"

#import "PHZBarViewController.h"
#import "CameraViewController.h"


@interface PHInfoCollectController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *groupHeader;

@property (nonatomic, copy) NSString *orderNumer;

@end

@implementation PHInfoCollectController

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
    PHSettingGroup *group = [PHSettingGroup settingGoup];
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
    PHSettingGroup *group = [PHSettingGroup settingGoup];
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
    PHSettingGroup *group = [PHSettingGroup settingGoup];
    group.header = self.groupHeader[2];
    NSArray *recipers = @[@"收件人姓名",@"收件人地址",@"收件人具体位置",@"收件人电话"];
    PHSettingTextItem *a = [PHSettingTextItem itemWithLabelTitle:recipers[0]];
    PHSettingTextItem *b = [PHSettingTextItem itemWithLabelTitle:recipers[1] accessoryName:@"home_arrow"];
    b.option = ^{
        
    };
    PHSettingTextItem *c = [PHSettingTextItem itemWithLabelTitle:recipers[2]];
    PHSettingTextItem *d = [PHSettingTextItem itemWithLabelTitle:recipers[3]];
    d.keyboardType = UIKeyboardTypeNumberPad;
    group.items = @[a,b,c,d];
    return group;
}
- (PHSettingGroup *)four {
    PHSettingGroup *group = [PHSettingGroup settingGoup];
    group.header = self.groupHeader[3];
    
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
    tableView.dataSource = self;
    tableView.delegate = self;
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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [self.view endEditing:YES];
    }]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIdentityNotification) name:PHSaveIdentifyInfoNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UITableView
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    PHSettingGroup *group = [self.dataSource objectAtIndex:section];
    return group.header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PHSettingGroup *group = [self.dataSource objectAtIndex:section];
    return group.items.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PHTextViewCell *cell = [PHTextViewCell cellWithTableView:tableView];
    PHSettingGroup *group = [self.dataSource objectAtIndex:indexPath.section];
    PHSettingTextItem *item = [group.items objectAtIndex:indexPath.row];
    cell.textItem = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
