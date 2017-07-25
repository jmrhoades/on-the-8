//
//  TypeOnView.m
//  On the 8
//
//  Created by Justin Rhoades on 1/15/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "TypeOnView.h"
#import "StyleKit.h"

@interface TypeOnView()

@property (nonatomic, strong) UIView *cursor;
@property (nonatomic, retain) CADisplayLink *displayLink;
@property (nonatomic) double frameTimestamp;
@property (nonatomic) int charCount;
@property (nonatomic) int cycleLength;
@property (nonatomic) int cycleCount;
@property (nonatomic, retain) NSString *chars;
@property (nonatomic, retain) NSArray *words;
@property (nonatomic) int wordCount;
@property (nonatomic) int waitingCount;
@property (nonatomic) int activeTabId;
@property (nonatomic) BOOL isWaiting;
@property (nonatomic) BOOL isFirstNumberTap;
@property (nonatomic, retain) NSString *timeString;
@property (nonatomic, retain) NSString *finalString;
@property (nonatomic) float cursorWidth;
@property (nonatomic) BOOL isRightAligned;

- (void) updateCursor;
- (void) reset;
- (void) setTitle:(NSString *)title;
- (void) pause;
- (void) resume;

@end

@implementation TypeOnView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [UILabel new];
        [self addSubview:_label];
        _label.textColor = StyleKit.gray1;
        
        _cursorWidth = 2.0;
        _cursor = [UILabel new];
        [self addSubview:_cursor];
        _cursor.backgroundColor = StyleKit.yellow1;
        _cursor.frame = CGRectMake(0, 0, _cursorWidth, self.bounds.size.height);
        _cursor.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _cursor.layer.cornerRadius = 2.0;
        _cursor.hidden = YES;
        self.chars = @"&%$#@ABCEFIJLPSTVYZ012345679";
        self.wordCount = 0;
    }
    
return self;
}


- (void) dealloc {
    [_displayLink  invalidate];
    _displayLink = nil;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _label.frame = self.bounds;
    _cursor.frame = CGRectMake(CGRectGetMinX(_cursor.frame), 0, _cursorWidth, CGRectGetHeight(self.bounds));
}

- (void) reset {
    //_label.layer.opacity = 1.f;
    
    _label.text = @"";
    
    self.charCount = 0;
    self.cycleCount = 0;
    self.isWaiting = NO;
    
    //self.cycleLength = 2 + (arc4random() % 10);
    self.cycleLength = 15;
    [self.displayLink  invalidate];
    self.displayLink = nil;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) wipeOff {
    _cursor.alpha = 1.0f;
    
    [UIView transitionWithView:_label duration:.33f options:UIViewAnimationOptionTransitionCrossDissolve+UIViewAnimationOptionCurveEaseOut+UIViewAnimationOptionBeginFromCurrentState
     animations:^{
     _label.textColor = StyleKit.gray1;
     } completion:^(BOOL finished)
     {
     
     }];
    float cursorX = 0;
    if (_isRightAligned) {
        cursorX = CGRectGetWidth(self.bounds);
    }
    [UIView animateWithDuration:.33f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut+UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _cursor.frame = CGRectMake(cursorX, 0, _cursorWidth, CGRectGetHeight(self.bounds));
                         _label.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self reset];
                         [UIView animateWithDuration:.33f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveEaseInOut+UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              _label.layer.opacity = 1;
                                          }
                                          completion:^(BOOL finished){
                                          }
                          ];
                         
                     }
     ];
    
}

