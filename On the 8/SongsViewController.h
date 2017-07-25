//
//  SongsViewController.h
//  on the 8
//
//  Created by Justin Rhoades on 2/28/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"
#import "PGMidiMessage.h"
#import "PGMidiSession.h"
#import "PGMidi.h"
#import "AboutViewController.h"
#import "MIDIConnectionsViewController.h"

@interface SongsViewController : UIViewController <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, AKPickerViewDataSource, AKPickerViewDelegate, PGMidiSourceDelegate, PresentedViewControllerDelegate>

- (void) midiClockStart;
- (void) midiClockStop;
- (void) midiSource:(PGMidiSource *)source midiReceived:(const MIDIPacketList *)packetList;
- (void) midiSource:(PGMidiSource *)source sentNote:(int)note velocity:(int)velocity;
- (void) midiSource:(PGMidiSource *)source sentCC:(int)cc value:(int)value;
- (void) tickUpdate:(int)count;
- (void) onNewBar;
- (void) didClose;

- (void) startCCEdit;
- (void) endCCEdit;

@end
