//
//  CountdownViewController.m
//  On the 8
//
//  Created by Justin Rhoades on 9/19/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "CountdownViewController.h"
#import "MIDIStatusView.h"
#import "MIDIHelpViewController.h"
#import "StyleKit.h"
#import "HideSongSegue.h"
#import "SongsTableViewController.h"
#import "SongDetailTableViewController.h"

@interface CountdownViewController ()

@end

@implementation CountdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _transitionTime = .25f;
    
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
    
    // Drawing loop
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    // PGMIDI bar / beat listener
    [[PGMidiSession sharedSession] performBlockOnMainThread:^{ [self onNewBar]; } quantizedToInterval:1 repeat:YES];
    //[[PGMidiSession sharedSession] performBlockOnMainThread:^{ [self onNewBeat]; } quantizedToInterval:.25 repeat:YES];
    
    // Help button
    CGRect helpFrame = CGRectMake(0, 0, 44.f, 44.f);
    UIImage *helpImageNormal = [StyleKit imageOfHelpIconOutlineWithFrame:helpFrame color:StyleKit.gray1];
    UIImage *helpImageHighlighted = [StyleKit imageOfHelpIconFilledWithFrame:helpFrame color:StyleKit.red];
    [_helpButton setImage:helpImageNormal forState:UIControlStateNormal];
    [_helpButton setImage:helpImageHighlighted forState:UIControlStateHighlighted];
    _helpButton.layer.opacity = 0;
    _timeSinceMIDIConnection = CACurrentMediaTime();
    
    // Settings button
    CGRect settingsFrame = _settingsButton.bounds;
    UIImage *settingsImageNormal = [StyleKit imageOfSongsListIconWithFrame:settingsFrame color:StyleKit.gray1];
    UIImage *settingsImageHighlighted = [StyleKit imageOfSongsListIconWithFrame:settingsFrame color:StyleKit.yellow1];
    [_settingsButton setImage:settingsImageNormal forState:UIControlStateNormal];
    [_settingsButton setImage:settingsImageHighlighted forState:UIControlStateHighlighted];

    // Timer
    [_timerView hideTimer:NO];
    
    // Global Bar Count Picker
    //_barCountPickerView.hidden = YES;
    
    // Init counting and state vars
    [self resetStatus];
    
    // Repeatedly check if there's a MIDI connection or not
    self.scanMIDIConnectionTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(rescanMidi) userInfo:nil repeats:YES];
    _isMIDIConnected = NO;
    _isFirstRun = YES;
    
    // Assign ref to MIDIStatusView for callback purposes
    _midiStatusView.delegate = self;
    
    /*
    // Set global bar count from preferences
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults valueForKey:@"barCountUnit"];
    NSLog(@"CountdownViewController viewdidload value: %@", value);
    NSArray *barCountNames = [CountdownViewController barCountNames];
    NSString *name = [barCountNames objectAtIndex:value.intValue];
    _barCountUnit = name.intValue;
    _numbersLabelView.barCountUnit = _barCountUnit;
    */
    
    /*
    CABasicAnimation *opacityAnimation =
    [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue   = @(0.0);
    opacityAnimation.duration  = 1.0; // For convenience
    [_section1View.layer addAnimation:opacityAnimation forKey:@"Change opacity"];
    _section1View.layer.speed = 0.0; // Pause the animation
    [_section2View.layer addAnimation:opacityAnimation forKey:@"Change opacity"];
    _section2View.layer.speed = 0.0; // Pause the animation
    [_section3View.layer addAnimation:opacityAnimation forKey:@"Change opacity"];
    _section3View.layer.speed = 0.0; // Pause the animation
    */
    //NSLog(@"viewDidLoad");

}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //NSLog(@"viewWillLayoutSubviews");
    [_sectionsScrollView setContentOffset:CGPointMake(0, self.view.bounds.size.height) animated:NO];
    _prevScrollPosition = _sectionsScrollView.contentOffset.y;
}

