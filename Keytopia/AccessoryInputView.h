//
//  AccessoryInputView.h
//  Keytopia
//
//  Created by Rob Stearn on 07/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

@import UIKit;

/**
 Wrapper around the tag value of the options buttons for readability
 */
typedef enum : NSUInteger {
  AccessoryInputOptionCamera = 0,
  AccessoryInputOptionPhotoLibrary,
  AccessoryInputOptionAudioRecord,
  AccessoryInputOptionPDFMe,
  AccessoryInputOptionVCard,
} AccessoryInputOption;

// simple block definition, no paramters no return
typedef void(^AccessoryInputViewOptionSelectHandler)();

@interface AccessoryInputView : UIInputView

@property (nonatomic, readonly) UITextField *textfield;
@property (nonatomic, readonly) UIButton    *optionsButton;

// Blocks to call on option selection...
@property (nonatomic, copy) AccessoryInputViewOptionSelectHandler photoHandler;
@property (nonatomic, copy) AccessoryInputViewOptionSelectHandler cameraHandler;
@property (nonatomic, copy) AccessoryInputViewOptionSelectHandler audioHandler;
@property (nonatomic, copy) AccessoryInputViewOptionSelectHandler pdfHandler;
@property (nonatomic, copy) AccessoryInputViewOptionSelectHandler vcardHandler;

- (instancetype)initWithFrame:(CGRect)frame
               inputViewStyle:(UIInputViewStyle)inputViewStyle
                  placeholder:(BOOL)placeholder;

@end
