//
//  SongViewCell.h
//  on the 8
//
//  Created by Justin Rhoades on 3/1/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"
#import "MIDIStatusView.h"
#import "NumbersLabelView.h"
#import "CircleProgressView.h"
#import "BaseRing.h"
#import "AccentView.h"
#import "SongsViewController.h"

@interface SongViewCell : UICollectionViewCell <UITextFieldDelegate, UIScrollViewDelegate, MIDIStatusViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@property (weak, nonatomic) SongsViewController *viewController;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *keyField;
@property (weak, nonatomic) IBOutlet UILabel *ccLabel;
@property (weak, nonatomic) IBOutlet UILabel *ccEditingLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bpmLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *timerLabel;
@property (unsafe_unretained, nonatomic) IBOutlet BaseRing *baseRing;

@property (weak, nonatomic) IBOutlet AKPickerView *barCountPicker;
@property (weak, nonatomic) IBOutlet AccentView *accentView;
@property (weak, nonatomic) IBOutlet UILabel *barCountLabel;

@property (unsafe_unretained, nonatomic) IBOutlet MIDIStatusView *midiStatusView;
@property (unsafe_unretained, nonatomic) IBOutlet NumbersLabelView *numbersView;
@property (unsafe_unretained, nonatomic) IBOutlet CircleProgressView *circleProgressView;
@property (weak, nonatomic) IBOutlet UIScrollView *barCountScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *numbersScrollView;

@property (weak, nonatomic) IBOutlet UIView *centerSquare;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerSquareWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerSquareHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleProgressViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleProgressViewHeight;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *baseRingWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleFieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleFieldWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleFieldX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleFieldY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyFieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyFieldWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyFieldY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyFieldX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ccLabelX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ccLabelY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bpmLabelX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bpmLabelY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerLabelX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerLabelY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ccLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ccLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bpmLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bpmLabelWidth;





@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accentViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;

@property (nonatomic) CAShapeLayer *maskShape;
@property (strong, nonatomic) NSArray *barCountPickerTitles;

@property (nonatomic) int               counter;
@property (nonatomic, retain)  NSTimer  *updateElapsedTimeTimer;
@property (nonatomic) CFTimeInterval    startTime;

@property (nonatomic) BOOL isFocussed;
@property (nonatomic) BOOL isMIDIConnected;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL isEditingCC;

- (void) setCCValue:(NSNumber *)value;
- (void) setTitleValue:(NSString *)value;
- (void) setKeyValue:(NSString *)value;
- (void) setNoteValue:(NSString *)value;
- (void) setBarCountValue:(NSUInteger)value;

- (void) setMIDIConnected:(BOOL)connected;

- (void) startTimer;
- (void) stopTimer;
- (void) resetTimer;
- (IBAction)onCCCancel:(id)sender;
- (IBAction)onCCAccept:(id)sender;

- (void) closeCCEditing;
- (void) updateStateWithDuration:(float)duration;

@end
