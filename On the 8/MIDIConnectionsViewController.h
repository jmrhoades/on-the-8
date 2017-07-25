//
//  MIDIConnectionsViewController.h
//  on the 8
//
//  Created by Justin Rhoades on 8/12/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresentedViewControllerDelegate
- (void) didClose;
@end

@interface MIDIConnectionsViewController : UIViewController

@property (nonatomic, weak) id delegate;

@end
