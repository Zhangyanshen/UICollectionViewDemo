//
//  PrefetchViewController.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/5.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "PrefetchViewController.h"
#import "PrefetchCell.h"
#import "Masonry.h"
#import "PrefetchOperation.h"
#import "DataStore.h"

@interface PrefetchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) NSOperationQueue *loadingQueue; // 预加载的队列
@property (nonatomic, strong) NSMutableDictionary *loadingOperations; // 存放预加载的operation

@end

@implementation PrefetchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[DataStore sharedInstance] numberOfImages];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PrefetchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PrefetchOperation *operation = self.loadingOperations[indexPath];
    if (operation && operation.image) {
        [cell updateAppearance:operation.image animation:NO];
    } else {
        [cell updateAppearance:nil animation:NO];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    PrefetchCell *prefetchCell = (PrefetchCell *)cell;
    __weak typeof(self) wself = self;
    void(^updateCell)(UIImage *image) = ^(UIImage *image) {
        __strong typeof(wself) sself = wself;
        [prefetchCell updateAppearance:image animation:YES];
        [sself.loadingOperations removeObjectForKey:indexPath];
    };
    
    PrefetchOperation *operation = self.loadingOperations[indexPath];
    if (operation) {
        if (operation.image) {
            [prefetchCell updateAppearance:operation.image animation:NO];
            [self.loadingOperations removeObjectForKey:indexPath];
        } else {
            operation.loadingCompleteHandler = updateCell;
        }
    } else {
        PrefetchOperation *operation = [[DataStore sharedInstance] loadImageAtIndexPath:indexPath];
        if (operation) {
            operation.loadingCompleteHandler = updateCell;
            [self.loadingQueue addOperation:operation];
            self.loadingOperations[indexPath] = operation;
        }
    }
}

//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    PrefetchOperation *operation = self.loadingOperations[indexPath];
//    if (operation) {
//        [operation cancel];
//        [self.loadingOperations removeObjectForKey:indexPath];
//    }
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = CGRectGetWidth(collectionView.frame) / 2;
    CGFloat itemH = itemW;
    return CGSizeMake(itemW, itemH);
}

#pragma mark - UICollectionViewDataSourcePrefetching

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    for (NSIndexPath *indexPath in indexPaths) {
        if (self.loadingOperations[indexPath]) {
            continue;
        }
        PrefetchOperation *operation = [[DataStore sharedInstance] loadImageAtIndexPath:indexPath];
        if (operation) {
            [self.loadingQueue addOperation:operation];
            self.loadingOperations[indexPath] = operation;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    for (NSIndexPath *indexPath in indexPaths) {
        PrefetchOperation *operation = self.loadingOperations[indexPath];
        if (operation) {
            [operation cancel];
            [self.loadingOperations removeObjectForKey:indexPath];
        }
    }
}

#pragma mark - Setters/Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 0;
        layout.minimumLineSpacing = margin;
        layout.minimumInteritemSpacing = margin;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        if (@available(iOS 10.0, *)) {
            _collectionView.prefetchDataSource = self;
        }
        [_collectionView registerNib:[UINib nibWithNibName:@"PrefetchCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSOperationQueue *)loadingQueue {
    if (!_loadingQueue) {
        _loadingQueue = [[NSOperationQueue alloc] init];
        _loadingQueue.maxConcurrentOperationCount = 5;
    }
    return _loadingQueue;
}

- (NSMutableDictionary *)loadingOperations {
    if (!_loadingOperations) {
        _loadingOperations = [NSMutableDictionary dictionary];
    }
    return _loadingOperations;
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

#pragma mark - dealloc

- (void)dealloc {
    NSLog(@"PrefetchViewController释放了！");
}

@end
