//
//  HideSongSegue.m
//  On the 8
//
//  Created by Justin Rhoades on 1/27/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "HideSongSegue.h"
#import "CountdownViewController.h"

@implementation HideSongSegue

- (void)perform
{
    // Add your own animation code here.
    // Add your own animation code here.

    
    double delayInSeconds = .5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CountdownViewController *cvc = (CountdownViewController *)self.destinationViewController;
        [cvc showInterface];
        [[self destinationViewController] dismissViewControllerAnimated:NO completion:nil];
    });
    
}

@end
