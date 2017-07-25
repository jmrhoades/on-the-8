//
//  SongsTableViewController.m
//  On the 8
//
//  Created by Justin Rhoades on 1/26/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "SongsTableViewController.h"
#import "StyleKit.h"
#import "CloseSongTableViewCell.h"
#import "AddSongTableViewCell.h"
#import "CountdownViewController.h"
#import "SongDetailTableViewController.h"
#import "ActionTableViewCell.h"
#import "SongTableViewCell.h"

static NSString * const CloseCellIdentifier      = @"CloseCell";
static NSString * const AddSongCellIdentifier    = @"AddSongCell";
static NSString * const SongCellIdentifier    = @"SongCell";


@interface SongsTableViewController ()

@property (nonatomic) BOOL      isFirstShow;

@end

@implementation SongsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _isFirstShow = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rows = 2;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *songsArray = [[defaults arrayForKey:@"songsList"] mutableCopy];
    rows = rows + songsArray.count;
    
    /*
    float rowHeight = [self getTableCellHeight];
    float yOffset = (self.tableView.bounds.size.height - (rows * rowHeight)) / 2;
    if (yOffset > 0) {
        self.tableView.contentOffset = CGPointMake(0.0, -yOffset);
    }
    */
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    NSInteger numRows = [self.tableView numberOfRowsInSection:0];

    if (indexPath.row == numRows-2) {
        cell = [tableView dequeueReusableCellWithIdentifier:AddSongCellIdentifier forIndexPath:indexPath];
    } else if (indexPath.row == numRows-1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CloseCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:SongCellIdentifier forIndexPath:indexPath];
    }

    return cell;
}

- (float) getTableCellHeight {
    float rowHeight = 128.0;
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getTableCellHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger numRows = [self.tableView numberOfRowsInSection:0];


    if (indexPath.row == numRows-2) {
        ActionTableViewCell *actionCell = (ActionTableViewCell *)cell;
        actionCell.icon.image = [StyleKit imageOfAddSongIconWithFrame:actionCell.icon.bounds color:StyleKit.green];
    } else if (indexPath.row == numRows-1) {

    } else {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *songsArray = [[defaults arrayForKey:@"songsList"] mutableCopy];
        NSDictionary *song = songsArray[indexPath.row];

        SongTableViewCell *songCell = (SongTableViewCell *)cell;
        songCell.titleValueLabel.text = song[@"title"];
        songCell.ccValueLabel.text = [NSString stringWithFormat:@"%@", song[@"cc"]];
        songCell.keyValueLabel.text = song[@"key"];
        songCell.barValueLabel.text = [NSString stringWithFormat:@"%@", song[@"bar"]];
      
    }
    


    if (_isFirstShow) {
    // Animate
    cell.layer.opacity = 0;
    cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, 80.f, 0.f);
    
    [UIView animateWithDuration:0.5 delay:indexPath.row * 0.1f
         usingSpringWithDamping:0.9 initialSpringVelocity:10.0f
                        options:0 animations:^{
                            cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, 0.f, 0.f);
                            cell.layer.opacity = 1;

                        } completion:nil];
    }
    
    _isFirstShow = NO;
    
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger numRows = [self.tableView numberOfRowsInSection:0];

    if (indexPath.row == numRows-2) {
        CountdownViewController *countdownViewController = (CountdownViewController *)([[UIApplication sharedApplication] delegate]).window.rootViewController;
        [countdownViewController showNewSongDetail:self];
    }
    else if (indexPath.row == numRows-1) {
        
        NSInteger rows = [self tableView:self.tableView numberOfRowsInSection:0];
        for (NSInteger i=0; i < rows; i++) {
            NSUInteger indexArray[] = {0,rows-i-1};
            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexArray length:2];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [UIView animateWithDuration:0.5 delay:i*0.1f
                 usingSpringWithDamping:0.9 initialSpringVelocity:10.0f
                                options:0 animations:^{
                                    cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, 120.f, 0.f);
                                    cell.layer.opacity = 0;
                                    
                                } completion:nil];
        }

        
        
        CountdownViewController *countdownViewController = (CountdownViewController *)([[UIApplication sharedApplication] delegate]).window.rootViewController;
        [countdownViewController hideSongsList:self];
    } else {
        
    }
}




@end
