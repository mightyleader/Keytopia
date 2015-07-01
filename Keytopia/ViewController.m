//
//  ViewController.m
//  Keytopia
//
//  Created by Rob Stearn on 05/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "ViewController.h"
#import "AccessoryInputView.h"
#import "Datasource.h"
#import "ModelMessage.h"
#import "ModelStatus.h"
#import "UIColor+ColorHelper.h"

@import QuartzCore;
@import Photos;

#define kAccessoryInputViewHeight 44.0f
#define kTableViewTopInset 20.0f

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic) Datasource *datasource;
@property (nonatomic) AccessoryInputView *accessoryInputView;

@end

@implementation ViewController

/**
 *  All we do here is remove all notifications registered to this instance.
 */
- (void)dealloc
{
  NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
  [nCenter removeObserver:self];
}

/**
 *  Sets up the datasource, notifications, tableview and text input fields
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupData];
  [self setupNotifications];
  [self setupTableview];
  [self setupAccessoryInputView];
  self.title = @"Keytopia";
}

/**
 *  In here we set the textfield in our 'fake' text input area to be first responder.
 *  This triggers the keyboard to show, which in turn triggers a notification.
 *
 *  @param animated whether to animate.
 */
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self becomeFirstResponder];
}


- (void)setupData
{
  _datasource = [[Datasource alloc] init];
}

/**
 *  Register for the various keyboard notifications and send them to internal methods.
 */
- (void)setupNotifications
{
  NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
  
  [nCenter addObserver:self
              selector:@selector(keyboardDidShow:)
                  name:UIKeyboardDidShowNotification
                object:nil];
}

/**
 *  Sets up the tableview with cell type and styling. Also sets the initial insets around the fake text input view.
 */
