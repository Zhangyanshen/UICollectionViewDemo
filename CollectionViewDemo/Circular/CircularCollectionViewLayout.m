//
//  CircularCollectionViewLayout.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/4.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "CircularCollectionViewLayout.h"
#import "CircularCollectionViewLayoutAttributes.h"

@interface CircularCollectionViewLayout ()
{
    CGFloat _centerX;
    CGFloat _anchorPointY; // item的锚点Y值
}
@property (nonatomic, strong) NSMutableArray<CircularCollectionViewLayoutAttributes *> *attributesList; // 属性数组
@property (nonatomic, assign) CGFloat angleAtExtreme; // 当collectionView滑到极端时，第 0个item的角度 （第0个开始是 0 度，  当滑到极端时， 最后一个是 0 度）
@property (nonatomic, assign) CGFloat angle; // 滑动时，第0个item的角度

@end

@implementation CircularCollectionViewLayout

- (instancetype)init {
    if (self = [super init]) {
        self.itemSize = CGSizeMake(133, 173);
        self.attributesList = [NSMutableArray array];
        self.radius = 500;
        self.anglePerItem = atan(self.itemSize.width / self.radius);
        self.angleAtExtreme = 0;
        self.angle = 0;
    }
    return self;
}

// 告诉类使用CircularCollectionViewLayoutAttributes类布局
+ (Class)layoutAttributesClass {
    return [CircularCollectionViewLayoutAttributes class];
}

// CollectionView的内容尺寸
- (CGSize)collectionViewContentSize {
    return CGSizeMake([self.collectionView numberOfItemsInSection:0] * self.itemSize.width, self.collectionView.bounds.size.height);
}

// 布局是否随着CollectionView的滚动发生变化
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

/**
 准备开始布局
 每次开始布局前，都会调用这个方法，让你做一些后面布局更新需要用到的初始化处理
 */
- (void)prepareLayout {
    [super prepareLayout];
    self.angleAtExtreme = [self.collectionView numberOfItemsInSection:0] > 0 ? -([self.collectionView numberOfItemsInSection:0] - 1) * self.anglePerItem : 0;
    self.angle = self.angleAtExtreme * self.collectionView.contentOffset.x / (self.collectionViewContentSize.width - self.collectionView.bounds.size.width);
    // 整体布局是将每个item设置在屏幕中心，然后旋转 anglePerItem * i 度
    _centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
    // 锚点的y值，多增加了raidus的值
    _anchorPointY = (self.itemSize.height / 2.0 + self.radius) / self.itemSize.height;
    
//    // 不要计算所有的item，只计算在屏幕中的item,theta最大倾斜
//    CGFloat theta = atan2(self.collectionView.bounds.size.width / 2.0, self.radius + (self.itemSize.height / 2.0) - (self.collectionView.bounds.size.height / 2.0));
//    NSInteger startIndex = 0;
//    NSInteger endIndex = [self.collectionView numberOfItemsInSection:0] - 1;
//    // 开始位置
//    if (self.angle < -theta) {
//        startIndex = floor((-theta - self.angle) / self.anglePerItem);
//    }
//    // 结束为止
//    endIndex = MIN(endIndex, ceil((theta - self.angle) / self.anglePerItem));
//    if (endIndex < startIndex) {
//        endIndex = 0;
//        startIndex = 0;
//    }
    
    // 将布局属性进行缓存
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CircularCollectionViewLayoutAttributes *attr = (CircularCollectionViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesList addObject:attr];
    }
}

// 返回rect区域的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *result = [NSMutableArray array];
    [self.attributesList enumerateObjectsUsingBlock:^(CircularCollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [result addObject:obj];
        }
    }];
    return result;
}

// 返回indexPath位置的item的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircularCollectionViewLayoutAttributes *attr = [CircularCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 设置item的大小
    attr.size = self.itemSize;
    // 设置居中
    attr.center = CGPointMake(_centerX, CGRectGetMidY(self.collectionView.bounds));
    // 设置角度
    attr.angle = self.angle + self.anglePerItem * indexPath.item;
    // 锚点，我们自定义的属性
    attr.anchorPoint = CGPointMake(0.5, _anchorPointY);
    
    return attr;
}

// 返回停止滚动时的点，可以在这里进行调整，让距离CollectionView中心最近的cell居中显示
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGPoint finalContentOffset = proposedContentOffset;

    // 每单位偏移量对应的偏移角度
    CGFloat factor = -self.angleAtExtreme / (self.collectionViewContentSize.width - self.collectionView.bounds.size.width);
    CGFloat proposedAngle = proposedContentOffset.x * factor;

    // 大约偏移了多少个
    CGFloat ratio = proposedAngle / self.anglePerItem;
    CGFloat multiplier;

    if (velocity.x > 0) { // 往左划
        multiplier = ceil(ratio);
    } else if (velocity.x < 0) { // 往右划
        multiplier = floor(ratio);
    } else {
        multiplier = round(ratio);
    }

    finalContentOffset.x = multiplier * self.anglePerItem / factor;

    return finalContentOffset;
}

#pragma mark - Setters/Getters

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self invalidateLayout];
}

- (void)setAnglePerItem:(CGFloat)anglePerItem {
    _anglePerItem = anglePerItem;
    [self invalidateLayout];
}

@end
