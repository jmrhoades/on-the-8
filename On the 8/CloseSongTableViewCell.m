//
//  CloseSongTableViewCell.m
//  On the 8
//
//  Created by Justin Rhoades on 1/26/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "StyleKit.h"
#import "CloseSongTableViewCell.h"

@implementation CloseSongTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    _closeImageView.image = [StyleKit imageOfCloseIconWithFrame:_closeImageView.bounds color:StyleKit.gray1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
