//
//  CDAOptionButtonsViewController.h
//  Keytopia
//
//  Created by Rob Stearn on 12/08/2015.
//  Copyright © 2015 cocoadelica. All rights reserved.
//

@import UIKit;
@class CDAOptionButton;

/**
 Wrapper around the tag value of the options buttons for readability
 */
typedef enum : NSUInteger {
    AccessoryInputOptionCamera = 0,
    AccessoryInputOptionPhotoLibrary,
    AccessoryInputOptionAudioRecord,
    AccessoryInputOptionPDFMe,
    AccessoryInputOptionVCard,
    AccessoryInputOptionStickers,
} AccessoryInputOption;

typedef void(^AccessoryInputViewOptionSelectHandler)(BOOL);

@interface CDAOptionButtonsViewController : UIViewController

@property (nonatomic) NSArray<CDAOptionButton *>                        *optionButtons;
@property (nonatomic) NSArray<AccessoryInputViewOptionSelectHandler>    *actionsBlocks;

- (void)deselectAllButtons;

@end
