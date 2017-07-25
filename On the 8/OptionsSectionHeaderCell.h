//
//  OptionsSectionHeaderCell.h
//  On the 8
//
//  Created by Justin Rhoades on 1/11/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsSectionHeaderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *sectionHeaderLabel;
@property (nonatomic, weak) IBOutlet UIView  *separator;

- (void) setHeaderText:(NSString *)text;

@end
