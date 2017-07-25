//
//  AboutTableViewController.m
//  On the 8
//
//  Created by Justin Rhoades on 1/12/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "AboutTableViewController.h"
#import "StyleKit.h"
#import "OptionsSectionHeaderCell.h"
#import "ContactTableViewCell.h"

static NSString * const AboutCellIdentifier = @"AboutCell";
static NSString * const SectionHeaderCellIdentifier = @"SectionHeaderCell";


@interface AboutTableViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *aboutIcon;
@property (nonatomic, weak) IBOutlet UILabel *aboutLabel;
@property (nonatomic, weak) IBOutlet UIView *tableFooterView;
@property (nonatomic, weak) IBOutlet UIImageView *njLogo;

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = StyleKit.tableBgColor;
    
    _tableFooterView.backgroundColor = StyleKit.tableBgColor;
    self.tableView.tableFooterView = _tableFooterView;
    _njLogo.image = [StyleKit imageOfNJLogoWithFrame:CGRectMake(0, 0, 100.0, 20.0)];
    _njLogo.userInteractionEnabled = YES;
    UITapGestureRecognizer *njLinkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(njLinkTapped:)];
    [_njLogo addGestureRecognizer:njLinkTap];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.row == 1) {
        OptionsSectionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionHeaderCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    return nil;
}
*/


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        cell.backgroundColor = StyleKit.tableBgColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //_aboutIcon.image = [StyleKit imageOfAboutIcon];
        UIFont *font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:19.f];
        _aboutLabel.font = font;
        _aboutLabel.textColor = StyleKit.cellTextColor;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineSpacing:2.0];
        NSDictionary *attributes = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_aboutLabel.text attributes:attributes];
        [_aboutLabel setAttributedText: attributedString];
        
    }
    if (indexPath.row == 1) {
        OptionsSectionHeaderCell *contactHeaderCell = (OptionsSectionHeaderCell *)cell;
        [contactHeaderCell setHeaderText:@"CONTACT"];
    }
    if (indexPath.row == 2) {
        ContactTableViewCell *emailCell = (ContactTableViewCell *)cell;
        emailCell.image.image = [StyleKit imageOfEmailWithColor:StyleKit.cellAssetColor];
    }
    if (indexPath.row == 3) {
        ContactTableViewCell *twitterCell = (ContactTableViewCell *)cell;
        twitterCell.image.image = [StyleKit imageOfTwitterWithColor:StyleKit.cellAssetColor];
    }


    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 0;
    if (indexPath.row == 0) {
        CGSize constraint = CGSizeMake(self.tableView.bounds.size.width-30.f,CGFLOAT_MAX);
        UIFont *font = [UIFont fontWithName:@"Bryant-RegularCondensed" size:19.f];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:_aboutLabel.text attributes:@{NSFontAttributeName:font}];
        CGRect rect = [attributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize size = rect.size;
        height = size.height + 200.0 + 48.0;
    }
    if (indexPath.row == 1) {
        height = 56.0;
    }
    if (indexPath.row == 2) {
        height = 48.0;
    }
    if (indexPath.row == 3) {
        height = 48.0;
    }
    return height;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@nojesus.net"]];
    }
    if (indexPath.row == 3) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/nooojesus"]];
    }
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
