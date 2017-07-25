//
//  BarCountPickerView.h
//  on the 8
//
//  Created by Justin Rhoades on 2/3/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"
#import "TypeOnView.h"

@interface BarCountPickerView : UIView  <AKPickerViewDataSource, AKPickerViewDelegate>

@property (nonatomic, weak) IBOutlet AKPickerView *picker;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) TypeOnView  *typeOnView;

- (void) typeOnString:(NSString *)string;

@end
