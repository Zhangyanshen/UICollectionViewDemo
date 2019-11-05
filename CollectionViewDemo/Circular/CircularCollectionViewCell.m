//
//  CircularCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/4.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "CircularCollectionViewCell.h"
#import "Masonry.h"
#import "CircularCollectionViewLayoutAttributes.h"

@implementation CircularCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

// 自定义UICollectionViewLayoutAttributes时可以重写该方法
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    CircularCollectionViewLayoutAttributes *attr = (CircularCollectionViewLayoutAttributes *)layoutAttributes;
    self.layer.anchorPoint = attr.anchorPoint;
    CGPoint center = self.center;
    center.y += (attr.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds);
    self.center = center;
}

#pragma mark - Setters/Getters

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont systemFontOfSize:20];
    }
    return _textLabel;
}

@end
