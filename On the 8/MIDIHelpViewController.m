//
//  MIDIHelpViewController.m
//  On the 8
//
//  Created by Justin Rhoades on 12/19/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "MIDIHelpViewController.h"

@interface MIDIHelpViewController ()

@end

@implementation MIDIHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = FALSE;
    [self loadHelpURL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.modalPresentationStyle = UIModalPresentationFormSheet;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadHelpURL {
    NSURL *requestURL = [NSURL URLWithString:@"http://nojesus.net/onthe8/midihelp/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [_webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // Report the error inside the web view.
    NSString *localizedErrorMessage = NSLocalizedString(@"An error occured:", nil);
    NSString *errorFormatString = @"<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">%@%@</div></body></html>";
    NSString *errorHTML = [NSString stringWithFormat:errorFormatString, localizedErrorMessage, error.localizedDescription];
    [_webView loadHTMLString:errorHTML baseURL:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
