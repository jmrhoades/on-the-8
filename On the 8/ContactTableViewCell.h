//
//  ContactTableViewCell.h
//  On the 8
//
//  Created by Justin Rhoades on 1/12/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel     *label;
@property (nonatomic, weak) IBOutlet UIView      *separator;
@property (nonatomic, weak) IBOutlet UIImageView *image;

@end
