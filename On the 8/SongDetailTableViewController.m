//
//  SongDetailTableViewController.m
//  On the 8
//
//  Created by Justin Rhoades on 1/28/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "SongDetailTableViewController.h"
#import "StyleKit.h"
#import "SongDetailTextFieldTableViewCell.h"
#import "AddSongTableViewCell.h"
#import "StyleKit.h"
#import "CountdownViewController.h"
#import "SongDetailPickerTableViewCell.h"
#import "ActionTableViewCell.h"

@interface SongDetailTableViewController ()

@property (nonatomic, strong) SongDetailTextFieldTableViewCell *activeDetailCell;


@end

@implementation SongDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shownIndexes = [NSMutableSet set];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SongDetailTextFieldTableViewCell *labelCell = (SongDetailTextFieldTableViewCell *)cell;
        [labelCell setHeaderText:@"TITLE"];
        labelCell.field.text = @"Untitled";
    }
    if (indexPath.row == 1) {
        SongDetailTextFieldTableViewCell *labelCell = (SongDetailTextFieldTableViewCell *)cell;
        [labelCell setHeaderText:@"KEY"];
        labelCell.field.text = @"C";
    }
    if (indexPath.row == 2) {
        SongDetailPickerTableViewCell *pickerCell = (SongDetailPickerTableViewCell *)cell;
        [pickerCell setHeaderText:@"BAR"];
        pickerCell.picker.delegate = self;
        pickerCell.titles = @[@"4", @"8", @"16", @"24", @"32", @"40", @"48", @"56", @"64"];
        [pickerCell.picker reloadData];
    }
    if (indexPath.row == 3) {
        SongDetailPickerTableViewCell *pickerCell = (SongDetailPickerTableViewCell *)cell;
        [pickerCell setHeaderText:@"CC1"];
        pickerCell.picker.delegate = self;
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for(int i=0; i<128; i++) {
            [tempArray addObject:[NSString stringWithFormat:@"%i", i+1]];
        }
        pickerCell.titles = tempArray;
        [pickerCell.picker reloadData];
    }
    if (indexPath.row == 4) {
        ActionTableViewCell *saveButton = (ActionTableViewCell *)cell;
        saveButton.icon.image = [StyleKit imageOfSaveCircleIconWithFrame:saveButton.icon.bounds color:StyleKit.green];
    }
    
    if (![self.shownIndexes containsObject:indexPath]) {
        [self.shownIndexes addObject:indexPath];
    cell.layer.opacity = 0;
    cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, 80.f, 0.f);
    [UIView animateWithDuration:0.5 delay:indexPath.row * 0.1f
         usingSpringWithDamping:0.9 initialSpringVelocity:10.0f
                        options:0 animations:^{
                            cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.f, 0.f, 0.f);
                            cell.layer.opacity = 1;
                            
                        } completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 128.0;
    return height;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        SongDetailTextFieldTableViewCell *songDetailCell = (SongDetailTextFieldTableViewCell *)cell;
        [self setActiveDetailCell:songDetailCell];
    }
    
    if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        SongDetailTextFieldTableViewCell *songDetailCell = (SongDetailTextFieldTableViewCell *)cell;
        [self setActiveDetailCell:songDetailCell];
    }
    
    /*
    if (indexPath.row == 2) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        SongDetailTextFieldTableViewCell *songDetailCell = (SongDetailTextFieldTableViewCell *)cell;
        [self setActiveDetailCell:songDetailCell];
    }
    
    if (indexPath.row == 3) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        SongDetailTextFieldTableViewCell *songDetailCell = (SongDetailTextFieldTableViewCell *)cell;
        [self setActiveDetailCell:songDetailCell];
    }
     */
    
    if (indexPath.row == 4) {
        
        NSUInteger indexArray[] = {0,0};
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexArray length:2];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        SongDetailTextFieldTableViewCell *titleCell = (SongDetailTextFieldTableViewCell *)cell;
        NSString *title = titleCell.field.text;
        
        NSUInteger indexArrayB[] = {0,1};
        indexPath = [NSIndexPath indexPathWithIndexes:indexArrayB length:2];
        UITableViewCell *cellB = [self.tableView cellForRowAtIndexPath:indexPath];
        SongDetailTextFieldTableViewCell *keyCell = (SongDetailTextFieldTableViewCell *)cellB;
        NSString *key = keyCell.field.text;
        
        NSUInteger indexArrayC[] = {0,2};
        indexPath = [NSIndexPath indexPathWithIndexes:indexArrayC length:2];
        UITableViewCell *cellC = [self.tableView cellForRowAtIndexPath:indexPath];
        SongDetailPickerTableViewCell *ccCell = (SongDetailPickerTableViewCell *)cellC;
        NSNumber *cc = [NSNumber numberWithUnsignedInteger:ccCell.picker.selectedItem];
        
        NSUInteger indexArrayD[] = {0,3};
        indexPath = [NSIndexPath indexPathWithIndexes:indexArrayD length:2];
        UITableViewCell *cellD = [self.tableView cellForRowAtIndexPath:indexPath];
        SongDetailPickerTableViewCell *barCell = (SongDetailPickerTableViewCell *)cellD;
        NSNumber *bar = [NSNumber numberWithUnsignedInteger:barCell.picker.selectedItem];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *songsArray = [[defaults arrayForKey:@"songsList"] mutableCopy];
        [songsArray addObject:@{@"title": title, @"key": key, @"bar":bar, @"cc":cc}];
        [defaults setValue:songsArray forKey:@"songsList"];
        [defaults synchronize];
        
        CountdownViewController *countdownViewController = (CountdownViewController *)([[UIApplication sharedApplication] delegate]).window.rootViewController;
        [countdownViewController hideNewSongDetail:self];
    }
    
    if (indexPath.row == 5) {
        
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
        [countdownViewController hideNewSongDetail:self];
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        SongDetailTextFieldTableViewCell *songDetailCell = (SongDetailTextFieldTableViewCell *)cell;
        //[self setActiveDetailCell:songDetailCell];
        [songDetailCell setNormal];
        [songDetailCell.field resignFirstResponder];
    }
    
    if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        SongDetailTextFieldTableViewCell *songDetailCell = (SongDetailTextFieldTableViewCell *)cell;
        //[self setActiveDetailCell:songDetailCell];
        [songDetailCell setNormal];
        [songDetailCell.field resignFirstResponder];
    }
    
    return indexPath;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate (set in Interface Builder)

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //NSUInteger indexArray[] = {0,textField.tag};
    //NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexArray length:2];
    //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //SongDetailTextFieldTableViewCell *songDetailCell = (SongDetailTextFieldTableViewCell *)cell;
    //[self setActiveDetailCell:songDetailCell];

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    
}

#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {
    NSLog(@"Picker: %ld", (long)item);
}

- (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item {
	label.textColor = StyleKit.gray1;
	label.highlightedTextColor = StyleKit.yellow1;
}

/*
 - (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item {
	return CGSizeMake(40, 20);
 }
*/


#pragma mark - Random stuff

- (void) setActiveDetailCell:(SongDetailTextFieldTableViewCell *) cell {
    /*
    if (cell != _activeDetailCell) {
        if (_activeDetailCell != nil) {
            //[_activeDetailCell setNormal];
        }
        _activeDetailCell = cell;
        [_activeDetailCell setActive];
        [_activeDetailCell.field becomeFirstResponder];
    }
     */
    
    [cell.field becomeFirstResponder];
}


@end
