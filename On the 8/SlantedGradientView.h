//
//  SlantedGradientView.h
//  On the 8
//
//  Created by Justin Rhoades on 10/14/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface SlantedGradientView : UIView

@property (nonatomic) IBInspectable UIColor *topColor;
@property (nonatomic) IBInspectable UIColor *bottomColor;
@property (nonatomic) IBInspectable NSInteger slantType;

@end
