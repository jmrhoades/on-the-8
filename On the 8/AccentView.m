//
//  AccentView.m
//  On the 8
//
//  Created by Justin Rhoades on 1/14/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "AccentView.h"
#import "StyleKit.h"

@implementation AccentView

-(void) awakeFromNib {

    _colors = [NSArray arrayWithObjects:(id)StyleKit.yellow1.CGColor, (id)StyleKit.yellow1.CGColor, nil];
    //_colors = [NSArray arrayWithObjects:(id)StyleKit.gray1.CGColor, (id)StyleKit.gray0.CGColor, nil];

    NSNumber *stopOne   = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo   = [NSNumber numberWithFloat:1.0];
    NSArray  *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    _gradient = [CAGradientLayer new];
    _gradient.colors = _colors;
    _gradient.locations = locations;
    [self.layer addSublayer:_gradient];
    
    self.alpha = 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradient.frame = self.bounds;
}

- (void) fadeOut:(float)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    }];
}

- (void) fadeIn:(float)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    }];
}

@end
