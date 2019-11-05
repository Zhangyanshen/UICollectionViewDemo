//
//  ViewController.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/1.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "BasicUseViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UICollectionView";
    self.dataArr = @[
        @{@"sectionTitle": @"静态缓存", @"classes": @[
                  @{@"title": @"UICollectionView基本使用", @"class": @"BasicUseViewController"},
                  @{@"title": @"UICollectionView流式布局", @"class": @"WaterfallFlowViewController"},
                  @{@"title": @"UICollectionView分页多cell", @"class": @"MultiCellHorizontalScrollViewController"}
        ]},
        @{@"sectionTitle": @"动态调整", @"classes": @[
                  @{@"title": @"CoverFlow效果", @"class": @"CoverFlowViewController"},
                  @{@"title": @"轮转卡片效果", @"class": @"CircularViewController"}
        ]}
                    ];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = self.dataArr[section];
    return [dic[@"classes"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary *dic = self.dataArr[indexPath.section];
    cell.textLabel.text = [dic[@"classes"][indexPath.row] objectForKey:@"title"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDic = self.dataArr[section];
    return sectionDic[@"sectionTitle"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *section = self.dataArr[indexPath.section];
    NSString *classStr = [section[@"classes"][indexPath.row] objectForKey:@"class"];
    NSString *title = [section[@"classes"][indexPath.row] objectForKey:@"title"];
    id obj = [[NSClassFromString(classStr) alloc] init];
    [obj setValue:title forKey:@"title"];
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark - Setters/Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionHeaderHeight = 20;
        _tableView.sectionFooterHeight = 10;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
