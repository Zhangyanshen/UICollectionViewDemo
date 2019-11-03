//
//  BasicFooterCollectionReusableView.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/2.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "BasicFooterCollectionReusableView.h"
#import "Masonry.h"

@implementation BasicFooterCollectionReusableView

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
        _textLbl.font = [UIFont systemFontOfSize:18];
        _textLbl.textColor = [UIColor blueColor];
    }
    return _textLbl;
}

#pragma mark - Private methods

- (void)setupUI {
    [self addSubview:self.textLbl];
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self);
    }];
}

@end
