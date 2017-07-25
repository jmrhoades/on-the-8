//
//  SongsListView.m
//  on the 8
//
//  Created by Justin Rhoades on 2/16/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "SongsListView.h"
#import "CountdownViewController.h"
#import "StyleKit.h"

@implementation SongsListView

- (void) awakeFromNib {
    [super awakeFromNib];
    _items = @[@"1", @"2", @"3"];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGSize margins = [CountdownViewController getCornerLabelMargins];
    CGFloat marginX = margins.width;
    CGFloat marginY = margins.height;
    UIFont *labelFont = [CountdownViewController getCornerLabelFont];
    CGFloat labelHeight = labelFont.pointSize;
    CGFloat labelWidth = self.bounds.size.width;
    if (_typeOnView == nil) {
        _typeOnView = [TypeOnView new];
        [self addSubview:_typeOnView];
    }
    CGRect topLeftLabelFrame = CGRectMake(marginX, marginY, labelWidth, labelHeight);
    _typeOnView.frame = topLeftLabelFrame;
    _typeOnView.label.font = labelFont;
    _typeOnView.label.text = @"Songs";
    _typeOnView.label.textColor = StyleKit.gray1;
    
    SongsCollectionViewLayout *layout = [SongsCollectionViewLayout new];
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.allowsSelection = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.collectionView registerClass:[SongCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SongCollectionViewCell class])];
        [self addSubview:self.collectionView];
    };
    _collectionView.collectionViewLayout = layout;
}

- (void)didEndScrolling {
    CGPoint center = [self convertPoint:self.collectionView.center toView:self.collectionView];
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
    /*
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.collectionView.layer.mask.frame = self.collectionView.bounds;
    [CATransaction commit];
     */
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SongCollectionViewCell class]) forIndexPath:indexPath];
    cell.ccValueLabel.text = [NSString stringWithFormat:@"%li", (long)indexPath.item + 1];
    //cell.ccValueLabel.text = @"sdfs";
    //cell.label.text = [_items objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

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


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Select Item
    NSLog(@"collectionView didSelectItemAtIndexPath %li", (long)indexPath.row);
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


@end


#pragma mark - SongsCollectionViewLayout

@interface SongsCollectionViewLayout ()
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat midX;
@property (nonatomic, assign) CGFloat maxAngle;
@end

@implementation SongsCollectionViewLayout

