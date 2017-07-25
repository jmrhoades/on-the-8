//
//  SongDetailTextFieldTableViewCell.h
//  On the 8
//
//  Created by Justin Rhoades on 1/28/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongDetailTextFieldTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *field;
@property (nonatomic, weak) IBOutlet UILabel     *label;
@property (nonatomic, weak) IBOutlet UIView      *separator;
- (void) setHeaderText:(NSString *)text;
- (void) setActive;
- (void) setNormal;
@end
