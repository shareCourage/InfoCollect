//
//  PHInfoCollectController.m
//  InfoCollect
//
//  Created by Kowloon on 15/12/16.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "PHInfoCollectController.h"

@interface PHInfoCollectController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PHInfoCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息采集";
    self.view.backgroundColor = [UIColor purpleColor];
    self.navigationController.navigationBar.hidden = NO;

    [self tableViewInitial];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)tableViewInitial {
    CGFloat tvX = 0;
    CGFloat tvY = 0;
    CGFloat tvW = kWidthOfScreen;
    CGFloat tvH = kHeightOfScreen - 60;
    CGRect tvF = CGRectMake(tvX, tvY, tvW, tvH);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tvF style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.contentMode = UIViewContentModeCenter;
    UIImage *image = [UIImage imageNamed:@"main_background"];
    backgroundImageView.image = image;
    tableView.backgroundView = backgroundImageView;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
