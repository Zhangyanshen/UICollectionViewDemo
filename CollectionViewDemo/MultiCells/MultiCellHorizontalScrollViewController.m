//
//  MultiCellHorizontalScrollViewController.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/3.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "MultiCellHorizontalScrollViewController.h"
#import "MultiCellsFlowLayout.h"
#import "BasicCollectionViewCell.h"
#import "Masonry.h"

#define Lines 4
#define Colums 4
#define ItemCount 17

@interface MultiCellHorizontalScrollViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation MultiCellHorizontalScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BasicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BasicCollectionViewCell class]) forIndexPath:indexPath];
    cell.textLbl.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    self.pageControl.currentPage = index;
}

#pragma mark - Event response

- (void)handlePageControlClick:(UIPageControl *)pageControl {
    NSInteger currentPage = pageControl.currentPage;
    CGPoint contentOff = CGPointMake(currentPage * self.collectionView.bounds.size.width, 0);
    [self.collectionView setContentOffset:contentOff animated:YES];
}

#pragma mark - Setters/Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        MultiCellsFlowLayout *layout = [[MultiCellsFlowLayout alloc] init];
        layout.lines = Lines;
        layout.colms = Colums;
        CGFloat margin = 8;
        layout.minimumLineSpacing = margin;
        layout.minimumInteritemSpacing = margin;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[BasicCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BasicCollectionViewCell class])];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = ItemCount % (Lines * Colums) == 0 ? ItemCount / (Lines * Colums) : ItemCount / (Lines * Colums) + 1;
        [_pageControl addTarget:self action:@selector(handlePageControlClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageControl;
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
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.trailing.equalTo(self.view);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
}

@end
