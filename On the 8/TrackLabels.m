//
//  TrackLabels.m
//  On the 8
//
//  Created by Justin Rhoades on 10/26/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "TrackLabels.h"
#import "StyleKit.h"
#import "CountdownViewController.h"

@implementation TrackLabels

- (void)awakeFromNib {
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //[self addGestureRecognizer:tap];
    
    _songsListImageView.image = [StyleKit imageOfSongsListIconWithFrame:_songsListImageView.bounds color:StyleKit.gray0];
    _songsListImageView.hidden = YES;
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //[self addGestureRecognizer:tap];
    
    //UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    //longPress.minimumPressDuration = .001;
    //[self addGestureRecognizer:longPress];
    
    _isTap = NO;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CountdownViewController *countdownViewController = (CountdownViewController *)([[UIApplication sharedApplication] delegate]).window.rootViewController;
    [countdownViewController showSongsList:self];
}



-(void)didLongPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan){
        _songsListImageView.image = [StyleKit imageOfSongsListIconWithFrame:_songsListImageView.bounds color:StyleKit.yellow1];
    }
}



- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    BOOL isLandscape = NO;
    float pWidth = self.layer.bounds.size.width;
    float baseSize = self.layer.bounds.size.width;
    if (self.layer.bounds.size.width > self.layer.bounds.size.height) {
        isLandscape = YES;
        baseSize = self.layer.bounds.size.height;
    }
    
    CGSize margins = [CountdownViewController getCornerLabelMargins];
    float marginX = margins.width;
    float marginY = margins.height;
    float labelHeight =  29.f;
    float keyLabelWidth =  80.f;
    
    // iPhone 4, 5 & 6
    _labelFontSize = 36.f;
    
    // iPhone 6+
    if (baseSize > 400) {
        _labelFontSize = 40.f;
    }
    
    // iPad
    if (baseSize > 700) {
        _labelFontSize = 62.f;
        keyLabelWidth =  160.f;
    }
    
    _labelFont = [CountdownViewController getCornerLabelFont];
    labelHeight = _labelFont.pointSize;
    float nameLabelWidth = pWidth - marginX - keyLabelWidth - marginX - marginX;
    
    /*
    if (isLandscape) {
        if (pWidth > 567.f) {
            nameLabelWidth = 200.f;
        }
        if (pWidth > 666.f) {
            nameLabelWidth = 220.f;
        }
        if (pWidth > 1023.f) {
            nameLabelWidth = 340.f;
        }
    } else {
        nameLabelWidth = 200.f;
        if (pWidth > 374.f) {
            nameLabelWidth = 255.f;
        }
        if (pWidth > 413.f) {
            nameLabelWidth = 274.f;
        }
        if (pWidth > 767.f) {
            nameLabelWidth = 548.f;
        }
    }
    */
    

    //_labelFont = [UIFont fontWithName:@"Bryant-RegularCondensed" size:_labelFontSize];
    CGRect topLeftLabelFrame = CGRectMake(marginX, marginY, nameLabelWidth, labelHeight);
    CGRect topRightLabelFrame = CGRectMake(pWidth - marginX - keyLabelWidth, marginY, keyLabelWidth, labelHeight);
    
    /*
    if (_trackName == nil) {
        _trackName = [TypeOnView new];
        [self addSubview:_trackName];
        _trackName.label.textColor = StyleKit.yellow1;
    }
    _trackName.frame = topLeftLabelFrame;
    
    if (_trackKey == nil) {
        _trackKey = [TypeOnView new];
        [self addSubview:_trackKey];
        _trackKey.label.textColor = StyleKit.yellow1;
        [_trackKey setRightAlignment];
    }
    _trackKey.frame = topRightLabelFrame;
    
    _trackName.label.font = _labelFont;
    _trackKey.label.font = _labelFont;
    */
    
    
    if (_trackName == nil) {
        _trackName = [UILabel new];
        [self addSubview:_trackName];
        _trackName.textColor = StyleKit.yellow1;
    }
    _trackName.frame = topLeftLabelFrame;
    
    if (_trackKey == nil) {
        _trackKey = [UILabel new];
        [self addSubview:_trackKey];
        _trackKey.textColor = StyleKit.gray1;
        _trackKey.textAlignment = NSTextAlignmentRight;
    }
    _trackKey.frame = topRightLabelFrame;
    
    /*
    if (_typeOnView == nil) {
        _typeOnView = [TypeOnView new];
        _typeOnView.alpha = 0;
        [self addSubview:_typeOnView];
        _typeOnView.label.textColor = StyleKit.yellow1;
    }
    _typeOnView.frame = topLeftLabelFrame;
    */
    
    _trackKey.font = _labelFont;
    _trackName.font = _labelFont;
    //_typeOnView.label.font = _labelFont;
}

