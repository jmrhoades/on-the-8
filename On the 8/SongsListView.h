//
//  SongsListView.h
//  on the 8
//
//  Created by Justin Rhoades on 2/16/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeOnView.h"
#import "AKPickerView.h"


@interface SongsListView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger selectedItem;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) TypeOnView  *typeOnView;
@end

@interface SongCollectionViewCell : UICollectionViewCell <AKPickerViewDataSource, AKPickerViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UILabel *ccValueLabel;
@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextField *keyField;
@property (nonatomic, strong) AKPickerView *picker;
@end

@interface SongsCollectionViewLayout : UICollectionViewFlowLayout
@end