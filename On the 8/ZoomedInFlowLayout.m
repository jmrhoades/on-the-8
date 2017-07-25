//
//  ZoomedInFlowLayout.m
//  on the 8
//
//  Created by Justin Rhoades on 2/26/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "ZoomedInFlowLayout.h"

@implementation ZoomedInFlowLayout

- (id)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout {

    CGFloat scaleFactor = 1.0;
    CGSize size = CGSizeMake(self.collectionView.bounds.size.width*scaleFactor, self.collectionView.bounds.size.height*scaleFactor);
    self.itemSize = size;
    
    self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    CGSize firstSize = size;
    CGSize lastSize = size;
    self.sectionInset = UIEdgeInsetsMake(0, (self.collectionView.bounds.size.width - firstSize.width) / 2,
                                         0, (self.collectionView.bounds.size.width - lastSize.width) / 2);
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

@end
