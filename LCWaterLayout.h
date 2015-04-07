//
//  LCWaterLayout.h
//  testWaterLayout
//
//  Created by Mac on 15-3-16.
//  Copyright (c) 2015年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCWaterLayout;

@protocol LCWaterLayoutDeleagte <NSObject>

- (CGFloat)waterLayout:(LCWaterLayout *)layout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end

@interface LCWaterLayout : UICollectionViewLayout
@property (nonatomic, assign) CGFloat colConut;
@property (nonatomic, assign) CGFloat rowMargin;
@property (nonatomic, assign) CGFloat colMargin;
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property (nonatomic, weak) id <LCWaterLayoutDeleagte> delegate;
@end
