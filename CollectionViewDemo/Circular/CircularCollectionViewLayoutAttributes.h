//
//  CircularCollectionViewLayoutAttributes.h
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/4.
//  Copyright © 2019 张延深. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircularCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, assign) CGFloat angle;

@end

NS_ASSUME_NONNULL_END
