//
//  AccentView.h
//  On the 8
//
//  Created by Justin Rhoades on 1/14/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccentView : UIView

@property (nonatomic, strong) CAGradientLayer *gradient;
@property (nonatomic) NSArray *colors;

- (void) fadeOut:(float)duration;
- (void) fadeIn:(float)duration;

@end
