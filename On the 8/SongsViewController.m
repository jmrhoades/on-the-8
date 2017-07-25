//
//  SongsViewController.m
//  on the 8
//
//  Created by Justin Rhoades on 2/28/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <CoreAudioKit/CoreAudioKit.h>

#import "SongsViewController.h"
#import "StyleKit.h"
#import "SongViewCell.h"
#import "PanelFlowLayout.h"

static NSString * const SongCellIdentifier = @"SongCell";

@interface SongsViewController ()

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
@property (nonatomic) BOOL      isEditingCC;
@property (nonatomic) BOOL      isBluetoothConnectionsVisible;

@property (nonatomic, retain) NSTimer *scanMIDIConnectionTimer;
@property (nonatomic) CFTimeInterval timeSinceMIDIConnection;
@property (nonatomic, retain) CADisplayLink *displayLink;

@property (nonatomic) BOOL isFocussed;

@property (nonatomic) NSUInteger selectedItem;
@property (nonatomic) NSInteger focussedItem;
@property (nonatomic) NSInteger previouslySelectedItem;

@property (strong, nonatomic) NSMutableArray *songsList;
@property (strong, nonatomic) NSArray *barCountPickerTitles;

@property (weak, nonatomic) IBOutlet UIView *topButtons;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UICollectionView *songsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomButtons;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *MIDIButton;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundImageHeight;

@property (strong, nonatomic) CABTMIDILocalPeripheralViewController *localPeripheralViewController;


- (IBAction)onDeleteSongTap:(id)sender;
- (IBAction)onAddSongTap:(id)sender;

@end

@implementation SongsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = StyleKit.cellBgColor;
    
    // Set Up Top Buttons
    CGRect buttonFrame = CGRectMake(0, 0, 24.0, 24.0);
    
    UIImage *deleteImageNormal = [StyleKit imageOfDeleteIconWithFrame:buttonFrame color:StyleKit.gray1];
    UIImage *deleteImageHighlighted = [StyleKit imageOfDeleteIconWithFrame:buttonFrame color:StyleKit.red];
    [_deleteButton setImage:deleteImageNormal forState:UIControlStateNormal];
    [_deleteButton setImage:deleteImageHighlighted forState:UIControlStateHighlighted];
    
    UIImage *addImageNormal = [StyleKit imageOfPlusIconWithFrame:buttonFrame color:StyleKit.yellow1];
    UIImage *addImageHighlighted = [StyleKit imageOfPlusIconWithFrame:buttonFrame color:StyleKit.gray1];
    [_addButton setImage:addImageNormal forState:UIControlStateNormal];
    [_addButton setImage:addImageHighlighted forState:UIControlStateHighlighted];
    
    // Set Up Bottom Buttons
    UIImage *infoImageNormal = [StyleKit imageOfHelpIconWithFrame:buttonFrame color:StyleKit.gray1];
    UIImage *infoImageHighlighted = [StyleKit imageOfHelpFilledIconWithFrame:buttonFrame color:StyleKit.gray1];
    [_infoButton setImage:infoImageNormal forState:UIControlStateNormal];
    [_infoButton setImage:infoImageHighlighted forState:UIControlStateHighlighted];
    
    //UIImage *midiImageNormal = [StyleKit imageOfMidiConnectorButtonWithFrame:buttonFrame color:StyleKit.gray1];
    UIImage *midiImageNormal = [StyleKit imageOfBluetoothStatusWithFrame:buttonFrame color:StyleKit.gray2];
    UIImage *midiImageHighlighted = [StyleKit imageOfBluetoothStatusWithFrame:buttonFrame color:StyleKit.yellow1];
    [_MIDIButton setImage:midiImageNormal forState:UIControlStateNormal];
    [_MIDIButton setImage:midiImageHighlighted forState:UIControlStateHighlighted];
    
    // Get saved song list
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _songsList = [[defaults arrayForKey:@"songsList"] mutableCopy];
    
    // Set Up Collection View
    _songsCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    // Background Image
    _backgroundImageView.image = [StyleKit imageOfSongsBgSymbolWithFrame:_backgroundImageView.bounds color:[UIColor colorWithWhite:1.0 alpha:0.1]];
    _backgroundImageView.alpha = 1;
    
    // Bar Count Options
    _barCountPickerTitles = @[@"4", @"8", @"16", @"24", @"32", @"40", @"48", @"56", @"64"];
    
    [self initMIDI];
    
    // Init right layout
    PanelFlowLayout *layout = [PanelFlowLayout new];
    layout.fullscreen = YES;
    _isFocussed = YES;
    _songsCollectionView.collectionViewLayout = layout;
    
    // Find a song to show
    //    Look at saved songs, show last one used
    //    If no saved songs, create one
    // Show song
    // Select the item in the scrollview and scroll to it
    // NSUInteger songIndex = 0;
    if (_songsList.count == 0) {
        //NSLog(@"CREATE A NEW SONG");
        [self createNewSong];
    } else {
        
    }

    // Update buttons
    [self updateButtonStates];
    [self updateCornerButtons];
    
    _localPeripheralViewController = [CABTMIDILocalPeripheralViewController new];
    
    //[self presentViewController:_localPeripheralViewController animated:YES completion:nil];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setSongBarCount];

}


