//
//  BarCountSegmentControl.h
//  On the 8
//
//  Created by Justin Rhoades on 1/11/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BarCountSegmentDelegate <NSObject>

- (void) segmentTapped:(NSInteger)tag;

@end

@protocol BarCountSegmentControlDelegate <NSObject>

- (void) segmentTapped:(NSInteger)tag;

@end

@interface BarCountSegmentControl : UIView

@property (nonatomic, assign) id<BarCountSegmentControlDelegate> delegate;

- (void) segmentTapped:(NSInteger)tag;
- (void) setActiveSegment:(NSInteger)tag;

@end

@interface BarCountSegmentButton : UIView

@end