//
//  CountdownViewController.h
//  On the 8
//
//  Created by Justin Rhoades on 9/19/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PGMidiMessage.h"
#import "PGMidiSession.h"
#import "PGMidi.h"
#import "MIDIStatusView.h"
#import "TrackLabels.h"
#import "TimerView.h"
#import "CircleProgressView.h"
#import "BackgroundGradient.h"
#import "NumbersLabelView.h"
#import "AccentView.h"
#import "BPMView.h"
#import "BaseRing.h"
#import "SongsTableViewController.h"
#import "CenterRing.h"
#import "BarCountPickerView.h"
#import "TypeOnView.h"

static NSString * const Ot8StateRunning       = @"Running";
static NSString * const Ot8StateNoMIDI        = @"NoMIDI";
static NSString * const Ot8StateMIDIConnected = @"MIDIConnected";
static NSString * const Ot8StateSetBarCount   = @"SetBarCount";
static NSString * const Ot8StateDefault       = @"Default";

static NSString * const Ot8SectionSongs       = @"SectionSongs";
static NSString * const Ot8SectionProgress    = @"SectionProgress";
static NSString * const Ot8SectionBarCount    = @"SectionBarCount";

@interface CountdownViewController : UIViewController <UIGestureRecognizerDelegate, PGMidiSourceDelegate, MIDIStatusViewDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) NSTimer                     *scanMIDIConnectionTimer;
@property (nonatomic) CFTimeInterval                      timeSinceMIDIConnection;

@property (nonatomic) double    percent;
@property (nonatomic) int       tickCount;
@property (nonatomic) int       barCount;
@property (nonatomic) NSInteger barCountUnit;
@property (nonatomic) int       beatCount;
@property (nonatomic) float     transitionTime;
@property (nonatomic) int       currentProgramCC;
@property (nonatomic) BOOL      isMIDIConnected;
@property (nonatomic) BOOL      isFirstRun;
@property (nonatomic) BOOL      isPlaying;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *currentSection;

@property (nonatomic) CGFloat            prevScrollPosition;
@property (nonatomic) NSTimeInterval     prevTime;


@property (strong, nonatomic) IBOutlet BarCountPickerView *barCountPickerView;
@property (strong, nonatomic) IBOutlet CenterRing         *centerRing;
@property (strong, nonatomic) IBOutlet MIDIStatusView     *midiStatusView;
@property (strong, nonatomic) IBOutlet BaseRing           *baseRing;
@property (strong, nonatomic) IBOutlet TrackLabels        *trackLabels;
@property (strong, nonatomic) IBOutlet TimerView          *timerView;
@property (strong, nonatomic) IBOutlet BPMView            *bpmView;
@property (strong, nonatomic) IBOutlet CircleProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton           *helpButton;
@property (strong, nonatomic) IBOutlet UIButton           *settingsButton;
@property (strong, nonatomic) IBOutlet BackgroundGradient *bgColorView;
@property (strong, nonatomic) IBOutlet NumbersLabelView   *numbersLabelView;
@property (strong, nonatomic) IBOutlet AccentView         *accentView;
@property (strong, nonatomic) IBOutlet UIScrollView       *sectionsScrollView;

@property (strong, nonatomic) IBOutlet UIView *section1View;
@property (strong, nonatomic) IBOutlet UIView *section2View;
@property (strong, nonatomic) IBOutlet UIView *section3View;


@property (weak, nonatomic) SongsTableViewController      *songsTableView;
@property (nonatomic, retain) CADisplayLink               *displayLink;

- (void) midiClockStart;
- (void) midiClockStop;
- (void) midiSource:(PGMidiSource *)source midiReceived:(const MIDIPacketList *)packetList;
- (void) midiSource:(PGMidiSource *)source sentNote:(int)note velocity:(int)velocity;
- (void) midiSource:(PGMidiSource *)source sentCC:(int)cc value:(int)value;
- (void) tickUpdate:(int)count;
- (void) onNewBar;

- (IBAction)unwindToMainView:(UIStoryboardSegue *)segue;
- (IBAction)showHelp:(UIButton *)sender;


- (void) updateTitleLabel:(NSString *)title keyLabel:(NSString *)key;
- (void) updateBarCountUnit:(NSInteger)tag;
- (void) hideInterface;
- (void) showInterface;
- (void) setState:(NSString *)state;
- (void) centerRingScrolledDownPercent:(float)percent;

- (IBAction)showSongsList:(id)sender;
- (IBAction)hideSongsList:(id)sender;
- (IBAction)showNewSongDetail:(id)sender;
- (IBAction)hideNewSongDetail:(id)sender;

+ (UIFont *) getCornerLabelFont;
+ (CGSize) getCornerLabelMargins;
+ (UIFont *) getCenterNumberFont;
+ (UIFont *) getCenterNumberFontSmall;
+ (float) getCenterNumberOffsetY;
+ (float) getCenterPickerItemSpacing;
+ (NSArray *) barCountNames;
+ (NSArray *) barCountValues;

@end