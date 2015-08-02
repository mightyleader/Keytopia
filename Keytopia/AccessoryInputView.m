//
//  AccessoryInputView.m
//  Keytopia
//
//  Created by Rob Stearn on 07/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "AccessoryInputView.h"
#import "OptionButton.h"
#import "PhotoLibraryCollection.h"
@import QuartzCore;

typedef enum : NSUInteger {
  PresentationStateText = 0,
  PresentationStateOptionsLow,
  PresentationStateOptionsHigh,
} PresentationState;

@interface AccessoryInputView ()

@property (nonatomic) UIView *containingView;
@property (nonatomic) UITextField *textfield;
@property (nonatomic) UIButton   *optionsButton;
@property (nonatomic) UIVisualEffectView *blurBackgroundView;

@property (nonatomic) UIView *optionsContainer;
@property (nonatomic) NSArray<__kindof UIView*> *optionButtons;

@property (nonatomic) BOOL presenting;
@property (nonatomic) PresentationState presentationState;

@property (nonatomic) UICollectionViewFlowLayout *flow;
//@property (nonatomic) PhotoLibraryCollection *photos;

@property (nonatomic) NSMutableArray *containerConstraints;
@property (nonatomic) NSMutableArray *textentryConstraints;
@property (nonatomic) NSMutableArray *optionsConstraints;

@property (nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation AccessoryInputView

#pragma mark - Public interface

- (instancetype)initWithFrame:(CGRect)frame
               inputViewStyle:(UIInputViewStyle)inputViewStyle
{
  self = [super initWithFrame:frame
               inputViewStyle:inputViewStyle];
  if (self)
  {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setupSubviews];
    [self setupOptionButtons];
    [self setupConstraints];
    [self debugViewSettings];
  }
  return self;
}


#pragma mark - Private layout methods

- (void)debugViewSettings
{
  [self setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.5]];
  [_textfield setBackgroundColor:[[UIColor cyanColor] colorWithAlphaComponent:0.5]];
  [_optionsButton setBackgroundColor:[[UIColor orangeColor] colorWithAlphaComponent:0.5]];
  [_containingView setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:0.3]];
}

- (void)setupSubviews
{
  // init subviews
  _optionsButton  = [UIButton buttonWithType:UIButtonTypeCustom];

  // auto-resizing
//  CGFloat width = CGRectGetWidth(self.frame);
//  _textfield      = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width - 44, 44)];
//  [_optionsButton setFrame:CGRectMake(width - 44, 0, 44, 44)];
//  _containingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
  
  // auto layout
  // *** COMMENT OUT FOR AUTORESIZING ***
  _textfield      = [[UITextField alloc] initWithFrame:CGRectZero];
  [_optionsButton setFrame:CGRectZero];
  _containingView = [[UIView alloc] initWithFrame:CGRectZero];
  [_textfield setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_optionsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_containingView setTranslatesAutoresizingMaskIntoConstraints:NO];
  
  [_containingView addSubview:_textfield];
  [_containingView addSubview:_optionsButton];
  [self addSubview:_containingView];
  
  // configure text input and button
  [_textfield setKeyboardAppearance:UIKeyboardAppearanceLight];
  [_textfield setReturnKeyType:UIReturnKeySend];
  [_textfield setTintColor:[UIColor colorWithRed:1.000
                                           green:0.502
                                            blue:0.000
                                           alpha:1.000]];
  
  [_textfield setTextColor:[UIColor colorWithWhite:0.200
                                             alpha:1.000]];
  
  [_textfield.layer setCornerRadius:5.0f];
  [_textfield setBackgroundColor:[UIColor colorWithWhite:0.8
                                                   alpha:0.0]];
  
  [_textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
  
  [_textfield setPlaceholder:NSLocalizedString(@"type your message here", nil)];
  
  UIImage *messageIcon = [UIImage imageNamed:@"Message"];
  UIImageView *leftIcon = [[UIImageView alloc] initWithImage:messageIcon];
  [leftIcon setAlpha:0.2];
  [leftIcon setTintColor:[UIColor grayColor]];
  [_textfield setLeftViewMode:UITextFieldViewModeAlways];
  [_textfield setLeftView:leftIcon];
  
  [_optionsButton setTintColor:[UIColor darkGrayColor]];
  [_optionsButton setBackgroundColor:[UIColor clearColor]]; //DEBUG
  [_containingView setBackgroundColor:[UIColor clearColor]];
  
  [self changeOptionsButtonImage:NO];
  
  [_optionsButton addTarget:self
                     action:@selector(toggleOptions:)
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupOptionButtons
{
  NSMutableArray *optionButtons = [NSMutableArray array];
  NSArray *optionButtonImageNames = @[@"Contact", @"BusinessCard", @"Audio", @"Sticker", @"Smartphone", @"Photo" ];
  
  OptionButton *button;
  NSInteger count = optionButtonImageNames.count;
  CGFloat width   = 55.0f; //TODO: Abstract to constant
  
  _optionsContainer = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame), 0.0f, width * count, 44.0f)];
  [_optionsContainer setBackgroundColor:[UIColor clearColor]];
  
  for (NSInteger i = 0; i < count; i++)
    {
      UIImage *image = [UIImage imageNamed:optionButtonImageNames[i]];
      button = [[OptionButton alloc] initWithFrame:CGRectMake(width * i, 0.0f, width, 44.0f)
                                          andImage:image
                                         tintColor:[UIColor darkGrayColor]
                                   backgroundColor:[UIColor clearColor]];
      [button setTag:i];
      [button addTarget:self
                 action:@selector(handleOptionBlockForButton:)
       forControlEvents:UIControlEventTouchUpInside];
      [optionButtons addObject:button];
      [_optionsContainer addSubview:button];
    }
  
  [_containingView addSubview:_optionsContainer];
  
  _optionButtons = [NSArray arrayWithArray:optionButtons];
  _presenting = NO;
}

