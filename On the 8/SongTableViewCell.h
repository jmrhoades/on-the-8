//
//  SongTableViewCell.h
//  On the 8
//
//  Created by Justin Rhoades on 1/26/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView     *infoView;
@property (nonatomic, weak) IBOutlet UILabel   *titleValueLabel;
@property (nonatomic, weak) IBOutlet UILabel   *ccHeaderLabel;
@property (nonatomic, weak) IBOutlet UILabel   *ccValueLabel;
@property (nonatomic, weak) IBOutlet UILabel   *keyHeaderLabel;
@property (nonatomic, weak) IBOutlet UILabel   *keyValueLabel;
@property (nonatomic, weak) IBOutlet UILabel   *barHeaderLabel;
@property (nonatomic, weak) IBOutlet UILabel   *barValueLabel;
@property (nonatomic, weak) IBOutlet UIView    *separator;

@end
