//
//  AppDelegate.m
//  On the 8
//
//  Created by Justin Rhoades on 9/19/14.
//  Copyright (c) 2014 Justin Rhoades. All rights reserved.
//

#import "AppDelegate.h"
#import "StyleKit.h"
#import "Song.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIFont *font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:21.f];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{ NSFontAttributeName:font, NSForegroundColorAttributeName:StyleKit.navBarTitleColor }];
    [[UINavigationBar appearance] setBarTintColor:StyleKit.navBarBgColor];

    NSDictionary *textAttributes = @{ NSFontAttributeName:font, NSForegroundColorAttributeName:StyleKit.yellow1 };
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, -1000) forBarMetrics:UIBarMetricsDefault];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    /*
    NSArray *songs = [defaults arrayForKey:@"songs"];
    if (songs == nil) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for(int i=0; i<128; i++) {
            [tempArray addObject:@{@"title": @"", @"key": @""}];
        }
        [defaults setValue:tempArray forKey:@"songs"];
        [defaults synchronize];
    }
    */
    
    NSArray *songsList = [defaults arrayForKey:@"songsList"];
    if (songsList == nil) {
        NSMutableArray *songsListArray = [[NSMutableArray alloc] init];
        [defaults setValue:songsListArray forKey:@"songsList"];
        [defaults synchronize];
    }
    
    NSString *barCountUnit = [defaults stringForKey:@"barCountUnit"];
    if (barCountUnit == nil) {
        [defaults setValue:@"1" forKey:@"barCountUnit"];
        [defaults synchronize];
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
