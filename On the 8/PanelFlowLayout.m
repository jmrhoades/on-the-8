//
//  PanelFlowLayout.m
//  on the 8
//
//  Created by Justin Rhoades on 2/26/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "PanelFlowLayout.h"

@interface PanelFlowLayout ()
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat midX;
@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;

@end

@implementation PanelFlowLayout

- (id)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _fullscreen = NO;
        
    }
    self.minimumLineSpacing = 24.f;
    return self;
}

- (void)prepareLayout {
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    _midX = CGRectGetMidX(visibleRect);
    _width = CGRectGetWidth(visibleRect) / 2;
    
    if (self.collectionView.bounds.size.width > 600) {
        self.minimumLineSpacing = 64.f;
    }
    
    CGFloat scaleFactor = 0.75;
    if (_fullscreen) {
        scaleFactor = 1.0;
    }
    
    CGSize size = CGSizeMake(self.collectionView.bounds.size.width*scaleFactor, self.collectionView.bounds.size.height*scaleFactor);
    self.itemSize = size;
    
    self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    CGSize firstSize = size;
    CGSize lastSize = size;
    self.sectionInset = UIEdgeInsetsMake(0, (self.collectionView.bounds.size.width - firstSize.width) / 2, 0, (self.collectionView.bounds.size.width - lastSize.width) / 2);
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    NSLog(@"%@ prepare for updated", self);
    [super prepareForCollectionViewUpdates:updateItems];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
    
    self.indexPathsToAnimate = indexPaths;
}

- (void)finalizeCollectionViewUpdates
{
    NSLog(@"%@ finalize updates", self);
    [super finalizeCollectionViewUpdates];
    self.indexPathsToAnimate = nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [super layoutAttributesForElementsInRect:rect];
}


- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    //NSLog(@"%@ initial attr for %@", self, itemIndexPath);
    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];

    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
        //attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
        attr.transform = CGAffineTransformMakeScale(0.2, 0.2);
        attr.alpha = 0.0;
        //attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
        [_indexPathsToAnimate removeObject:itemIndexPath];
    }
    
    return attr;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    //NSLog(@"%@ final attr for %@", self, itemIndexPath);
    UICollectionViewLayoutAttributes *attr = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];

    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
        
        //CATransform3D flyUpTransform = CATransform3DIdentity;
        //flyUpTransform.m34 = 1.0 / -20000;
        //flyUpTransform = CATransform3DTranslate(flyUpTransform, 0, 0, 19500);
        //attr.transform3D = flyUpTransform;
        //attr.center = self.collectionView.center;
        //attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), -300);
        attr.alpha = 0.0;
        attr.transform = CGAffineTransformMakeScale(0.2, 0.2);
        //attr.zIndex = 1;
        
        [_indexPathsToAnimate removeObject:itemIndexPath];
    }
    else{
        attr.alpha = 1.0;
    }
    
    //NSLog(@"final %@", attr);
    return attr;
}


@end
