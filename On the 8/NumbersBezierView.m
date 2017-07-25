//
//  NumbersView.m
//  On the 8
//
//  Created by Justin Rhoades on 12/23/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "NumbersBezierView.h"
#import "StyleKit.h"

@implementation NumbersBezierView

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    /*
    if (_maskRing == nil) {
        _maskRing = [CAShapeLayer new];
        [self.layer addSublayer:_maskRing];
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.ringBounds, self.lineWidth/2, self.lineWidth/2)];
        _maskRing.path = path.CGPath;
        _maskRing.fillColor = StyleKit.red.CGColor;
        _maskRing.lineWidth = self.lineWidth;
    }
    _maskRing.frame = self.ringFrame;
    self.layer.mask = _maskRing;
    */
    
    float w = self.layer.bounds.size.width;
    float h = self.layer.bounds.size.height;
    _numberFrame = CGRectMake((w-self.baseSize)/2, (h-self.baseSize)/2, self.baseSize, self.baseSize);
    
    if (_numberA == nil) {
        _numberA = [CAShapeLayer new];
        [self.layer addSublayer:_numberA];
        //_numberA.path = numberFrameBezier.CGPath;
        //_numberA.path = [self getPathForNum:0].CGPath;
        _numberA.fillColor = StyleKit.gray1.CGColor;
    }
    //_numberA.frame = CGRectOffset(_numberFrame, 0, self.baseSize);
    _numberA.frame = _numberFrame;
    _numberA.opacity = 0;
    
    if (_numberB == nil) {
        _numberB = [CAShapeLayer new];
        [self.layer addSublayer:_numberB];
        //_numberB.path = numberFrameBezier.CGPath;
        //_numberB.path = [self getPathForNum:1].CGPath;
        _numberB.fillColor = StyleKit.gray1.CGColor;
    }
    //_numberB.frame = CGRectOffset(_numberFrame, 0, self.baseSize);
    _numberB.frame = _numberFrame;
    _numberB.opacity = 0;
    
    
    float centerY = self.center.y;
    float bottomY = centerY + self.baseSize;
    float topY = centerY - self.baseSize;

    _moveUpFromBottomAnimation = [CABasicAnimation animation];
    _moveUpFromBottomAnimation.keyPath = @"position.y";
    _moveUpFromBottomAnimation.fromValue=@(bottomY);
    _moveUpFromBottomAnimation.toValue=@(centerY);
    //_moveUpFromBottomAnimation.duration = .25;
    _moveUpFromBottomAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _moveUpFromBottomAnimation.removedOnCompletion = YES;

    _moveUpFromCenterAnimation = [CABasicAnimation animation];
    _moveUpFromCenterAnimation.keyPath = @"position.y";
    _moveUpFromCenterAnimation.fromValue=@(centerY);
    _moveUpFromCenterAnimation.toValue=@(topY);
    //_moveUpFromCenterAnimation.duration = .25f;
    _moveUpFromCenterAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _moveUpFromCenterAnimation.removedOnCompletion = YES;
    
    _scaleInAnimation = [CABasicAnimation animation];
    _scaleInAnimation.keyPath = @"transform.scale";
    _scaleInAnimation.fromValue = @.1f;
    _scaleInAnimation.toValue = @1;
    _scaleInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _scaleInAnimation.fillMode = kCAFillModeForwards;
    _scaleInAnimation.removedOnCompletion = NO;
    
    _scaleOutAnimation = [CABasicAnimation animation];
    _scaleOutAnimation.keyPath = @"transform.scale";
    _scaleOutAnimation.fromValue = @1.f;
    _scaleOutAnimation.toValue = @3.5;
    _scaleOutAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _scaleOutAnimation.fillMode = kCAFillModeForwards;
    _scaleOutAnimation.removedOnCompletion = NO;
    
    _scaleAwayAnimation = [CABasicAnimation animation];
    _scaleAwayAnimation.keyPath = @"transform.scale";
    _scaleAwayAnimation.fromValue = @1.f;
    _scaleAwayAnimation.toValue = @.1;
    _scaleAwayAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _scaleAwayAnimation.fillMode = kCAFillModeForwards;
    _scaleAwayAnimation.removedOnCompletion = NO;

    _fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //_fadeInAnimation.duration = .25f;
    _fadeInAnimation.removedOnCompletion = YES;
    _fadeInAnimation.fromValue=@(0);
    _fadeInAnimation.toValue=@(1);
    _fadeInAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _fadeInAnimation.fillMode = kCAFillModeForwards;
    _fadeInAnimation.removedOnCompletion = NO;

    _fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //_fadeOutAnimation.duration = .25f;
    _fadeOutAnimation.removedOnCompletion = YES;
    _fadeOutAnimation.fromValue=@(1);
    _fadeOutAnimation.toValue=@(0);
    _fadeOutAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _fadeOutAnimation.fillMode = kCAFillModeForwards;
    _fadeOutAnimation.removedOnCompletion = NO;
    
    _showAnimation = [CAAnimationGroup animation];
    _showAnimation.delegate = self;
    _showAnimation.removedOnCompletion = YES;
    //_showAnimation.duration = .25f;
    [_showAnimation setAnimations:[NSArray arrayWithObjects:_fadeInAnimation, _moveUpFromBottomAnimation, nil]];
    
    _hideAnimation = [CAAnimationGroup animation];
    _hideAnimation.delegate = self;
    _hideAnimation.removedOnCompletion = YES;
    //_hideAnimation.duration = .25f;
    [_hideAnimation setAnimations:[NSArray arrayWithObjects:_fadeOutAnimation, _moveUpFromCenterAnimation, nil]];

}


