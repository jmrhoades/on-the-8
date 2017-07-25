//
//  BarCountTableViewCell.h
//  On the 8
//
//  Created by Justin Rhoades on 1/11/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarCountSegmentControl.h"

@interface BarCountTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *separator;
@property (nonatomic, weak) IBOutlet BarCountSegmentControl *barCountControl;

@end
