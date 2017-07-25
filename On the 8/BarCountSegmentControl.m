//
//  BarCountSegmentControl.m
//  On the 8
//
//  Created by Justin Rhoades on 1/11/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "BarCountSegmentControl.h"
#import "StyleKit.h"



@interface BarCountSegmentButton ()

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *selectedMarker;
@property (nonatomic, strong) UIView *divider;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, assign) id<BarCountSegmentDelegate> delegate;

- (void) setSegmentSelected:(BOOL)selected;

@end

@implementation BarCountSegmentButton

- (void)awakeFromNib {
    UIFont *font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:19.f];
    
    _divider = [UIView new];
    [self addSubview:_divider];
    _divider.backgroundColor = StyleKit.cellSegmentColor;
    
    _selectedMarker = [UIView new];
    [self addSubview:_selectedMarker];
    _selectedMarker.backgroundColor = StyleKit.yellow1;
    _selectedMarker.alpha = 0;
   
    _countLabel = [UILabel new];
    _countLabel.userInteractionEnabled = NO;
    _countLabel.font = font;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = StyleKit.cellTextFieldColor;
    [self addSubview:_countLabel];
    _countLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tag];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segmentTapped:)];
    [self addGestureRecognizer:tap];
    
    _isSelected = NO;
}

- (void)layoutSubviews {
    if (self.tag != 64) {
        _divider.frame = CGRectMake(self.bounds.size.width-1.0, 0, 1.0, self.bounds.size.height);
    }    
    float markerWidth = 32.0;
    _selectedMarker.frame = CGRectMake((self.bounds.size.width-markerWidth)/2, self.bounds.size.height-3.0, markerWidth, 2.0);
    _countLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    //NSLog(@"%f", _countLabel.bounds.size.width);
}

- (void) setSegmentSelected:(BOOL)selected {
    if (selected) {
        [UIView transitionWithView:_countLabel duration:.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _countLabel.textColor = StyleKit.yellow1;
        } completion:^(BOOL finished) { }];
        [UIView transitionWithView:_countLabel duration:.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _selectedMarker.alpha = 1;
        } completion:^(BOOL finished) { }];
    } else {
        [UIView transitionWithView:_countLabel duration:.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _countLabel.textColor = StyleKit.cellTextFieldColor;
        } completion:^(BOOL finished) { }];
        [UIView transitionWithView:_countLabel duration:.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _selectedMarker.alpha = 0;
        } completion:^(BOOL finished) { }];
    }

    _isSelected = selected;
}

- (void)segmentTapped:(UITapGestureRecognizer *)gesture {
    
    if (_delegate) {
        [_delegate segmentTapped:self.tag];
    }
}


@end



@interface BarCountSegmentControl () <BarCountSegmentDelegate>

@property (nonatomic, strong) CAShapeLayer *bgFrame;

@property (nonatomic, weak) IBOutlet BarCountSegmentButton *barCount4;
@property (nonatomic, weak) IBOutlet BarCountSegmentButton *barCount8;
@property (nonatomic, weak) IBOutlet BarCountSegmentButton *barCount16;
@property (nonatomic, weak) IBOutlet BarCountSegmentButton *barCount32;
@property (nonatomic, weak) IBOutlet BarCountSegmentButton *barCount64;
@property (nonatomic, weak) BarCountSegmentButton *selectedSegment;


@end

@implementation BarCountSegmentControl


- (void)awakeFromNib {
    _barCount4.delegate = self;
    _barCount8.delegate = self;
    _barCount16.delegate = self;
    _barCount32.delegate = self;
    _barCount64.delegate = self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];

    if (_bgFrame == nil) {
        _bgFrame = [CAShapeLayer new];
        [self.layer addSublayer:_bgFrame];
        _bgFrame.borderWidth = 1.0;
        _bgFrame.borderColor = StyleKit.cellSegmentColor.CGColor;
        _bgFrame.cornerRadius = 4.0;
    }
    _bgFrame.frame = self.bounds;
}

- (void) segmentTapped:(NSInteger)tag {
    //NSLog(@"segmentTapped %li", (long)tag);
    [self setActiveSegment:tag];
    
    if (_delegate) {
        [_delegate segmentTapped:tag];
    }
}

- (void) setActiveSegment:(NSInteger)tag {
    BarCountSegmentButton *b = (BarCountSegmentButton *)[self viewWithTag:tag];
    if (_selectedSegment) {
        if (_selectedSegment == b) return;
        [_selectedSegment setSegmentSelected:NO];
    }
    [b setSegmentSelected:YES];
    _selectedSegment = b;
}




@end


