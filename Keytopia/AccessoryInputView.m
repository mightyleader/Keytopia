//
//  AccessoryInputView.m
//  Keytopia
//
//  Created by Rob Stearn on 07/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "AccessoryInputView.h"
#import "OptionButton.h"
@import QuartzCore;

@interface AccessoryInputView ()

@property (nonatomic) UITextField *textfield;
@property (nonatomic) UIButton   *optionsButton;
@property (nonatomic) UIVisualEffectView *blurBackgroundView;
@property (nonatomic) NSArray *optionButtons;
@property (nonatomic) BOOL placeholder;
@property (nonatomic) BOOL presenting;

@end

@implementation AccessoryInputView

#pragma mark - Public interface

- (instancetype)initWithFrame:(CGRect)frame
               inputViewStyle:(UIInputViewStyle)inputViewStyle
                  placeholder:(BOOL)placeholder
{
  self = [super initWithFrame:frame
               inputViewStyle:inputViewStyle];
  if (self)
  {
  _placeholder = placeholder;
  [self setupSubviews];
  [self setupOptionButtons];
  }
  return self;
}


#pragma mark - Private layout methods

- (void)setupSubviews
{
  // init subviews
  _textfield = [[UITextField alloc] initWithFrame:CGRectZero];
  _optionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
  
  // auto layout
  [_textfield setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_optionsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  
  [self addSubview:_textfield];
  [self addSubview:_optionsButton];
  
  // configure text input and button
  [_textfield setKeyboardAppearance:UIKeyboardAppearanceDark];
  [_textfield setReturnKeyType:UIReturnKeySend];
  [_textfield setTintColor:[UIColor orangeColor]];
  [_textfield setTextColor:[UIColor whiteColor]];
  [_textfield.layer setCornerRadius:5.0f];
  [_textfield setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.1]];
  [_textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
  
  [_optionsButton setTintColor:[UIColor whiteColor]];
  
  UIImage *paperclip = [UIImage imageNamed:@"paperclip"];
  [_optionsButton setImage:paperclip forState:UIControlStateNormal];
  
  [_optionsButton addTarget:self
                     action:@selector(toggleOptions:)
           forControlEvents:UIControlEventTouchUpInside];
  
  if (_placeholder) {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurBackgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurBackgroundView.frame = self.bounds;
    [self addSubview:_blurBackgroundView];
    [self sendSubviewToBack:_blurBackgroundView];
  }
}

- (void)setupOptionButtons
{
  NSMutableArray *optionButtons = [NSMutableArray array];
  NSArray *optionButtonImageNames = @[@"Smartphone",@"Photo",@"Audio",@"BusinessCard", @"Contact"];
  
  OptionButton *button;
  NSInteger count = optionButtonImageNames.count;
  CGFloat width   = (CGRectGetWidth(self.frame) - 39.0f) / count;
  CGFloat height  = CGRectGetHeight(self.frame);
  CGFloat maxX    = (CGRectGetWidth(self.frame) - 39.0f);
  
  for (NSInteger i = 0; i < count; i++)
  {
    UIImage *image = [UIImage imageNamed:optionButtonImageNames[i]];
    button = [[OptionButton alloc] initWithFrame:CGRectMake((maxX - (width * (i + 1))),
                                                            CGRectGetHeight(self.frame),
                                                            width, height)
                                        andImage:image
                                       tintColor:[UIColor whiteColor]
                                 backgroundColor:[UIColor darkGrayColor]];
    [button setAlpha:0.0f];
    [optionButtons addObject:button];
    [self addSubview:button];
  }
  
  _optionButtons = [NSArray arrayWithArray:optionButtons];
  _presenting = NO;
}

- (void)updateConstraints
{
  NSDictionary *constrained = NSDictionaryOfVariableBindings(_optionsButton, _textfield);
  NSMutableArray *constraints = [NSMutableArray array];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7-[_textfield]-7-[_optionsButton(==32)]-7-|"
                                                                           options:kNilOptions
                                                                           metrics:nil
                                                                             views:constrained]];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_textfield]-7-|"
                                                                           options:kNilOptions
                                                                           metrics:nil
                                                                             views:constrained]];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_optionsButton]-5-|"
                                                                           options:kNilOptions
                                                                           metrics:nil
                                                                             views:constrained]];
  [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.textfield attribute:NSLayoutAttributeBottom multiplier:1.0 constant:7.0]];
  
  [self addConstraints:constraints];
  [super updateConstraints];
}

#pragma mark - Event handler

- (void)toggleOptions:(id)sender
{
  for (OptionButton *button in _optionButtons) {
    CGRect frame = button.frame;
    frame.origin.y = _presenting ? CGRectGetHeight(self.frame) : 0;
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:
   ^{
     [button setAlpha:!_presenting];
     [button setFrame:frame];
    } completion:nil];
  }
  _presenting = !_presenting;
}


@end
