//
//  ActionTableViewCell.h
//  On the 8
//
//  Created by Justin Rhoades on 2/1/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet UIView      *separator;

@end