-(void)awakeFromNib {
    //NSLog(@"awakeFromNib");
    
}



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
        [self resetStatus];
    } else {
        //NSLog(@"Hide NO MIDI MSG");
        //self.debugMidiTextView.text = [self.debugMidiTextView.text stringByAppendingString:@"\n\n Hide NO MIDI MSG"];
    }
}

- (void) resetStatus {
    //NSLog(@"resetStatus");
    _percent = 0;
    _barCount = 1;
    _beatCount = 0;
    _tickCount = 0;
    _isPlaying = NO;
}

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
    
    if ((_isMIDIConnected && hasChangedState) || (_isMIDIConnected && _isFirstRun)) {
        //NSLog(@"CONNECTED");
        //[self setStateMIDIConnected];
        [self setState:Ot8StateMIDIConnected];

    }
    
    if ((!_isMIDIConnected && hasChangedState) || (!_isMIDIConnected && _isFirstRun)) {
        //NSLog(@"NOT CONNECTED");
        //[self setStateNoMIDI];
        [self setState:Ot8StateNoMIDI];
    }
}

- (void) midiConnectedAnimationComplete {
    //NSLog(@"midiConnectedAnimationComplete!!!!");
    [_numbersLabelView showNumber:0 withDuration:_transitionTime];
    
    [_timerView showTimer:YES];
}

- (void) setTransitionTime {
    double bpm = [PGMidiSession sharedSession].bpm;
    _transitionTime = 60/bpm;
    
    [_bpmView setBPM:bpm];
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
    [self resetStatus];
    _isPlaying = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timerView startTimer];
        [_trackLabels setIsPlaying:YES];
    });
}

- (void) midiClockStop {
    //NSLog(@"midiClockStop");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timerView stopTimer];
        [_trackLabels setIsPlaying:NO];
    });
}

- (void) midiSource:(PGMidiSource *)source midiReceived:(const MIDIPacketList *)packetList {
    //NSLog(@"midiSource midiReceived");
}

- (void) midiSource:(PGMidiSource *)source sentNote:(int)note velocity:(int)velocity {
    //NSLog(@"midiSource sentNote %d with velocity %d", note, velocity);
    
     NSArray *noteStrings = [NSArray arrayWithObjects: @"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B", nil];
     //int octave = (note / 12) - 1;
     int noteIndex = (note % 12);
     NSString *noteString = noteStrings[noteIndex];
    
    [_trackLabels setNote:noteString];
}

- (void) midiSource:(PGMidiSource *)source sentCC:(int)cc value:(int)value {
    //NSLog(@"midiSource sentCC %d with value %d", cc, value);
    
    if(cc != 1) return;
    
    if (value != _currentProgramCC && value > 0 && value < 127) {
        _currentProgramCC = value;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *songArray = [defaults arrayForKey:@"songs"];
        NSDictionary *song = [songArray objectAtIndex:value];
        //[self updateTitleLabel:song[@"title"] keyLabel:song[@"key"]];
        [_trackLabels updateTitleLabel:song[@"title"] keyLabel:song[@"key"] animated:YES];
        [_timerView resetTimer];
    }
}


- (void) onNewBeat {
    [_progressView setProgress:_percent];

    _beatCount++;
    if (_beatCount > 31) {
        _beatCount = 0;
    }
}

- (void) onNewBar {
    //NSLog(@"transition time: %f", _transitionTime);
    
    if (_barCount == _barCountUnit) {
        //[_bgColorView showColors:[_bgColorView alertColors] withTime:_transitionTime*3.9];
        [_accentView fadeIn:_transitionTime*3.9];
    }
    
    if (_barCount == 1) {
        _tickCount = 0;
        //[_bgColorView showColors:[_bgColorView backgroundColors] withTime:_transitionTime];
        [_accentView fadeOut:_transitionTime];
        _progressView.isSpent = NO;
    }
    
    [_numbersLabelView showNumber:_barCount withDuration:_transitionTime];
    
    _barCount++;
    if (_barCount > _barCountUnit) {
        _barCount = 1;
    }
}

