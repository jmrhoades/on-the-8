//
//  BPMView.m
//  On the 8
//
//  Created by Justin Rhoades on 1/25/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "BPMView.h"
#import "StyleKit.h"
#import "CountdownViewController.h"


@implementation BPMView


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (_bpmLabel == nil) {
        _bpmLabel = [UILabel new];
        [self addSubview:_bpmLabel];
        _bpmLabel.textAlignment = NSTextAlignmentRight;
        _bpmLabel.textColor = StyleKit.gray1;
        _bpmLabel.text = @"";
        _bpmLabel.userInteractionEnabled = NO;
    }
    UIFont *labelFont = [CountdownViewController getCornerLabelFont];

    float fontSize = labelFont.pointSize;
    float pWidth = CGRectGetWidth(self.layer.bounds);
    float pHeight = CGRectGetHeight(self.layer.bounds);
    float labelHeight = fontSize;
    CGSize margins = [CountdownViewController getCornerLabelMargins];
    CGRect bottomRightLabelFrame = CGRectMake(margins.width, pHeight - labelHeight - margins.height, pWidth - (margins.width*2), labelHeight);
    
    _bpmLabel.font = labelFont;
    _bpmLabel.frame = bottomRightLabelFrame;
}

- (void) setBPM:(double)bpm {
    if (bpm == -1) {
        _bpmLabel.text =  @"";
    } else {
        int roundedBPM = round(bpm);
        _bpmLabel.text = [NSString stringWithFormat:@"%d", roundedBPM];
    }
}

@end
