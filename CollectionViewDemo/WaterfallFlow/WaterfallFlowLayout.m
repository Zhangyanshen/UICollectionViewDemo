//
//  WaterfallFlowLayout.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/2.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "WaterfallFlowLayout.h"

@interface WaterfallFlowLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributeArray; // 布局属性数组
@property (nonatomic, strong) NSMutableArray *yArray; // 每列最大y值的数组
@property (nonatomic, assign) CGFloat maxHeight; // CollectionView内容最大高度

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

// 布局前的准备工作
- (void)prepareLayout {
    [super prepareLayout];
    for (int i = 0; i < self.cols; i++) {
        [self.yArray addObject:@(self.sectionInset.top)];
    }
    // 将布局属性缓存起来
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.layoutAttributeArray addObject:attr];
    }
}

/**
 设置CollectionView的滚动区域
 layoutAttributesForElementsInRect方法调用之后都会调用该方法
 */
- (CGSize)collectionViewContentSize {
    CGFloat maxHeight = [[self.yArray valueForKeyPath:@"@max.floatValue"] floatValue] + self.sectionInset.bottom;
    self.maxHeight = maxHeight;
    return CGSizeMake(self.collectionView.bounds.size.width, self.maxHeight);
}

/**
 返回指定区域所有cell的布局属性
 这个方法会多次执行，直到所有cell都显示出来就不执行了
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *resultArr = [NSMutableArray array];
    [self.layoutAttributeArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [resultArr addObject:obj];
        }
    }];
    return resultArr;
}

// 返回IndexPath位置的item的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建一个UICollectionViewLayoutAttributes对象
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // item宽度
    CGFloat itemW = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * (self.cols - 1)) / self.cols;
    // item高度，从代理中获取
    CGFloat itemH = [self.delegate waterfallFlowLayout:self itemHeightAtIndexPath:indexPath];
    // itemY
    // 找出最小高度的那一列
    NSNumber *min =[self.yArray valueForKeyPath:@"@min.floatValue"];
    NSInteger minHeightIndex = [self.yArray indexOfObject:min];
    CGFloat itemY = [self.yArray[minHeightIndex] floatValue];
    // 从第二行开始需要加上item的间距
    if (indexPath.item >= self.cols) {
        itemY += self.minimumInteritemSpacing;
    }
    // itemX
    CGFloat itemX = self.sectionInset.left + (itemW + self.minimumInteritemSpacing) * minHeightIndex;

    attr.frame = CGRectMake(itemX, itemY, itemW, itemH);

    // 重新设置最小列高度
    self.yArray[minHeightIndex] = [NSNumber numberWithFloat:CGRectGetMaxY(attr.frame)];

    return attr;
}

@end