- (void) update {
    double currentTime = [self.displayLink timestamp];
    //NSLog(@"%f", currentTime-self.frameTimestamp);
    
    if (self.isWaiting) {
        return;
    }
    
    // Set the 'final' string
    self.finalString = [self.words objectAtIndex:0];
    if (self.wordCount == 1) {
        NSString *timeString = @"";
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        timeString = [dateFormatter stringFromDate:date];
        self.timeString = timeString;
        self.finalString = self.timeString;
    }
    
    NSString *letter = @"";
    BOOL isRealLetter = NO;
    if (self.cycleCount < self.cycleLength) {
        for (int i = 0; i < ([self.finalString length] - self.charCount); i++) {
            letter = [NSString stringWithFormat:@"%@%C",letter,[self.chars characterAtIndex:arc4random() % ([self.chars length]-1)]];
        }
        self.cycleCount++;
    } else {
        letter = [NSString stringWithFormat:@"%C",[self.finalString characterAtIndex:self.charCount]];
        self.cycleCount = 0;
        self.charCount++;
        isRealLetter = YES;
    }
    if (letter != nil) {
        if (self.charCount == 0) {
            [self setTitle:letter];
            
        } else if (self.charCount == [self.finalString length]) {
            _label.text = self.finalString;
            self.wordCount++;
            if (self.wordCount > 1) self.wordCount = 0;
            self.isWaiting = YES;
            self.waitingCount = 0;
            
            CGSize size = [_label sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
            float cursorX = size.width;
            if (_isRightAligned) {
                CGSize fullSize = [_label.text sizeWithFont:_label.font constrainedToSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
                cursorX = CGRectGetWidth(self.bounds) - fullSize.width + size.width;
            }
            //[self updateCursor];
            [UIView animateWithDuration:.25f
                                  delay:0.f
                                options:UIViewAnimationOptionCurveEaseOut+UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _cursor.frame = CGRectMake(cursorX, 0, _cursorWidth, CGRectGetHeight(self.bounds));
                             }
                             completion:^(BOOL finished)
             {

                 [UIView transitionWithView:_label duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve+UIViewAnimationOptionCurveEaseIn+UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     _label.textColor = StyleKit.gray1;
                                 } completion:^(BOOL finished)
                  {
                      [self.displayLink  invalidate];
                      self.displayLink = nil;
                      [self hideCursor];
                      
                      
                      [UIView transitionWithView:_label duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve+UIViewAnimationOptionCurveEaseOut+UIViewAnimationOptionBeginFromCurrentState
                                      animations:^{
                                          //_label.textColor = StyleKit.yellow1;
                                      } completion:^(BOOL finished)
                       {
            

                       }];
                      
                      
                  }];
             }
             ];
            
        } else {
            [self setTitle:[NSString stringWithFormat:@"%@%@",[self.finalString substringToIndex:self.charCount], letter]];
            if (isRealLetter) [self updateCursor];
        }
    }
    self.frameTimestamp = currentTime;
}

-(void)updateCursor {
    _cursor.hidden = NO;
    CGFloat cursorX = 0;
    if (self.charCount>0) {
        NSString *l = @"";
        l = [self.finalString substringToIndex:self.charCount];
        //CGSize constraint = CGSizeMake(self.bounds.size.width, CGFLOAT_MAX);
        //CGRect rect = [l boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        //CGSize size = rect.size;
        CGSize size = [l sizeWithFont:_label.font constrainedToSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
        cursorX = size.width;
        if (_isRightAligned) {
            //CGSize fullSize = [self.finalString sizeWithFont:_label.font constrainedToSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
            cursorX = CGRectGetWidth(self.bounds) - size.width - 2.f;
            //NSLog(@"%f %f %f %f", CGRectGetWidth(self.bounds), fullSize.width, size.width, cursorX);

        }
    }
    _cursor.alpha = 0.0f;
    
    [UIView animateWithDuration:.19f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut+UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _cursor.frame = CGRectMake(cursorX, 0, _cursorWidth, CGRectGetHeight(self.bounds));
                         _cursor.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.5f
                                               delay:0.1f
                                             options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState)
                                          animations:^{
                                              _cursor.alpha = 0.0f;
                                          }
                                          completion:^(BOOL finished){}];
                     }
     ];
    
}

- (void)hideCursor {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         _cursor.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                             _cursor.hidden = YES;
                     }];

}

- (void) setTitle:(NSString *)title {
    if ([title length] > 0) {
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:title];
        [attString addAttribute:NSForegroundColorAttributeName value:StyleKit.gray1 range:NSMakeRange(self.charCount,[title length] - self.charCount)];
        _label.attributedText = attString;
    } else {
        _label.text = title;
    }
}

- (void) pause {
    [self.displayLink  invalidate];
    self.displayLink = nil;
}

- (void) resume {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) typeOnString:(NSString *)string {
    [self.displayLink  invalidate];
    self.displayLink = nil;
    self.wordCount = 0;
    self.words = @[string];
    //[self wipeOff];
    //_label.layer.opacity = 1.f;
    //_label.textColor = StyleKit.yellow1;
    
    if (_isRightAligned) {
        //CGSize fullSize = [string sizeWithFont:_label.font constrainedToSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
        //CGFloat cursorX = CGRectGetWidth(self.bounds) - fullSize.width - 10.f;
        CGFloat cursorX = CGRectGetWidth(self.bounds);
        _cursor.frame = CGRectMake(cursorX, 0, _cursorWidth, CGRectGetHeight(self.bounds));
    }
    
    [self reset];

}

- (void) setRightAlignment {
    _isRightAligned = YES;
    _label.textAlignment = NSTextAlignmentRight;
}





@end
