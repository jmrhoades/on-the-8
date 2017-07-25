//
//  NumbersView.h
//  On the 8
//
//  Created by Justin Rhoades on 12/23/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "RingView.h"

@interface NumbersBezierView : RingView

@property (nonatomic) CAShapeLayer *maskRing;
@property (nonatomic) CAShapeLayer *numberA;
@property (nonatomic) CAShapeLayer *numberB;
@property (nonatomic) CAShapeLayer *activeNumber;
@property (nonatomic) CGRect       numberFrame;

@property (nonatomic) CABasicAnimation *moveUpFromBottomAnimation;
@property (nonatomic) CABasicAnimation *moveUpFromCenterAnimation;

@property (nonatomic) CABasicAnimation *fadeInAnimation;
@property (nonatomic) CABasicAnimation *fadeOutAnimation;

@property (nonatomic) CABasicAnimation *scaleInAnimation;
@property (nonatomic) CABasicAnimation *scaleOutAnimation;
@property (nonatomic) CABasicAnimation *scaleAwayAnimation;

@property (nonatomic) CAAnimationGroup *showAnimation;
@property (nonatomic) CAAnimationGroup *hideAnimation;

- (void) showNumber:(int)number withDuration:(float)duration;
- (void) hideActiveNumber;
- (UIBezierPath *) getPathForNum:(int)number;

@end
