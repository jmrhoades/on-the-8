//
//  StyleKit.h
//  On the 8
//
//  Created by Justin Rhoades on 8/12/15.
//  Copyright (c) 2015 Fuck Off Enterprises. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class PCGradient;

@interface StyleKit : NSObject

// iOS Controls Customization Outlets
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* mIDIWordMarkTargets;

// Colors
+ (UIColor*)white;
+ (UIColor*)black;
+ (UIColor*)red;
+ (UIColor*)orange;
+ (UIColor*)green;
+ (UIColor*)yellow1;
+ (UIColor*)yellow2;
+ (UIColor*)yellow3;
+ (UIColor*)gray0;
+ (UIColor*)gray1;
+ (UIColor*)gray2;
+ (UIColor*)gray3;
+ (UIColor*)navBarBgColor;
+ (UIColor*)navBarTitleColor;
+ (UIColor*)tableBgColor;
+ (UIColor*)cellBgAltColor;
+ (UIColor*)cellBgColor;
+ (UIColor*)cellSeparatorColor;
+ (UIColor*)cellSegmentColor;
+ (UIColor*)cellAssetColor;
+ (UIColor*)cellTextColor;
+ (UIColor*)cellTextFieldColor;

// Gradients
+ (PCGradient*)redGradient;

// Drawing Methods
+ (void)drawMIDIConnectorWithFrame: (CGRect)frame;
+ (void)drawMConnectorWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawMIDIWordMark;
+ (void)drawSettingsIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawHelpIconOutlineWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawNumbersWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawNJLogoWithFrame: (CGRect)frame;
+ (void)drawChevronWithColor: (UIColor*)color;
+ (void)drawAboutIconWithFrame: (CGRect)frame;
+ (void)drawEmailWithColor: (UIColor*)color;
+ (void)drawTwitterWithColor: (UIColor*)color;
+ (void)drawCloseIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawPlusCircleIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawSongsListIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawSaveCircleIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawAddSongIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawPlusIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawDeleteIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawSongsBgSymbolWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawHelpIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawHelpFilledIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawMidiConnectorButtonWithFrame: (CGRect)frame color: (UIColor*)color;
+ (void)drawCCAcceptWithColor: (UIColor*)color;
+ (void)drawCCCancelWithColor: (UIColor*)color;
+ (void)drawBluetoothStatusWithFrame: (CGRect)frame color: (UIColor*)color;

// Generated Images
+ (UIImage*)imageOfMIDIConnectorWithFrame: (CGRect)frame;
+ (UIImage*)imageOfMConnectorWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfMIDIWordMark;
+ (UIImage*)imageOfSettingsIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfHelpIconFilledWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfHelpIconOutlineWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfNJLogoWithFrame: (CGRect)frame;
+ (UIImage*)imageOfChevronWithColor: (UIColor*)color;
+ (UIImage*)imageOfAboutIconWithFrame: (CGRect)frame;
+ (UIImage*)imageOfEmailWithColor: (UIColor*)color;
+ (UIImage*)imageOfTwitterWithColor: (UIColor*)color;
+ (UIImage*)imageOfCloseIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfPlusCircleIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfSongsListIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfSaveCircleIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfAddSongIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfPlusIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfDeleteIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfSongsBgSymbolWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfHelpIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfHelpFilledIconWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfMidiConnectorButtonWithFrame: (CGRect)frame color: (UIColor*)color;
+ (UIImage*)imageOfCCAcceptWithColor: (UIColor*)color;
+ (UIImage*)imageOfCCCancelWithColor: (UIColor*)color;
+ (UIImage*)imageOfBluetoothStatusWithFrame: (CGRect)frame color: (UIColor*)color;

@end



@interface PCGradient : NSObject
@property(nonatomic, readonly) CGGradientRef CGGradient;
- (CGGradientRef)CGGradient NS_RETURNS_INNER_POINTER;

+ (instancetype)gradientWithColors: (NSArray*)colors locations: (const CGFloat*)locations;
+ (instancetype)gradientWithStartingColor: (UIColor*)startingColor endingColor: (UIColor*)endingColor;

@end
