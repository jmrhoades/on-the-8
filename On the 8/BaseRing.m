//
//  BaseRing.m
//  On the 8
//
//  Created by Justin Rhoades on 12/13/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "BaseRing.h"
#import "StyleKit.h"
#import "RingView.h"

@implementation BaseRing

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (_backgroundRing == nil) {
        _backgroundRing = [CAShapeLayer new];
        [self.layer addSublayer:_backgroundRing];
        _backgroundRing.fillColor = nil;
        _backgroundRing.lineWidth = self.lineWidth;
        _backgroundRing.transform = CATransform3DRotate(_backgroundRing.transform, -M_PI/2, 0, 0, 1);
        _backgroundRing.strokeColor = StyleKit.gray1.CGColor;
        _backgroundRing.lineCap = kCALineCapRound;
    }
    self.ringBounds = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.ringBounds, self.lineWidth/2, self.lineWidth/2)];
    _backgroundRing.path = path.CGPath;
    _backgroundRing.frame = self.bounds;
    
    
    //NSLog(@"ring frame %f", self.ringFrame.origin.x);
    //NSLog(@"ring frame %f", self.ringFrame.origin.y);
}



@end
