//
//  CenterRing.h
//  on the 8
//
//  Created by Justin Rhoades on 2/4/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRing.h"

@interface CenterRing : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView    *scrollView;

@property (nonatomic) CAShapeLayer *maskShape;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;

@end
