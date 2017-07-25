//
//  OptionsSectionHeaderCell.m
//  On the 8
//
//  Created by Justin Rhoades on 1/11/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "OptionsSectionHeaderCell.h"
#import "StyleKit.h"

@interface OptionsSectionHeaderCell ()

@end

@implementation OptionsSectionHeaderCell

- (void)awakeFromNib {
    self.backgroundColor = StyleKit.tableBgColor;
    _sectionHeaderLabel.font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:15.f];
    _sectionHeaderLabel.textColor = StyleKit.cellTextColor;
    _separator.backgroundColor = StyleKit.cellSeparatorColor;
    _separator.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setHeaderText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSKernAttributeName value:@(1.2) range:NSMakeRange(0, attributedString.length)];
    _sectionHeaderLabel.attributedText = attributedString;
}

@end
