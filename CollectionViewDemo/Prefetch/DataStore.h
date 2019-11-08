//
//  DataStore.h
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/8.
//  Copyright © 2019 张延深. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefetchOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataStore : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)numberOfImages;

- (NSString *)loadImageAt:(NSIndexPath *)indexPath;
- (PrefetchOperation *)loadImageAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
