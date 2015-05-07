//
//  ViewController.m
//  Keytopia
//
//  Created by Rob Stearn on 05/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "ViewController.h"
#import "AccessoryInputView.h"
#import "DatasourceModel.h"

#define kAccessoryInputViewHeight 44.0f
#define kTableViewTopInset 20.0f

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic) DatasourceModel *datasource;
@property (nonatomic) AccessoryInputView *fauxAccessoryInputView;
@property (nonatomic) AccessoryInputView *accessoryInputView;

@end

@implementation ViewController

- (void)dealloc
{
  NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
  [nCenter removeObserver:self];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupData];
  [self setupNotifications];
  [self setupTableview];
  [self setupAccessoryInputViews];
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [_fauxAccessoryInputView.textfield becomeFirstResponder];
}


- (void)setupData
{
  _datasource = [[DatasourceModel alloc] init];
}


- (void)setupNotifications
{
  NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
  
  [nCenter addObserver:self
              selector:@selector(keyboardWillShow:)
                  name:UIKeyboardWillShowNotification
                object:nil];
  
  [nCenter addObserver:self
              selector:@selector(keyboardDidShow:)
                  name:UIKeyboardDidShowNotification
                object:nil];
  
  [nCenter addObserver:self
              selector:@selector(keyboardWillHide:)
                  name:UIKeyboardWillHideNotification
                object:nil];
  
  [nCenter addObserver:self
              selector:@selector(keyboardDidHide:)
                  name:UIKeyboardDidHideNotification
                object:nil];
}


- (void)setupTableview
{
  [_tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
  [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"numberCell"];

  UIEdgeInsets tableViewInsets = UIEdgeInsetsMake(kTableViewTopInset, 0, kAccessoryInputViewHeight, 0);
  [self setTableViewInsets:tableViewInsets];
}


- (void)setupAccessoryInputViews
{
  CGRect realFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44.0f);
  CGRect fauxFrame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 44.0f, CGRectGetWidth(self.view.frame), 44.0f);
  _accessoryInputView = [[self class] accessoryInputViewWithFrame:realFrame];
  _fauxAccessoryInputView = [[self class] accessoryInputViewWithFrame:fauxFrame];
  
  [self.view addSubview:_fauxAccessoryInputView];
  [self.view bringSubviewToFront:_fauxAccessoryInputView];
  [_fauxAccessoryInputView.textfield setInputAccessoryView:_accessoryInputView];
  [_fauxAccessoryInputView.textfield becomeFirstResponder];
  
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
  return _datasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"numberCell"];
  
  NSInteger row = indexPath.row;
  NSString *title = [_datasource objectAtIndex:row];
  
  [cell.textLabel setText:title];
  
  return cell;
}


#pragma mark - Scroll to position

- (void)scrollToLatestEntryAnimated:(BOOL)animated
{
  NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_datasource.count - 1 inSection:0];
  [_tableview scrollToRowAtIndexPath:lastIndexPath
                    atScrollPosition:UITableViewScrollPositionBottom
                            animated:animated];
}


#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
  _fauxAccessoryInputView.hidden = YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
  //get the end frame of the keyboard when it's presented
  NSDictionary *userInfo = notification.userInfo;
  NSValue *valueObject = userInfo[UIKeyboardFrameEndUserInfoKey];
  CGRect endFrame = valueObject.CGRectValue;
  
  //get hte insets right on the tableview content
  UIEdgeInsets tableViewInsets = UIEdgeInsetsMake(kTableViewTopInset, 0.0f, endFrame.size.height, 0.0f);
  [self setTableViewInsets:tableViewInsets];
  
  //get the cursor in the real input view
  [_accessoryInputView.textfield becomeFirstResponder];
  
  //somehow scroll to the bottom of the list
  [self scrollToLatestEntryAnimated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
  _fauxAccessoryInputView.hidden = NO;
  
  //prevents the keyboard auto-reappearing
  [_accessoryInputView.textfield resignFirstResponder];
}


- (void)keyboardDidHide:(NSNotification *)notification
{
  UIEdgeInsets tableViewInsets = UIEdgeInsetsMake(kTableViewTopInset, 0.0f, kAccessoryInputViewHeight, 0.0f);
  [self setTableViewInsets:tableViewInsets];
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
      [_datasource addToDatasource:textField.text];
      [_tableview reloadData];
      [self scrollToLatestEntryAnimated:YES];
      [textField setText:@""];
      return YES;
    }
  }
  return NO;
}

@end
