//
//  BarCountTableViewCell.m
//  On the 8
//
//  Created by Justin Rhoades on 1/11/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "BarCountTableViewCell.h"
#import "StyleKit.h"

@implementation BarCountTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = StyleKit.cellBgColor;
    _separator.backgroundColor = StyleKit.cellSeparatorColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
