//
//  CoverFlowViewController.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/3.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "CoverFlowViewController.h"
#import "CoverFlowLayout.h"
#import "Masonry.h"
#import "BasicCollectionViewCell.h"

@interface CoverFlowViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *textLbl;

@end

@implementation CoverFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollViewDidEndDecelerating:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BasicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BasicCollectionViewCell class]) forIndexPath:indexPath];
    cell.textLbl.text = [NSString stringWithFormat:@"%ld", indexPath.item];
    cell.contentView.backgroundColor = indexPath.item % 2 == 0 ? [UIColor redColor] : [UIColor greenColor];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    BasicCollectionViewCell *cell = (BasicCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self.collectionView bringSubviewToFront:cell];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint point = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    self.textLbl.text = [NSString stringWithFormat:@"第%ld个", indexPath.item];
}

#pragma mark - Setters/Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CoverFlowLayout *layout = [[CoverFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((self.view.bounds.size.width) / 3, 200);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[BasicCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BasicCollectionViewCell class])];
    }
    return _collectionView;
}

- (UILabel *)textLbl {
    if (!_textLbl) {
        _textLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLbl.textAlignment = NSTextAlignmentCenter;
        _textLbl.font = [UIFont systemFontOfSize:30];
        _textLbl.textColor = [UIColor redColor];
    }
    return _textLbl;
}

#pragma mark - Private methods

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.height.mas_equalTo(200);
    }];
    [self.view addSubview:self.textLbl];
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

@end
