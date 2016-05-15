//
//  AccessoryInputView.m
//  Keytopia
//
//  Created by Rob Stearn on 07/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "CDAAccessoryInputView.h"
#import "CDAOptionButtonsViewController.h"
#import "KeytopiaPhotoLibraryCollection.h"
@import QuartzCore;

#define KTAtextEntryIconAlpha       0.2f
#define KTALayerCornerRadius        5.0f
#define KTAStandardTouchDimension   44.0f
#define ZERO_INT                    0
#define ZERO_FLOAT                  0.0f

@interface CDAAccessoryInputView ()

@property (nonatomic) UIView        *containingView;
@property (nonatomic) UITextField   *textfield;
@property (nonatomic) UIButton      *optionsButton;
@property (nonatomic) UIView        *additionalOptionsView;

@property (nonatomic) CDAOptionButtonsViewController *optionsViewController;
@property (nonatomic) UIView *optionsContainer;
@property (nonatomic) NSArray *optionButtons;

@property (nonatomic) BOOL presentingButtons;
@property (nonatomic) BOOL presentingAttachmentType;

@property (nonatomic) NSLayoutConstraint *heightConstraint;
@property (nonatomic) NSLayoutConstraint *optionsHiddenLeadingConstraint;
@property (nonatomic) NSLayoutConstraint *optionsShowingLeadingConstraint;
@property (nonatomic) NSLayoutConstraint *additionalHiddenHeightConstraint;
@property (nonatomic) NSLayoutConstraint *additionalShowingHeightConstraint;

@end

@implementation CDAAccessoryInputView

#pragma mark - Public interface

- (instancetype)initWithFrame:(CGRect)frame
               inputViewStyle:(UIInputViewStyle)inputViewStyle
{
    self = [super initWithFrame:frame
                 inputViewStyle:inputViewStyle];
    if (self)
    {
        _presentingButtons          = NO;
        _presentingAttachmentType   = NO;
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setupSubviews];
        [self setupOptionButtonsAndConstraints];
        [self setupConstraints];
//      [self debugViewSettings]; //DEBUG PURPOSES ONLY
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
    _optionsViewController = [[CDAOptionButtonsViewController alloc] init];
    _optionsContainer = _optionsViewController.view;
    _optionsButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optionsButton setFrame:CGRectZero];
    [_optionsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _textfield      = [[UITextField alloc] initWithFrame:CGRectZero];
    [_textfield setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _containingView = [[UIView alloc] initWithFrame:CGRectZero];
    [_containingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_containingView addSubview:_textfield];
    [_containingView addSubview:_optionsButton];
    [self addSubview:_containingView];
    
    // configure text input and button
    [_textfield setKeyboardAppearance:UIKeyboardAppearanceLight];
    [_textfield setReturnKeyType:UIReturnKeySend];
    [_textfield setTintColor:[UIColor colorWithRed:1.000
                                             green:0.502
                                              blue:ZERO_FLOAT
                                             alpha:1.000]];
    
    [_textfield setTextColor:[UIColor colorWithWhite:0.200
                                               alpha:1.000]];
    
    [_textfield.layer setCornerRadius:KTALayerCornerRadius];
    [_textfield setBackgroundColor:[UIColor colorWithWhite:0.8
                                                     alpha:ZERO_FLOAT]];
    
    [_textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    [_textfield setPlaceholder:NSLocalizedString(@"type your message here", nil)];
    
    UIImage *messageIcon = [UIImage imageNamed:@"Message"];
    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:messageIcon];
    [leftIcon setAlpha:KTAtextEntryIconAlpha];
    [leftIcon setTintColor:[UIColor grayColor]];
    [_textfield setLeftViewMode:UITextFieldViewModeAlways];
    [_textfield setLeftView:leftIcon];
    
    [_optionsButton setTintColor:[UIColor darkGrayColor]];
    [_optionsButton setBackgroundColor:[UIColor clearColor]]; //DEBUG
    [_containingView setBackgroundColor:[UIColor clearColor]];
    
    [self changeOptionsButtonImage:_presentingButtons];
    
    [_optionsButton addTarget:self
                       action:@selector(toggleOptions:)
             forControlEvents:UIControlEventTouchUpInside];
    
    _additionalOptionsView = [[UIView alloc] init];
    [_additionalOptionsView setTranslatesAutoresizingMaskIntoConstraints: NO];
    _additionalOptionsView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.9];
    [_containingView addSubview: _additionalOptionsView];
}

