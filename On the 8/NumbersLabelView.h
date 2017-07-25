//
//  NumbersLabelView.h
//  On the 8
//
//  Created by Justin Rhoades on 1/13/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "RingView.h"

@interface NumbersLabelView : RingView

@property (nonatomic) NSInteger barCountUnit;
@property (nonatomic, strong) UILabel *activeNumber;

- (void) showNumber:(int)number withDuration:(float)duration;
- (void) hideActiveNumber;

@end
