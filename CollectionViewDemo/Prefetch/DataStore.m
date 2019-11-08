//
//  DataStore.m
//  CollectionViewDemo
//
//  Created by 张延深 on 2019/11/8.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "DataStore.h"

static DataStore *dataStore = nil;

@interface DataStore ()

@property (nonatomic, strong) NSArray *imageArr;

@end

@implementation DataStore

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataStore = [[self alloc] init];
    });
    return dataStore;
}

- (instancetype)init {
    if (self = [super init]) {
        self.imageArr = @[
            @"http://img.jiaodong.net/pic/0/10/95/81/10958118_604510.jpg",
            @"https://b-ssl.duitang.com/uploads/item/201407/06/20140706222438_AV2dN.jpeg",
            @"https://b-ssl.duitang.com/uploads/item/201809/11/20180911180218_hklyi.jpg",
            @"http://i03.pictn.sogoucdn.com/a3922ed43d6d7027",
            @"http://i01.pictn.sogoucdn.com/400a032e4c831fb1",
            @"http://i03.pictn.sogoucdn.com/64a055f3497f295f",
            @"http://i04.pictn.sogoucdn.com/40778a743abae44a",
            @"http://i02.pictn.sogoucdn.com/a20381b4283dc77d",
            @"http://i01.pictn.sogoucdn.com/4120d236bb1627b3",
            @"http://00.imgmini.eastday.com/mobile/20180531/20180531120049_a82a43190cc4cf4e17ee880786e914c7_1.png",
            @"http://imgup04.iefans.net/iefans/2019-03/15/16/15526377496738_7.jpg",
            @"http://sports.sun0769.com/photo/composite/201303/W020130331542966530065.jpg",
            @"http://ztd00.photos.bdimg.com/ztd/w=350;q=70/sign=1d1c9b312f2dd42a5f0907ae33002a88/fd039245d688d43f4da25faa771ed21b0ef43b5b.jpg"
            ,
            @"http://pic.87g.com/upload/2018/0301/20180301021316192.jpg",
            @"https://img.cehca.com/uploadimg/ico/2019/1021/1571646577459981.jpg",
            @"http://b.hiphotos.baidu.com/zhidao/pic/item/3b292df5e0fe992535a1545f3ca85edf8db1710b.jpg"
            ,
            @"http://d.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=a2e684445b82b2b7a7ca31c2019de7d7/622762d0f703918fa34e218a533d269758eec4d6.jpg",
            @"https://b-ssl.duitang.com/uploads/item/201809/01/20180901124516_fconj.thumb.700_0.jpeg",
            @"http://img3.duitang.com/uploads/item/201501/01/20150101084426_sVcze.jpeg",
            @"http://pic22.photophoto.cn/20120113/0036036771604425_b.jpg",
            @"http://i04.pictn.sogoucdn.com/473008194fe06391",
            @"http://upload.mnw.cn/2014/1030/1414658148257.jpg",
            @"http://img0.pconline.com.cn/pconline/1808/14/11597744_584_2018081352737202_thumb.jpg",
            @"http://i01.pictn.sogoucdn.com/6e7a1bfdcb65926b"
        ];
    }
    return self;
}

- (NSInteger)numberOfImages {
    return self.imageArr.count;
}

- (PrefetchOperation *)loadImageAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= 0 && indexPath.item < self.imageArr.count) {
        NSString *imageURL = self.imageArr[indexPath.item];
        return [[PrefetchOperation alloc] initWithImageURL:imageURL];
    }
    return nil;
}

- (NSString *)loadImageAt:(NSIndexPath *)indexPath {
    return self.imageArr[indexPath.item];
}

@end
