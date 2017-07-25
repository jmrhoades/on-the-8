//
//  SongViewCell.m
//  on the 8
//
//  Created by Justin Rhoades on 3/1/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "SongViewCell.h"
#import "StyleKit.h"
#import "CountdownViewController.h"

@implementation SongViewCell

- (void) awakeFromNib {
    
    self.backgroundColor = [UIColor blackColor];
    
    //UIFont *labelFont = [UIFont fontWithName:@"Bryant-RegularCondensed" size:28.f];
    UIFont *labelFont = [CountdownViewController getCornerLabelFont];
    UIFont *fieldFont = [UIFont fontWithName:labelFont.fontName size:labelFont.pointSize*1.0f];
    UIFont *ccFont = [UIFont fontWithName:labelFont.fontName size:labelFont.pointSize*0.75f];
   
    UIColor *fieldColor = StyleKit.cellTextFieldColor;
    fieldColor = StyleKit.yellow1;
    UIColor *labelColor = StyleKit.gray1;
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    CGFloat baseSize = w;
    CGFloat cornerMargin = 8.f;
    if (w > h) { baseSize = h; }
    if (baseSize > 700) { cornerMargin = 16.f; }
    
    // Center
    _barCountPicker.pickerViewStyle = AKPickerViewStyleFlat;
    UIFont *numberFont = [CountdownViewController getCenterNumberFontSmall];
    _barCountPicker.font = numberFont;
    _barCountPicker.highlightedFont = numberFont;
    _barCountPicker.interitemSpacing = 32.0f;
    [_barCountPicker reloadData];
    
    if (_maskShape == nil) {
        _maskShape = [CAShapeLayer new];
        [_centerSquare.layer addSublayer:_maskShape];
        _maskShape.fillColor = [UIColor redColor].CGColor;
        _centerSquare.layer.mask = _maskShape;
    }
    
    // Top left corner
    _titleField.font = fieldFont;
    _titleField.textColor = fieldColor;
    _titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Song Title" attributes:@{NSForegroundColorAttributeName: fieldColor}];
    _titleField.layer.anchorPoint = CGPointMake(0.0f, 0.0f);
    _titleFieldHeight.constant = _titleField.font.pointSize;
    _titleFieldWidth.constant = (w - (cornerMargin*3))*0.75f;
    _titleFieldX.constant = -_titleFieldWidth.constant/2 + cornerMargin;
    _titleFieldY.constant = -_titleFieldHeight.constant/2 + cornerMargin;
    _titleLabel.font = labelFont;
    _titleLabel.layer.anchorPoint = CGPointMake(0.0f, 0.0f);
    _titleLabel.textColor = labelColor;
    _titleLabel.alpha = 0;
    
    // Top right corner
    _keyField.font = fieldFont;
    _keyField.textColor = fieldColor;
    _keyField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Key" attributes:@{NSForegroundColorAttributeName: fieldColor}];
    _keyField.layer.anchorPoint = CGPointMake(1.0f, 0.0f);
    _keyFieldHeight.constant = _keyField.font.pointSize;
    _keyFieldWidth.constant = (w - (cornerMargin*3))*0.25f;
    _keyFieldX.constant = -_keyFieldWidth.constant/2 + cornerMargin;
    _keyFieldY.constant = -_keyFieldHeight.constant/2 + cornerMargin;
    _keyLabel.font = labelFont;
    _keyLabel.layer.anchorPoint = CGPointMake(1.0f, 0.0f);
    _keyLabel.textColor = labelColor;
    _keyLabel.alpha = 0;
    
    // Bottom left corner
    _ccLabel.font = ccFont;
    _ccLabel.textColor = fieldColor;
    _ccLabelHeight.constant = _ccLabel.font.pointSize;
    _ccLabelWidth.constant = (w - (cornerMargin*3))*0.75f;
    _ccLabel.layer.anchorPoint = CGPointMake(0.0f, 1.0f);
    _ccLabelX.constant = -_ccLabelWidth.constant/2 + cornerMargin;
    _ccLabelY.constant = -_ccLabelHeight.constant/2 + cornerMargin;
    _timerLabel.font = labelFont;
    _timerLabel.textColor = labelColor;
    _timerLabelHeight.constant = _timerLabel.font.pointSize;
    _timerLabelWidth.constant = (w - (cornerMargin*3))*0.75f;
    _timerLabel.layer.anchorPoint = CGPointMake(0.0f, 1.0f);
    _timerLabelX.constant = -_timerLabelWidth.constant/2 + cornerMargin;
    _timerLabelY.constant = -_timerLabelHeight.constant/2 + cornerMargin;

    // Bottom right corner
    _bpmLabel.text = @"";
    _bpmLabel.font = labelFont;
    _bpmLabel.textColor = labelColor;
    _bpmLabelHeight.constant = _bpmLabel.font.pointSize;
    _bpmLabelWidth.constant = (w - (cornerMargin*3))*0.25f;
    _bpmLabel.layer.anchorPoint = CGPointMake(1.0f, 1.0f);
    _bpmLabelX.constant = -_bpmLabelWidth.constant/2 + cornerMargin;
    _bpmLabelY.constant = -_bpmLabelHeight.constant/2 + cornerMargin;
    
    _barCountScrollView.userInteractionEnabled = NO;
    _numbersScrollView.userInteractionEnabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCCLabelTap:)];
    [_ccLabel addGestureRecognizer:tap];
    _ccLabel.userInteractionEnabled = YES;
    
    _ccEditingLabel.alpha = 0;
    _ccEditingLabel.font = _ccLabel.font;
    _ccEditingLabel.textColor = StyleKit.gray2;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"CC1 VALUE"];
    [attributedString addAttribute:NSKernAttributeName value:@(1.2) range:NSMakeRange(0, attributedString.length)];
    _ccEditingLabel.attributedText = attributedString;
    
    _barCountLabel.alpha = 0;
    _barCountLabel.font = _ccEditingLabel.font;
    _barCountLabel.textColor = _ccEditingLabel.textColor;
    NSMutableAttributedString *barCountString = [[NSMutableAttributedString alloc] initWithString:@"BAR COUNT"];
    [barCountString addAttribute:NSKernAttributeName value:@(1.2) range:NSMakeRange(0, barCountString.length)];
    _barCountLabel.attributedText = barCountString;
    
    
    [_numbersView showNumber:0 withDuration:0];
    _isFocussed = NO;

}