- (void)setupTableview
{
  [_tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
  [_tableview setBackgroundColor:[UIColor clearColor]];
  [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"numberCell"];
  [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [_tableview setSeparatorColor:[UIColor clearColor]];
  
  UIEdgeInsets tableViewInsets = UIEdgeInsetsMake(kTableViewTopInset,
                                                  0.0f,
                                                  kAccessoryInputViewHeight,
                                                  0.0f);
  [self setTableViewInsets:tableViewInsets];
}


- (void)setupAccessoryInputView
{
  CGRect realFrame = CGRectMake(0.0f,
                                0.0f,
                                CGRectGetWidth(self.view.frame),
                                44.0f);
  
  _accessoryInputView = [[self class] accessoryInputViewWithFrame:realFrame];
  [_accessoryInputView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_accessoryInputView setPhotoHandler:[self photoAction]];
  [_accessoryInputView.textfield setDelegate:self];
}


- (void)setTableViewInsets:(UIEdgeInsets)edgeInsets
{
  [_tableview setContentInset:edgeInsets];
  [_tableview setScrollIndicatorInsets:edgeInsets];
}


#pragma mark - Tableview data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  return [_datasource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"numberCell"];
  
  NSInteger row = indexPath.row;
  id<ModelProtocol> object = [_datasource objectAtIndex:row];
  
  [cell.textLabel setText:[object message]];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  UIColor *textColour;
  UIFont  *textFont;
  
  [cell.textLabel.layer setCornerRadius:9.0f];
  [cell.textLabel.layer setMasksToBounds:YES];
  [cell.textLabel setNumberOfLines:0];
  [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
  
  if ([object isKindOfClass:[ModelMessage class]]) {
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    textColour = [UIColor whiteColor];
    textFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.detailTextLabel.text = [[(ModelMessage *)object datePosted] description];
    cell.textLabel.backgroundColor = [(ModelMessage *)object backgroundColor];
    textColour = [UIColor textColorForBackgroundColor:[(ModelMessage *)object backgroundColor]];
  }
  
  if ([object isKindOfClass:[ModelStatus class]]) {
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    textColour = [UIColor lightGrayColor];
    textFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    cell.detailTextLabel.text = @""; // TODO: make a constant
    [cell.textLabel.layer setCornerRadius:5.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
  }
  
  cell.textLabel.textColor = textColour;
  cell.textLabel.font = textFont;
  cell.contentView.backgroundColor = [UIColor clearColor];
  cell.backgroundColor = [UIColor clearColor];
  
  return cell;
}


#pragma mark - Button actions

- (AccessoryInputViewOptionSelectHandler)photoAction
{
  __weak typeof(self) weakSelf = self;
  
  return ^(BOOL show) {
    typeof(self) strongSelf = weakSelf;
    if ( !strongSelf ) { return; }
    
    };
}

- (AccessoryInputViewOptionSelectHandler)cameraAction
{
  __weak typeof(self) weakSelf = self;
  
  return ^(BOOL show) {
    typeof(self) strongSelf = weakSelf;
    if ( !strongSelf ) { return; }

  };
}

- (AccessoryInputViewOptionSelectHandler)audioAction
{
  __weak typeof(self) weakSelf = self;
  
  return ^(BOOL show) {
    typeof(self) strongSelf = weakSelf;
    if ( !strongSelf ) { return; }

  };
}

- (AccessoryInputViewOptionSelectHandler)pdfAction
{
  __weak typeof(self) weakSelf = self;
  
  return ^(BOOL show) {
    typeof(self) strongSelf = weakSelf;
    if ( !strongSelf ) { return; }

  };
}

- (AccessoryInputViewOptionSelectHandler)vcardAction
{
  __weak typeof(self) weakSelf = self;
  
  return ^(BOOL show) {
    typeof(self) strongSelf = weakSelf;
    if ( !strongSelf ) { return; }

  };
}



#pragma mark - Scroll to position

- (void)scrollToLatestEntryAnimated:(BOOL)animated
{
  NSInteger datasourceCount = _datasource.count;
  if (datasourceCount > 0) {
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:(datasourceCount - 1)
                                                    inSection:0];
    [_tableview scrollToRowAtIndexPath:lastIndexPath
                      atScrollPosition:UITableViewScrollPositionBottom
                              animated:animated];
  }
}


#pragma mark - Keyboard notifications

- (void)keyboardDidShow:(NSNotification *)notification
{
  //get the end frame of the keyboard when it's presented
  NSDictionary *userInfo = notification.userInfo;
  NSValue *valueObject = userInfo[UIKeyboardFrameEndUserInfoKey];
  CGRect endFrame = valueObject.CGRectValue;
  
  //get the insets right on the tableview content
  UIEdgeInsets tableViewInsets = UIEdgeInsetsMake(kTableViewTopInset,
                                                  0.0f,
                                                  endFrame.size.height,
                                                  0.0f);
  [self setTableViewInsets:tableViewInsets];
 
  //somehow scroll to the bottom of the list
  [self scrollToLatestEntryAnimated:YES];
}


#pragma mark - Accessory Input View

+ (AccessoryInputView *)accessoryInputViewWithFrame:(CGRect)frame
{
  AccessoryInputView *inputView = [[AccessoryInputView alloc] initWithFrame:frame
                                                             inputViewStyle:UIInputViewStyleKeyboard];
  return inputView;
}


#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ([textField isEqual:_accessoryInputView.textfield]) {
    if (textField.text.length > 0)
      {
        ModelMessage *message = [[ModelMessage alloc] initWithMessage:textField.text
                                                           datePosted:[NSDate date]
                                                                 sent:YES];
        [_datasource addToDatasource:message];
        [_tableview reloadData];
        [self scrollToLatestEntryAnimated:YES];
        [textField setText:@""];
        return YES;
      }
  }
  return NO;
}

#pragma mark - this is going to be awesome

- (BOOL)canBecomeFirstResponder
{
  return YES;
}

- (UIView *)inputAccessoryView
{
  return _accessoryInputView;
}

@end
