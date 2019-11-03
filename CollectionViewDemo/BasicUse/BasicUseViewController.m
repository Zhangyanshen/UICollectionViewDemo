//
//  BasicUseViewController.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/1.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "BasicUseViewController.h"
#import "Masonry.h"
#import "BasicCollectionViewCell.h"
#import "BasicHeaderCollectionReusableView.h"
#import "BasicFooterCollectionReusableView.h"

@interface BasicUseViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BasicUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10 + section * 3;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BasicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLbl.text = [NSString stringWithFormat:@"%ld", indexPath.item];
    cell.contentView.backgroundColor = indexPath.section % 2 == 0 ? [UIColor greenColor] : [UIColor redColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BasicHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor purpleColor];
        header.textLbl.text = [NSString stringWithFormat:@"第 %ld 组的头部", indexPath.section];
        return header;
    }
    BasicFooterCollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    footer.backgroundColor = [UIColor lightGrayColor];
    footer.textLbl.text = [NSString stringWithFormat:@"第 %ld 组的尾部", indexPath.section];
    return footer;
}

#pragma mark - Setters/Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 8;
        CGFloat itemW = (self.view.bounds.size.width - margin * 4) / 3;
        CGFloat itemH = itemW;
        // header的大小
        flowLayout.headerReferenceSize = CGSizeMake(0, 40);
        // header悬停
        if (@available(iOS 9.0, *)) {
            flowLayout.sectionHeadersPinToVisibleBounds = YES;
        }
        // footer悬停
        if (@available(iOS 9.0, *)) {
//            flowLayout.sectionFootersPinToVisibleBounds = YES;
        }
        // footer的大小
        flowLayout.footerReferenceSize = CGSizeMake(0, 40);
        // 每个item的大小
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        // 最小行间距
        flowLayout.minimumLineSpacing = margin;
        // 最小item之间的间距
        flowLayout.minimumInteritemSpacing = margin;
        // 分区内边距
        flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        // 滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[BasicCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[BasicHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView registerClass:[BasicFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    }
    return _collectionView;
}

@end
