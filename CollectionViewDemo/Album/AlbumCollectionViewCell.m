//
//  AlbumCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/8.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "AlbumCollectionViewCell.h"

@implementation AlbumCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
}

@end
