//
//  SongCell.m
//  on the 8
//
//  Created by Justin Rhoades on 2/26/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "SongCell.h"
#import "StyleKit.h"


@interface SongCell()

@end

@implementation SongCell

- (void)initialize {
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //[self.contentView addGestureRecognizer:tap];
    //self.userInteractionEnabled = YES;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) awakeFromNib {
    NSLog(@"awakeFromNib");
    UIFont *labelFont = [UIFont fontWithName:@"Bryant-RegularCondensed" size:34.f];
    UIColor *labelColor = StyleKit.gray1;
    
    _titleLabel.font = labelFont;
    _titleLabel.textColor = labelColor;
    _titleLabel.hidden = YES;

    _keyLabel.font = labelFont;
    _keyLabel.textColor = labelColor;
    
    _ccLabel.font = labelFont;
    _ccLabel.textColor = labelColor;
    
    _titleField.font = labelFont;
    _titleField.textColor = labelColor;
}



- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
}

- (void) layoutSubviews {
    [super layoutSubviews];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {

    [UIView animateWithDuration:0.33 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
