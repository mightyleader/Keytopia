//
//  AccessoryInputView.h
//  Keytopia
//
//  Created by Rob Stearn on 07/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

@import UIKit;

/**
 *    @author Rob Stearn, 09-08-15 21:08:36
 *
 *    Simple block definition for the option buttons action, returns a BOOL.
 *
 *    @param BOOL return value from block code.
 */
typedef void(^AccessoryInputViewOptionSelectHandler)(BOOL);

@interface CDAAccessoryInputView : UIInputView

@property (nonatomic, readonly) UITextField *textfield;
@property (nonatomic, readonly) UIButton    *optionsButton;

// Blocks to call on option selection...
@property (nonatomic, copy) AccessoryInputViewOptionSelectHandler photoHandler;
@property (nonatomic, copy) AccessoryInputViewOptionSelectHandler cameraHandler;
@property (nonatomic, copy) AccessoryInputViewOptionSelectHandler audioHandler;
@property (nonatomic, copy) AccessoryInputViewOptionSelectHandler pdfHandler;
@property (nonatomic, copy) AccessoryInputViewOptionSelectHandler vcardHandler;

- (instancetype)initWithFrame:(CGRect)frame
               inputViewStyle:(UIInputViewStyle)inputViewStyle;

@end
