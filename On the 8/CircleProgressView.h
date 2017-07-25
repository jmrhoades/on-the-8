//
//  CircleProgressView.h
//  On the 8
//
//  Created by Justin Rhoades on 10/14/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "RingView.h"

@interface CircleProgressView : RingView

@property (nonatomic) CAShapeLayer *ring;
@property (nonatomic) float progress;
@property (nonatomic) BOOL isSpent;
@property (nonatomic) BOOL isShowing;

@property (nonatomic, strong) UIView *progressContainer;

@property (nonatomic) CAShapeLayer     *waitingRing;
@property (nonatomic) UIColor          *waitingColor1;
@property (nonatomic) UIColor          *waitingColor2;
@property (nonatomic) UIColor          *connectedColor1;
@property (nonatomic) UIColor          *connectedColor2;
@property (nonatomic) CAGradientLayer  *waitingGradient;
@property (nonatomic) CABasicAnimation *hideWaitingRing;
@property (nonatomic) CAAnimationGroup *waitingRingAnimation;
@property (nonatomic) CAAnimationGroup *connectedRingAnimation;
@property (nonatomic) BOOL isConnected;

@property (nonatomic) CAShapeLayer *backgroundRing;
@property (nonatomic) CAShapeLayer *backgroundPickerRing;

- (void) setProgress:(float)progress;
- (void) reset;
- (void) setWaitingForMIDI;
- (void) setMIDIConnected;
- (void) setMIDIConnectedNoAnimation;
- (void) setVisible:(BOOL)isVisible animated:(BOOL)animated;
- (void) centerRingScrolledDownPercent:(float)percent;


@end