- (void)setupOptionButtonsAndConstraints
{
    [_containingView addSubview:_optionsContainer];
    
    _optionsShowingLeadingConstraint = [_optionsContainer.leadingAnchor constraintEqualToAnchor: _containingView.leadingAnchor];
    _optionsHiddenLeadingConstraint  = [_optionsContainer.leadingAnchor constraintEqualToAnchor: _containingView.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints: @[
                                               [_optionsContainer.bottomAnchor constraintEqualToAnchor: _containingView.bottomAnchor],
                                               [_optionsContainer.heightAnchor constraintEqualToAnchor: _containingView.heightAnchor],
                                               [_optionsContainer.widthAnchor constraintEqualToConstant:200]
                                               ]];
    
    [NSLayoutConstraint activateConstraints: @[_optionsHiddenLeadingConstraint]];
    _optionButtons = [NSArray arrayWithArray:_optionsViewController.optionButtons];
}

- (void)setupConstraints
{
    NSLayoutConstraint *containerLeft   = [_containingView.leftAnchor constraintEqualToAnchor:self.leftAnchor];
    NSLayoutConstraint *containerRight  = [_containingView.rightAnchor constraintEqualToAnchor:self.rightAnchor];
    NSLayoutConstraint *containerHeight = [_containingView.heightAnchor constraintEqualToConstant:KTAStandardTouchDimension];
    NSLayoutConstraint *containerBottom = [_containingView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    
    [NSLayoutConstraint activateConstraints:@[containerLeft,
                                              containerRight,
                                              containerBottom,
                                              containerHeight
                                              ]];
    
    NSLayoutConstraint *buttonRight     = [_optionsButton.rightAnchor constraintEqualToAnchor:self.rightAnchor];
    NSLayoutConstraint *buttonTop       = [_optionsButton.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *buttonBottom    = [_optionsButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    NSLayoutConstraint *buttonWidth     = [_optionsButton.widthAnchor constraintEqualToConstant:KTAStandardTouchDimension];
    
    [NSLayoutConstraint activateConstraints:@[buttonTop,
                                              buttonBottom,
                                              buttonRight,
                                              buttonWidth
                                              ]];
    
    NSLayoutConstraint *textEntryLeft   = [_textfield.leftAnchor constraintEqualToAnchor:self.leftAnchor];
    NSLayoutConstraint *textEntryRight  = [_textfield.rightAnchor constraintEqualToAnchor:_optionsButton.leftAnchor];
    NSLayoutConstraint *textEntryTop    = [_textfield.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *textEntryBottom = [_textfield.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    
    [NSLayoutConstraint activateConstraints:@[textEntryLeft,
                                              textEntryRight,
                                              textEntryTop,
                                              textEntryBottom
                                              ]];
    
    NSLayoutConstraint *additionalLeading = [_additionalOptionsView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor];
    NSLayoutConstraint *additionalTrailing = [_additionalOptionsView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor];
    NSLayoutConstraint *constraintToOptionsContainer = [_additionalOptionsView.bottomAnchor constraintEqualToAnchor: _optionsContainer.topAnchor];
    _additionalHiddenHeightConstraint   = [_additionalOptionsView.heightAnchor constraintEqualToConstant:ZERO_FLOAT];
    _additionalShowingHeightConstraint  = [_additionalOptionsView.heightAnchor constraintEqualToConstant:116.0f];
    
    NSLayoutConstraint *correctHeightConstraint = _presentingAttachmentType ? _additionalShowingHeightConstraint
                                                                            : _additionalHiddenHeightConstraint;
    
    [NSLayoutConstraint activateConstraints:@[
                                              additionalLeading,
                                              additionalTrailing,
                                              constraintToOptionsContainer,
                                              correctHeightConstraint
                                              ]];
}


#pragma mark - Event handler

- (void)toggleOptions:(id)sender
{
    CGRect frame    = _optionsContainer.frame;
    CGFloat startx  = CGRectGetMaxX(self.frame);
    CGFloat endx  = CGRectGetMinX(_optionsButton.frame) - CGRectGetWidth(frame);
    BOOL isShowingOptions = _optionsShowingLeadingConstraint.isActive;
    frame.origin.x  =  isShowingOptions ? startx : endx; // Move based on current position
    __block UIView *sendingView = sender;
    [UIView animateWithDuration:0.2
                          delay:ZERO_FLOAT
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:
     ^{
         [self changeOptionsButtonImage:!_presentingButtons];
         [_textfield setAlpha:isShowingOptions];
         [self.optionsViewController deselectAllButtons];
         if ([sender isKindOfClass:[UIView class]]) {
             sendingView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
         }
         
         if (!isShowingOptions)
         {
             [NSLayoutConstraint deactivateConstraints: @[_optionsHiddenLeadingConstraint]];
             [NSLayoutConstraint activateConstraints: @[_optionsShowingLeadingConstraint]];
         }
         else
         {
             [NSLayoutConstraint deactivateConstraints: @[_optionsShowingLeadingConstraint]];
             [NSLayoutConstraint activateConstraints: @[_optionsHiddenLeadingConstraint]];
         }
         [self layoutIfNeeded];
         
     } completion:^(BOOL finished) {
         sendingView.transform = CGAffineTransformIdentity;
         _presentingButtons = !_presentingButtons;
         [self invalidateIntrinsicContentSize];
         if (_presentingAttachmentType)
         {
             [self toggleOptionsWithConstraints:_optionsButton];
         }
     }];
}

- (void)toggleOptionsWithConstraints:(id)sender
{
    NSLayoutConstraint *optionsHeight = [_optionsContainer.heightAnchor constraintEqualToAnchor: _optionsButton.heightAnchor];
    [NSLayoutConstraint activateConstraints: @[optionsHeight]];
    
    [_containingView bringSubviewToFront: _optionsContainer];
    
    __block UIView *sendingView = sender;
    __block NSLayoutConstraint *correctHeightConstraint     = _additionalShowingHeightConstraint;
    __block NSLayoutConstraint *incorrectHeightConstraint   = _additionalHiddenHeightConstraint;
    
    if ( _presentingAttachmentType ) {
        correctHeightConstraint     = _additionalHiddenHeightConstraint;
        incorrectHeightConstraint   = _additionalShowingHeightConstraint;
    }
    
    [UIView animateWithDuration:0.1
                          delay:ZERO_FLOAT
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         sendingView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
                         [NSLayoutConstraint deactivateConstraints:@[incorrectHeightConstraint]];
                         [NSLayoutConstraint activateConstraints:@[correctHeightConstraint]];
                         [self invalidateIntrinsicContentSize];
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                          _presentingAttachmentType = !_presentingAttachmentType;
                         sendingView.transform = CGAffineTransformIdentity;
                     }];
}


- (void)changeOptionsButtonImage:(BOOL)presenting
{
    UIImage *image = [UIImage imageNamed:@"paperclip"];
    if (presenting) {
        image = [UIImage imageNamed:@"CloseButton"];
    }
    [_optionsButton setImage:image forState:UIControlStateNormal];
}

- (void)changeHeightConstraintToPresenting:(BOOL)presenting
{
    _presentingAttachmentType = presenting;
    [self invalidateIntrinsicContentSize];
}


- (CGSize)intrinsicContentSize
{
    CGSize newSize = self.bounds.size;
    if (_presentingAttachmentType)
    {
        newSize.height = 160.0;
    }
    else
    {
        newSize.height = KTAStandardTouchDimension;
    }
    return newSize;
}


#pragma mark - STUFF

- (void)setupOptionalContentViews
{
    
}


@end