- (void) showNumber:(int)number withDuration:(float)duration {
    
    //_moveUpFromBottomAnimation.duration = duration;
    //_moveUpFromCenterAnimation.duration = duration;
    
    _scaleInAnimation.duration = duration;
    _scaleOutAnimation.duration = duration;
    _fadeInAnimation.duration = duration;
    _fadeOutAnimation.duration = duration;
    
    UIColor *fillColor = StyleKit.gray1;
    if (number == 8) {
        fillColor = StyleKit.yellow1;
    }
    
    //float centerY = self.center.y;
    //float bottomY = centerY + (self.baseSize/2);
    //float topY = centerY - (self.baseSize/2);
    
    /*
    if (number == 0) {
        NSLog(@"show 0");

        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        _numberB.path = [self getPathForNum:number].CGPath;
        _numberB.fillColor = fillColor.CGColor;
        //_numberB.position = CGPointMake(self.center.x, bottomY);
        [CATransaction commit];
        
        //[_numberB addAnimation:_showAnimation forKey:@"show"];
        //_numberB.position = CGPointMake(self.center.x, centerY);
        _numberB.opacity = 1;
        _activeNumber = _numberB;
        return;
    }
    */
    
    int oddOrEven = number%2;
    if (oddOrEven == 1) {
        
        NSLog(@"showA");
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        _numberA.path = [self getPathForNum:number].CGPath;
        _numberA.fillColor = fillColor.CGColor;
        //_numberA.position = CGPointMake(self.center.x, bottomY);
        //_numberB.position = CGPointMake(self.center.x, centerY);
        [CATransaction commit];
        
        //[_numberA addAnimation:_showAnimation forKey:@"show"];
        //_numberA.position = CGPointMake(self.center.x, centerY);
        //_numberA.opacity = 1;
        [_numberA addAnimation:_scaleInAnimation forKey:@"scaleIn"];
        [_numberA addAnimation:_fadeInAnimation forKey:@"fadeIn"];
        _activeNumber = _numberA;
        
        //[_numberB addAnimation:_hideAnimation forKey:@"hide"];
        //_numberB.position = CGPointMake(self.center.x, topY);
        //_numberB.opacity = 0;
        if (number != 1) {
            [_numberB addAnimation:_scaleOutAnimation forKey:@"scaleOut"];
            [_numberB addAnimation:_fadeOutAnimation forKey:@"fadeOut"];
        } else {
            [_numberB removeAllAnimations];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _numberB.opacity = 0;
            [CATransaction commit];
        }
        
    } else {
        
        NSLog(@"showB");
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        _numberB.path = [self getPathForNum:number].CGPath;
        _numberB.fillColor = fillColor.CGColor;
        //_numberB.position = CGPointMake(self.center.x, bottomY);
        //_numberA.position = CGPointMake(self.center.x, centerY);
        [CATransaction commit];
        
        //[_numberA addAnimation:_hideAnimation forKey:@"hide"];
        //_numberA.position = CGPointMake(self.center.x, topY);
        _numberA.opacity = 0;
        [_numberA addAnimation:_scaleOutAnimation forKey:@"scaleOut"];
        [_numberA addAnimation:_fadeOutAnimation forKey:@"fadeOut"];
        
        //[_numberB addAnimation:_showAnimation forKey:@"show"];
        //_numberB.position = CGPointMake(self.center.x, centerY);
        _numberB.opacity = 1;
        [_numberB addAnimation:_scaleInAnimation forKey:@"scaleIn"];
        [_numberB addAnimation:_fadeInAnimation forKey:@"fadeIn"];
        _activeNumber = _numberB;
    }

}

- (void) hideActiveNumber {
    if (_activeNumber) {
        [_activeNumber addAnimation:_scaleAwayAnimation forKey:@"scaleAway"];
        [_activeNumber addAnimation:_fadeOutAnimation forKey:@"fadeOut"];
    }
}

