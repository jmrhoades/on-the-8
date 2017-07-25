//
//  ActionTableViewCell.m
//  On the 8
//
//  Created by Justin Rhoades on 2/1/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "StyleKit.h"
#import "ActionTableViewCell.h"

@implementation ActionTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    _separator.backgroundColor = StyleKit.cellSeparatorColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
