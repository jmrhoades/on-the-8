//
//  NumbersLabelView.m
//  On the 8
//
//  Created by Justin Rhoades on 1/13/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "NumbersLabelView.h"
#import "StyleKit.h"
#import "CountdownViewController.h"

@interface NumbersLabelView ()

@property (nonatomic, strong) UILabel *numberA;
@property (nonatomic, strong) UILabel *numberB;

@property (nonatomic) UIFont          *labelFont;
@property (nonatomic) float           labelFontSize;

@property (nonatomic) CABasicAnimation *fadeInAnimation;
@property (nonatomic) CABasicAnimation *fadeOutAnimation;

@property (nonatomic) CABasicAnimation *scaleInAnimation;
@property (nonatomic) CABasicAnimation *scaleOutAnimation;
@property (nonatomic) CABasicAnimation *scaleAwayAnimation;

@end

@implementation NumbersLabelView

-(void) awakeFromNib {
    
    _barCountUnit = 8;
    
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
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //NSLog(@"Numbers Label baseSize: %f", self.baseSize);
    
    BOOL isLandscape = NO;
    if (self.layer.bounds.size.width > self.layer.bounds.size.height) {
        isLandscape = YES;
    }
    
    // iPhone 4 & 5
    _labelFontSize = (isLandscape) ? 140.0 : 150.0;
    float offsetY = 10.0;
   
    // iPhone 6
    if (self.baseSize > 370) {
        _labelFontSize = (isLandscape) ? 180.0 : 200.0;
        offsetY = (isLandscape) ? 15.0 : 17.0;
    }
    
    // iPhone 6+
    if (self.baseSize > 400) {
        _labelFontSize = (isLandscape) ? 200.0 : 220.0;
        offsetY = (isLandscape) ? 17.0 : 19.0;
    }
    
    // iPad
    if (self.baseSize > 760) {
        _labelFontSize = (isLandscape) ? 410.0 : 410.0;
        offsetY = (isLandscape) ? 32.0 : 36.0;
    }
    
    _labelFontSize = self.baseSize * 0.625;
    
    _labelFont = [CountdownViewController getCenterNumberFont];
    offsetY = [CountdownViewController getCenterNumberOffsetY];
    CGRect labelFrame = CGRectOffset(self.bounds, 0, offsetY);
    
    if (_numberA == nil) {
        _numberA = [UILabel new];
        _numberA.textAlignment = NSTextAlignmentCenter;
        _numberA.textColor = StyleKit.gray1;
        [self addSubview:_numberA];
    }
    _numberA.font = _labelFont;
    _numberA.frame = labelFrame;

    if (_numberB == nil) {
        _numberB = [UILabel new];
        _numberB.textAlignment = NSTextAlignmentCenter;
        _numberB.textColor = StyleKit.gray1;
        [self addSubview:_numberB];
    }
    _numberB.font = _labelFont;
    _numberB.frame = labelFrame;
}

- (void) showNumber:(int)number withDuration:(float)duration {
    //NSLog(@"Number showNumber: %i", number);

    _scaleInAnimation.duration = duration;
    _scaleOutAnimation.duration = duration;
    _fadeInAnimation.duration = duration;
    _fadeOutAnimation.duration = duration;
    
    UIColor *fillColor = StyleKit.yellow1;
    if (number == _barCountUnit) {
        fillColor = StyleKit.yellow1;
    }
    if (number == 0) {
        fillColor = StyleKit.gray1;
    }
    
    int oddOrEven = number%2;
    if (oddOrEven == 1) {
        //NSLog(@"showA");

        _numberA.text = [NSString stringWithFormat:@"%i", number];
        _numberA.textColor = fillColor;
        [_numberA.layer addAnimation:_scaleInAnimation forKey:@"scaleIn"];
        [_numberA.layer addAnimation:_fadeInAnimation forKey:@"fadeIn"];

        if (number != 1) {
            [_numberB.layer addAnimation:_scaleOutAnimation forKey:@"scaleOut"];
            [_numberB.layer addAnimation:_fadeOutAnimation forKey:@"fadeOut"];
        } else {
            [_numberB.layer removeAllAnimations];
            _numberB.layer.opacity = 0;
        }
        
        _activeNumber = _numberA;
    } else {
        //NSLog(@"showB");

        _numberB.text = [NSString stringWithFormat:@"%i", number];
        _numberB.textColor = fillColor;
        _numberB.layer.opacity = 1;
        [_numberB.layer addAnimation:_scaleInAnimation forKey:@"scaleIn"];
        [_numberB.layer addAnimation:_fadeInAnimation forKey:@"fadeIn"];
        
        _numberA.layer.opacity = 0;
        [_numberA.layer addAnimation:_scaleOutAnimation forKey:@"scaleOut"];
        [_numberA.layer addAnimation:_fadeOutAnimation forKey:@"fadeOut"];

        _activeNumber = _numberB;
    }
}

- (void) hideActiveNumber {
    if (_activeNumber) {
        [_activeNumber.layer addAnimation:_scaleAwayAnimation forKey:@"scaleAway"];
        [_activeNumber.layer addAnimation:_fadeOutAnimation forKey:@"fadeOut"];
    }
    _activeNumber = nil;
}


@end
