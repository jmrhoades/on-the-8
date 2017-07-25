//
//  SongTableViewCell.m
//  On the 8
//
//  Created by Justin Rhoades on 1/26/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "StyleKit.h"
#import "SongTableViewCell.h"

@implementation SongTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _separator.backgroundColor = StyleKit.cellSeparatorColor;
    
    _titleValueLabel.font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:24.f];
    _titleValueLabel.textColor = StyleKit.gray0;
    
    _ccHeaderLabel.font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:15.f];
    _ccHeaderLabel.textColor = StyleKit.cellTextColor;
    _keyHeaderLabel.font = _ccHeaderLabel.font;
    _keyHeaderLabel.textColor = _ccHeaderLabel.textColor;
    _barHeaderLabel.font = _ccHeaderLabel.font;
    _barHeaderLabel.textColor = _ccHeaderLabel.textColor;
    
    _ccValueLabel.font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:19.f];
    _ccValueLabel.textColor = StyleKit.gray0;
    _keyValueLabel.font = _ccValueLabel.font;
    _keyValueLabel.textColor = _ccValueLabel.textColor;
    _barValueLabel.font = _ccValueLabel.font;
    _barValueLabel.textColor = _ccValueLabel.textColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
