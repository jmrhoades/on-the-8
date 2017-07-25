//
//  MIDIStatusView.h
//  On the 8
//
//  Created by Justin Rhoades on 10/28/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingView.h"

@import AVFoundation;


@protocol MIDIStatusViewDelegate < NSObject >

- (void) midiConnectedAnimationComplete;

@end

@interface MIDIStatusView : RingView

@property (nonatomic) CAShapeLayer     *waitingRing;
@property (nonatomic) CAGradientLayer  *waitingGradient;
@property (nonatomic) CABasicAnimation *hideWaitingRing;
@property (nonatomic) CGRect           connectorFrame;

@property (nonatomic) UIColor *waitingColor1;
@property (nonatomic) UIColor *waitingColor2;
@property (nonatomic) UIColor *connectedColor1;
@property (nonatomic) UIColor *connectedColor2;

@property (nonatomic) UIImageView      *midiConnectorBg;
@property (nonatomic) UIImageView      *midiConnector;
@property (nonatomic) CABasicAnimation *hideMIDIConnector;
@property (nonatomic) CABasicAnimation *showMIDIConnector;


@property (nonatomic) CABasicAnimation *blinkAnimation;
@property (nonatomic) CAAnimationGroup *waitingRingAnimation;
@property (nonatomic) CAAnimationGroup *connectedRingAnimation;

@property (nonatomic) CAShapeLayer     *connectedCheckmark;
@property (nonatomic) CGRect           checkmarkFrame;
@property (nonatomic) CAAnimationGroup *checkmarkAnimation;

@property (nonatomic) BOOL isConnected;

@property (assign) SystemSoundID searchingSound;
@property (assign) SystemSoundID connectedSound;

@property (nonatomic, assign) id<MIDIStatusViewDelegate> delegate;


- (void) setWaitingForMIDI;
- (void) setMIDIConnected;
- (void) setMIDIConnectedNoAnimation;

@end
