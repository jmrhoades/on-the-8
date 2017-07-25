//
//  TitleKeyTableViewCell.m
//  On the 8
//
//  Created by Justin Rhoades on 1/8/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "TitleKeyTableViewCell.h"
#import "StyleKit.h"

@implementation TitleKeyTableViewCell

- (void)awakeFromNib {
        
    UIFont *font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:19.f];
    
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = StyleKit.yellow1;
    
    // Labels
    _ccValueLabel.font = font;
    _ccValueLabel.textColor = StyleKit.cellTextFieldColor;
    
    // Text Fields
    _songTitleTextField.font = font;
    _songTitleTextField.textColor = StyleKit.cellTextFieldColor;
    
    _keyTextField.font = font;
    _keyTextField.textColor = StyleKit.cellTextFieldColor;

    // Separators
    _ccValueSeparator.backgroundColor = StyleKit.cellSeparatorColor;
    _keySeparator.backgroundColor = StyleKit.cellSeparatorColor;
    _bottomSeparator.backgroundColor = StyleKit.cellSeparatorColor;
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
*/




@end
