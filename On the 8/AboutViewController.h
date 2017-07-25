//
//  AboutViewController.h
//  on the 8
//
//  Created by Justin Rhoades on 4/24/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresentedViewControllerDelegate
- (void) didClose;
@end

@interface AboutViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, weak) id delegate;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)Close:(id)sender;


@end
