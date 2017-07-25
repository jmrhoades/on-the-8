//
//  CircleProgressView.m
//  On the 8
//
//  Created by Justin Rhoades on 10/14/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "CircleProgressView.h"
#import "RingView.h"
#import "StyleKit.h"


@implementation CircleProgressView

-(void) awakeFromNib {
    _isSpent = NO;
    _isConnected = YES;
    [self setProgress:0];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    /*
    if (_backgroundRing == nil) {
        _backgroundRing = [CAShapeLayer new];
        [self.layer addSublayer:_backgroundRing];
        _backgroundRing.fillColor = nil;
        _backgroundRing.lineWidth = self.lineWidth;
        _backgroundRing.strokeColor = StyleKit.gray1.CGColor;
        _backgroundRing.lineCap = kCALineCapRound;
    }
    self.ringBounds = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.ringBounds, self.lineWidth/2, self.lineWidth/2)];
    _backgroundRing.path = path.CGPath;
    _backgroundRing.frame = self.bounds;
    
    if (_backgroundPickerRing == nil) {
        _backgroundPickerRing = [CAShapeLayer new];
        [self.layer addSublayer:_backgroundPickerRing];
        _backgroundPickerRing.fillColor = nil;
        _backgroundPickerRing.lineWidth = self.lineWidth;
        _backgroundPickerRing.strokeColor = StyleKit.yellow1.CGColor;
    }
    _backgroundPickerRing.path = _backgroundRing.path;
    _backgroundPickerRing.frame = self.bounds;
    _backgroundPickerRing.opacity = 0;
    */

    if (_progressContainer == nil) {
        _progressContainer = [UIView new];
        [self addSubview:_progressContainer];
    }
    _progressContainer.frame = self.bounds;

    if (_ring == nil) {
        _ring = [CAShapeLayer new];
        [_progressContainer.layer addSublayer:_ring];
        _ring.fillColor = nil;
        _ring.lineWidth = self.lineWidth+1;
        _ring.transform = CATransform3DRotate(_ring.transform, -M_PI/2, 0, 0, 1);
        _ring.strokeColor = StyleKit.yellow1.CGColor;
        _ring.lineCap = kCALineCapRound;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, self.lineWidth/2, self.lineWidth/2)];
    _ring.path = path.CGPath;
    _ring.frame = self.bounds;
    _ring.strokeEnd = _progress;
    
    /*
     Waiting ring
     */
    if (_waitingRing == nil) {
        _waitingRing = [CAShapeLayer new];
        [_progressContainer.layer addSublayer:_waitingRing];
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
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, self.lineWidth/2, self.lineWidth/2)];
    _waitingRing.path = path.CGPath;
    _waitingRing.frame = self.bounds;
    
    /*
     Waiting gradient
     */
    if (_waitingGradient == nil) {
        _waitingGradient = [CAGradientLayer layer];
        [_progressContainer.layer addSublayer:_waitingGradient];
        _waitingColor1 = [UIColor colorWithRed:(255/255.0) green:(38/255.0) blue:(100/255.0) alpha:1.0];
        _waitingColor2 = [UIColor colorWithRed:(255/255.0)  green:(94/255.0)  blue:(0/255.0)  alpha:1.0];
        _connectedColor1 = [UIColor colorWithRed:(11/255.0) green:(211/255.0) blue:(24/255.0) alpha:1.0];
        _connectedColor2 = [UIColor colorWithRed:(135/255.0)  green:(252/255.0)  blue:(112/255.0)  alpha:1.0];
        _waitingGradient.colors = @[(id)_waitingColor1.CGColor, (id)_waitingColor2.CGColor];
        _waitingGradient.locations = @[@0.0, @1.0f];
        _waitingGradient.mask = _waitingRing;
    }
    _waitingGradient.frame = self.bounds;
    
}

- (void)setProgress:(float)progress {
    
    if (_progress == progress) {
        return;
    }
    
    if (_isSpent && progress < .3) {
        return;
    }
    
    _progress = progress;
    
    //if (_ring.strokeEnd > _progress) {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        _ring.strokeEnd = _progress;    
        [CATransaction commit];
    //} else {
        _ring.strokeEnd = _progress;
    //}
    
    if(_progress >= .98f) {
        _isSpent = YES;
    }
}

- (void)reset {
    _progress = 0;
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    _ring.strokeEnd = _progress;
    [CATransaction commit];
    
    //[_waitingRing removeAnimationForKey:@"waitingRingAnimation"];
    //[_waitingRing removeAnimationForKey:@"connectedRingAnimation"];
    //_waitingRing.opacity = 0;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    //NSLog(@"animationDidStop");
    
    if (theAnimation == [_waitingRing animationForKey:@"waitingRingAnimation"]) {
        if (_isConnected) {
            _waitingGradient.colors = @[(id)_connectedColor1.CGColor, (id)_connectedColor2.CGColor];
            [_waitingRing addAnimation:_connectedRingAnimation forKey:@"connectedRingAnimation"];
        } else {
            [self performSelector:@selector(animateWaitingRing) withObject:nil afterDelay:.3];
        }
    }
    
    if (theAnimation == [_waitingRing animationForKey:@"connectedRingAnimation"]) {
        
    }
}

- (void)animationDidStart:(CAAnimation *)theAnimation {
    //NSLog(@"animationDidStart");
}

- (void)animateWaitingRing {
    [_waitingRing removeAnimationForKey:@"waitingRingAnimation"];
    [_waitingRing removeAnimationForKey:@"connectedRingAnimation"];
    
    _waitingGradient.colors = @[(id)_waitingColor1.CGColor, (id)_waitingColor2.CGColor];
    [_waitingRing addAnimation:_waitingRingAnimation forKey:@"waitingRingAnimation"];
}

- (void) setMIDIConnected {
    NSLog(@"CircleProgressView setMIDIConnected");
    _isConnected = YES;
}

- (void) setMIDIConnectedNoAnimation {
    NSLog(@"CircleProgressView setMIDIConnectedNoAnimation");
    _isConnected = YES;
    [_waitingRing removeAllAnimations];
}

- (void) setWaitingForMIDI {
    [self reset];
    if (_isConnected == NO) return;
    [self animateWaitingRing];
    _isConnected = NO;
}

- (void) centerRingScrolledDownPercent:(float)percent {
    _progressContainer.alpha = 1 - percent;
    //_backgroundPickerRing.opacity = percent;
    //_backgroundRing.opacity = 1 - percent;
}

- (void) setVisible:(BOOL)isVisible animated:(BOOL)animated {
    _isShowing = isVisible;
    CGFloat opacity = isVisible ? 1.0 : 0.0;
    if (animated) {
        [UIView animateWithDuration:0.33 animations:^{
            self.alpha = opacity;
        }];
    } else {
        self.alpha = opacity;
    }
    //[_waitingRing removeAnimationForKey:@"waitingRingAnimation"];
    //[_waitingRing removeAnimationForKey:@"connectedRingAnimation"];
}

@end