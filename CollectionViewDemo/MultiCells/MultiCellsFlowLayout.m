//
//  MultiCellsFlowLayout.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/3.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "MultiCellsFlowLayout.h"

@interface MultiCellsFlowLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributeArray; // 布局frame数组
@property (nonatomic, assign) CGFloat maxWidth;

@end

@implementation MultiCellsFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.colms = 4;
        self.lines = 2;
        self.layoutAttributeArray = [NSMutableArray array];
        self.maxWidth = 0;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    // item的宽
    CGFloat itemW = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - (self.colms - 1) * self.minimumInteritemSpacing) / self.colms;
    // item的高
    CGFloat itemH = (self.collectionView.bounds.size.height - self.sectionInset.top - self.sectionInset.bottom - (self.lines - 1) * self.minimumLineSpacing) / self.lines;
    // item总个数
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < itemCount; i++) {
        NSInteger page = i / (self.colms * self.lines);
        NSInteger index = i % (self.colms * self.lines);
        // item的x
        CGFloat itemX = page * self.collectionView.bounds.size.width + self.sectionInset.left + (itemW + self.minimumInteritemSpacing) * (index % self.colms);
        // item的y
        CGFloat itemY = self.sectionInset.top + (itemH + self.minimumLineSpacing) * (index / self.colms);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        attr.frame = CGRectMake(itemX, itemY, itemW, itemH);
        
        [self.layoutAttributeArray addObject:attr];
    }
    // 计算collectionView宽度
    NSInteger pageCount = itemCount % (self.lines * self.colms) == 0 ? itemCount / (self.lines * self.colms) : itemCount / (self.lines * self.colms) + 1;
    self.maxWidth = pageCount * self.collectionView.bounds.size.width;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.maxWidth, 0);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *result = [NSMutableArray array];
    [self.layoutAttributeArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [result addObject:obj];
        }
    }];
    return result;
}

@end