- (void) startCCEdit {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
    SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _topButtons.alpha = 0;
        _bottomButtons.alpha = 0;
        cell.barCountPicker.alpha = 0;
        cell.barCountLabel.alpha = 0;

        NSUInteger l = _songsList.count;
        for (NSUInteger i = 0; i < l; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
            if (cell.isEditingCC != YES) {
                cell.alpha = 0.f;
            }
        }
    } completion:^(BOOL finished) {
        // Select current CC val
        NSDictionary *song = [_songsList objectAtIndex:indexPath.row];
        NSNumber *ccValue = (NSNumber *)[song valueForKey:@"cc"];
        [cell.barCountPicker updateSelectedItem:ccValue.intValue-1];
        [cell.barCountPicker reloadData];
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.barCountPicker.alpha = 1.0f;
            cell.ccEditingLabel.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
        
    }];
    
    _songsCollectionView.scrollEnabled = NO;
    _isEditingCC = YES;
    
    /*
    SystemSoundID searchingSound;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"connected02" ofType:@"caf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &searchingSound);
    AudioServicesPlaySystemSound(searchingSound);
    */
}

- (void) endCCEdit {
    
    //NSLog(@"endCCEdit");
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
    SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _topButtons.alpha = 1.0f;
        _bottomButtons.alpha = 1.0f;
        cell.barCountPicker.alpha = 0.0f;
        cell.ccEditingLabel.alpha = 0.0f;
        NSUInteger l = _songsList.count;
        for (NSUInteger i = 0; i < l; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
            cell.alpha = 1.0f;
        }
    } completion:^(BOOL finished) {
        _songsCollectionView.scrollEnabled = YES;
        _isEditingCC = NO;
        
        // Set new cc value on label
        NSDictionary *song = [_songsList objectAtIndex:indexPath.row];
        NSNumber *ccValue = (NSNumber *)[song valueForKey:@"cc"];
        [cell setCCValue:ccValue];
        
        // Update the picker control to display bar count again
        NSString *barCount = (NSString *)[song valueForKey:@"barCount"];
        //NSLog(@"cell.isEditingCC %i", cell.isEditingCC);
        [cell.barCountPicker updateSelectedItem:barCount.intValue];
        [cell.barCountPicker reloadData];
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.barCountPicker.alpha = 1.0f;
            cell.barCountLabel.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
        
    }];
    
    /*
    SystemSoundID searchingSound;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"connected02" ofType:@"caf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &searchingSound);
    AudioServicesPlaySystemSound(searchingSound);
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) didClose {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //NSLog(@"Segue ID: %@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"SegueToAbout"]) {
        AboutViewController *aboutViewController = segue.destinationViewController;
        aboutViewController.delegate = self;
    }
    
}

- (IBAction)onBluetoothStatusBtn:(id)sender {
    
    //_localPeripheralViewController.view.layoutMargins = UIEdgeInsetsMake(-200.f, 0.f, 0.f, 0.f);
    //[self.navigationController presentViewController:_localPeripheralViewController animated:YES completion:nil];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:_localPeripheralViewController animated:YES];
    _isBluetoothConnectionsVisible = YES;
}


- (void) initMIDI {
    // Set up PGMIDI Session, listen for notifications
    PGMidiSession *session = [PGMidiSession sharedSession];
    session.delegate = (id)self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(midiSetupChanged:)
                                                 name:@"PGMidiSetupChangedNotification"
                                               object:session.midi];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(midiSourceAdded:)
                                                 name:@"PGMidiSourceAddedNotification"
                                               object:session.midi];
    
    // PGMIDI bar / beat listener
    [[PGMidiSession sharedSession] performBlockOnMainThread:^{ [self onNewBar]; } quantizedToInterval:1 repeat:YES];
    
    // Repeatedly check if there's a MIDI connection or not
    _scanMIDIConnectionTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(rescanMidi) userInfo:nil repeats:YES];
    _isMIDIConnected = NO;
    _isFirstRun = YES;
    
    // Drawing loop
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMIDIProgress)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    // Set Bar Count Unit
    _barCountUnit = 8;
}

- (void) saveSongList {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:_songsList forKey:@"songsList"];
    [defaults synchronize];
}

- (void) createNewSong {
    NSNumber *ccVal = [self getFirstAvailableCC];
    NSDictionary *newSong = @{@"title": @"", @"key": @"", @"cc": ccVal, @"bpm":@"", @"barCount":@"1"};
    NSUInteger item = 0;
    if (_songsList.count > 0 && _selectedItem >= 0) {
        item = _selectedItem+1;
    }
    [_songsList insertObject:newSong atIndex:item];
    _selectedItem = item;
    // Save the new song to disk
    [self saveSongList];
}

- (void)didEndScrolling {
    CGPoint center = [self.view convertPoint:_songsCollectionView.center toView:_songsCollectionView];
    NSIndexPath *indexPath = [_songsCollectionView indexPathForItemAtPoint:center];
    [self selectItem:indexPath.item animated:YES];
}

- (void)selectItem:(NSUInteger)item animated:(BOOL)animated {
    [self selectItem:item animated:animated notifySelection:YES];
}

- (void)selectItem:(NSUInteger)item animated:(BOOL)animated notifySelection:(BOOL)notifySelection {
    //NSLog(@"----------------selectItem --------------------");

    //NSLog(@"Current selected item: %li", (long)_selectedItem);
    
    [self scrollToItem:item animated:animated];
    
    if (item == _selectedItem) return;
    
    // Save index of last selected item
    _previouslySelectedItem = _selectedItem;
    
    // Set new selected item var
    _selectedItem = item;
    //NSLog(@"New selected item: %li", (long)_selectedItem);
    
    //[_songsCollectionView reloadItemsAtIndexPaths:_songsCollectionView.indexPathsForVisibleItems];
    //[_songsCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:item inSection:0]]];
    
    // Select the item in the scrollview and scroll to it
    [_songsCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] animated:animated scrollPosition:UICollectionViewScrollPositionNone];
    
}

- (void)scrollToItem:(NSUInteger)item animated:(BOOL)animated {
    [_songsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:animated];
}

- (void) updateButtonStates {
    CGFloat deleteButtonAlpha = 1.0;
    CGFloat bgImageAlpha = 0.0;
    if (_songsList.count > 0) {
        [_deleteButton setEnabled:YES];
    } else {
        [_deleteButton setEnabled:NO];
        deleteButtonAlpha = 0;
        bgImageAlpha = 1.0;
    }
    [UIView animateWithDuration:0.33 animations:^{
        _deleteButton.alpha = deleteButtonAlpha;
        _backgroundImageView.alpha = bgImageAlpha;
    }];
}

- (void) updateCornerButtons {
    if (!_isFocussed) {
        [self.view bringSubviewToFront:_topButtons];
        [self.view bringSubviewToFront:_bottomButtons];
        [UIView animateWithDuration:0.33 animations:^{
            _topButtons.alpha = 1;
            _bottomButtons.alpha = 1;
        }];
    } else {
        [self.view bringSubviewToFront:_songsCollectionView];
        [UIView animateWithDuration:0.33 animations:^{
            _topButtons.alpha = 0;
            _bottomButtons.alpha = 0;
        }];
    }
}

- (NSNumber *) getFirstAvailableCC {
    NSNumber *val = 0;
    for(int i=1; i<128; i++) {
        BOOL match = NO;
        NSNumber *iNum = [NSNumber numberWithInt:i];
        for (id object in _songsList) {
            NSNumber *objCCVal = (NSNumber *)[object valueForKey:@"cc"];
            if (objCCVal == iNum) {
                match = YES;
            }
        }
        if (match == NO) {
            return iNum;
        }
    }
    return val;
}

- (NSMutableArray *) getAllCC {
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0; i<127; i++) {
        [array addObject:[NSString stringWithFormat:@"%i", i+1]];
    }
    return array;
}

- (void) resetClockCounters {
    //NSLog(@"resetClockCounters");
    
    _percent = 0;
    _beatCount = 0;
    _barCount = 1;
    _tickCount = 0;
    
    if (_selectedItem) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
        SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
        cell.circleProgressView.isSpent = NO;
        cell.numbersView.barCountUnit = _barCountUnit;
    }
}

// Polling function for keeping up with the state of MIDI connections
// Called every 0.5 seconds for the life of the app
// Updates state of app when MIDI status changes
- (void)rescanMidi {
    
    PGMidiSession *session = [PGMidiSession sharedSession];
    BOOL isConnected = [session.midi isMidiConnected];
    [self setTransitionTime];
    BOOL hasChangedState = NO;
    
    if (_isMIDIConnected != isConnected) {
        //NSLog(@"rescanMidi: %i", isConnected);
        hasChangedState = YES;
    }
    _isMIDIConnected = isConnected;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
    SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
    
    if ((_isMIDIConnected && hasChangedState) || (_isMIDIConnected && _isFirstRun)) {
        //NSLog(@"MIDI CONNECTED");
        
        if (cell != nil) {
            [cell setMIDIConnected:YES];
        }
        _timeSinceMIDIConnection = CACurrentMediaTime();
        
        // If MIDI
        if(_isBluetoothConnectionsVisible) {
            [self.navigationController popViewControllerAnimated:YES];
            _isBluetoothConnectionsVisible = NO;
        }
        
        if (_isFirstRun) {

        } else {
            // Wait for the animation callback instead
        }
        _isFirstRun = NO;
    }
    
    if ((!_isMIDIConnected && hasChangedState) || (!_isMIDIConnected && _isFirstRun)) {
        //NSLog(@"NOT CONNECTED");
        //cell.bpmLabel.text = @"";
        [cell stopTimer];
        [self resetClockCounters];
        //CFTimeInterval elapsedTime = CACurrentMediaTime() - _timeSinceMIDIConnection;
        //NSLog(@"%f", elapsedTime);
        // After 5 seconds of no MIDI, show the help button
        //if (elapsedTime > 5) {
        //}
        // Make sure the timer is hiding
        //[_timerView hideTimer:YES];
        _isFirstRun = NO;
        _isPlaying = NO;
        cell.isPlaying = _isPlaying;
    
        if (_isFocussed) {
            [cell setMIDIConnected:NO];
        }
    }
}

- (void) setSongBarCount {
    NSDictionary *song = [_songsList objectAtIndex:_selectedItem];
    NSString *barCount = (NSString *)[song valueForKey:@"barCount"];
    NSString *barCountStr = _barCountPickerTitles[barCount.intValue];
    _barCountUnit = barCountStr.intValue;
    
    //NSLog(@"setSongBarCount: %@ %@", barCount, barCountStr);
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    UICollectionViewFlowLayout *flowLayout = (id)_songsCollectionView.collectionViewLayout;
    //NSLog(@"INVALIDATE------");
    [flowLayout invalidateLayout]; //force the elements to get laid out again with the new size
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    _isBluetoothConnectionsVisible = NO;
}


#pragma mark - PGMidi Setup Changed Notifications

- (void) midiSourceAdded:(NSNotification *)notification {
    //NSLog(@"View Controller: midiSourceAdded");
    //self.debugMidiTextView.text = [self.debugMidiTextView.text stringByAppendingString:@"\n\n View Controller: midiSourceAdded"];
}

- (void) midiSetupChanged:(NSNotification *)notification {
    //NSLog(@"View Controller: midiSetupChanged");
    
    //self.debugMidiTextView.text = [self.debugMidiTextView.text stringByAppendingString:@"\n\n View Controller: midiSetupChanged\n\n"];
    //NSString *message = [notification.userInfo valueForKey:@"message"];
    //self.debugMidiTextView.text = [self.debugMidiTextView.text stringByAppendingString:message];
    
    PGMidiSession *session = [PGMidiSession sharedSession];
    BOOL isConnected = [session.midi isMidiConnected];
    if (!isConnected) {
        //NSLog(@"Show NO MIDI MSG");
        //self.debugMidiTextView.text = [self.debugMidiTextView.text stringByAppendingString:@"\n\n Show NO MIDI MSG"];
    } else {
        //NSLog(@"Hide NO MIDI MSG");
        //self.debugMidiTextView.text = [self.debugMidiTextView.text stringByAppendingString:@"\n\n Hide NO MIDI MSG"];
    }
}

#pragma mark - PGMidi Clock Notifications

- (void) setTransitionTime {
    double bpm = [PGMidiSession sharedSession].bpm;
    //NSLog(@"bpm: %f", bpm);
   
    if (_isMIDIConnected && (bpm > 1 && bpm < 300)) {
        //NSLog(@"bpm: %f", bpm);
        int roundedBPM = round(bpm);
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
        SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
        cell.bpmLabel.text = [NSString stringWithFormat:@"%i", roundedBPM];
        
        _transitionTime = 60/bpm;
        if (_transitionTime < 0.3) {
            _transitionTime = 0.3;
        }
    } else {
        _transitionTime = 0.3;
    }
    
}

- (void) tickUpdate:(int)count {
    float totalTicks = 95.f*_barCountUnit;
    if (_tickCount == totalTicks-1) {
        _tickCount = 0;
    } else {
        _tickCount++;
    }
    _percent = _tickCount/totalTicks;
    //NSLog(@"percent:%f barCount: %d  tickCount: %d count: %d totalTicks: %f",  _percent, _barCount, _tickCount,count,totalTicks);
}

- (void) midiClockStart {
    //NSLog(@"midiClockStart");
    [self resetClockCounters];
    _isPlaying = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
    SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
    cell.isPlaying = _isPlaying;
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell startTimer];
        //[_trackLabels setIsPlaying:YES];
    });
}

- (void) midiClockStop {
    //NSLog(@"midiClockStop");
    _isPlaying = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
    SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
    cell.isPlaying = _isPlaying;
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell stopTimer];
        [cell.accentView fadeOut:_transitionTime];
        //[_trackLabels setIsPlaying:NO];
    });
}

- (void) midiSource:(PGMidiSource *)source midiReceived:(const MIDIPacketList *)packetList {
    //NSLog(@"midiSource midiReceived");
}

- (void) midiSource:(PGMidiSource *)source sentNote:(int)note velocity:(int)velocity {
    //NSLog(@"midiSource sentNote %d with velocity %d", note, velocity);
    if (_isFocussed) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
        SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
        NSArray *noteStrings = [NSArray arrayWithObjects: @"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B", nil];
        //int octave = (note / 12) - 1;
        int noteIndex = (note % 12);
        NSString *noteString = noteStrings[noteIndex];
        [cell setNoteValue:noteString];
    }
}

- (void) midiSource:(PGMidiSource *)source sentCC:(int)cc value:(int)value {
    //NSLog(@"midiSource sentCC %d with value %d", cc, value);
    
    // only listen to cc1
    if(cc != 1) return;
    
    if (value > 0 && value < 127) {
        // if value is valid, look through songs to find a match
        NSUInteger l = _songsList.count;
        for (NSUInteger i = 0; i < l; i++) {
            NSObject *song = [_songsList objectAtIndex:i];
            NSNumber *ccVal = [song valueForKey:@"cc"];
            NSNumber *valNum = [NSNumber numberWithInt:value];
            if ([ccVal isEqualToNumber:valNum]) {
                if (i == _selectedItem) return;
                if (_isFocussed) {
                    //NSLog(@"SCANN MATCH CC:%@ valNum:%@", ccVal, valNum);
                    [self selectItem:i animated:YES notifySelection:YES];
                    if (_isPlaying) {
                        //NSLog(@"Stop old cell/song. Start new cell/song.");
                        [self setSongBarCount];
                        //[self resetClockCounters];
                        
                        //NSIndexPath *oldIndexPath = [NSIndexPath indexPathForItem:_previouslySelectedItem inSection:0];
                        //SongViewCell *oldCell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:oldIndexPath];
                        //NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
                        //SongViewCell *newCell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:newIndexPath];
                        //dispatch_async(dispatch_get_main_queue(), ^{
                        //[oldCell stopTimer];
                        //[newCell startTimer];
                        //});
                    }
                }
            }
        }
        
       /*
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *songArray = [defaults arrayForKey:@"songs"];
        NSDictionary *song = [songArray objectAtIndex:value];
        [_trackLabels updateTitleLabel:song[@"title"] keyLabel:song[@"key"] animated:YES];
        [_timerView resetTimer];
        */
    }
}


