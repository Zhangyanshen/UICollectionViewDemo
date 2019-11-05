//
//  InteractViewController.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/5.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "InteractViewController.h"
#import "BasicCollectionViewCell.h"
#import "Masonry.h"

@interface InteractViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation InteractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < 30; i++) {
        NSString *str = [NSString stringWithFormat:@"%d", i];
        [self.dataArr addObject:str];
    }
    [self setupUI];
}

#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BasicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BasicCollectionViewCell class]) forIndexPath:indexPath];
    cell.textLbl.text = self.dataArr[indexPath.item];
    cell.contentView.backgroundColor = indexPath.item % 2 == 0 ? [UIColor redColor] : [UIColor greenColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *item = [self.dataArr objectAtIndex:sourceIndexPath.item];
    [self.dataArr removeObject:item];
    [self.dataArr insertObject:item atIndex:destinationIndexPath.item];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = (CGRectGetWidth(self.collectionView.frame) - 4 * 8) / 3.0;
    CGFloat itemH = itemW;
    return CGSizeMake(itemW, itemH);
}

#pragma mark - UICollectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", self.dataArr[indexPath.item]);
}

#pragma mark - Event response

- (void)handleLongPress:(UILongPressGestureRecognizer *)longGes {
    if (@available(iOS 9.0, *)) {
        CGPoint point = [longGes locationInView:longGes.view];
        switch (longGes.state) {
            case UIGestureRecognizerStateBegan: // 手势开始
            {
                NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
                
                break;
            case UIGestureRecognizerStateChanged: // 更新位置
                [self.collectionView updateInteractiveMovementTargetPosition:point];
                break;
            case UIGestureRecognizerStateEnded: // 手势结束
                [self.collectionView endInteractiveMovement];
                break;
            default: // 取消手势
                [self.collectionView cancelInteractiveMovement];
                break;
        }
    }
    
}

#pragma mark - Setters/Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 8;
        flowLayout.minimumLineSpacing = margin;
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[BasicCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BasicCollectionViewCell class])];
        // 添加长按手势
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [_collectionView addGestureRecognizer:longGes];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
