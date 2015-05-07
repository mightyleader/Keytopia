//
//  AccessoryInputView.m
//  Keytopia
//
//  Created by Rob Stearn on 07/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "AccessoryInputView.h"
@import QuartzCore;

@interface AccessoryInputView ()

@property (nonatomic) UITextField *textfield;
@property (nonatomic) UIButton    *optionsButton;

@end

@implementation AccessoryInputView

- (instancetype)initWithFrame:(CGRect)frame
               inputViewStyle:(UIInputViewStyle)inputViewStyle
{
  self = [super initWithFrame:frame
               inputViewStyle:inputViewStyle];
  if (self)
  {
  [self setupSubviews];
  }
  return self;
}

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
  
  [_optionsButton setTintColor:[UIColor whiteColor]];
  UIImage *paperclip = [UIImage imageNamed:@"paperclip"];
  [_optionsButton setImage:paperclip forState:UIControlStateNormal];
  
  [self setBackgroundColor:[UIColor darkGrayColor]];
}

- (void)updateConstraints
{
  NSDictionary *constrained = NSDictionaryOfVariableBindings(_optionsButton, _textfield);
  NSMutableArray *constraints = [NSMutableArray array];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_textfield]-[_optionsButton(==44)]-5-|"
                                                                           options:kNilOptions
                                                                           metrics:nil
                                                                             views:constrained]];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_textfield]-5-|"
                                                                           options:kNilOptions
                                                                           metrics:nil
                                                                             views:constrained]];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_optionsButton]-0-|"
                                                                           options:kNilOptions
                                                                           metrics:nil
                                                                             views:constrained]];
  [self addConstraints:constraints];
  [super updateConstraints];
}

@end