- (UIBezierPath *) getPathForNum:(int)number {
    UIBezierPath *path = UIBezierPath.bezierPath;
    CGRect frame = CGRectMake(0, 0, self.baseSize, self.baseSize);
    
    if (number == 0)
    {
        //// b0 Drawing
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50150 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.61550 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50062 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.58150 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.61550 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59013 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50150 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.61550 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.41113 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.58150 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50062 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.42150 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.38750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.41113 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50150 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.38750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59013 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.42150 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50150 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path closePath];
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39950 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50062 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50150 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33912 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39950 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.41863 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.42900 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33912 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.60350 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50062 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.57400 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33912 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.60350 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.41863 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50150 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66212 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.60350 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.58262 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.57400 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66212 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39950 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50062 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.42900 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66212 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39950 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.58262 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39950 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50062 * CGRectGetHeight(frame))];
        [path closePath];
        path.miterLimit = 4;
        path.usesEvenOddFillRule = YES;

    }
    if (number == 1)
    {
        //// b1 Drawing
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50762 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66312 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50762 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33413 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50162 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50762 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33063 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.50562 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49662 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32913 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.49813 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32863 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35313 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.41563 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35862 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.41712 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35412 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.41563 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35563 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42112 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36363 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.41563 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36162 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.41813 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36363 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42663 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36263 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.42313 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36363 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.42512 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36312 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49562 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34113 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49562 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66312 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50162 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66912 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.49562 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66663 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.49813 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66912 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50762 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66312 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50512 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66912 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.50762 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66663 * CGRectGetHeight(frame))];
        [path closePath];
        path.miterLimit = 4;
        path.usesEvenOddFillRule = YES;
    }
    if (number == 2)
    {
        //// b2 Drawing
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.58262 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67025 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.58813 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66475 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.58563 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67025 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.58813 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66775 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.58262 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65975 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.58813 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66225 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.58563 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65975 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40263 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65975 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40263 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65475 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49562 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.51675 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40263 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.58175 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.42213 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56425 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.58513 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.40825 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.55912 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47575 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.58513 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45225 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49112 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33125 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.58513 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36075 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.54912 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33125 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39863 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36275 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.45312 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33125 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.42213 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34425 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39563 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36825 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39663 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36425 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39563 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36625 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40113 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37325 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39563 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37125 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39813 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37325 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40563 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37175 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40313 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37325 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40412 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37275 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49013 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34175 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.42862 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35325 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.45763 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34175 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57312 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.40875 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.54363 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34175 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.57312 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36675 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48712 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50875 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.57312 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45425 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.53863 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47575 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65375 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.41513 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55475 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57725 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66425 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39613 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67025 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66725 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39263 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67025 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.58262 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67025 * CGRectGetHeight(frame))];
        [path closePath];
        path.miterLimit = 4;
        path.usesEvenOddFillRule = YES;
    }
    if (number == 3)
    {
        //// b3 Drawing
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.58875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.54625 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.58875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63213 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.51075 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.58875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52663 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.55275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49562 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.40713 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.55375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47413 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.57475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44112 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.57475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36113 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.53975 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40775 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35062 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.45625 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.43025 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33513 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35612 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40575 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35213 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35362 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.41025 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36113 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35862 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36113 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.41475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35962 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.41225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36113 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.41325 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36063 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33912 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.43625 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34513 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.45925 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33912 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.56275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.40763 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.53275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33912 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.56275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36713 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48075 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48312 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.56275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44912 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.52975 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48312 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.44825 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48312 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.44225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.44525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48312 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.44225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48463 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.44825 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49363 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.44225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49162 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.44525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49363 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48175 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49363 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.53775 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49363 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.57675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52763 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66212 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.57675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62912 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.53675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66212 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62662 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.44375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66212 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.41475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.64813 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62362 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39075 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62512 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.38925 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62362 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62912 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.38375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62362 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.38125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62562 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38425 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63462 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.38125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63113 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.38225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63262 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40725 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65613 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.43875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path closePath];
        path.miterLimit = 4;
        path.usesEvenOddFillRule = YES;
    }
    if (number == 4)
    {
        //// b4 Drawing
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.61238 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56463 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.61738 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55963 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.61538 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56463 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.61738 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56262 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.61238 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55462 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.61738 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55663 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.61538 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55462 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.55688 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55462 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.55688 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33413 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.55137 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.55688 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33063 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.55488 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54538 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33163 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.54888 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.54737 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32913 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37388 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55512 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37188 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56012 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.37238 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55712 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.37188 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55862 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37738 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56463 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.37188 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56262 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.37388 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56463 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54538 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56463 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54538 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66312 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.55137 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66912 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.54538 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66663 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.54788 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66912 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.55688 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66312 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.55488 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66912 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.55688 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66663 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.55688 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56463 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.61238 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56463 * CGRectGetHeight(frame))];
        [path closePath];
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54538 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35013 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54538 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55462 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38838 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55462 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54538 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35013 * CGRectGetHeight(frame))];
        [path closePath];
        path.miterLimit = 4;
        path.usesEvenOddFillRule = YES;
    }
    if (number == 5)
    {
        //// b5 Drawing
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67075 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59025 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56325 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.55475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67075 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59025 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61825 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48925 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46175 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.59025 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50275 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.55025 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46175 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40625 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49425 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.45675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46175 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.42675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47425 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34175 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.56425 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34175 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.56975 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33675 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.56725 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34175 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.56975 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33925 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.56425 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33125 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.56975 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33375 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.56725 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33125 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.41825 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33125 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.41225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33675 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.41475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33125 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.41225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33325 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50025 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40025 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50725 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50325 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39575 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50725 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50325 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40425 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50725 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40625 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50525 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48975 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47225 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.43325 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48375 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.45675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47225 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57825 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56325 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.54175 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47225 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.57825 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50725 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66025 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.57825 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61475 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.54525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66025 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39175 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62075 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.44775 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66025 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.41525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.64625 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61825 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39075 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61975 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.38925 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61825 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62325 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.38325 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61825 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.38125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62075 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38325 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62775 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.38125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62475 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.38225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62675 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67075 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40425 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65175 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.44025 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67075 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67075 * CGRectGetHeight(frame))];
        [path closePath];
        path.miterLimit = 4;
    }
    if (number == 6)
    {
        //// b6 Drawing
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48925 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59175 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57162 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.55175 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59175 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62613 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47112 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.59175 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.51362 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.55075 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47112 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53513 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.44825 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47112 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49462 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.52925 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44812 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.45425 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.38012 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.53375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33263 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.53225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33663 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.53375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33513 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.52875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.53375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33012 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.53175 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.52275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32963 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.52675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.52525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32863 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55912 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.43875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37212 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.38125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46662 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48925 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.38125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62862 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.42025 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48925 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path closePath];
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48163 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57975 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57212 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.54675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48163 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.57975 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52012 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48925 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66263 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.57975 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62213 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.54225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66263 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56963 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.43125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66263 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62662 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48163 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.51513 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.44425 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48163 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48163 * CGRectGetHeight(frame))];
        [path closePath];
        path.miterLimit = 4;
        path.usesEvenOddFillRule = YES;
    }
    if (number == 7)
    {
        //// b7 Drawing
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59625 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34075 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59775 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33625 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.59725 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33925 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59775 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33825 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59175 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33125 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.59775 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33325 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33125 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39925 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33125 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33675 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39625 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33125 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33325 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39925 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34175 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33925 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39625 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34175 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.58275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34175 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.47075 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66025 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.51475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.43675 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.47125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53025 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.47075 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66225 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.47675 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66825 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.47075 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66575 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.47325 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66825 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66225 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.48075 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66825 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.48275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66525 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66125 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59625 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34075 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.48275 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52725 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.52825 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.43575 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59625 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34075 * CGRectGetHeight(frame))];
        [path closePath];
        path.miterLimit = 4;
        path.usesEvenOddFillRule = YES;
    }
    if (number == 8)
    {
        //// b8 Drawing
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.60963 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.56463 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.60963 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63062 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.53212 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48662 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.60963 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53063 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.57612 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49813 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59113 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.40963 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.56863 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47162 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59113 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44412 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.59113 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36063 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.55113 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40912 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.40963 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.44912 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32812 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40912 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36063 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.46813 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48662 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40912 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44412 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.43163 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47162 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.42412 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49813 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53063 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63062 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.43563 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67312 * CGRectGetHeight(frame))];
        [path closePath];
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66263 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40263 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.44612 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66263 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40263 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62862 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49212 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40263 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52412 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.44912 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49212 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59763 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.55113 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49212 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59763 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52412 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66263 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.59763 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62862 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.55412 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66263 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66263 * CGRectGetHeight(frame))];
        [path closePath];
        [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.40963 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33812 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.42062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36962 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.45163 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33812 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57962 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.40963 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.54863 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33812 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.57962 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36962 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48163 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.57962 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44962 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.54363 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48163 * CGRectGetHeight(frame))];
        [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.40963 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.45663 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48163 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.42062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44962 * CGRectGetHeight(frame))];
        [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42062 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.40963 * CGRectGetHeight(frame))];
        [path closePath];
        path.miterLimit = 4;
        path.usesEvenOddFillRule = YES;
    }


    return path;
}

@end
