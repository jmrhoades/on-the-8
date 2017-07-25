//
//  SongDetailTextFieldTableViewCell.m
//  On the 8
//
//  Created by Justin Rhoades on 1/28/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "SongDetailTextFieldTableViewCell.h"
#import "StyleKit.h"

@implementation SongDetailTextFieldTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _label.font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:15.f];
    _label.textColor = StyleKit.cellTextColor;
    _separator.backgroundColor = StyleKit.cellSeparatorColor;
    
    _field.font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:24.f];
    _field.textColor = StyleKit.yellow1;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setHeaderText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSKernAttributeName value:@(1.2) range:NSMakeRange(0, attributedString.length)];
    _label.attributedText = attributedString;
}

- (void) setActive {
    /*
    [UIView animateWithDuration:0.5 animations:^{
        _separator.backgroundColor = StyleKit.yellow1;
    }];
    */
}

- (void) setNormal {
    /*
    [UIView animateWithDuration:0.5 animations:^{
        _separator.backgroundColor = StyleKit.cellSeparatorColor;
    }];
    */
}
@end
