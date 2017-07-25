//
//  BPMView.h
//  On the 8
//
//  Created by Justin Rhoades on 1/25/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPMView : UIView

@property (nonatomic) UILabel *bpmLabel;

- (void) setBPM:(double)bpm;

@end
