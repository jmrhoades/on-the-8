//
//  SongDetailPickerTableViewCell.m
//  On the 8
//
//  Created by Justin Rhoades on 2/1/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "SongDetailPickerTableViewCell.h"

@implementation SongDetailPickerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.field.hidden = YES;
    
    _picker.dataSource = self;
    
    _picker.font = self.field.font;
    _picker.highlightedFont = self.field.font;
    _picker.interitemSpacing = 20.0;
    _picker.fisheyeFactor = 0.001;
    _picker.pickerViewStyle = AKPickerViewStyle3D;
    
    /*
    self.titles = @[@"1",
                    @"2",
                    @"3",
                    @"4",
                    @"5",
                    @"6",
                    @"7",
                    @"8",
                    @"9",
                    @"10"];
    
    [_picker reloadData];
    */

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {
    return [self.titles count];
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item {
    return self.titles[item];
}

/*
 - (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
 {
	return [UIImage imageNamed:self.titles[item]];
 }
 */


@end
