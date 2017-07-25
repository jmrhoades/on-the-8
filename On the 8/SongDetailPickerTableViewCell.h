//
//  SongDetailPickerTableViewCell.h
//  On the 8
//
//  Created by Justin Rhoades on 2/1/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "SongDetailTextFieldTableViewCell.h"
#import "AKPickerView.h"
#import <UIKit/UIKit.h>

@interface SongDetailPickerTableViewCell : SongDetailTextFieldTableViewCell <AKPickerViewDataSource>

@property (nonatomic, weak) IBOutlet AKPickerView *picker;
@property (nonatomic, strong) NSArray *titles;

@end
