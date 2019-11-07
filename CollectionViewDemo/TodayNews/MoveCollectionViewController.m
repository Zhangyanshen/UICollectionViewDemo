//
//  MoveCollectionViewController.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/6.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "MoveCollectionViewController.h"
#import "Masonry.h"
#import "MoveCollectionViewCell.h"
#import "MoveHeaderCollectionReusableView.h"

@interface MoveCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isEdit; // 是否处于编辑状态
@property (nonatomic, strong) UIBarButtonItem *editItem; // 编辑按钮
@property (nonatomic, assign) CGPoint fingerLocation; // 手指按住CollectionView的位置
@property (nonatomic, strong) NSIndexPath *originalIndexPath; // 手指长按时对应的indexPath，可能是nil
@property (nonatomic, strong) NSIndexPath *relocatedIndexPath; // 手指移动时对应的indexPath，可能是nil
@property (nonatomic, strong) UIView *snapshot; // 截屏View

@end

@implementation MoveCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEdit = NO;
    NSArray *tmpArray = @[
        [@[@"推荐", @"热点", @"视频", @"问答", @"体育", @"历史", @"科技", @"健康", @"娱乐", @"时尚", @"故事", @"直播", @"数码", @"辟谣", @"养生"] mutableCopy],
        [@[@"美图", @"正能量", @"搞笑", @"文化", @"小说", @"语录", @"深圳", @"社会", @"汽车", @"财经", @"军事", @"段子", @"美女", @"国际", @"趣图", @"特卖", @"房产", @"育儿", @"美食", @"电影"] mutableCopy]
    ];
    self.dataArray = [NSMutableArray arrayWithArray:tmpArray];
    [self setupUI];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *sectionArray = self.dataArray[indexPath.section];
    if (indexPath.section == 0) {
        cell.textLabel.text = sectionArray[indexPath.item];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"+%@", sectionArray[indexPath.item]];
    }
    if (self.isEdit && indexPath.section == 0) {
        cell.deleteButton.hidden = NO;
        [cell beginAnimation];
    } else {
        cell.deleteButton.hidden = YES;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MoveHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            header.titleLabel.text = @"我的频道";
            header.subTitleLabel.text = self.isEdit ? @"拖拽可以排序" : @"点击进入频道";
        } else {
            header.titleLabel.text = @"频道推荐";
            header.subTitleLabel.text = @"点击添加频道";
        }
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = (self.collectionView.bounds.size.width - 5 * 10) / 4.0;
    CGFloat itemH = 50;
    return CGSizeMake(itemW, itemH);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isEdit && indexPath.section == 0) {
        NSLog(@"进入频道：%@", self.dataArray[indexPath.section][indexPath.item]);
        return;
    }
    // 先移动数据，再刷新
    [self.collectionView performBatchUpdates:^{
        [self betweenSectionsMoveCellFrom:indexPath];
    } completion:^(BOOL finished) {
        [self.collectionView reloadItemsAtIndexPaths:@[self.originalIndexPath]];
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint translationPoint = [pan translationInView:pan.view];
    if (ABS(translationPoint.x) > 0.2 && !self.snapshot) {
        return YES;
    }
    return NO;
}

#pragma mark - Event response

- (void)edit:(UIBarButtonItem *)item {
    self.isEdit = !self.isEdit;
    item.title = self.isEdit ? @"完成" : @"编辑";
    // 关闭隐式动画
    [CATransaction setDisableActions:YES];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    [CATransaction commit];
}

- (void)handleLongPressGestureRecognize:(UILongPressGestureRecognizer *)longPress {
    [self handleGesture:longPress];
}

- (void)handlePanGestureRecognize:(UIPanGestureRecognizer *)pan {
    [self handleGesture:pan];
}

#pragma mark - Setters/Getters

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 20, 10);
        layout.headerReferenceSize = CGSizeMake(0, 30);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"MoveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"MoveHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        // 添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognize:)];
        [_collectionView addGestureRecognizer:longPress];
        // 添加滑动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognize:)];
        pan.delegate = self;
        [_collectionView addGestureRecognizer:pan];
    }
    return _collectionView;
}

- (UIBarButtonItem *)editItem {
    if (!_editItem) {
        _editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
    }
    return _editItem;
}

#pragma mark - Private methods

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    self.navigationItem.rightBarButtonItem = self.editItem;
}

