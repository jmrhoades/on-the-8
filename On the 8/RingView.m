//
//  RingView.m
//  On the 8
//
//  Created by Justin Rhoades on 12/13/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "RingView.h"

@implementation RingView

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    /*
     Find size of circle by comparing self's frame width to height,
     use the smaller of the two dimensions for circle size base
     */
    
    BOOL isLandscape = NO;
    _baseSize = self.layer.bounds.size.width;
    if (self.layer.bounds.size.width > self.layer.bounds.size.height) {
        _baseSize = self.layer.bounds.size.height;
        isLandscape = YES;
    }
    
    // iPhone 4s & 5
    _lineWidth = 4.f;
    _margin = 32.f;

    // iPhone 6
    if (_baseSize > 350) {
        
    }
    
    // iPhone 6+
    if (_baseSize > 400) {
         _lineWidth = 6.f;
    }
    
    // iPad
    if (_baseSize > 700) {
        _lineWidth = 8.f;
        _margin = 64.f;
    }
    
    /*
     Size & Position
     */
    
    
    _ringBounds = CGRectMake(0, 0, _baseSize - (_margin*2), _baseSize - (_margin*2));
    if (isLandscape) {
        _ringBounds = CGRectMake(0, 0, floorf((_baseSize - (_margin*2))*.8), floorf((_baseSize - (_margin*2))*.8));
    }
    //NSLog(@"%f", _ringBounds.size.width);
    //NSLog(@"%f", _ringBounds.size.height);
    
    _ringX = (CGRectGetWidth(self.frame) -  CGRectGetWidth(_ringBounds)) / 2;
    _ringY = (CGRectGetHeight(self.frame) -  CGRectGetHeight(_ringBounds)) / 2;
    
    //NSLog(@"%f", _ringX);
    //NSLog(@"%f", _ringY);
    
    _ringFrame = CGRectOffset(_ringBounds, _ringX, _ringY);
    
    //NSLog(@"%f", _ringFrame.size.width);
    //NSLog(@"%f", _ringFrame.size.height);
}

@end
