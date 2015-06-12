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

@interface AccessoryInputView ()

@property (nonatomic) UIView *containingView;
@property (nonatomic) UITextField *textfield;
@property (nonatomic) UIButton   *optionsButton;
@property (nonatomic) UIVisualEffectView *blurBackgroundView;

@property (nonatomic) UIView *optionsContainer;
@property (nonatomic) NSArray *optionButtons;

@property (nonatomic) BOOL placeholder;
@property (nonatomic) BOOL presenting;

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
  _textfield      = [[UITextField alloc] initWithFrame:CGRectZero];
  _optionsButton  = [UIButton buttonWithType:UIButtonTypeCustom];
  _containingView = [[UIView alloc] initWithFrame:CGRectZero];
  
  // auto layout
  [_textfield setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_optionsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_containingView setTranslatesAutoresizingMaskIntoConstraints:NO];
  
  [_containingView addSubview:_textfield];
  [_containingView addSubview:_optionsButton];
  [self addSubview:_containingView];
  
  // configure text input and button
  [_textfield setKeyboardAppearance:UIKeyboardAppearanceLight];
  [_textfield setReturnKeyType:UIReturnKeySend];
  [_textfield setTintColor:[UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000]];
  [_textfield setTextColor:[UIColor colorWithWhite:0.200 alpha:1.000]];
  [_textfield.layer setCornerRadius:5.0f];
  [_textfield setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.0]];
  [_textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
  
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
  
  if (_placeholder) {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _blurBackgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurBackgroundView.frame = self.bounds;
    [self addSubview:_blurBackgroundView];
    [self sendSubviewToBack:_blurBackgroundView];
  }
  else {
    //DEBUG
    //[self setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
  }
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

- (void)updateConstraints
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
    
    [_textentryConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[_textfield]-6-[_optionsButton(==32)]-6-|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:constrained]];
    [_textentryConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_textfield(==32)]-6-|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:constrained]];
    [_textentryConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_optionsButton(==32)]-6-|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:constrained]];
    
  }
  
  [self addConstraints:_containerConstraints];
  [_containingView addConstraints:_textentryConstraints];
  
  [super updateConstraints];
}

#pragma mark - Event handler

- (void)toggleOptions:(id)sender
{
  CGRect frame    = _optionsContainer.frame;
  CGFloat startx  = CGRectGetMaxX(self.frame);
  CGFloat endx  = CGRectGetMinX(_optionsButton.frame) - CGRectGetWidth(frame);
  frame.origin.x  = _presenting ? startx : endx;
  [UIView animateWithDuration:0.3
                        delay:0.0
       usingSpringWithDamping:0.4
        initialSpringVelocity:0.4
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:
   ^{
     [_optionsContainer setFrame:frame];
     [self changeOptionsButtonImage:!_presenting];
   } completion:^(BOOL finished) {
   }];
  _presenting = !_presenting;
}


- (void)changeOptionsButtonImage:(BOOL)presenting
{
  UIImage *image = [UIImage imageNamed:@"paperclip"];
  if (presenting) {
    image = [UIImage imageNamed:@"CloseButton"];
  }
  [_textfield setAlpha:!presenting];
  [_optionsButton setImage:image forState:UIControlStateNormal];
}


- (void)handleOptionBlockForButton:(id)sender
{
  AccessoryInputOption chosenOption = [sender tag];
  BOOL show = YES;
  switch (chosenOption) {
    case AccessoryInputOptionCamera:
    {
    [self toggleOptions:sender];
    [self changeHeightConstraintToPresenting:YES];
    self.photoHandler(show);
    }
      break;
    case AccessoryInputOptionPhotoLibrary:
    {
    [self toggleOptions:sender];
    [self changeHeightConstraintToPresenting:YES];
    self.photoHandler(show);
    }
      break;
    case AccessoryInputOptionAudioRecord:
    {
    [self toggleOptions:sender];
    [self changeHeightConstraintToPresenting:YES];
    self.photoHandler(show);
    }
      break;
    case AccessoryInputOptionPDFMe:
    {
    [self toggleOptions:sender];
    [self changeHeightConstraintToPresenting:YES];
    self.photoHandler(show);
    }
      break;
    case AccessoryInputOptionVCard:
    {
    [self toggleOptions:sender];
    [self changeHeightConstraintToPresenting:YES];
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
  NSInteger heightConstant = 44.0f;
  if (presenting) {
    heightConstant = 160.0f;
  }
  //  NSLayoutConstraint *heightConstraint = [[self constraints] firstObject];
  //  heightConstraint.constant = heightConstant;
  //  [self setNeedsDisplay];
  
  [self setFrame: CGRectMake(0, 0, 375, 160)];
  [self setNeedsDisplay];
}


#pragma mark - STUFF

- (void)setupOptionalContentViews
{
  //  _flow = [[UICollectionViewFlowLayout alloc] init];
  //  _photos = [[PhotoLibraryCollection alloc] initWithCollectionViewLayout:_flow];
  //  _collectionView = _photos.collectionView;
  //  [_flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  //  [_flow setEstimatedItemSize:CGSizeMake(100, 100)];
  //  [self addChildViewController:_photos];
  //  CGFloat bottomInset       = strongSelf.tableview.contentInset.bottom;
  //  CGFloat topInset          = strongSelf.tableview.contentInset.top;
  //  UIEdgeInsets currentInset = UIEdgeInsetsMake(60 + topInset, 10, bottomInset, 10);
  //
  //  if (show) {
  //    [strongSelf.view addSubview:strongSelf.collectionView];
  //    strongSelf.collectionView.contentInset = currentInset;
  //  }
  //  else {
  //    [strongSelf.collectionView removeFromSuperview];
  //  }
  
}


@end
