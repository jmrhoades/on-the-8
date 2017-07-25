//
//  MIDIStatusView.m
//  On the 8
//
//  Created by Justin Rhoades on 10/28/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "StyleKit.h"
#import "RingView.h"
#import "MIDIStatusView.h"

@import AVFoundation;

@implementation MIDIStatusView

- (void)awakeFromNib {

    _isConnected = YES;
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //[self addGestureRecognizer:tap];
    //self.userInteractionEnabled = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"searching03" ofType:@"caf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_searchingSound);
    
    path = [[NSBundle mainBundle] pathForResource:@"connected02" ofType:@"caf"];
    url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_connectedSound);
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [self setWaitingForMIDI];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setMIDIConnected];
    });
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // iPhone 4s & 5
    _connectorFrame = CGRectMake(0, 0, 88, 88);
    _checkmarkFrame = CGRectMake(0, 0, 128, 128);
    
    // iPhone 6
    if (self.baseSize > 350) {
        _connectorFrame = CGRectMake(0, 0, 104, 104);
        _checkmarkFrame = CGRectMake(0, 0, 144, 144);
    }
    
    // iPhone 6+
    if (self.baseSize > 400) {
        _connectorFrame = CGRectMake(0, 0, 128, 128);
        _checkmarkFrame = CGRectMake(0, 0, 160, 160);
    }
    
    // iPad
    if (self.baseSize > 700) {
        _connectorFrame = CGRectMake(0, 0, 224, 224);
        _checkmarkFrame = CGRectMake(0, 0, 256, 256);
    }
    
    /*
     Waiting ring
     */
    if (_waitingRing == nil) {
        _waitingRing = [CAShapeLayer new];
        [self.layer addSublayer:_waitingRing];
        _waitingRing.fillColor = nil;
        _waitingRing.lineWidth = self.lineWidth;
        _waitingRing.transform = CATransform3DRotate(_waitingRing.transform, -M_PI/2, 0, 0, 1);
        _waitingRing.strokeColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
        _waitingRing.lineCap = kCALineCapRound;
        _waitingRing.strokeEnd = 0;
        
        CABasicAnimation *fadeIn=[CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeIn.duration = .2;
        fadeIn.beginTime = 0;
        fadeIn.removedOnCompletion = NO;
        fadeIn.fromValue=@(0);
        fadeIn.toValue=@(1);
        fadeIn.fillMode = kCAFillModeForwards;
        fadeIn.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        CABasicAnimation *drawOnAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        drawOnAnimation.duration = 1.5;
        drawOnAnimation.beginTime = 0;
        drawOnAnimation.removedOnCompletion = NO;
        drawOnAnimation.fromValue=@(0);
        drawOnAnimation.toValue=@(1);
        drawOnAnimation.fillMode = kCAFillModeForwards;
        drawOnAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *drawOffAnimation=[CABasicAnimation animationWithKeyPath:@"strokeStart"];
        drawOffAnimation.duration = 1.5;
        drawOffAnimation.beginTime = .5;
        drawOffAnimation.removedOnCompletion = NO;
        drawOffAnimation.fromValue=@(0);
        drawOffAnimation.toValue=@(1);
        drawOffAnimation.fillMode = kCAFillModeForwards;
        drawOffAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat: M_PI * -.5];
        rotationAnimation.toValue = [NSNumber numberWithFloat: ((M_PI * 2.0) + M_PI * -.5)];
        rotationAnimation.duration = 2;
        rotationAnimation.cumulative = YES;
        rotationAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *fadeOut=[CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeOut.duration = .2;
        fadeOut.beginTime = 1.8;
        fadeOut.removedOnCompletion = NO;
        fadeOut.fromValue=@(1);
        fadeOut.toValue=@(0);
        fadeOut.fillMode = kCAFillModeForwards;
        fadeOut.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        _waitingRingAnimation = [CAAnimationGroup animation];
        //waitingRingAnimation.repeatCount = HUGE_VALF;
        //_waitingRingAnimation.fillMode = kCAFillModeForwards;
        _waitingRingAnimation.delegate = self;
        _waitingRingAnimation.removedOnCompletion = NO;
        _waitingRingAnimation.duration = 2.0;
        [_waitingRingAnimation setAnimations:[NSArray arrayWithObjects:fadeIn, drawOnAnimation, drawOffAnimation, rotationAnimation, fadeOut, nil]];
        
        CABasicAnimation *fadeIn2=[CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeIn2.duration = .1;
        fadeIn2.beginTime = 0;
        fadeIn2.removedOnCompletion = NO;
        fadeIn2.fromValue=@(0);
        fadeIn2.toValue=@(1);
        fadeIn2.fillMode = kCAFillModeForwards;
        fadeIn2.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        CABasicAnimation *drawOnAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        drawOnAnimation2.duration = .6;
        drawOnAnimation2.beginTime = 0;
        drawOnAnimation2.removedOnCompletion = NO;
        drawOnAnimation2.fromValue=@(0);
        drawOnAnimation2.toValue=@(1);
        drawOnAnimation2.fillMode = kCAFillModeForwards;
        drawOnAnimation2.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *drawOffAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        drawOffAnimation2.duration = .6;
        drawOffAnimation2.beginTime = 1.4;
        drawOffAnimation2.removedOnCompletion = NO;
        drawOffAnimation2.fromValue=@(0);
        drawOffAnimation2.toValue=@(1);
        drawOffAnimation2.fillMode = kCAFillModeForwards;
        drawOffAnimation2.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *fadeOut2=[CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeOut2.duration = .3;
        fadeOut2.beginTime = 1.7;
        fadeOut2.removedOnCompletion = NO;
        fadeOut2.fromValue=@(1);
        fadeOut2.toValue=@(0);
        fadeOut2.fillMode = kCAFillModeForwards;
        fadeOut2.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        _connectedRingAnimation = [CAAnimationGroup animation];
        _connectedRingAnimation.delegate = self;
        _connectedRingAnimation.removedOnCompletion = NO;
        _connectedRingAnimation.duration = 2;
        _connectedRingAnimation.fillMode = kCAFillModeForwards;
        [_connectedRingAnimation setAnimations:[NSArray arrayWithObjects:fadeIn2, drawOnAnimation2, drawOffAnimation2, fadeOut2, nil]];
        
        _hideWaitingRing = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _hideWaitingRing.duration = .5;
        _hideWaitingRing.beginTime = 0;
        _hideWaitingRing.removedOnCompletion = NO;
        _hideWaitingRing.fromValue=@(1);
        _hideWaitingRing.toValue=@(0);
        _hideWaitingRing.fillMode = kCAFillModeForwards;
        _hideWaitingRing.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, self.lineWidth/2, self.lineWidth/2)];
    _waitingRing.path = path.CGPath;
    _waitingRing.frame = self.bounds;
    
    /*
     Waiting gradient
     */
    if (_waitingGradient == nil) {
        _waitingGradient = [CAGradientLayer layer];
        [self.layer addSublayer:_waitingGradient];
        _waitingColor1 = [UIColor colorWithRed:(255/255.0) green:(38/255.0) blue:(100/255.0) alpha:1.0];
        _waitingColor2 = [UIColor colorWithRed:(255/255.0)  green:(94/255.0)  blue:(0/255.0)  alpha:1.0];
        _connectedColor1 = [UIColor colorWithRed:(11/255.0) green:(211/255.0) blue:(24/255.0) alpha:1.0];
        _connectedColor2 = [UIColor colorWithRed:(135/255.0)  green:(252/255.0)  blue:(112/255.0)  alpha:1.0];
        _waitingGradient.colors = @[(id)_waitingColor1.CGColor, (id)_waitingColor2.CGColor];
        _waitingGradient.locations = @[@0.0, @1.0f];
        _waitingGradient.mask = _waitingRing;
    }
    _waitingGradient.frame = self.bounds;
    _waitingGradient.opacity = 0;
    
    /*
     Status label
    if (_statusLabel == nil) {
        _statusLabel = [UILabel new];
        [self addSubview:_statusLabel];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.text = @"NO MIDI";
    }
    _statusLabel.frame = self.layer.bounds;
    _statusLabel.font = [UIFont fontWithName:@"BryantPro-Regular" size:_labelFontSize];
     */
    
    if (_midiConnectorBg == nil) {
        _midiConnectorBg = [UIImageView new];
        [self addSubview:_midiConnectorBg];
        _midiConnectorBg.image = [StyleKit imageOfMConnectorWithFrame:_connectorFrame color:StyleKit.gray1];
        [_midiConnectorBg sizeToFit];
        _midiConnectorBg.layer.opacity = 0;
        
        _hideMIDIConnector = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _hideMIDIConnector.duration = .5;
        _hideMIDIConnector.beginTime = 0;
        _hideMIDIConnector.removedOnCompletion = NO;
        _hideMIDIConnector.fromValue=@(1);
        _hideMIDIConnector.toValue=@(0);
        _hideMIDIConnector.fillMode = kCAFillModeForwards;
        _hideMIDIConnector.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _hideMIDIConnector.delegate = self;
        
        _showMIDIConnector = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _showMIDIConnector.duration = 1;
        _showMIDIConnector.beginTime = 0;
        _showMIDIConnector.removedOnCompletion = NO;
        _showMIDIConnector.fromValue=@(0);
        _showMIDIConnector.toValue=@(1);
        _showMIDIConnector.fillMode = kCAFillModeForwards;
        _showMIDIConnector.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    _midiConnectorBg.center = self.center;
    
    
    if (_midiConnector == nil) {
        _midiConnector = [UIImageView new];
        [self addSubview:_midiConnector];
        _midiConnector.image = [StyleKit imageOfMIDIConnectorWithFrame:_connectorFrame];
        [_midiConnector sizeToFit];
        _midiConnector.layer.opacity = 0;
        
        _blinkAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
        _blinkAnimation.duration = 1;
        _blinkAnimation.beginTime = 0;
        _blinkAnimation.removedOnCompletion=NO;
        _blinkAnimation.fromValue=@(0);
        _blinkAnimation.toValue=@(1);
        //blinkAnimation.repeatCount = HUGE_VALF;
        _blinkAnimation.autoreverses = YES;
        _blinkAnimation.delegate = self;
        _blinkAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        /*
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        animation.values = @[@0, @0, @1, @1, @0];
        animation.keyTimes = @[@0, @(2.1/4), @(2.3/4), @(3.3/4), @(3.6/4)];
        animation.duration = 4;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = HUGE_VALF;
        [_midiConnector.layer addAnimation:animation forKey:@"blinkLabel"];
        */
    }
    _midiConnector.center = self.center;
    
    /*
     Checkmark
     */
    if (_connectedCheckmark == nil) {
        _connectedCheckmark = [CAShapeLayer new];
        [self.layer addSublayer:_connectedCheckmark];
        
        CGRect frame = _checkmarkFrame;
        UIBezierPath* checkmarkBezierPath = UIBezierPath.bezierPath;
        [checkmarkBezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.08203 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59766 * CGRectGetHeight(frame))];
        [checkmarkBezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33984 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.85547 * CGRectGetHeight(frame))];
        [checkmarkBezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.92578 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.13672 * CGRectGetHeight(frame))];
        checkmarkBezierPath.miterLimit = 4;
        checkmarkBezierPath.lineCapStyle = kCGLineCapRound;
        checkmarkBezierPath.lineJoinStyle = kCGLineJoinRound;
        checkmarkBezierPath.usesEvenOddFillRule = YES;
        
        _connectedCheckmark.path = checkmarkBezierPath.CGPath;
        _connectedCheckmark.fillColor = nil;
        _connectedCheckmark.lineWidth = self.lineWidth;
        _connectedCheckmark.strokeColor = _connectedColor1.CGColor;
        _connectedCheckmark.lineCap = kCALineCapRound;
        _connectedCheckmark.lineJoin =kCALineJoinRound;
        _connectedCheckmark.strokeEnd = 0;
        
        CABasicAnimation *fadeIn=[CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeIn.duration = .2;
        fadeIn.beginTime = 0;
        fadeIn.removedOnCompletion = NO;
        fadeIn.fromValue=@(0);
        fadeIn.toValue=@(1);
        fadeIn.fillMode = kCAFillModeForwards;
        fadeIn.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        CABasicAnimation *drawOnAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        drawOnAnimation.duration = .5;
        drawOnAnimation.beginTime = .25;
        drawOnAnimation.removedOnCompletion = NO;
        drawOnAnimation.fromValue=@(0);
        drawOnAnimation.toValue=@(1);
        drawOnAnimation.fillMode = kCAFillModeForwards;
        drawOnAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *drawOffAnimation=[CABasicAnimation animationWithKeyPath:@"strokeStart"];
        drawOffAnimation.duration = .5;
        drawOffAnimation.beginTime = 1.25;
        drawOffAnimation.removedOnCompletion = NO;
        drawOffAnimation.fromValue=@(0);
        drawOffAnimation.toValue=@(1);
        drawOffAnimation.fillMode = kCAFillModeForwards;
        drawOffAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *fadeOut=[CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeOut.duration = .2;
        fadeOut.beginTime = 1.8;
        fadeOut.removedOnCompletion = NO;
        fadeOut.fromValue=@(1);
        fadeOut.toValue=@(0);
        fadeOut.fillMode = kCAFillModeForwards;
        fadeOut.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        _checkmarkAnimation = [CAAnimationGroup animation];
        _checkmarkAnimation.delegate = self;
        _checkmarkAnimation.removedOnCompletion = NO;
        _checkmarkAnimation.duration = 2.0;
        _checkmarkAnimation.fillMode = kCAFillModeForwards;
        [_checkmarkAnimation setAnimations:[NSArray arrayWithObjects:fadeIn, drawOnAnimation, drawOffAnimation, fadeOut, nil]];
    
    }
    _connectedCheckmark.frame = CGRectOffset(_checkmarkFrame, (CGRectGetWidth(self.frame)-CGRectGetWidth(_checkmarkFrame))/2, (CGRectGetHeight(self.frame)-CGRectGetHeight(_checkmarkFrame))/2);
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    //NSLog(@"animationDidStop");
    
    if (theAnimation == [_waitingRing animationForKey:@"waitingRingAnimation"]) {
        if (_isConnected) {
            [self startConnectedAnimation];
        } else {
            [self performSelector:@selector(animateWaitingRing) withObject:nil afterDelay:.3];
        }
    }
    
    if (theAnimation == [_waitingRing animationForKey:@"connectedRingAnimation"]) {
        //[_waitingRing addAnimation:_hideWaitingRing forKey:@"hideWaitingRing"];
    }
    
    if (theAnimation == [_connectedCheckmark animationForKey:@"checkmarkAnimation"]) {
        [_midiConnectorBg.layer addAnimation:_hideMIDIConnector forKey:@"hideMIDIConnector"];
    }
    
    if (theAnimation == [_midiConnectorBg.layer animationForKey:@"hideMIDIConnector"]) {
        if (self.delegate != nil) {
            [self.delegate midiConnectedAnimationComplete];
        }
    }

}

- (void)animationDidStart:(CAAnimation *)theAnimation {
    //NSLog(@"animationDidStart");
}

- (void)animateWaitingRing {
    [_waitingRing removeAnimationForKey:@"waitingRingAnimation"];
    [_waitingRing removeAnimationForKey:@"connectedRingAnimation"];
    [_midiConnector.layer removeAnimationForKey:@"blinkAnimation"];

    _waitingGradient.colors = @[(id)_waitingColor1.CGColor, (id)_waitingColor2.CGColor];
    [_waitingRing addAnimation:_waitingRingAnimation forKey:@"waitingRingAnimation"];
    [_midiConnector.layer addAnimation:_blinkAnimation forKey:@"blinkAnimation"];
    
    //AudioServicesPlaySystemSound(_searchingSound);
}

- (void) startConnectedAnimation {
    _waitingGradient.colors = @[(id)_connectedColor1.CGColor, (id)_connectedColor2.CGColor];
    [_waitingRing addAnimation:_connectedRingAnimation forKey:@"connectedRingAnimation"];
    [_connectedCheckmark addAnimation:_checkmarkAnimation forKey:@"checkmarkAnimation"];
    AudioServicesPlaySystemSound(_connectedSound);
}

- (void) setMIDIConnected {
    _isConnected = YES;
    
    //[_waitingRing removeAllAnimations];
    //[self startConnectedAnimation];
}

- (void) setMIDIConnectedNoAnimation {
    NSLog(@"MIDIStatusView setMIDIConnectedNoAnimation");
    _isConnected = YES;
    [_waitingRing removeAllAnimations];
}

- (void) setWaitingForMIDI {
    if (_isConnected == NO) return;
    [_midiConnectorBg.layer addAnimation:_showMIDIConnector forKey:@"showMIDIConnector"];
    [self animateWaitingRing];
    _isConnected = NO;
}

- (void) resetView {
    [_waitingRing removeAllAnimations];
    [_midiConnector.layer removeAllAnimations];
    [_midiConnectorBg.layer removeAllAnimations];
    [_connectedCheckmark removeAllAnimations];
}


@end