- (void) updateMIDIProgress {
    if (_isPlaying) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
        SongViewCell *selectedCell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
        [selectedCell.circleProgressView setProgress:_percent];
    }
}

- (void) onNewBar {
    //NSLog(@"onNewBar: transition time: %f", _transitionTime);
    
    if (_isPlaying) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
        SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
        cell.numbersView.barCountUnit = _barCountUnit;

        if (_barCount == _barCountUnit) {
            if (_isFocussed) {
                [cell.accentView fadeIn:_transitionTime*3.9];
            }
        }
    
        if (_barCount == 1) {
            _tickCount = 0;
            if (_isFocussed) {
                [cell.accentView fadeOut:_transitionTime];
            }
            cell.circleProgressView.isSpent = NO;
        }
    
        [cell.numbersView showNumber:_barCount withDuration:_transitionTime];
    
        _barCount++;
        if (_barCount > _barCountUnit) {
            _barCount = 1;
        }
    }
}


#pragma mark - UISCrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self didEndScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollViewDidScroll:scrollView];
    if (!decelerate) [self didEndScrolling];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"numberOfItemsInSection: %lu", (unsigned long)_songsList.count);
    return _songsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"cellForItemAtIndexPath: %lu isFocussed: %i", (unsigned long)indexPath.row, _isFocussed);

    SongViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SongCellIdentifier forIndexPath:indexPath];
    NSDictionary *song = [_songsList objectAtIndex:indexPath.row];
    NSNumber *ccValue = (NSNumber *)[song valueForKey:@"cc"];
    [cell setCCValue:ccValue];
    NSString *title = (NSString *)[song valueForKey:@"title"];
    [cell setTitleValue:title];
    NSString *key = (NSString *)[song valueForKey:@"key"];
    [cell setKeyValue:key];
    NSString *barCount = (NSString *)[song valueForKey:@"barCount"];
    //NSLog(@"barCount: %@", barCount);
    
    [cell setBarCountValue:barCount.intValue];
    cell.isMIDIConnected = _isMIDIConnected;
    
    //NSLog(@"setting cell isFocussed: %i", _isFocussed);
    cell.isFocussed = _isFocussed;
    cell.isPlaying = _isPlaying;
    cell.viewController = self;
    
    //NSLog(@"ensure that cell is properly set up");
    [cell updateStateWithDuration:0];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"SongsCollectionViewController didSelectItemAtIndexPath %li", (long)indexPath.row);
    
    PanelFlowLayout *layout = [PanelFlowLayout new];
    SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
    
    if (_isEditingCC == YES) {
        [cell closeCCEditing];
        return;
    }

    if (_isFocussed) {
        _isFocussed = NO;
        _songsCollectionView.scrollEnabled = YES;
    } else {
        layout.fullscreen = YES;
        _isFocussed = YES;
        _songsCollectionView.scrollEnabled = NO;
        
        cell.isPlaying = _isPlaying;
        
        // If there's already a cell in playing mode, stop it and
        // - start the timer of the new cell
        // - reset the bar count unit and counters
        if (_focussedItem != indexPath.row) {
            if (_isPlaying) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_focussedItem inSection:0];
                SongViewCell *oldCell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [oldCell stopTimer];
                    [cell startTimer];
                    [self setSongBarCount];
                    [self resetClockCounters];
                    [cell.numbersView showNumber:0 withDuration:0];
                });
            }
        }
        _focussedItem = indexPath.row;
    }
    
    // Update focus state for all visible cells
    //for(SongViewCell *cell in _songsCollectionView.visibleCells) {
        //cell.isFocussed = _isFocussed;
    //}
    
    cell.isFocussed = _isFocussed;
    [self updateCornerButtons];
    
    //[_songsCollectionView reloadItemsAtIndexPaths:_songsCollectionView.indexPathsForVisibleItems];
    [_songsCollectionView setCollectionViewLayout:layout animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     //SongViewCell *cell = (SongViewCell *)[_songsCollectionView cellForItemAtIndexPath:indexPath];
     //if (_isEditingCC == YES) {
         //[cell closeCCEditingForFocus];
         //return NO;
     //}
     return YES;
 }

