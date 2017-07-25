//
//  TrackLabels.h
//  On the 8
//
//  Created by Justin Rhoades on 10/26/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeOnView.h"


@interface TrackLabels : UIView

@property (nonatomic, strong) TypeOnView  *typeOnView;
@property (nonatomic, strong) UILabel     *trackName;
@property (nonatomic, strong) UILabel     *trackKey;
@property (nonatomic) float               labelFontSize;
@property (nonatomic) UIFont              *labelFont;
@property (nonatomic) BOOL                isTap;

@property (nonatomic, weak) IBOutlet UIImageView *songsListImageView;

- (void) updateTitleLabel:(NSString *)title keyLabel:(NSString *)key animated:(BOOL)isAnimated;
- (void) setNote:(NSString *)note;
- (void) setIsPlaying:(BOOL)isPlaying;
- (void) typeOnString:(NSString *)string;
- (void) setState:(NSString *)state;
- (void) centerRingScrolledDownPercent:(float)percent;

@end
