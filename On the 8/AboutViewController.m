//
//  AboutViewController.m
//  on the 8
//
//  Created by Justin Rhoades on 4/24/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "AboutViewController.h"
#import "StyleKit.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Up Close Button
    CGRect buttonFrame = CGRectMake(0, 0, 24.0, 24.0);

    UIImage *imageNormal = [StyleKit imageOfCloseIconWithFrame:buttonFrame color:StyleKit.gray0];
    UIImage *imageHighlighted = [StyleKit imageOfCloseIconWithFrame:buttonFrame color:StyleKit.yellow1];
    [_closeButton setImage:imageNormal forState:UIControlStateNormal];
    [_closeButton setImage:imageHighlighted forState:UIControlStateHighlighted];
    
    /*
    // Set Up About Text
    UIFont *font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:24.f];
    UIColor *color = [UIColor colorWithWhite:1.0 alpha:0.75];
    _aboutLabel.font = font;
    _aboutLabel.textColor = color;
     */
    
    /*
     Set line height for about text
    */
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineSpacing:6.0];
    NSDictionary *attributes = @{ NSFontAttributeName:_aboutLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_aboutLabel.text attributes:attributes];
    [_aboutLabel setAttributedText: attributedString];
    
    /* 
     Color "justin rhoades' portion of contact label
    */
    attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_contactLabel.text attributes:attributes];
    NSRange range = [_contactLabel.text rangeOfString:@"Justin Rhoades"];
    if (range.location != NSNotFound) {
        UIColor *color = StyleKit.yellow1;
        [string beginEditing];
        [string addAttribute:NSForegroundColorAttributeName value:color range:range];
        [string endEditing];
    }
    _contactLabel.attributedText = string;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_contactLabel addGestureRecognizer:tap];
    _contactLabel.userInteractionEnabled = YES;
    
    
    // Set up webview
    _webView.delegate = self;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [mainBundle URLForResource:@"info_view" withExtension:@"html"];
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlReq];
    
    //_webView.alpha = 0;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //NSLog(@"HI");
}

- (IBAction)Close:(id)sender {
    [self.delegate didClose];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //NSLog(@"webViewDidFinishLoad");
    [UIView animateWithDuration:0.33f animations:^{
        _webView.alpha = 1.0f;
    }];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
