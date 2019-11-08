//
//  PrefetchOperation.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/8.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "PrefetchOperation.h"

@interface PrefetchOperation ()

@property (nonatomic, copy) NSString *imageURLStr;

@end

@implementation PrefetchOperation

- (instancetype)initWithImageURL:(NSString *)urlStr {
    if (self = [super init]) {
        self.imageURLStr = urlStr;
    }
    return self;
}

- (void)main {
    // 1
    if (self.isCancelled) {
        return;
    }
    // 2
    NSError *err = nil;
    UIImage *image = nil;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURLStr] options:NSDataReadingMappedAlways error:&err];
    // 3
    if (self.isCancelled) {
        return;
    }
    // 4
    if (err) {
        NSLog(@"加载数据失败:%@", err);
    } else {
        image = [UIImage imageWithData:data];
        _image = image;
    }
    // 5
    if (self.loadingCompleteHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loadingCompleteHandler(image);
        });
    }
}

@end
