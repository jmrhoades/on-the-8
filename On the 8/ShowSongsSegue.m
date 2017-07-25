//
//  ShowSongsSegue.m
//  On the 8
//
//  Created by Justin Rhoades on 1/26/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "ShowSongsSegue.h"
#import "CountdownViewController.h"

@implementation ShowSongsSegue

- (void)perform
{
    // Add your own animation code here.
    CountdownViewController *cvc = (CountdownViewController *)self.sourceViewController;
    [cvc hideInterface];
    
    double delayInSeconds = .5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.sourceViewController presentModalViewController:self.destinationViewController animated:NO];
    });
}

@end
