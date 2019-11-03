//
//  BasicHeaderCollectionReusableView.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/2.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "BasicHeaderCollectionReusableView.h"
#import "Masonry.h"

@interface BasicHeaderCollectionReusableView ()



@end

@implementation BasicHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Setters/Getters

- (UILabel *)textLbl {
    if (!_textLbl) {
        _textLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLbl.translatesAutoresizingMaskIntoConstraints = NO;
        _textLbl.font = [UIFont systemFontOfSize:20];
        _textLbl.textColor = [UIColor yellowColor];
    }
    return _textLbl;
}

#pragma mark - Private methods

- (void)setupUI {
    [self addSubview:self.textLbl];
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
    }];
}

@end
