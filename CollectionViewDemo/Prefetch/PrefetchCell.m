//
//  PrefetchCell.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/5.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "PrefetchCell.h"

@interface PrefetchCell ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatorView;

@end

@implementation PrefetchCell

- (void)prepareForReuse {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateAppearance:nil animation:NO];
    });
}

- (void)updateAppearance:(UIImage * _Nullable)image animation:(BOOL)animation {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                [self displayImage:image];
            }];
        } else {
            [self displayImage:image];
        }
    });
}

- (void)displayImage:(UIImage *)image {
    if (image) {
        self.imgView.image = image;
        self.imgView.alpha = 1;
        self.loadingIndicatorView.alpha = 0;
        [self.loadingIndicatorView stopAnimating];
        self.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        self.imgView.alpha = 0;
        self.loadingIndicatorView.alpha = 1;
        [self.loadingIndicatorView startAnimating];
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
}

@end