- (void) updateProgress {
    [_progressView setProgress:_percent];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)unwindToMainView:(UIStoryboardSegue *)segue {
    
    //NSLog(@"Returned from second view");

}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController
                                      fromViewController:(UIViewController *)fromViewController
                                              identifier:(NSString *)identifier {
    
    // Check the identifier and return the custom unwind segue if this is an
    // unwind we're interested in
    if ([identifier isEqualToString:@"HideSongsSegue"]) {
        HideSongSegue *segue = [[HideSongSegue alloc] initWithIdentifier:identifier
                                      source:fromViewController
                                      destination:toViewController];
        return segue;
    }
    
    // return the default unwind segue otherwise
    return [super segueForUnwindingToViewController:toViewController
                                 fromViewController:fromViewController
                                         identifier:identifier];
}

- (IBAction)showHelp:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MIDIHelpViewController* viewController = [sb instantiateViewControllerWithIdentifier:@"midiHelp"];
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:viewController animated:YES completion:NULL];
}

- (void) updateTitleLabel:(NSString *)title keyLabel:(NSString *)key {
    NSLog(@"updateTitleLabel: %@ %@", title, key);
    [_trackLabels updateTitleLabel:title keyLabel:key animated:NO];
}

- (void) updateBarCountUnit:(NSInteger)tag {

    //NSArray *barCountValues = [CountdownViewController barCountValues];
    NSArray *barCountNames = [CountdownViewController barCountNames];
    //NSInteger value = (NSInteger)[barCountValues objectAtIndex:tag];
    NSString *strVal = [barCountNames objectAtIndex:tag];
    NSInteger intVal = strVal.intValue;
    NSLog(@"updateBarCountUnit %li %@, %li", (long)tag, strVal, intVal);
    
    _barCountUnit = intVal;
    _numbersLabelView.barCountUnit = _barCountUnit;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSString stringWithFormat:@"%li", (long)tag] forKey:@"barCountUnit"];
    [defaults synchronize];
}

- (void) hideInterface {
    
    [UIView animateWithDuration:0.5 animations:^{

        _numbersLabelView.alpha = 0;

    }];
    
    [UIView animateWithDuration:0.5 delay:0
         usingSpringWithDamping:0.9 initialSpringVelocity:10.0f
                        options:0 animations:^{
                            _trackLabels.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, -80.f, 0.f);
                            _trackLabels.layer.opacity = 0;
                            
                        } completion:nil];
    
    
    [UIView animateWithDuration:0.5 delay:.1
         usingSpringWithDamping:0.9 initialSpringVelocity:10.0f
                        options:0 animations:^{
                            
                            _midiStatusView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, -80.f, 0.f);
                            _midiStatusView.layer.opacity = 0;
                            
                            _progressView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, -80.f, 0.f);
                            _progressView.layer.opacity = 0;
                            
                            _baseRing.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, -80.f, 0.f);
                            _baseRing.layer.opacity = 0;
                            
                        } completion:nil];

    
}

- (void) showInterface {
    
    [UIView animateWithDuration:0.5 animations:^{
        _numbersLabelView.alpha = 1;
    }];
    
    [UIView animateWithDuration:0.5 delay:.1
         usingSpringWithDamping:0.9 initialSpringVelocity:10.0f
                        options:0 animations:^{
                            _trackLabels.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, 0.f, 0.f);
                            _trackLabels.layer.opacity = 1;
                        } completion:nil];
    
    [UIView animateWithDuration:0.5 delay:0
         usingSpringWithDamping:0.9 initialSpringVelocity:10.0f
                        options:0 animations:^{
                            _midiStatusView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, 0.f, 0.f);
                            _midiStatusView.layer.opacity = 1;
                            
                            _progressView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, 0.f, 0.f);
                            _progressView.layer.opacity = 1;
                            
                            _baseRing.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, 0.f, 0.f);
                            _baseRing.layer.opacity = 1;
                        } completion:nil];
}

