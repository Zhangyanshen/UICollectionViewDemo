//
//  CoverFlowLayout.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/3.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "CoverFlowLayout.h"

@implementation CoverFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scale = 0.8;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 获取rect中的布局属性
    NSArray<UICollectionViewLayoutAttributes *> *attrs = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    // 找到中心点
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0;
    // 每个点根据距离中心点距离进行缩放
    [attrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat pad = ABS(centerX - obj.center.x - self.itemSize.width);
        CGFloat scale = 1 / (1 + pad * 0.005);
//        obj.size = CGSizeMake(self.itemSize.width * (1 + self.scale), self.itemSize.height * (1 + self.scale));
        CGRect frame = obj.frame;
        obj.frame = CGRectOffset(frame, self.itemSize.width, 0);
        obj.transform = CGAffineTransformMakeScale(scale, scale);
    }];
    return attrs;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 获取中心点
    CGFloat centerX = proposedContentOffset.x + self.collectionView.bounds.size.width * 0.5;
    // 获取这个范围的布局属性
    NSArray<UICollectionViewLayoutAttributes *> *attrs = [self layoutAttributesForElementsInRect:CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height)];
    
    // 用每个cell的中心点和centerX进行比较, 最终比较出一个距离最短的值
    // 假设第0个元素是最小的
    int minIdx = 0;
    UICollectionViewLayoutAttributes *minAttr = attrs[minIdx];
    
    // 循环attrs数组, 找出最小值
    for (int i = 1; i < attrs.count; i++) {
        UICollectionViewLayoutAttributes *attr = attrs[i];
        if (ABS(attr.center.x - centerX) < ABS(minAttr.center.x - centerX)) {
            minIdx = i;
            minAttr = attr;
        }
    }
    
    // 计算出距离中心点最小的那个cell 和中心点的偏移
    CGFloat offsetX = minAttr.center.x - centerX;
    
    return CGPointMake(proposedContentOffset.x + offsetX, proposedContentOffset.y);
}

- (CGSize)collectionViewContentSize {
    CGFloat width = self.sectionInset.left + self.sectionInset.right + (self.itemSize.width + self.minimumInteritemSpacing) * ([self.collectionView numberOfItemsInSection:0] + 2) - self.minimumInteritemSpacing;
    return CGSizeMake(width, 0);
}

@end
