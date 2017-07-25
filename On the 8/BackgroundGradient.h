//
//  BackgroundGradient.h
//  On the 8
//
//  Created by Justin Rhoades on 12/13/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundGradient : UIView

@property (nonatomic) CAGradientLayer *backgroundGradient;
@property (nonatomic) NSArray *backgroundColors;
@property (nonatomic) NSArray *alertColors;

- (void)showColors:(NSArray *)colors withTime:(float)time;


@end