#pragma mark - UITextFieldDelegate (set in Interface Builder)

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Rely on the tag of the textField to tell if it's the title or key label
    // Rely on the current selectedItem index to know which model object to update
    
    NSString *key = @"title";
    if (textField.tag == 1) {
        key = @"key";
    }
    
    NSMutableDictionary *song = [(NSDictionary *)[_songsList objectAtIndex:_selectedItem] mutableCopy];
    [song setValue:textField.text forKey:key];
    [_songsList removeObjectAtIndex:_selectedItem];
    [_songsList insertObject:song atIndex:_selectedItem];
    [self saveSongList];
}

#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {
    //NSLog(@"numberOfItemsInPickerView");
    NSUInteger count = 0;
    
    if (_isEditingCC) {
        NSMutableArray *arr = [self getAllCC];
        count = [arr count];
    } else {
        count = [_barCountPickerTitles count];
    }
    //NSLog(@"numberOfItemsInPickerView: %i", count);

    return count;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item {
    //NSLog(@"pickerView titleForItem");

    if (_isEditingCC) {
        NSMutableArray *arr = [self getAllCC];
        return arr[item];
    }
    return _barCountPickerTitles[item];
}

#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {
    //NSLog(@"pickerView didSelectItem: %ld", (long)item);

    NSMutableDictionary *song = [(NSDictionary *)[_songsList objectAtIndex:_selectedItem] mutableCopy];
    if (_isEditingCC) {
        [song setValue:[NSNumber numberWithInt:item+1] forKey:@"cc"];
    } else {
        [song setValue:[NSString stringWithFormat:@"%li", (long)item] forKey:@"barCount"];
    }
    [_songsList removeObjectAtIndex:_selectedItem];
    [_songsList insertObject:song atIndex:_selectedItem];
    [self saveSongList];
    
    [self setSongBarCount];
    [self resetClockCounters];
}

