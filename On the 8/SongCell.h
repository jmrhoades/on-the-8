//
//  SongCell.h
//  on the 8
//
//  Created by Justin Rhoades on 2/26/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *ccLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleField;

@end
