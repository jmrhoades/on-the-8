//
//  SongsCollectionViewController.m
//  on the 8
//
//  Created by Justin Rhoades on 2/25/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "SongsCollectionViewController.h"
#import "SongCell.h"
#import "PanelFlowLayout.h"
#import "ZoomedInFlowLayout.h"
#import "StyleKit.h"

@interface SongsCollectionViewController ()

@property (nonatomic) NSInteger sectionCount;
@property (nonatomic, strong) NSMutableArray *itemCounts;
@property (nonatomic) BOOL isFocussed;

@property (nonatomic) BOOL largeItems;
@property (nonatomic, strong) PanelFlowLayout *smallLayout;
@property (nonatomic) NSInteger selectedItem;
@property (nonatomic, strong) UIPinchGestureRecognizer *pincher;

@end

@implementation SongsCollectionViewController

static NSString * const reuseIdentifier = @"SongCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PanelFlowLayout *layout = [PanelFlowLayout new];
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;

    // Register cell classes
    //[self.collectionView registerClass:[SongCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didEndScrolling {
    CGPoint center = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:center];
    [self selectItem:indexPath.item animated:YES];
}

- (void)selectItem:(NSUInteger)item animated:(BOOL)animated {
    [self selectItem:item animated:animated notifySelection:YES];
}

- (void)selectItem:(NSUInteger)item animated:(BOOL)animated notifySelection:(BOOL)notifySelection {
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] animated:animated scrollPosition:UICollectionViewScrollPositionNone];
    [self scrollToItem:item animated:animated];
    self.selectedItem = item;
}

- (void)scrollToItem:(NSUInteger)item animated:(BOOL)animated {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:animated];
}

#pragma mark - UISCrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self didEndScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollViewDidScroll:scrollView];
    if (!decelerate) [self didEndScrolling];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SongCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%li", (long)indexPath.row];
    
    cell.backgroundColor = StyleKit.cellBgColor;
    
    /*
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor greenColor];
    }
    if (indexPath.row == 1) {
        cell.backgroundColor = [UIColor purpleColor];
    }
    if (indexPath.row == 2) {
        cell.backgroundColor = [UIColor yellowColor];
    }
    if (indexPath.row == 3) {
        cell.backgroundColor = [UIColor redColor];
    }
    */

    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"SongsCollectionViewController didSelectItemAtIndexPath %li", (long)indexPath.row);

    
    if (_isFocussed) {
        PanelFlowLayout *l = [PanelFlowLayout new];
        [self.collectionView setCollectionViewLayout:l animated:YES];
        _isFocussed = NO;
        self.collectionView.scrollEnabled = YES;
    } else {
        
        ZoomedInFlowLayout *l = [ZoomedInFlowLayout new];
        [self.collectionView setCollectionViewLayout:l animated:YES];
        _isFocussed = YES;
        self.collectionView.scrollEnabled = NO;
        

    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark – UICollectionViewDelegateFlowLayout

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(256.f, 256.f);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return MAXFLOAT;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16.0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSInteger number = [self collectionView:collectionView numberOfItemsInSection:section];
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:number - 1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                            0, (collectionView.bounds.size.width - lastSize.width) / 2);
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

@end