- (void)onCCLabelTap:(UITapGestureRecognizer *)recognizer {

    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _titleField.alpha = 0;
        _keyField.alpha = 0;
        _ccLabel.alpha = 0;
    } completion:nil];
    
    _isEditingCC = YES;
    
    if (_viewController != nil) {
        [_viewController startCCEdit];
    }
}

- (IBAction)onCCCancel:(id)sender {
    //NSLog(@"onCCCancel");
    [self closeCCEditing];
}

- (IBAction)onCCAccept:(id)sender {
    //NSLog(@"onCCAccept");
    [self closeCCEditing];
}

- (void) closeCCEditing {
    //NSLog(@"cell: closeCCEditing");

    _isEditingCC = NO;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _titleField.alpha = 1.f;
        _keyField.alpha = 1.f;
        _ccLabel.alpha = 1.f;
    } completion:nil];
    
    if (_viewController != nil) {
        [_viewController endCCEdit];
    }
}




/*
- (void) layoutSubviews {
    [super layoutSubviews];
}
*/

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
   
    //NSLog(@"CELL: applyLayoutAttributes %f %f", layoutAttributes.size.width, layoutAttributes.size.height);
    
    //NSLog(@"CELL: applyLayoutAttributes _isFocussed: %i", _isFocussed);
    
    CGFloat cellWidth = layoutAttributes.size.width;
    CGFloat cellHeight = layoutAttributes.size.height;
    
    _accentViewWidth.constant = cellWidth;
    _accentViewHeight.constant = cellHeight;
    
    CGFloat baseSize = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin = 32.f;
    CGFloat cornerMargin = 8.f;
    CGFloat lineWidth = 4.f;
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) { baseSize = [UIScreen mainScreen].bounds.size.height;}
    // iPad
    if (baseSize > 700) {
        lineWidth = 8.f;
        margin = 80.f;
        cornerMargin = 16.f;
    }
    CGRect ringBounds = CGRectMake(0, 0, baseSize - (margin*2), baseSize - (margin*2));
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(ringBounds, 0, 0)];
    _maskShape.path = path.CGPath;
    _maskShape.frame = self.bounds;
    
    _centerSquareWidth.constant = ringBounds.size.width;
    _centerSquareHeight.constant = ringBounds.size.height;
    _circleProgressViewWidth.constant = ringBounds.size.width;
    _circleProgressViewHeight.constant = ringBounds.size.height;
    _baseRingWidth.constant = ringBounds.size.width;
    
    _titleField.enabled = !_isFocussed;
    _keyField.enabled = !_isFocussed;
    _titleLabel.text = _titleField.text;
    _keyLabel.text = _keyField.text;
    
    CGFloat scaleFactor = layoutAttributes.size.width/[UIScreen mainScreen].bounds.size.width;
    CGFloat ringScaleFactor = scaleFactor;
    if (scaleFactor < 1.0f) {
        ringScaleFactor = 0.66667f;
        if (baseSize > 700) {
            ringScaleFactor = 0.5f;
        }
    }
    CGFloat duration = 0.33;
    
    [self layoutIfNeeded];

    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
        
        _centerSquare.transform       = CGAffineTransformMakeScale(ringScaleFactor, ringScaleFactor);
        _circleProgressView.transform = CGAffineTransformMakeScale(ringScaleFactor, ringScaleFactor);
        _baseRing.transform           = CGAffineTransformMakeScale(ringScaleFactor, ringScaleFactor);

        _accentView.transform         = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        _titleField.transform         = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        _titleLabel.transform         = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        _keyField.transform           = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        _keyLabel.transform           = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        _ccLabel.transform            = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        _timerLabel.transform         = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        _bpmLabel.transform           = CGAffineTransformMakeScale(scaleFactor, scaleFactor);

        _ccLabel.alpha = _isFocussed ? 0.0 : 1.0;
        _timerLabel.alpha = _isFocussed ? 1.0 : 0.0;
        _bpmLabel.alpha = _isFocussed ? 1.0 : 0.0;
        _titleField.alpha = _isFocussed ? 0.0 : 1.0;
        _keyField.alpha = _isFocussed ? 0.0 : 1.0;
        _titleLabel.alpha = _isFocussed ? 1.0 : 0.0;
        _keyLabel.alpha = _isFocussed ? 1.0 : 0.0;
        _barCountLabel.alpha = _isFocussed ? 0.0 : 1.0;

    }];
    
    if (_isFocussed) {
        
        CGPoint contentOffset = CGPointMake(0, 0);
        [_barCountScrollView setContentOffset:contentOffset animated:YES];
        [_numbersScrollView setContentOffset:contentOffset animated:NO];
        [_circleProgressView setVisible:YES animated:YES];
        if (_isMIDIConnected) {
            
            [_circleProgressView setMIDIConnectedNoAnimation];
            if (_numbersView.activeNumber == nil) {
                [_numbersView showNumber:0 withDuration:0];
            }
            contentOffset = CGPointMake(_numbersScrollView.bounds.size.width, 0);
            [_numbersScrollView setContentOffset:contentOffset animated:NO];
            
        } else {
            [_midiStatusView setWaitingForMIDI];
            [_circleProgressView setWaitingForMIDI];
        }
        _barCountScrollView.userInteractionEnabled = NO;
        
    } else {
        
        CGPoint contentOffset = CGPointMake(0, _barCountScrollView.bounds.size.height);
        [_barCountScrollView setContentOffset:contentOffset animated:YES];
        [_circleProgressView setVisible:NO animated:YES];
        _barCountScrollView.userInteractionEnabled = YES;
        _barCountScrollView.scrollEnabled = NO;
    }
}

