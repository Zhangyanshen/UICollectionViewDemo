//
//  WaterfallFlowLayout.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/2.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "WaterfallFlowLayout.h"

@interface WaterfallFlowLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributeArray; // 布局frame数组
@property (nonatomic, strong) NSMutableArray *yArray; // 每列的高度的数组
@property (nonatomic, assign) CGFloat maxHeight; // 最大高度

@end

@implementation WaterfallFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.cols = 3;
        self.layoutAttributeArray = [NSMutableArray array];
        self.yArray = [NSMutableArray array];
        self.maxHeight = 0;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    for (int i = 0; i < self.cols; i++) {
        [self.yArray addObject:@(self.sectionInset.top)];
    }
    CGFloat itemW = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * (self.cols - 1)) / self.cols;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    // 最小高度的那一个的索引
    NSInteger minHeightIndex = 0;
    // 从 layoutAttributeArray.count 开始，避免重复加载
    for (NSInteger i = self.layoutAttributeArray.count; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        // item高度，从代理中获取
        CGFloat itemH = [self.delegate waterfallFlowLayout:self itemHeightAtIndexPath:indexPath];

        // 找出最小高度的那一列
        NSNumber *min =[self.yArray valueForKeyPath:@"@min.floatValue"];
        minHeightIndex = [self.yArray indexOfObject:min];
        CGFloat itemY = [self.yArray[minHeightIndex] floatValue];

        // 从第二行开始需要加上item的间距
        if (i >= self.cols) {
            itemY += self.minimumInteritemSpacing;
        }

        CGFloat itemX = self.sectionInset.left + (itemW + self.minimumInteritemSpacing) * minHeightIndex;

        attr.frame = CGRectMake(itemX, itemY, itemW, itemH);
        [self.layoutAttributeArray addObject:attr];
        // 重新设置最小列高度
        self.yArray[minHeightIndex] = [NSNumber numberWithFloat:CGRectGetMaxY(attr.frame)];
    }
    self.maxHeight = [[self.yArray valueForKeyPath:@"@max.floatValue"] floatValue] + self.sectionInset.bottom;
}

// 设置CollectionView的滚动区域
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, self.maxHeight);
}

// 返回指定区域所有cell的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *resultArr = [NSMutableArray array];
    [self.layoutAttributeArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [resultArr addObject:obj];
        }
    }];
    return resultArr;
}

@end
