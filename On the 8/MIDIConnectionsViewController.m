//
//  MIDIConnectionsViewController.m
//  on the 8
//
//  Created by Justin Rhoades on 8/12/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <CoreAudioKit/CoreAudioKit.h>
#import "MIDIConnectionsViewController.h"
#import "StyleKit.h"

@interface MIDIConnectionsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *btPeripheralContainerView;
@property (strong, nonatomic) CABTMIDILocalPeripheralViewController *localPeripheralViewController;

@end

@implementation MIDIConnectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Up Close Button
    CGRect buttonFrame = CGRectMake(0, 0, 24.0, 24.0);
    
    UIImage *imageNormal = [StyleKit imageOfCloseIconWithFrame:buttonFrame color:StyleKit.gray1];
    UIImage *imageHighlighted = [StyleKit imageOfCloseIconWithFrame:buttonFrame color:StyleKit.yellow1];
    [_closeButton setImage:imageNormal forState:UIControlStateNormal];
    [_closeButton setImage:imageHighlighted forState:UIControlStateHighlighted];
    
    _localPeripheralViewController = [CABTMIDILocalPeripheralViewController new];
    [self addChildViewController:_localPeripheralViewController];
    [_btPeripheralContainerView addSubview:_localPeripheralViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)onCloseButtonTap:(id)sender {
    if(self.delegate != nil) {
     [self.delegate didClose];
    }
}

@end