// 在不同section之间移动cell
- (void)betweenSectionsMoveCellFrom:(NSIndexPath *)indexPath {
    NSString *obj = self.dataArray[indexPath.section][indexPath.item];
    // 删除原来位置的数据
    [self.dataArray[indexPath.section] removeObjectAtIndex:indexPath.item];
    // 目标indexPath
    NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    if (indexPath.section == 1) {
        destinationIndexPath = [NSIndexPath indexPathForItem:[self.dataArray[0] count] inSection:0];
    }
    // 在新位置插入数据
    [self.dataArray[destinationIndexPath.section] insertObject:obj atIndex:destinationIndexPath.item];
    // CollectionView移动item
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:destinationIndexPath];
    
    self.originalIndexPath = destinationIndexPath;
}

// 处理长按和滑动手势
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognize {
    self.fingerLocation = [gestureRecognize locationInView:gestureRecognize.view];
    self.relocatedIndexPath = [self.collectionView indexPathForItemAtPoint:self.fingerLocation];
    switch (gestureRecognize.state) {
        case UIGestureRecognizerStateBegan: // 手势开始
        {
            self.originalIndexPath = [self.collectionView indexPathForItemAtPoint:self.fingerLocation];
            // 如果还没进入编辑状态，就让他进入编辑状态，同时cell显示删除按钮
            if (!self.isEdit) {
                self.isEdit = YES;
                self.editItem.title = @"完成";
                
                if (@available(iOS 9.0, *)) {
                    MoveHeaderCollectionReusableView *header = (MoveHeaderCollectionReusableView *)[self.collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                    header.subTitleLabel.text = @"拖拽可以排序";
                }
                
                for (int i = 0; i < [self.dataArray[0] count]; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    MoveCollectionViewCell *cell = (MoveCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                    [cell beginAnimation];
                    cell.deleteButton.hidden = NO;
                }
            }
            [self cellSelectedAtIndexPath:self.originalIndexPath];
        }
            break;
        case UIGestureRecognizerStateChanged: // 手势改变
        {
            // 移动cell
            self.snapshot.center = self.fingerLocation;
            // 记录一下位移之后的indexPath
            self.relocatedIndexPath = [self.collectionView indexPathForItemAtPoint:self.fingerLocation];
            // 进行排序
            [self cellRelocatedToNewIndexPath:self.relocatedIndexPath];
        }
            break;
        case UIGestureRecognizerStateEnded: // 手势结束
        {
            if (!self.snapshot) {
                return;
            }
            [self didEndDraging];
        }
            break;
        default:
            
            break;
    }
}

// 拖动结束，显示cell，并移除截图
- (void)didEndDraging {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.originalIndexPath];
    cell.hidden = NO;
    cell.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.snapshot.center = cell.center;
        self.snapshot.alpha = 0;
        self.snapshot.transform = CGAffineTransformIdentity;
        cell.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.snapshot removeFromSuperview];
        self.snapshot = nil;
        self.originalIndexPath = nil;
        self.relocatedIndexPath = nil;
    }];
}

// 移动cell，并更新数据源
- (void)cellRelocatedToNewIndexPath:(NSIndexPath *)indexPath {
    if (indexPath && indexPath.section == 0) {
        NSString *obj = self.dataArray[0][self.originalIndexPath.item];
        [self.dataArray[0] removeObjectAtIndex:self.originalIndexPath.item];
        [self.dataArray[0] insertObject:obj atIndex:indexPath.item];
        
        [self.collectionView moveItemAtIndexPath:self.originalIndexPath toIndexPath:indexPath];
        
        self.originalIndexPath = indexPath;
    }
}

// 隐藏cell，并显示截图
- (void)cellSelectedAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    self.snapshot = [self snapshotFromView:cell];
    [self.collectionView addSubview:self.snapshot];
    cell.hidden = YES;
    CGPoint center = self.snapshot.center;
    center.y = self.fingerLocation.y;
    [UIView animateWithDuration:0.2 animations:^{
        self.snapshot.transform = CGAffineTransformMakeScale(1.03, 1.03);
        self.snapshot.alpha = 0.98;
        self.snapshot.center = center;
    }];
}

// 截图
- (UIView *)snapshotFromView:(UIView *)inputView {
    // 生成一张图
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, [UIScreen mainScreen].scale);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 生成View
    UIImageView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.center = inputView.center;
    snapshot.alpha = 0.6;
    snapshot.layer.masksToBounds = YES;
    snapshot.layer.cornerRadius = 0.0;
    
    return snapshot;
}

@end
