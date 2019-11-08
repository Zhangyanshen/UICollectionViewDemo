//
//  AlbumViewController.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/8.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumLayout.h"
#import "Masonry.h"
#import "AlbumCollectionViewCell.h"
#import "DataStore.h"
#import "UIImageView+YYWebImage.h"

@interface AlbumViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[DataStore sharedInstance] numberOfImages];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *str = [[DataStore sharedInstance] loadImageAt:indexPath];
    [cell.imgView yy_setImageWithURL:[NSURL URLWithString:str] placeholder:nil];
    return cell;
}

#pragma mark - Setters/Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        AlbumLayout *layout = [[AlbumLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"AlbumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark - Private methods

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

@end
