//
//  WaterfallFlowViewController.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/2.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "WaterfallFlowViewController.h"
#import "Masonry.h"
#import "WaterfallFlowLayout.h"
#import "BasicCollectionViewCell.h"

@interface WaterfallFlowViewController () <UICollectionViewDelegate, UICollectionViewDataSource, WaterfallFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WaterfallFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BasicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLbl.text = [NSString stringWithFormat:@"%ld", indexPath.item];
    cell.contentView.backgroundColor = indexPath.item % 2 == 0 ? [UIColor redColor] : [UIColor greenColor];
    return cell;
}

#pragma mark - WaterfallFlowLayoutDelegate

- (CGFloat)waterfallFlowLayout:(WaterfallFlowLayout *)layout itemHeightAtIndexPath:(NSIndexPath *)indexPath {
    return arc4random_uniform(150) + 50;
}

#pragma mark - Setters/Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        WaterfallFlowLayout *layout = [[WaterfallFlowLayout alloc] init];
        layout.cols = 3;
        layout.delegate = self;
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 8;
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[BasicCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark - Private methods

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
    }];
}

@end
