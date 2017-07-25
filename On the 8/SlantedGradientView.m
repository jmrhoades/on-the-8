//
//  SlantedGradientView.m
//  On the 8
//
//  Created by Justin Rhoades on 10/14/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "SlantedGradientView.h"
#import "StyleKit.h"


@implementation SlantedGradientView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    UIBezierPath* path;
    path = [UIBezierPath bezierPathWithRect: rect];
    CGContextSaveGState(ctx);
    if (_slantType == 1) {
        path = [UIBezierPath bezierPath];
        [path moveToPoint: CGPointMake(0, rect.size.height - 10.f)];
        [path addLineToPoint: CGPointMake(rect.size.width, rect.size.height-(rect.size.height*.3))];
        [path addLineToPoint: CGPointMake(rect.size.width, 0)];
        [path addLineToPoint: CGPointMake(0, 0)];
        [path addLineToPoint: CGPointMake(0, rect.size.height - 10.f)];
        [path closePath];
        
    } else if (_slantType == 2) {
        path = [UIBezierPath bezierPath];
        [path moveToPoint: CGPointMake(16.f, rect.size.height)];
        [path addLineToPoint: CGPointMake(rect.size.width, rect.size.height)];
        [path addLineToPoint: CGPointMake(rect.size.width, 0)];
        [path addLineToPoint: CGPointMake(0, 0)];
        [path addLineToPoint: CGPointMake(16.f, rect.size.height)];
        [path closePath];
        
    } else if (_slantType == 3) {
        path = [UIBezierPath bezierPath];
        [path moveToPoint: CGPointMake(0, rect.size.height - 30.f)];
        [path addLineToPoint: CGPointMake(rect.size.width, rect.size.height - 10.f)];
        [path addLineToPoint: CGPointMake(rect.size.width, 0)];
        [path addLineToPoint: CGPointMake(0, 0)];
        [path addLineToPoint: CGPointMake(0, rect.size.height - 30.f)];
        [path closePath];
        
    } else {
        path = [UIBezierPath bezierPathWithRect: rect];
    }

    
    [path addClip];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat bGGradientLocations[] = {0.0f, 1.0f};
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)_topColor.CGColor, (id)_bottomColor.CGColor, nil];
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, bGGradientLocations);
    CGContextDrawLinearGradient(ctx, gradientRef, CGPointMake(rect.size.width/2, 0), CGPointMake(rect.size.width/2, rect.size.height), 0);
    CGContextRestoreGState(ctx);
}


@end