- (void) updateStateWithDuration:(float)duration {
    
    //NSLog(@"CELL: updateStateWithDuration: %f", duration);
    
    _titleField.enabled = !_isFocussed;
    _keyField.enabled = !_isFocussed;
    _titleLabel.text = _titleField.text;
    _keyLabel.text = _keyField.text;
    
    [UIView animateWithDuration:duration animations:^{
        
        _ccLabel.alpha = _isFocussed ? 0.0 : 1.0;
        _timerLabel.alpha = _isFocussed ? 1.0 : 0.0;
        _bpmLabel.alpha = _isFocussed ? 1.0 : 0.0;
        _titleField.alpha = _isFocussed ? 0.0 : 1.0;
        _keyField.alpha = _isFocussed ? 0.0 : 1.0;
        _titleLabel.alpha = _isFocussed ? 1.0 : 0.0;
        _keyLabel.alpha = _isFocussed ? 1.0 : 0.0;
        _barCountLabel.alpha = _isFocussed ? 0.0 : 1.0;
        
    }];
    
    if (_isFocussed) {
        
        CGPoint contentOffset = CGPointMake(0, 0);
        [_barCountScrollView setContentOffset:contentOffset animated:YES];
        [_numbersScrollView setContentOffset:contentOffset animated:NO];
        [_circleProgressView setVisible:YES animated:YES];
        if (_isMIDIConnected) {
            contentOffset = CGPointMake(_numbersScrollView.bounds.size.width, 0);
            [_numbersScrollView setContentOffset:contentOffset animated:NO];
            
            if (_numbersView.activeNumber == nil) {
                [_numbersView showNumber:0 withDuration:0];
            }
        
        } else {
            [_midiStatusView setWaitingForMIDI];
            [_circleProgressView setWaitingForMIDI];
        }
        _barCountScrollView.userInteractionEnabled = NO;
        
    } else {
        CGPoint contentOffset = CGPointMake(0, _barCountScrollView.bounds.size.height);
        [_barCountScrollView setContentOffset:contentOffset animated:YES];
        [_circleProgressView setVisible:NO animated:YES];
        _barCountScrollView.userInteractionEnabled = YES;
        _barCountScrollView.scrollEnabled = NO;
    }
    
    if (_isPlaying) {
        _timerLabel.textColor = StyleKit.yellow1;
        _keyLabel.textColor = StyleKit.yellow1;
        _titleLabel.textColor = StyleKit.yellow1;
        _bpmLabel.textColor = StyleKit.yellow1;
        
        [self startTimer];
        [_numbersView showNumber:1 withDuration:0];
    } else {
        _timerLabel.textColor = StyleKit.gray1;
        _keyLabel.textColor = StyleKit.gray1;
        _titleLabel.textColor = StyleKit.gray1;
        _bpmLabel.textColor = StyleKit.gray1;
        
        [self stopTimer];
        [_numbersView showNumber:0 withDuration:0];
    }
}

