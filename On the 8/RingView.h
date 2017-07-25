//
//  RingView.h
//  On the 8
//
//  Created by Justin Rhoades on 12/13/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RingView : UIView

@property (nonatomic) float baseSize;
@property (nonatomic) float margin;
@property (nonatomic) float lineWidth;

@property (nonatomic) CGRect ringBounds;
@property (nonatomic) float ringX;
@property (nonatomic) float ringY;
@property (nonatomic) CGRect ringFrame;

@end
