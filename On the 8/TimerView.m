//
//  TimerView.m
//  On the 8
//
//  Created by Justin Rhoades on 12/15/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//
#import "StyleKit.h"
#import "CountdownViewController.h"
#import "TimerView.h"

@implementation TimerView

- (void)awakeFromNib {
  
    _counter = 0;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //float baseSize = self.layer.bounds.size.width;
    float baseSize = [UIScreen mainScreen].bounds.size.width;
    //NSLog(@"%f", baseSize);
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        baseSize = [UIScreen mainScreen].bounds.size.height;
    }
    
    float marginX = 14.f;
    float marginY = 7.f;
    
    
    // iPhone 4 & 5
    _labelFontSize = 40.f;
    
    // iPhone 6
    if (baseSize > 370) {
        _labelFontSize = 48.f;
    }
    
    // iPhone 6+
    if (baseSize > 400) {
        _labelFontSize = 56.f;
    }
    
    // iPad
    if (baseSize > 760) {
        marginX = 28;
        marginY = 14;
        _labelFontSize = 80.f;
    }
    
    //NSLog(@"%f", _labelFontSize);
    _labelFont = [CountdownViewController getCornerLabelFont];
    
    float pWidth = CGRectGetWidth(self.layer.bounds);
    float pHeight = CGRectGetHeight(self.layer.bounds);
    float timerLabelHeight = _labelFont.pointSize;
    CGSize margins = [CountdownViewController getCornerLabelMargins];
    CGRect bottomLeftLabelFrame = CGRectMake(margins.width, pHeight - timerLabelHeight - margins.height, pWidth, timerLabelHeight);
    
    if (_trackTime == nil) {
        _trackTime = [UILabel new];
        [self addSubview:_trackTime];
        _trackTime.textAlignment = NSTextAlignmentLeft;
        _trackTime.textColor = StyleKit.gray1;
        _trackTime.text = @"00:00";
        _trackTime.userInteractionEnabled = YES;
        UITapGestureRecognizer *resetTimerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetTimerTapped:)];
        [_trackTime addGestureRecognizer:resetTimerTap];
    }
    _trackTime.font = _labelFont;
    _trackTime.frame = bottomLeftLabelFrame;
}

- (void) startTimer {
    _startTime = CACurrentMediaTime();
    _trackTime.text = @"00:00";
    [self updateTimer];
    _updateElapsedTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void) stopTimer {
    [_updateElapsedTimeTimer invalidate];
    _trackTime.textColor = StyleKit.gray1;
}

- (void) resetTimer {
    _startTime = CACurrentMediaTime();
    _trackTime.text = @"00:00";
}

- (void) updateTimer {
    CFTimeInterval elapsedTime = CACurrentMediaTime() - self.startTime;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:elapsedTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    //[formatter setDateFormat:@"HH:mm:ss"];
    [formatter setDateFormat:@"mm:ss"];
    NSString * strdate = [formatter stringFromDate:date];
    _trackTime.textColor = StyleKit.yellow1;
    //_trackTime.text = strdate;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strdate];
    NSRange selectedRange = NSMakeRange(2, 1);
 
    UIColor *color = StyleKit.gray1;
    int oddOrEven = _counter%2;
    if (oddOrEven == 1) {
        color = StyleKit.yellow1;
    }
    
    [string beginEditing];
    [string addAttribute:NSForegroundColorAttributeName value:color range:selectedRange];
    [string endEditing];
    _trackTime.attributedText = string;
    
    _counter++;
}

- (void)resetTimerTapped:(UITapGestureRecognizer *)gesture {
    [self resetTimer];
}

- (void) showTimer:(BOOL)isAnimated {
    if (isAnimated) {
        [UIView animateWithDuration:1.0
                              delay: 0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.layer.opacity = 1;
                         }
                         completion:nil];
    } else {
        self.layer.opacity = 1;
    }
    
}

- (void) hideTimer:(BOOL)isAnimated {
    if (isAnimated) {
        [UIView animateWithDuration:1.0
                              delay: 0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.layer.opacity = 0;
                         }
                         completion:nil];
    } else {
        self.layer.opacity = 0;
    }
}


@end