- (IBAction)showSongsList:(id)sender {
    [self hideInterface];
    
    _songsTableView = [self.storyboard instantiateViewControllerWithIdentifier:@"SongsTableViewController"];
    [self addChildViewController:_songsTableView];
    [self.view addSubview:_songsTableView.view];
    [_songsTableView didMoveToParentViewController:self];
}

- (IBAction)hideSongsList:(id)sender {
    [self showInterface];
    
    UIViewController *vc = (UIViewController *)sender;
    [UIView animateWithDuration:0.75 delay:0.25 options:0 animations:^{
        vc.view.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:nil];
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
        _songsTableView = nil;
    }];
}

- (IBAction)showNewSongDetail:(id)sender {
    
    //UIViewController *vc = (UIViewController *)sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        _songsTableView.view.alpha = 0;
    } completion:^(BOOL finished) {
        _songsTableView.view.hidden = YES;
    }];

    SongDetailTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SongDetailsTableViewController"];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (IBAction)hideNewSongDetail:(id)sender {
    
    _songsTableView.view.hidden = NO;
    _songsTableView.view.alpha = 0;
    
    
    UIViewController *vc = (UIViewController *)sender;
    [UIView animateWithDuration:0.75 delay:0.25 options:0 animations:^{
        vc.view.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:nil];
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
    }];
    
    
    /*
    [UIView animateWithDuration:1.0 delay:0
         usingSpringWithDamping:0.9 initialSpringVelocity:50.0f
                        options:0 animations:^{
                            vc.view.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, 120.f, 0.f);
                            vc.view.layer.opacity = 0;
                            
                        } completion:^(BOOL finished) {
                            [vc didMoveToParentViewController:nil];
                            [vc removeFromParentViewController];
                            [vc.view removeFromSuperview];
                        }];

    */

    [_songsTableView.tableView reloadData];
    [UIView animateWithDuration:0.5 delay:0.25 options:0 animations:^{
        _songsTableView.view.alpha = 1;
    } completion:^(BOOL finished) {
        //UIViewController *vc = (UIViewController *)sender;
        //[vc didMoveToParentViewController:nil];
        //[vc removeFromParentViewController];
        //[vc.view removeFromSuperview];
    }] ;
    
}

- (void) setState:(NSString *)state {
    
    NSLog(@"setState: %@", state);
    
    if (state == Ot8StateNoMIDI) {
        
        [_bpmView setBPM:-1];
        
        _numbersLabelView.hidden = YES;
        _midiStatusView.hidden = NO;
        //_barCountPickerView.hidden = YES;
        
        [self resetStatus];
        [_midiStatusView setWaitingForMIDI];
        [_progressView setWaitingForMIDI];

        [_numbersLabelView hideActiveNumber];
        
        //CFTimeInterval elapsedTime = CACurrentMediaTime() - _timeSinceMIDIConnection;
        //NSLog(@"%f", elapsedTime);
        // After 5 seconds of no MIDI, show the help button
        //if (elapsedTime > 5) {
        //}
        // Make sure the timer is hiding
        [_timerView hideTimer:YES];
        _isFirstRun = NO;
    }
    
    if (state == Ot8StateMIDIConnected) {
        [_midiStatusView setMIDIConnected];
        [_progressView setMIDIConnected];
        _numbersLabelView.hidden = NO;

        _timeSinceMIDIConnection = CACurrentMediaTime();
        
        if (_isFirstRun) {
            [_numbersLabelView showNumber:0 withDuration:_transitionTime];
            [_timerView showTimer:YES];
        } else {
            // Wait for the animation callback instead
        }
        _isFirstRun = NO;
    }
    
    if (state == Ot8StateRunning) {
        _numbersLabelView.hidden = NO;
        _midiStatusView.hidden = YES;
        //_barCountPickerView.hidden = YES;
        _trackLabels.hidden = NO;
    }
    
    if (state == Ot8StateSetBarCount) {
        [UIView animateWithDuration:0.25f animations:^{
            _bpmView.alpha = 0;
            _timerView.alpha = 0;
            _progressView.alpha = 0;
        }];
        [_trackLabels setState:state];
    }
    
    if (state == Ot8StateDefault) {
        [UIView animateWithDuration:0.25f animations:^{
            _progressView.alpha = 1;
            if (_isPlaying) {
                _bpmView.alpha = 1;
                _timerView.alpha = 1;
            }
        }];
        [_trackLabels setState:state];
    }

    
    _state = state;
}

