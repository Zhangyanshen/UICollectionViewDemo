//
//  MoveCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/6.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "MoveCollectionViewCell.h"

@implementation MoveCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)beginAnimation {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anim.fromValue = @(-M_PI / 40.0);
    anim.toValue = @(M_PI / 40.0);
    anim.duration = 0.15;
    anim.removedOnCompletion = NO;
    anim.repeatCount = MAXFLOAT;
    anim.autoreverses = YES;
    [self.layer addAnimation:anim forKey:@"animation"];
}

- (void)stopAnimation {
    [self.layer removeAllAnimations];
}

@end
