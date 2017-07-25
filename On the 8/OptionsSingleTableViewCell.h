//
//  OptionsSingleTableViewCell.h
//  On the 8
//
//  Created by Justin Rhoades on 1/11/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsSingleTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel     *label;
@property (nonatomic, weak) IBOutlet UIView      *topSeparator;
@property (nonatomic, weak) IBOutlet UIView      *bottomSeparator;
@property (nonatomic, weak) IBOutlet UIImageView *chevron;

@end
