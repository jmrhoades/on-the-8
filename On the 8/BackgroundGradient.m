//
//  BackgroundGradient.m
//  On the 8
//
//  Created by Justin Rhoades on 12/13/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "BackgroundGradient.h"
#import "StyleKit.h"

@implementation BackgroundGradient

-(void) awakeFromNib {
    _backgroundColors   = [NSArray arrayWithObjects:(id)StyleKit.gray2.CGColor, (id)StyleKit.gray3.CGColor, nil];
    //_backgroundColors   = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, nil];
    _alertColors        = [NSArray arrayWithObjects:(id)StyleKit.yellow1.CGColor, (id)StyleKit.yellow1.CGColor, nil];
    
    NSNumber *stopOne   = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo   = [NSNumber numberWithFloat:1.0];
    NSArray  *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    _backgroundGradient = [CAGradientLayer new];
    _backgroundGradient.colors = _backgroundColors;
    _backgroundGradient.locations = locations;
    [self.layer addSublayer:_backgroundGradient];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _backgroundGradient.frame = self.bounds;
}

- (void)showColors:(NSArray *)colors withTime:(float)time {
    if (time > 0) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"colors"];
        
        if (colors == _backgroundColors) {
            anim.fromValue = _alertColors;
        } else {
            anim.fromValue = _backgroundColors;
        }
        
        anim.toValue = colors;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        anim.duration = time;
        anim.delegate = self;
        anim.fillMode = kCAFillModeForwards;
        anim.removedOnCompletion = NO;
        [_backgroundGradient addAnimation:anim forKey:@"colors"];
    }
    else {
        [_backgroundGradient removeAllAnimations];
        _backgroundGradient.colors = colors;
    }
}




@end
