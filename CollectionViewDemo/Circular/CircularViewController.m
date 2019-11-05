//
//  CircularViewController.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/4.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "CircularViewController.h"
#import "CircularCollectionViewLayout.h"
#import "CircularCollectionViewCell.h"
#import "Masonry.h"

@interface CircularViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *textLbl;

@end

@implementation CircularViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircularCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CircularCollectionViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.item];
    cell.contentView.backgroundColor = indexPath.item % 2 == 0 ? [UIColor greenColor] : [UIColor redColor];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    self.textLbl.text = [NSString stringWithFormat:@"第 %ld 个", indexPath.item];
}

#pragma mark - Setters/Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CircularCollectionViewLayout *layout = [[CircularCollectionViewLayout alloc] init];
        // item的大小
        layout.itemSize = CGSizeMake(130, 200);
        // 半径
        layout.radius = 500;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[CircularCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CircularCollectionViewCell class])];
    }
    return _collectionView;
}

- (UILabel *)textLbl {
    if (!_textLbl) {
        _textLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLbl.textColor = [UIColor redColor];
        _textLbl.font = [UIFont boldSystemFontOfSize:20];
        _textLbl.textAlignment = NSTextAlignmentCenter;
//        _textLbl.backgroundColor = [UIColor blackColor];
    }
    return _textLbl;
}

#pragma mark - Private methods

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(300);
    }];
    [self.view addSubview:self.textLbl];
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

@end
