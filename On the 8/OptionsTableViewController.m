//
//  OptionsTableViewController.m
//  On the 8
//
//  Created by Justin Rhoades on 1/8/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "OptionsTableViewController.h"
#import "StyleKit.h"
#import "TitleKeyTableViewCell.h"
#import "BarCountSegmentControl.h"
#import "OptionsSectionHeaderCell.h"
#import "BarCountTableViewCell.h"
#import "OptionsSingleTableViewCell.h"
#import "OptionSectionFooterCell.h"
#import "AppDelegate.h"
#import "CountdownViewController.h"


static NSString * const BarCountCellIdentifier      = @"BarCountCell";
static NSString * const TitleKeyCellIdentifier      = @"TitleKeyCell";
static NSString * const SectionHeaderCellIdentifier = @"SectionHeaderCell";
static NSString * const SectionFooterCellIdentifier = @"SectionFooterCell";
static NSString * const OptionsSingleCellIdentifier = @"OptionsSingleCell";

@interface OptionsTableViewController ()

@property (nonatomic, weak) IBOutlet UIView *tableFooterView;
@property (nonatomic, weak) IBOutlet UIImageView *njLogo;
@property (nonatomic, weak) IBOutlet BarCountSegmentControl *barCountControl;
@property NSMutableArray *songArray;

@end

@implementation OptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = StyleKit.tableBgColor;
    
    _tableFooterView.backgroundColor = StyleKit.tableBgColor;
    self.tableView.tableFooterView = _tableFooterView;
    _njLogo.image = [StyleKit imageOfNJLogoWithFrame:CGRectMake(0, 0, 100.0, 20.0)];
    _njLogo.userInteractionEnabled = YES;
    UITapGestureRecognizer *njLinkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(njLinkTapped:)];
    [_njLogo addGestureRecognizer:njLinkTap];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.songArray = [[defaults arrayForKey:@"songs"] mutableCopy];
}

- (void)njLinkTapped:(UITapGestureRecognizer *)gesture {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://nojesus.net"]];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 1;
    if (section == 1) {
        //rows = 9;
        rows = self.songArray.count;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        BarCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BarCountCellIdentifier forIndexPath:indexPath];
        cell.barCountControl.delegate = self;
        return cell;
    }

    if (indexPath.section == 1) {
        TitleKeyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TitleKeyCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    if (indexPath.section == 2) {
        OptionsSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OptionsSingleCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        BarCountTableViewCell *barCountCell = (BarCountTableViewCell *)cell;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [barCountCell.barCountControl setActiveSegment:[defaults integerForKey:@"barCountUnit"]];
    }
    
    if (indexPath.section == 1) {
        TitleKeyTableViewCell *titleKeyCell = (TitleKeyTableViewCell *)cell;
        if (indexPath.row%2 == 0) {
            titleKeyCell.backgroundColor = StyleKit.cellBgAltColor;
        } else {
            titleKeyCell.backgroundColor = StyleKit.cellBgColor;
        }
        if (indexPath.row == 0) {
            titleKeyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            titleKeyCell.ccValueLabel.text = @"CC1";
            titleKeyCell.ccValueLabel.textColor = StyleKit.cellTextColor;
            titleKeyCell.keyTextField.text = @"Key";
            titleKeyCell.keyTextField.enabled = NO;
            titleKeyCell.keyTextField.textColor = StyleKit.cellTextColor;
            titleKeyCell.songTitleTextField.text = @"Title";
            titleKeyCell.songTitleTextField.enabled = NO;
            titleKeyCell.songTitleTextField.textColor = StyleKit.cellTextColor;
        } else {
            NSDictionary *song = _songArray[indexPath.row];
            titleKeyCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            titleKeyCell.ccValueLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
            titleKeyCell.ccValueLabel.textColor = StyleKit.yellow1;
            titleKeyCell.songTitleTextField.enabled = YES;
            titleKeyCell.songTitleTextField.textColor = StyleKit.cellTextFieldColor;
            titleKeyCell.songTitleTextField.text = song[@"title"];
            titleKeyCell.songTitleTextField.tag = indexPath.row;
            titleKeyCell.keyTextField.enabled = YES;
            titleKeyCell.keyTextField.textColor = StyleKit.cellTextFieldColor;
            titleKeyCell.keyTextField.text = song[@"key"];
            titleKeyCell.keyTextField.tag = indexPath.row;
        }
    }
    
    if (indexPath.section == 2) {
        OptionsSingleTableViewCell *aboutCell = (OptionsSingleTableViewCell *)cell;
        aboutCell.label.text = @"About";
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 0;
    if (indexPath.section == 0) {
        return 90.f;
    }
    if (indexPath.section == 1) {
        return 48.f;
    }
    if (indexPath.section == 2) {
        return 48.f;
    }
    return height;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row != 0) {
            //[tableView deselectRowAtIndexPath:indexPath animated:YES];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            TitleKeyTableViewCell *titleKeyCell = (TitleKeyTableViewCell *)cell;
            CountdownViewController *countdownViewController = (CountdownViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
            [countdownViewController updateTitleLabel:titleKeyCell.songTitleTextField.text keyLabel:titleKeyCell.keyTextField.text];
            [self performSegueWithIdentifier:@"unwindSegue" sender:self];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        OptionsSectionHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:SectionHeaderCellIdentifier];
        [headerCell setHeaderText:@"BAR COUNT"];
        return headerCell;
    }
    if (section == 1) {
        OptionsSectionHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:SectionHeaderCellIdentifier];
        [headerCell setHeaderText:@"SONGS"];
        return headerCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    float height = 0;
    if (section == 0) {
        height = 56.0;
    }
    if (section == 1) {
        height = 56.0;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        OptionSectionFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionFooterCellIdentifier];
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineSpacing:2.0];
        NSDictionary *attributes = @{ NSFontAttributeName:cell.label.font, NSParagraphStyleAttributeName:paragraphStyle};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:cell.label.text attributes:attributes];
        [cell.label setAttributedText: attributedString];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    float height = 0;
    if (section == 1) {
        OptionSectionFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionFooterCellIdentifier];
        CGSize constraint = CGSizeMake(self.tableView.bounds.size.width-30.f,CGFLOAT_MAX);
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:cell.label.text attributes:@{NSFontAttributeName:cell.label.font}];
        CGRect rect = [attributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize size = rect.size;
        height = ceilf(size.height) + 12.0 + 32.0;
    }
    return height;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate (set in Interface Builder)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%ld", (long)textField.tag);
    NSLog(@"%f", textField.bounds.size.width);
    
    NSDictionary *song = _songArray[textField.tag];
    NSDictionary *updatedSong;

    float fieldWidth = textField.bounds.size.width;
    if (fieldWidth < 80) {
        updatedSong = @{@"title":[song valueForKey:@"title"], @"key": textField.text};
    } else {
        updatedSong = @{@"title":textField.text, @"key": [song valueForKey:@"key"]};
    }
    [_songArray removeObjectAtIndex:textField.tag];
    [_songArray insertObject:updatedSong atIndex:textField.tag];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:_songArray forKey:@"songs"];
    [defaults synchronize];
}

#pragma mark - BarCountSegmentControlDelegate

- (void) segmentTapped:(NSInteger)tag {
    NSLog(@"segmentTapped %li", (long)tag);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:tag forKey:@"barCountUnit"];
    [defaults synchronize];
    
    CountdownViewController *countdownViewController = (CountdownViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    [countdownViewController updateBarCountUnit:tag];
    
    //[self performSegueWithIdentifier:@"unwindSegue" sender:self];
}

@end
