//
//  PrefetchViewController.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/5.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "PrefetchViewController.h"
#import "PrefetchCell.h"
#import "Masonry.h"
#import "UIImageView+YYWebImage.h"

@interface PrefetchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation PrefetchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[
        @"http://img.jiaodong.net/pic/0/10/95/81/10958118_604510.jpg",
        @"http://i01.pic.sogou.com/47907287c1f7d45b",
        @"http://i01.pic.sogou.com/c61c287fc43cb6bf",
        @"http://i03.pictn.sogoucdn.com/a3922ed43d6d7027",
        @"http://i01.pictn.sogoucdn.com/400a032e4c831fb1",
        @"http://i03.pictn.sogoucdn.com/64a055f3497f295f",
        @"http://i04.pictn.sogoucdn.com/40778a743abae44a",
        @"http://i02.pictn.sogoucdn.com/a20381b4283dc77d",
        @"http://i01.pictn.sogoucdn.com/4120d236bb1627b3",
        @"http://i04.pic.sogou.com/8a7ab42259a7778e",
        @"http://i04.pic.sogou.com/d0cc38f5775ae2dc",
        @"http://sports.sun0769.com/photo/composite/201303/W020130331542966530065.jpg",
        @"http://ztd00.photos.bdimg.com/ztd/w=350;q=70/sign=1d1c9b312f2dd42a5f0907ae33002a88/fd039245d688d43f4da25faa771ed21b0ef43b5b.jpg"
        ,
        @"http://i02.pictn.sogoucdn.com/f0da5d1d2e399f54",
        @"http://www.manjpg.com/uploads/allimg/140712/628-140G2151G3.jpg",
        @"http://b.hiphotos.baidu.com/zhidao/pic/item/3b292df5e0fe992535a1545f3ca85edf8db1710b.jpg"
        ,
        @"http://d.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=a2e684445b82b2b7a7ca31c2019de7d7/622762d0f703918fa34e218a533d269758eec4d6.jpg",
        @"http://www.laonanren.cc/uploads/allimg/160215/3-1602151642164A.jpg",
        @"http://img3.duitang.com/uploads/item/201501/01/20150101084426_sVcze.jpeg",
        @"http://pic22.photophoto.cn/20120113/0036036771604425_b.jpg",
        @"http://i04.pictn.sogoucdn.com/473008194fe06391",
        @"http://upload.mnw.cn/2014/1030/1414658148257.jpg",
        @"http://img5.duitang.com/uploads/item/201502/23/20150223111936_XH3m8.jpeg",
        @"http://i01.pictn.sogoucdn.com/6e7a1bfdcb65926b"
    ];
    [self setupUI];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PrefetchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imgView yy_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.item]] placeholder:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    [[(PrefetchCell *)cell imgView] sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.item]] placeholderImage:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = CGRectGetWidth(collectionView.frame) / 2;
    CGFloat itemH = itemW;
    return CGSizeMake(itemW, itemH);
}

#pragma mark - UICollectionViewDataSourcePrefetching

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
//    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        PrefetchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:obj];
//        [cell.imgView yy_setImageWithURL:[NSURL URLWithString:self.dataArr[obj.item]] placeholder:nil];
//    }];
}

#pragma mark - Setters/Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 0;
        layout.minimumLineSpacing = margin;
        layout.minimumInteritemSpacing = margin;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        if (@available(iOS 10.0, *)) {
            [_collectionView setPrefetchingEnabled:NO];
//            _collectionView.prefetchDataSource = self;
        }
        [_collectionView registerNib:[UINib nibWithNibName:@"PrefetchCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark - Private methods

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
    }];
}

@end
