//
//  LCViewController.m
//  testWaterLayout
//
//  Created by Mac on 15-3-16.
//  Copyright (c) 2015年 chao. All rights reserved.
//

#import "LCViewController.h"
#import "MJExtension.h"
#import "LCShop.h"
#import "LCShopCell.h"
#import "LCWaterLayout.h"
#import "MJRefresh.h"

@interface LCViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, LCWaterLayoutDeleagte>
@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation LCViewController


static NSString * const ID=@"shop";

- (NSMutableArray *)shops
{
    if (_shops==nil) {
        _shops=[[NSMutableArray alloc] initWithArray:[LCShop objectArrayWithFilename:@"1.plist"]];
    }
    return _shops;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    LCWaterLayout *layout=[[LCWaterLayout alloc] init];
    layout.delegate=self;
    
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    [collectionView registerNib:[UINib nibWithNibName:@"LCShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    [self.view addSubview:collectionView];
    self.collectionView=collectionView;
    
    __block NSMutableArray *blockShops=self.shops;
    [self.collectionView addFooterWithCallback:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *shopArray = [LCShop objectArrayWithFilename:@"1.plist"];
            [blockShops addObjectsFromArray:shopArray];
            [collectionView reloadData];
            [collectionView footerEndRefreshing];
        });
    }];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LCShopCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.shop=self.shops[indexPath.item];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)waterLayout:(LCWaterLayout *)layout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    LCShop *shop=self.shops[indexPath.item];
    return width * [shop.h floatValue] / [shop.w floatValue];
}
@end
