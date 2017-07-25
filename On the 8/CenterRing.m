//
//  CenterRing.m
//  on the 8
//
//  Created by Justin Rhoades on 2/4/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "CenterRing.h"
#import "CountdownViewController.h"

@implementation CenterRing

- (void) awakeFromNib {
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    // Add tap gesture to center ring
    //UITapGestureRecognizer *centerRingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerRingTapped:)];
    //[self addGestureRecognizer:centerRingTap];
}

- (void)centerRingTapped:(UITapGestureRecognizer *)recognizer {
    float offset = (self.bounds.size.height);
    NSLog(@"centerRingTapped %f", offset);
    [_scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    /*
    if (_maskShape == nil) {
        _maskShape = [CAShapeLayer new];
        [self.layer addSublayer:_maskShape];
        _maskShape.fillColor = [UIColor redColor].CGColor;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 0, 0)];
    _maskShape.path = path.CGPath;
    _maskShape.frame = self.bounds;
    self.layer.mask = _maskShape;
    */
    
    BOOL isLandscape = NO;
    float baseSize = [UIScreen mainScreen].bounds.size.width;
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        baseSize = [UIScreen mainScreen].bounds.size.height;
        isLandscape = YES;
    }
    
    // iPhone 4s & 5
    float margin = 32.f;
    
    // iPhone 6
    if (baseSize > 350) {
        
    }
    
    // iPhone 6+
    if (baseSize > 400) {
    }
    
    // iPad
    if (baseSize > 700) {
        margin = 64.f;
    }
    
    /*
     Size & Position
     */
    CGRect ringBounds = CGRectMake(0, 0, baseSize - (margin*2), baseSize - (margin*2));
    if (isLandscape) {
        ringBounds = CGRectMake(0, 0, floorf((baseSize - (margin*2))*.8), floorf((baseSize - (margin*2))*.8));
    }
    
    _widthConstraint.constant = ringBounds.size.width;
    _heightConstraint.constant = ringBounds.size.height;
    [self layoutIfNeeded];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float percentScrolledDown = scrollView.contentOffset.y / (self.bounds.size.height/2);
    if (percentScrolledDown > 0 && percentScrolledDown < 1) {
        //CountdownViewController *countdownViewController = (CountdownViewController *)([[UIApplication sharedApplication] delegate]).window.rootViewController;
        //[countdownViewController centerRingScrolledDownPercent:percentScrolledDown];
    }
    
    //NSLog(@"%f %f",scrollView.contentOffset.y, percentScrolledDown);
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSString *state = Ot8StateSetBarCount;
    
    CGFloat target = targetContentOffset->y;
    float secondPageOffset = (self.bounds.size.height/2);
    CGFloat newTarget = 0;
    if (target > secondPageOffset) {
        newTarget = self.bounds.size.height;
    }
    //targetContentOffset->y = newTarget;
    
    if (velocity.y == 0.f) {
        // A 0 velocity means the user dragged and stopped (no flick)
        // In this case, tell the scroll view to animate to the closest index
        newTarget = 0.f;
        state = Ot8StateDefault;
        if (target > secondPageOffset) {
            newTarget = self.bounds.size.height;
            state = Ot8StateSetBarCount;
        }
    }
    else if (velocity.y > 0.f) {
        // User scrolled downwards
        newTarget = self.bounds.size.height;
    } else {
        // User scrolled upwards
        newTarget = 0;
        state = Ot8StateDefault;
    }
    CountdownViewController *countdownViewController = (CountdownViewController *)([[UIApplication sharedApplication] delegate]).window.rootViewController;
    [countdownViewController setState:state];
    *targetContentOffset = CGPointMake(0, newTarget);
    
    //NSLog(@"scrollViewWillEndDragging withVelocity:%f newTarget:%f", velocity.y, newTarget);
    //[scrollView setContentOffset:CGPointMake(0, newTarget) animated:YES];
    //[scrollView scrollRectToVisible:CGRectMake(0, newTarget, self.bounds.size.width, self.bounds.size.height) animated:YES];
}

@end