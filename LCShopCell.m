//
//  LCShopCell.m
//  testWaterLayout
//
//  Created by Mac on 15-3-16.
//  Copyright (c) 2015年 chao. All rights reserved.
//

#import "LCShopCell.h"
#import "LCShop.h"
#import "UIImageView+WebCache.h"

@interface LCShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation LCShopCell

- (void)setShop:(LCShop *)shop
{
    _shop=shop;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_shop.img] placeholderImage:[UIImage imageNamed:@"loading"]] ;
    self.priceLabel.text=_shop.price;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
