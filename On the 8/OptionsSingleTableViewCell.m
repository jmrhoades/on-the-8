//
//  OptionsSingleTableViewCell.m
//  On the 8
//
//  Created by Justin Rhoades on 1/11/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "OptionsSingleTableViewCell.h"
#import "StyleKit.h"

@implementation OptionsSingleTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = StyleKit.cellBgColor;

    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = StyleKit.yellow1;
    
    _topSeparator.backgroundColor = StyleKit.cellSeparatorColor;
    _bottomSeparator.backgroundColor = StyleKit.cellSeparatorColor;
    UIFont *font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:19.f];
    _label.font = font;
    _label.textColor = StyleKit.cellTextFieldColor;
    _chevron.image = [StyleKit imageOfChevronWithColor:StyleKit.cellTextColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
