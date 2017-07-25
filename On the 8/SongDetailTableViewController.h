//
//  SongDetailTableViewController.h
//  On the 8
//
//  Created by Justin Rhoades on 1/28/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "AKPickerView.h"
#import <UIKit/UIKit.h>

@interface SongDetailTableViewController : UITableViewController <UITextFieldDelegate, AKPickerViewDelegate>

@property (nonatomic, strong) NSMutableSet *shownIndexes;

@end
