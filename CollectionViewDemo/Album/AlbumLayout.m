//
//  AlbumLayout.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/8.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "AlbumLayout.h"

@interface AlbumLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attrs;
@property (nonatomic, assign) CGFloat maxHeight;

@end

@implementation AlbumLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = UIEdgeInsetsZero;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 获取item个数
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    // 最小item的宽高
    CGFloat minItemW = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat minItemH = minItemW;
    // item的X和Y
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    // item的W和H
    CGFloat itemW = 0;
    CGFloat itemH = 0;
    // 第几页
    NSInteger pageCount = itemCount / 7;
    NSInteger delta = itemCount % 7;
    // 一页高度
    CGFloat pageH = 6 * minItemH;
    // 遍历
    for (int i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 创建UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        // 计算item的index
        NSInteger index = i % 7;
        NSInteger page = i / 7;
        switch (index) {
            case 0:
            {
                itemW = minItemW;
                itemH = minItemH;
                itemX = 0;
                itemY = page * pageH;
            }
                break;
            case 1:
            {
                itemW = minItemW;
                itemH = minItemH;
                itemX = minItemW;
                itemY = page * pageH;
            }
                break;
            case 2:
            {
                itemW = minItemW;
                itemH = minItemH;
                itemX = minItemW * 2;
                itemY = page * pageH;
            }
                break;
            case 3:
            {
                itemW = minItemW * 2;
                itemH = minItemH * 2;
                itemX = 0;
                itemY = page * pageH + minItemH;
            }
                break;
            case 4:
            {
                itemW = minItemW;
                itemH = minItemH;
                itemX = minItemW * 2;
                itemY = page * pageH + minItemH;
            }
                break;
            case 5:
            {
                itemW = minItemW;
                itemH = minItemH;
                itemX = minItemW * 2;
                itemY = page * pageH + 2 * itemH;
            }
                break;
            case 6:
            {
                itemW = minItemW * 3;
                itemH = minItemH * 3;
                itemX = 0;
                itemY = page * pageH + 3 * minItemH;
            }
                break;
            default:
                break;
        }
        // 设置attr的frame
        attr.frame = CGRectMake(itemX, itemY, itemW, itemH);
        // 缓存attr
        [self.attrs addObject:attr];
    }
    // 计算contentSize
    switch (delta) {
        case 1:
        case 2:
        case 3:
        {
            self.maxHeight = pageCount * pageH + minItemH;
        }
            break;
        case 4:
        case 5:
        case 6:
        {
            self.maxHeight = pageCount * pageH + minItemH * 3;
        }
            break;
        default:
            break;
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, self.maxHeight);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *result = [NSMutableArray array];
    [self.attrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(obj.frame, rect)) {
            [result addObject:obj];
        }
    }];
    return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attrs[indexPath.item];
}

#pragma mark - Setters/Getters

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attrs {
    if (!_attrs) {
        _attrs = [NSMutableArray array];
    }
    return _attrs;
}

@end