- (void)setupConstraints
{
  if (!_textentryConstraints || !_containerConstraints) {
    NSDictionary *constrained = NSDictionaryOfVariableBindings(_optionsButton, _textfield, _containingView);
    
    // container view
    _containerConstraints = [NSMutableArray array];
    
    [_containerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_containingView]-0-|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:constrained]];
    [_containerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_containingView]-0-|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:constrained]];
    
    // text entry
    _textentryConstraints = [NSMutableArray array];
    
    // *** COMMENT OUT FOR AUTORESIZING ***
    [_textentryConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_textfield]-0-[_optionsButton(==44)]-0-|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:constrained]];
    [_textentryConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_textfield(==44)]-0-|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:constrained]];
    [_textentryConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_optionsButton(==44)]-0-|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:constrained]];
    
  }
  [self addConstraints:_containerConstraints];
  [_containingView addConstraints:_textentryConstraints];
}


#pragma mark - Event handler

- (void)toggleOptions:(id)sender
{
  CGRect frame    = _optionsContainer.frame;
  CGFloat startx  = CGRectGetMaxX(self.frame);
  CGFloat endx  = CGRectGetMinX(_optionsButton.frame) - CGRectGetWidth(frame);
  BOOL isShowingOptions = (frame.origin.x == endx);
  frame.origin.x  =  isShowingOptions ? startx : endx; // Move based on current position
  [UIView animateWithDuration:0.2
                        delay:0.0
       usingSpringWithDamping:0.4
        initialSpringVelocity:0.4
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:
   ^{
     [_optionsContainer setFrame:frame];
     [self changeOptionsButtonImage:!_presenting];
     [_textfield setAlpha:isShowingOptions];
     [self deselectAllButtons];
   } completion:^(BOOL finished) {
     if (_presenting) {
       _presenting = !_presenting;
       [self invalidateIntrinsicContentSize];
     }
   }];
}


- (void)changeOptionsButtonImage:(BOOL)presenting
{
  UIImage *image = [UIImage imageNamed:@"paperclip"];
  if (presenting) {
    image = [UIImage imageNamed:@"CloseButton"];
  }
  [_optionsButton setImage:image forState:UIControlStateNormal];
  _presenting = !presenting;
}


- (void)deselectAllButtons
{
  for (UIButton *button in _optionButtons) {
    [button setBackgroundColor:[UIColor clearColor]]; // TODO: make these refer to constants
    [button.imageView setTintColor:[UIColor blackColor]];
  }
}


- (void)handleOptionBlockForButton:(id)sender
{
  //Switch on the button by the tag
  AccessoryInputOption chosenOption = [sender tag];
  BOOL show = YES;
  
  // Only change the layout bounds of self if not already changed
  if (!_presenting) {
    [self changeHeightConstraintToPresenting:YES];
  }
  
  // Manage selection state
  [self deselectAllButtons];
  [sender setBackgroundColor:[UIColor darkGrayColor]];
  [[sender imageView] setTintColor:[UIColor whiteColor]];
  
  // Call any associated block code
  switch (chosenOption) {
    case AccessoryInputOptionCamera:
    case AccessoryInputOptionPhotoLibrary:
    case AccessoryInputOptionAudioRecord:
    case AccessoryInputOptionPDFMe:
    case AccessoryInputOptionVCard:
    case AccessoryInputOptionStickers:
    {
      self.photoHandler(show);
    }
      break;
    default:
      return;
      break;
  }
}


- (void)changeHeightConstraintToPresenting:(BOOL)presenting
{
  self.presenting = presenting;
  [self invalidateIntrinsicContentSize];
}


- (CGSize)intrinsicContentSize
{
  CGSize newSize = self.bounds.size;
  if (self.presenting)
  {
    newSize.height = 160.0;
  }
  else
  {
    newSize.height = 44.0;
  }
  return newSize;
}


#pragma mark - STUFF

- (void)setupOptionalContentViews
{
  
}


@end