- (void) setCCValue:(NSNumber *)value {
    NSString *ccValue = [NSString stringWithFormat:@"CC1: %@", value];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:ccValue];
    NSRange selectedRange = NSMakeRange(0, 4);
    UIColor *color = StyleKit.gray1;
    [string beginEditing];
    [string addAttribute:NSForegroundColorAttributeName value:color range:selectedRange];
    [string endEditing];
    
    _ccLabel.attributedText = string;
}

- (void) setTitleValue:(NSString *)value {
    _titleField.text = value;
    _titleLabel.text = _titleField.text;
}

- (void) setKeyValue:(NSString *)value {
    //NSLog(@"setNoteValue with value %@", value);
    _keyField.text = value;
    _keyLabel.text = _keyField.text;
}

- (void) setNoteValue:(NSString *)value {
    //NSLog(@"setNoteValue with value %@", value);
    _keyLabel.text = value;
}


- (void) setBarCountValue:(NSUInteger)value {
    [_barCountPicker selectItem:value animated:NO notifySelection:NO];
}

- (void) setMIDIConnected:(BOOL)connected {
    //NSLog(@"SET MIDI STATUS ON CELL: %i", connected);
    
    if (connected && _isFocussed) {
        _midiStatusView.delegate = self;
        [_midiStatusView setMIDIConnected];
        [_circleProgressView setMIDIConnected];
    }
    
    if (connected && !_isFocussed) {
        [_midiStatusView setMIDIConnectedNoAnimation];
        [_circleProgressView setMIDIConnectedNoAnimation];
        [_numbersView showNumber:0 withDuration:0];
    }

    if (!connected && _isFocussed) {
        //NSLog(@"LOST CONNECTION: RESET CELL");
        
        [_midiStatusView setWaitingForMIDI];
        [_circleProgressView setWaitingForMIDI];
        [_numbersView hideActiveNumber];
        [_circleProgressView setVisible:YES animated:YES];
        CGPoint contentOffset = CGPointMake(0, 0);
        [_numbersScrollView setContentOffset:contentOffset animated:YES];
        _accentView.alpha = 0;
        [self stopTimer];
    }
    _isMIDIConnected = connected;
}

- (void) midiConnectedAnimationComplete {
    //NSLog(@"midiConnectedAnimationComplete!!!!");
    
    [_numbersView showNumber:0 withDuration:0];
    CGPoint contentOffset = CGPointMake(_numbersScrollView.bounds.size.width, 0);
    [_numbersScrollView setContentOffset:contentOffset animated:YES];
}


#pragma mark - UISCrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - Timer

- (void) startTimer {
    //NSLog(@"startTimer");
    _startTime = CACurrentMediaTime();
    _timerLabel.text = @"00:00";
    [self updateTimer];
    
    if (_updateElapsedTimeTimer != nil) {
        [_updateElapsedTimeTimer invalidate];
        _updateElapsedTimeTimer = nil;
    }
    _updateElapsedTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    _timerLabel.textColor = StyleKit.yellow1;
    _keyLabel.textColor = StyleKit.yellow1;
    _titleLabel.textColor = StyleKit.yellow1;
    _bpmLabel.textColor = StyleKit.yellow1;
    
}

- (void) stopTimer {
    //NSLog(@"stopTimer");

    [_updateElapsedTimeTimer invalidate];
    _updateElapsedTimeTimer = nil;
    
    _timerLabel.textColor = StyleKit.gray1;
    _keyLabel.textColor = StyleKit.gray1;
    _titleLabel.textColor = StyleKit.gray1;
    _bpmLabel.textColor = StyleKit.gray1;
}

- (void) resetTimer {
    _startTime = CACurrentMediaTime();
    _timerLabel.text = @"00:00";
}

- (void) updateTimer {
    CFTimeInterval elapsedTime = CACurrentMediaTime() - self.startTime;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:elapsedTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    //[formatter setDateFormat:@"HH:mm:ss"];
    [formatter setDateFormat:@"mm:ss"];
    NSString * strdate = [formatter stringFromDate:date];
    _timerLabel.textColor = StyleKit.yellow1;
    _timerLabel.text = strdate;
    
    /*
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
    _timerLabel.attributedText = string;
    */
    _counter++;
}


@end
