//
//  TypeOnView.h
//  On the 8
//
//  Created by Justin Rhoades on 1/15/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeOnView : UIView

@property (nonatomic, strong) UILabel *label;

- (void) typeOnString:(NSString *)string;
- (void) setRightAlignment;


@end
