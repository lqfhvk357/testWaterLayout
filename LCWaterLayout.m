
//
//  LCWaterLayout.m
//  testWaterLayout
//
//  Created by Mac on 15-3-16.
//  Copyright (c) 2015年 chao. All rights reserved.
//

#import "LCWaterLayout.h"

@interface LCWaterLayout ()
@property (nonatomic, strong) NSMutableDictionary *colMaxYs;
@property (nonatomic, strong) NSMutableArray *layoutAttributes;

@end

@implementation LCWaterLayout

- (NSMutableDictionary *)colMaxYs
{
    if (_colMaxYs==nil) {
        _colMaxYs=[[NSMutableDictionary alloc] init];
    }
    return _colMaxYs;
}

- (NSMutableArray *)layoutAttributes
{
    if (_layoutAttributes==nil) {
        _layoutAttributes=[[NSMutableArray alloc] init];
    }
    return _layoutAttributes;
}

- (id)init
{
    if (self=[super init]) {
        self.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
        self.colConut=3;
        self.colMargin=10;
        self.rowMargin=10;
    }
    return self;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

- (void)prepareLayout
{
    [self.colMaxYs removeAllObjects];
    for (int i=0; i<self.colConut; i++) {
        NSString *str=[NSString stringWithFormat:@"%d", i];
        self.colMaxYs[str]=@(self.sectionInset.top);
    }
    
    [self.layoutAttributes removeAllObjects];
    NSInteger count=[self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<count; i++) {
        UICollectionViewLayoutAttributes *attr=[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.layoutAttributes addObject:attr];
    }
    
}

- (CGSize)collectionViewContentSize
{
    CGFloat maxY=0;
    for (int i=0; i<self.colConut; i++) {
        NSString *str=[NSString stringWithFormat:@"%d", i];
        if (maxY<[self.colMaxYs[str] floatValue]) {
            maxY=[self.colMaxYs[str] floatValue];
        }
    }
    return CGSizeMake(0, maxY+self.sectionInset.top);
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{

    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    NSMutableArray *visibleArray=[NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in self.layoutAttributes) {
        if (CGRectIntersectsRect(visibleRect, attr.frame)) {
            [visibleArray addObject:attr];
        }
    }

    NSLog(@"count:%ld-------visbleCount:%lu", (long)visibleArray.count, (unsigned long)self.layoutAttributes.count);
    return visibleArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __block NSString *minRowOfColMaxY=@"0";
    [self.colMaxYs enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {
        if ([obj floatValue]<[self.colMaxYs[minRowOfColMaxY] floatValue]) {
            minRowOfColMaxY=key;
        }
    }];
    
    CGFloat width=(self.collectionView.frame.size.width-self.sectionInset.left-self.sectionInset.right-(self.colConut-1)*self.colMargin)/self.colConut;
    CGFloat height=[self.delegate waterLayout:self heightForWidth:width atIndexPath:indexPath];
    
    CGFloat x=self.sectionInset.left+[minRowOfColMaxY intValue]*(self.rowMargin+width);
    CGFloat y=[self.colMaxYs[minRowOfColMaxY] floatValue] + self.rowMargin;
    
    self.colMaxYs[minRowOfColMaxY]=[NSString stringWithFormat:@"%f", y+height];
    
    UICollectionViewLayoutAttributes *attrs=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame=CGRectMake(x, y, width, height);
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs=[UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"" withIndexPath:indexPath];
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs=[UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"" withIndexPath:indexPath];
    return attrs;
}
@end
