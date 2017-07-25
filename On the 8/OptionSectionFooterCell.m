//
//  OptionSectionFooterCell.m
//  On the 8
//
//  Created by Justin Rhoades on 1/12/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "OptionSectionFooterCell.h"
#import "StyleKit.h"

@implementation OptionSectionFooterCell

- (void)awakeFromNib {
    self.backgroundColor = StyleKit.tableBgColor;
    _label.font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:17.f];
    _label.textColor = StyleKit.cellTextColor;
    _separator.backgroundColor = StyleKit.tableBgColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
