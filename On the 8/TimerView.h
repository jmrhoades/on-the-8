//
//  TimerView.h
//  On the 8
//
//  Created by Justin Rhoades on 12/15/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerView : UIView

@property (nonatomic) UILabel      *trackTime;
@property (nonatomic) UIFont       *labelFont;
@property (nonatomic) float        labelFontSize;
@property (nonatomic) int          counter;


@property (nonatomic, retain)  NSTimer  *updateElapsedTimeTimer;
@property (nonatomic) CFTimeInterval     startTime;
- (void) startTimer;
- (void) stopTimer;
- (void) resetTimer;
- (void) showTimer:(BOOL)isAnimated;
- (void) hideTimer:(BOOL)isAnimated;
@end