- (void) centerRingScrolledDownPercent:(float)percent {
    NSLog(@"centerRingScrolledDownPercent %f", percent);
    float p = 1 - percent;
    
    _progressView.alpha = p;
    //[_progressView centerRingScrolledDownPercent:percent];
    //_trackLabels.alpha = p;
    [_trackLabels centerRingScrolledDownPercent:percent];

    if (_isPlaying) {
        _bpmView.alpha = p;
        _timerView.alpha = p;
    }
    
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"scrollViewWillEndDragging withVelocity:%f newTarget:%f", velocity.y, targetContentOffset->y);
    NSString *section = Ot8SectionProgress;
    CGFloat height = self.view.bounds.size.height;
    if (targetContentOffset->y == 0) {
        section = Ot8SectionSongs;
    }
    if (targetContentOffset->y == height) {
        section = Ot8SectionProgress;
    }
    if (targetContentOffset->y == (height*2)) {
        section = Ot8SectionBarCount;
    }
    if (_currentSection != section) {
        [self changeToSection:section];
    }
}

- (void) changeToSection:(NSString *)section {
    NSLog(@"changeToSection: %@", section);
    
    
    if (section == Ot8SectionSongs) {

    }
    
    if (section == Ot8SectionProgress) {

    }
    
    if (section == Ot8SectionBarCount) {
        //[_barCountPickerView typeOnString:@"Bar Count"];
    }
    
    _currentSection = section;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat currentPosition = _sectionsScrollView.contentOffset.y;
    CGFloat height = self.view.bounds.size.height;
    CGFloat percentScrolled = 0;
    BOOL isUp = NO;
    if ((currentPosition-_prevScrollPosition) > 0) {
        //NSLog(@"down");
        isUp = NO;
    } else {
        //NSLog(@"up");
        isUp = YES;
    }
    _prevScrollPosition = currentPosition;
    
    // View 1
    percentScrolled = 1-(currentPosition/height);
    _section1View.alpha = percentScrolled;
    
    // View 2
    //CGPoint center = self.view.center;
    //CGPoint p = [_section2View.superview convertPoint:_section2View.center toView:self.view];
    if (isUp && (currentPosition < height)) {
        percentScrolled = currentPosition/(height);
    } else {
        percentScrolled = 1-((currentPosition-height)/(height));
    }
    _section2View.alpha = percentScrolled;
    
    // View 3
    percentScrolled = -1*(1-(currentPosition/height));
    _section3View.alpha = percentScrolled;

    //NSLog(@"scrollViewDidScroll %f", _section3View.alpha);
}


+ (UIFont *) getCornerLabelFont {
    
    float baseSize = [UIScreen mainScreen].bounds.size.width;
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        baseSize = [UIScreen mainScreen].bounds.size.height;
    }

    // iPhone 4 & 5
    float fontSize = 32.0f;
    
    // iPhone 6
    if (baseSize > 370) {
        fontSize = 32.0f;
    }
    
    // iPhone 6+
    if (baseSize > 400) {
        fontSize = 36.0f;
    }
    
    // iPad
    if (baseSize > 760) {
        fontSize = 64.0f;
    }
    
    //NSLog(@"getCornerLabelFont baseSize: %f %f", baseSize, fontSize);

    return [UIFont fontWithName:@"Bryant-RegularCondensed" size:fontSize];
}

