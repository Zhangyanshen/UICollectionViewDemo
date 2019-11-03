//
//  BasicCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/1.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "BasicCollectionViewCell.h"
#import "Masonry.h"

@implementation BasicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.textLbl];
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - Setters/Getters

- (UILabel *)textLbl {
    if (!_textLbl) {
        _textLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLbl.textColor = [UIColor blackColor];
        _textLbl.textAlignment = NSTextAlignmentCenter;
        _textLbl.font = [UIFont systemFontOfSize:18];
    }
    return _textLbl;
}

@end
