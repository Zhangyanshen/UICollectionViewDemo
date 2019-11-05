//
//  CircularCollectionViewLayoutAttributes.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/4.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "CircularCollectionViewLayoutAttributes.h"

@implementation CircularCollectionViewLayoutAttributes

- (instancetype)init {
    if (self = [super init]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return self;
}

// 需要实现这个方法，collection View  实时布局时，会copy参数，确保自身的参数被copy
- (id)copyWithZone:(NSZone *)zone {
    CircularCollectionViewLayoutAttributes *attr = [super copyWithZone:zone];
    attr.anchorPoint = self.anchorPoint;
    return attr;
}

#pragma mark - Setters/Getters

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    self.zIndex = angle * 10000000;
    self.transform = CGAffineTransformMakeRotation(angle);
}

@end
