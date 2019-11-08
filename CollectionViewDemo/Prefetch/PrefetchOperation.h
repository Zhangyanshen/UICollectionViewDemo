//
//  PrefetchOperation.h
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/8.
//  Copyright © 2019 张延深. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrefetchOperation : NSOperation

@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong) void(^loadingCompleteHandler)(UIImage * _Nullable image);

- (instancetype)initWithImageURL:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