- (id)init {
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout {
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    self.midX = CGRectGetMidX(visibleRect);
    self.width = CGRectGetWidth(visibleRect) / 2;
    self.maxAngle = M_PI_2;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [super layoutAttributesForElementsInRect:rect];
}

@end

#pragma mark - SongCollectionViewCell

@interface SongCollectionViewCell()
@property (nonatomic, strong) CAShapeLayer *square1;
@property (nonatomic, strong) UILabel *ccLabel;
@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *barLabel;
@property (nonatomic, strong) UIView *separator1;
@property (nonatomic, strong) UIView *separator2;
@property (nonatomic, strong) UIView *separator3;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation SongCollectionViewCell

- (void)initialize {
    self.layer.doubleSided = NO;
    self.backgroundColor = StyleKit.cellBgColor;
    _titles = @[@"4", @"8", @"16", @"24", @"32", @"40", @"48", @"56", @"64"];
    
    UIFont *titleFont =   [UIFont fontWithName:@"Bryant-RegularCondensed" size:34.f];
    UIFont *controlFont = [UIFont fontWithName:@"Bryant-RegularCondensed" size:24.f];
    UIFont *labelFont =   [UIFont fontWithName:@"Bryant-RegularCondensed" size:14.f];
    UIColor *labelColor = StyleKit.gray1;
    
    if (_titleField == nil) {
        _titleField = [UITextField new];
        [self.contentView addSubview:_titleField];
        _titleField.backgroundColor = [UIColor clearColor];
        _titleField.font = titleFont;
        _titleField.textColor = StyleKit.cellTextFieldColor;
        _titleField.keyboardAppearance = UIKeyboardAppearanceDark;
        _titleField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _titleField.autocorrectionType = UITextAutocorrectionTypeNo;
        _titleField.spellCheckingType = UITextSpellCheckingTypeNo;
        _titleField.delegate = self;
        _titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Untitled" attributes:@{NSForegroundColorAttributeName: StyleKit.cellTextFieldColor}];
        //_titleField.text = @"Untitled";
    }
    
    if (_keyLabel == nil) {
        _keyLabel = [UILabel new];
        [self.contentView addSubview:_keyLabel];
        _keyLabel.backgroundColor = [UIColor clearColor];
        _keyLabel.font = labelFont;
        _keyLabel.textColor = labelColor;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"KEY"];
        [attributedString addAttribute:NSKernAttributeName value:@(1.2) range:NSMakeRange(0, attributedString.length)];
        _keyLabel.attributedText = attributedString;
    }
    
    if (_barLabel == nil) {
        _barLabel = [UILabel new];
        [self.contentView addSubview:_barLabel];
        _barLabel.backgroundColor = [UIColor clearColor];
        _barLabel.font = labelFont;
        _barLabel.textColor = labelColor;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"BAR"];
        [attributedString addAttribute:NSKernAttributeName value:@(1.2) range:NSMakeRange(0, attributedString.length)];
        _barLabel.attributedText = attributedString;
    }
    
    if (_ccLabel == nil) {
        _ccLabel = [UILabel new];
        [self.contentView addSubview:_ccLabel];
        _ccLabel.backgroundColor = [UIColor clearColor];
        _ccLabel.font = labelFont;
        _ccLabel.textColor = labelColor;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"CC1"];
        [attributedString addAttribute:NSKernAttributeName value:@(1.2) range:NSMakeRange(0, attributedString.length)];
        _ccLabel.attributedText = attributedString;
    }
    
    if (_ccValueLabel == nil) {
        _ccValueLabel = [UILabel new];
        [self.contentView addSubview:_ccValueLabel];
        _ccValueLabel.backgroundColor = [UIColor clearColor];
        _ccValueLabel.font = controlFont;
        _ccValueLabel.textColor = StyleKit.yellow1;
        _ccValueLabel.textAlignment = NSTextAlignmentCenter;
        _ccValueLabel.text = @"1";
    }
    
    if (_keyField == nil) {
        _keyField = [UITextField new];
        [self.contentView addSubview:_keyField];
        _keyField.backgroundColor = [UIColor clearColor];
        _keyField.font = controlFont;
        _keyField.textColor = StyleKit.cellTextFieldColor;
        _keyField.keyboardAppearance = UIKeyboardAppearanceDark;
        _keyField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _keyField.autocorrectionType = UITextAutocorrectionTypeNo;
        _keyField.clearsOnBeginEditing = YES;
        _keyField.textAlignment = NSTextAlignmentCenter;
        _keyField.spellCheckingType = UITextSpellCheckingTypeNo;
        _keyField.delegate = self;
        _keyField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"F#" attributes:@{NSForegroundColorAttributeName: StyleKit.cellTextFieldColor}];
        //_keyField.text = @"F#";
    }

    if (_picker == nil) {
        _picker = [AKPickerView new];
        [self.contentView addSubview:_picker];
        _picker.dataSource = self;
        _picker.delegate = self;
        //_picker.isLeftAligned = YES;
        _picker.font = controlFont;
        _picker.highlightedFont = controlFont;
        _picker.interitemSpacing = 20.0;
        _picker.fisheyeFactor = 0.001;
        _picker.pickerViewStyle = AKPickerViewStyleFlat;
        [_picker selectItem:1 animated:NO];
        [_picker reloadData];
    }
    
    if (_separator1 == nil) {
        _separator1 = [UIView new];
        [self.contentView addSubview:_separator1];
        _separator1.backgroundColor = StyleKit.cellSeparatorColor;
    }
    
    if (_separator2 == nil) {
        _separator2 = [UIView new];
        [self.contentView addSubview:_separator2];
        _separator2.backgroundColor = StyleKit.cellSeparatorColor;
    }
    
    if (_separator3 == nil) {
        _separator3 = [UIView new];
        [self.contentView addSubview:_separator3];
        _separator3.backgroundColor = StyleKit.cellSeparatorColor;
    }
    
    if (_square1 == nil) {
        _square1 = [CAShapeLayer new];
        //[self.layer addSublayer:_square1];
        _square1.fillColor = [UIColor blackColor].CGColor;
    }


}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 24.0f;
    CGFloat controlHeight = 56.f;
    CGFloat titleHeight = 80.f;
    CGFloat interMargin = 48.0f;
    CGFloat squareSize = 24.f;
    CGFloat left = margin;
    CGFloat top = 0;
    CGFloat bottom = self.bounds.size.height;
    CGFloat width = self.bounds.size.width - margin - margin;
    CGFloat separatorHeight = 0.5;
    
    _titleField.frame = CGRectMake(left, top, width, titleHeight);
    _separator1.frame = CGRectMake(left, _titleField.frame.origin.y + _titleField.frame.size.height-separatorHeight, width, separatorHeight);

    _keyLabel.frame = CGRectMake(left, _titleField.frame.origin.y + _titleField.frame.size.height, interMargin, controlHeight);
    _keyField.frame = CGRectMake(left+interMargin, _titleField.frame.origin.y + _titleField.frame.size.height, width-interMargin-interMargin, controlHeight);
    _separator2.frame = CGRectMake(left, _keyField.frame.origin.y + _keyField.frame.size.height-separatorHeight, width, separatorHeight);

    _barLabel.frame = CGRectMake(left, _keyLabel.frame.origin.y + controlHeight, interMargin, controlHeight);
    _picker.frame = CGRectMake(left+interMargin, _keyField.frame.origin.y + controlHeight, width-interMargin-interMargin, controlHeight);
    _separator3.frame = CGRectMake(left, _picker.frame.origin.y + _picker.frame.size.height-separatorHeight, width, separatorHeight);

    _ccLabel.frame = CGRectMake(left, _barLabel.frame.origin.y + controlHeight, interMargin, controlHeight);
    _ccValueLabel.frame = CGRectMake(left+interMargin, _barLabel.frame.origin.y + controlHeight, width-interMargin-interMargin, controlHeight);
    
    _square1.path =[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, squareSize, squareSize)].CGPath;
    _square1.frame = CGRectMake(self.bounds.size.width - squareSize, bottom - squareSize, squareSize, squareSize);

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}

#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {
    return _titles.count;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item {
    return _titles[item];
}

#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {
    NSLog(@"Picker: %ld", (long)item);
}

- (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item {
    label.textColor = StyleKit.gray2;
    label.highlightedTextColor = StyleKit.cellTextFieldColor;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
}



@end