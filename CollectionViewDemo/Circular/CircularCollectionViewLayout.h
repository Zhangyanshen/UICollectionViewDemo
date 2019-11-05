//
//  CircularCollectionViewLayout.h
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/4.
//  Copyright © 2019 张延深. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircularCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize itemSize; // 每个item的大小
@property (nonatomic, assign) CGFloat radius; // 设置半径，需要重新设置布局
@property (nonatomic, assign) CGFloat anglePerItem; // 每两个item 之间的角度，任意值

@end

NS_ASSUME_NONNULL_END