+ (CGSize) getCornerLabelMargins {
    
    float baseSize = [UIScreen mainScreen].bounds.size.width;
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        baseSize = [UIScreen mainScreen].bounds.size.height;
    }
    
    float marginX = 14.f;
    float marginY = 7.f;
    
    // iPad
    if (baseSize > 760) {
        marginX = 28;
        marginY = 14;
    }
    
    CGSize margins = CGSizeMake(marginX, marginY);
    return margins;
}

+ (UIFont *) getCenterNumberFont {
    BOOL isLandscape = NO;
    float baseSize = [UIScreen mainScreen].bounds.size.width;
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        baseSize = [UIScreen mainScreen].bounds.size.height;
        isLandscape = YES;
    }
    
    // iPhone 4 & 5
    float fontSize = (isLandscape) ? 140.0 : 150.0;
    
    // iPhone 6
    if (baseSize > 370) {
        fontSize = (isLandscape) ? 180.0 : 200.0;
    }
    
    // iPhone 6+
    if (baseSize > 400) {
        fontSize = (isLandscape) ? 200.0 : 220.0;
    }
    
    // iPad
    if (baseSize > 760) {
        fontSize = (isLandscape) ? 256.0 : 272.0;
    }
    
    fontSize = baseSize * 0.5;

    return [UIFont fontWithName:@"Bryant-LightCondensed" size:fontSize];
}

+ (UIFont *) getCenterNumberFontSmall {
    BOOL isLandscape = NO;
    float baseSize = [UIScreen mainScreen].bounds.size.width;
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        baseSize = [UIScreen mainScreen].bounds.size.height;
        isLandscape = NO;
    }
    
    // iPhone 4 & 5
    float fontSize = (isLandscape) ? 72.f : 72.f;
    
    // iPhone 6
    if (baseSize > 370) {
        fontSize = (isLandscape) ? 72.f : 72.f;
    }
    
    // iPhone 6+
    if (baseSize > 400) {
        fontSize = (isLandscape) ? 72.f : 72.f;
    }
    
    // iPad
    if (baseSize > 760) {
        fontSize = (isLandscape) ? 128.f : 128.f;
    }
    
    return [UIFont fontWithName:@"Bryant-LightCondensed" size:fontSize];
}

+ (float) getCenterNumberOffsetY {
    BOOL isLandscape = NO;
    float baseSize = [UIScreen mainScreen].bounds.size.width;
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        baseSize = [UIScreen mainScreen].bounds.size.height;
        isLandscape = YES;
    }
    
    // iPhone 4 & 5
    float offsetY = 10.0;
    
    // iPhone 6
    if (baseSize > 370) {
        offsetY = (isLandscape) ? 15.0 : 17.0;
    }
    
    // iPhone 6+
    if (baseSize > 400) {
        offsetY = (isLandscape) ? 17.0 : 19.0;
    }
    
    // iPad
    if (baseSize > 760) {
        offsetY = (isLandscape) ? 24.0 : 28.0;
    }

    return offsetY;
}

+ (float) getCenterPickerItemSpacing {
    float spacing = 40.0;
    float baseSize = [UIScreen mainScreen].bounds.size.width;
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        baseSize = [UIScreen mainScreen].bounds.size.height;
    }
    // iPad
    if (baseSize > 760) {
        spacing = 60.0;
    }
    return spacing;
}

+ (NSArray *) barCountNames {
    return @[@"4", @"8", @"16", @"24", @"32", @"40", @"48", @"56", @"64"];
}

+ (NSArray *) barCountValues {
    return @[@(4), @(8), @(16), @(24), @(32), @(40), @(48), @(56), @(64)];
}



@end
