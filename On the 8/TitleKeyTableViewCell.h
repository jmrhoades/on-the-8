//
//  TitleKeyTableViewCell.h
//  On the 8
//
//  Created by Justin Rhoades on 1/8/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleKeyTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *ccValueLabel;

@property (nonatomic, weak) IBOutlet UITextField *songTitleTextField;
@property (nonatomic, weak) IBOutlet UITextField *keyTextField;

@property (nonatomic, weak) IBOutlet UIView *ccValueSeparator;
@property (nonatomic, weak) IBOutlet UIView *keySeparator;
@property (nonatomic, weak) IBOutlet UIView *bottomSeparator;

@end
