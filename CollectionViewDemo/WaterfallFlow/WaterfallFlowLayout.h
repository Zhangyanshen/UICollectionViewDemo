//
//  WaterfallFlowLayout.h
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/2.
//  Copyright © 2019 张延深. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterfallFlowLayout;

NS_ASSUME_NONNULL_BEGIN

@protocol WaterfallFlowLayoutDelegate <NSObject>

- (CGFloat)waterfallFlowLayout:(WaterfallFlowLayout *)layout itemHeightAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterfallFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger cols; // 列数
@property (nonatomic, weak) id<WaterfallFlowLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
