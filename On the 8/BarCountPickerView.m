//
//  BarCountPickerView.m
//  on the 8
//
//  Created by Justin Rhoades on 2/3/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "CountdownViewController.h"
#import "BarCountPickerView.h"
#import "AKPickerView.h"
#import "StyleKit.h"


@implementation BarCountPickerView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _picker.dataSource = self;
    _picker.fisheyeFactor = 0.001;
    //_picker.pickerViewStyle = AKPickerViewStyle3D;
    _picker.pickerViewStyle = AKPickerViewStyleFlat;
    _picker.delegate = self;
    _titles = [CountdownViewController barCountNames];
    [_picker reloadData];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults valueForKey:@"barCountUnit"];
    NSLog(@"BarCountPickerView awakeFromNib value: %@", value);
    [_picker selectItem:value.intValue animated:NO];
}



- (void)layoutSubviews {
    
    [super layoutSubviews];
    _picker.font = [CountdownViewController getCenterNumberFontSmall];
    _picker.highlightedFont = [CountdownViewController getCenterNumberFontSmall];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.ty = [CountdownViewController getCenterNumberOffsetY];
    _picker.transform = transform;
    _picker.interitemSpacing = [CountdownViewController getCenterPickerItemSpacing];
    
    CGSize margins = [CountdownViewController getCornerLabelMargins];
    CGFloat marginX = margins.width;
    CGFloat marginY = margins.height;
    UIFont *labelFont = [CountdownViewController getCornerLabelFont];
    CGFloat labelHeight = labelFont.pointSize;
    CGFloat labelWidth = self.bounds.size.width;
    if (_typeOnView == nil) {
        _typeOnView = [TypeOnView new];
        [self addSubview:_typeOnView];
    }
    CGRect topLeftLabelFrame = CGRectMake(marginX, marginY, labelWidth, labelHeight);
    _typeOnView.frame = topLeftLabelFrame;
    _typeOnView.label.font = labelFont;
    _typeOnView.label.text = @"Bar Count";
    _typeOnView.label.textColor = StyleKit.yellow1;

}

- (void) typeOnString:(NSString *)string {
    [_typeOnView typeOnString:string];
}


#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {
    return [self.titles count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item {
    return self.titles[item];
}

/*
 - (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
 {
	return [UIImage imageNamed:self.titles[item]];
 }
 */


#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {
    NSLog(@"Picker: %ld", (long)item);
    
    CountdownViewController *countdownViewController = (CountdownViewController *)([[UIApplication sharedApplication] delegate]).window.rootViewController;
    [countdownViewController updateBarCountUnit:item];
}

- (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item {
    label.textColor = StyleKit.gray1;
    label.highlightedTextColor = StyleKit.yellow1;
}

/*
 - (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item {
 return CGSizeMake(0, 0);

 }
*/

@end