- (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item {
    /*
    if (_isEditingCC) {
        BOOL match = NO;
        NSNumber *iNum = [NSNumber numberWithInt:item-1];
        for (id object in _songsList) {
            NSNumber *objCCVal = (NSNumber *)[object valueForKey:@"cc"];
            if (objCCVal == iNum) {
                match = YES;
                NSLog(@"MATCH!!!");
                label.textColor = StyleKit.gray3;
                label.highlightedTextColor = StyleKit.gray3;
            } else {
                label.textColor = StyleKit.gray1;
                label.highlightedTextColor = StyleKit.yellow1;
            }
        }
    } else {
        label.textColor = StyleKit.gray1;
        label.highlightedTextColor = StyleKit.yellow1;
    }
    */
}

- (void)pickerView:(AKPickerView *)pickerView configureCell:(AKCollectionViewCell * const)cell forItem:(NSInteger)item {
    // Loop thru all the songs and look for the selected CC
    // If found make sure that cell can't be selected
    if (_isEditingCC) {
        BOOL match = NO;
        for (id object in _songsList) {
            NSInteger songCCVal = ((NSNumber *)[object valueForKey:@"cc"]).intValue - 1;
            //NSLog(@"songCCVal: %i item: %i", songCCVal, item);
            if (songCCVal == item) {
                //NSLog(@"MATCH on: %i", item);
                match = YES;
                cell.isInactive = YES;
                return;
            }
        }
    }
    cell.isInactive = NO;
}


#pragma mark - Add / Delete Buttons

- (IBAction)onDeleteSongTap:(id)sender {
    //NSLog(@"onDeleteSongTap");
    
    if (_selectedItem < _songsList.count && _selectedItem >= 0 ) {
        [_songsList removeObjectAtIndex:_selectedItem];
        [_songsCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_selectedItem inSection:0]]];
        if (_selectedItem > (_songsList.count-1)) {
            _selectedItem = _songsList.count-1;
        }
        [self updateButtonStates];
        
        // Save the updated songlist to disk
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:_songsList forKey:@"songsList"];
        [defaults synchronize];
        
    } else {
        //NSLog(@"UH OH _selectedItem out of range: %long", (unsigned long)_selectedItem);
    }
}

- (IBAction)onAddSongTap:(id)sender {
    //NSLog(@"onAddSongTap");
    [self createNewSong];
    
    [_songsCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_selectedItem inSection:0]]];
    [self scrollToItem:_selectedItem animated:YES];
    [self updateButtonStates];
    [_songsCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedItem inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}


@end
