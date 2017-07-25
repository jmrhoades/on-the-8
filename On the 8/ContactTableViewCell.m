//
//  ContactTableViewCell.m
//  On the 8
//
//  Created by Justin Rhoades on 1/12/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "StyleKit.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = StyleKit.cellBgColor;
    
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = StyleKit.yellow1;
    
    _separator.backgroundColor = StyleKit.cellSeparatorColor;
    UIFont *font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:19.f];
    _label.font = font;
    _label.textColor = StyleKit.cellTextFieldColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