- (void) updateTitleLabel:(NSString *)title keyLabel:(NSString *)key animated:(BOOL)isAnimated {
    NSLog(@"updateTitleLabel: %@ %@", title, key);
    
    _trackName.text = title;
    _trackKey.text = key;
    
    if (isAnimated) {
        _trackName.layer.opacity = 0;
        _trackKey.layer.opacity = 0;
    
        CAKeyframeAnimation *fadeInAndOut = [CAKeyframeAnimation animationWithKeyPath: @"opacity"];
        fadeInAndOut.beginTime = 0.f;
        fadeInAndOut.values   = @[@0, @1, @1, @0];
        fadeInAndOut.duration = 1.5f;
        fadeInAndOut.keyTimes = @[@0, @0.25, @0.75, @1.0];
        fadeInAndOut.repeatCount = 5;
    
        CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeIn.duration = 1.0f;
        fadeIn.beginTime = 7.5f;
        fadeIn.fromValue=@(0);
        fadeIn.toValue=@(1);
        fadeIn.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
        CAAnimationGroup *fadeInAndOutAndIn = [CAAnimationGroup animation];
        fadeInAndOutAndIn.duration = 8.5f;
        fadeInAndOutAndIn.removedOnCompletion = NO;
        fadeInAndOutAndIn.fillMode = kCAFillModeForwards;
        [fadeInAndOutAndIn setAnimations:@[fadeInAndOut, fadeIn]];
    
        [_trackName.layer addAnimation:fadeInAndOutAndIn forKey:@"fadeIn"];
        [_trackKey.layer addAnimation:fadeInAndOutAndIn forKey:@"fadeIn"];
    }
    
}


- (void) typeOnString:(NSString *)string {
    //[_typeOnView typeOnString:string];
}


- (void) setNote:(NSString *)note {
    _trackKey.text = note;
}

- (void) setIsPlaying:(BOOL)isPlaying {
    if (isPlaying) {
        _trackName.textColor = StyleKit.yellow1;
        _trackKey.textColor = StyleKit.yellow1;
    } else {
        _trackName.textColor = StyleKit.gray1;
        _trackKey.textColor = StyleKit.gray1;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchBegan");
    _isTap = YES;
    [self setButtonsActive];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchMoved");
    _isTap = NO;
    [self setButtonsNormal];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchEnded");
    if (_isTap) {
        CountdownViewController *countdownViewController = (CountdownViewController *)([[UIApplication sharedApplication] delegate]).window.rootViewController;
        [countdownViewController showSongsList:self];
    }
    [self setButtonsNormal];
    _isTap = NO;
}

- (void) setButtonsActive {
    _songsListImageView.image = [StyleKit imageOfSongsListIconWithFrame:_songsListImageView.bounds color:StyleKit.yellow1];

}

- (void) setButtonsNormal {
    _songsListImageView.image = [StyleKit imageOfSongsListIconWithFrame:_songsListImageView.bounds color:StyleKit.gray0];

}

- (void) setState:(NSString *)state {
    
    //NSLog(@"setState: %@", state);
    
    if (state == Ot8StateDefault) {
        [UIView animateWithDuration:.25f animations:^{
            _trackName.alpha = 1;
            _trackKey.alpha = 1;
            //_typeOnView.alpha = 0;
        }];
    }
    if (state == Ot8StateSetBarCount) {
        [UIView animateWithDuration:1.25f animations:^{
            _trackName.alpha = 0;
            _trackKey.alpha = 0;
            //_typeOnView.alpha = 1;
        }];
        //[_typeOnView typeOnString:@"Bar Count"];
    }
}

- (void) centerRingScrolledDownPercent:(float)percent {
    float p = 1 - percent;
    //_typeOnView.alpha = percent;
    _trackName.alpha = p;
    _trackKey.alpha = p;
}

@end
