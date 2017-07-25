//
//  AddSongTableViewCell.m
//  On the 8
//
//  Created by Justin Rhoades on 1/26/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "AddSongTableViewCell.h"
#import "StyleKit.h"

@implementation AddSongTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    _addImageView.image = [StyleKit imageOfPlusCircleIconWithFrame:_addImageView.bounds color:StyleKit.green];

    _label.font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:24.f];
    _label.textColor = StyleKit.green;
    
    _separator.backgroundColor = StyleKit.cellSeparatorColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
