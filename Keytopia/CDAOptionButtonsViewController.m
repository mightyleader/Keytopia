//
//  CDAOptionButtonsViewController.m
//  Keytopia
//
//  Created by Rob Stearn on 12/08/2015.
//  Copyright © 2015 cocoadelica. All rights reserved.
//

#import "CDAOptionButtonsViewController.h"
#import "CDAOptionButton.h"
@import QuartzCore;

#define KTAOptionsButtonWidth       52.0f
#define KTAStandardTouchDimension   44.0f

@interface CDAOptionButtonsViewController ()

@end

@implementation CDAOptionButtonsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setupButtons];
}

- (void)setupButtons
{
    NSMutableArray *optionButtons = [NSMutableArray array];
    NSArray *optionButtonImageNames = @[@"Contact",
                                        @"BusinessCard",
                                        @"Audio",
                                        @"Sticker",
                                        @"Smartphone",
                                        @"Photo" ];
    
    CDAOptionButton *button;
    NSInteger count = optionButtonImageNames.count;
    CGFloat width   = (CGRectGetWidth(self.view.frame) - KTAStandardTouchDimension) / count;
    
//    _optionsContainer = [[UIView alloc] initWithFrame:CGRectZero];
//    [_optionsContainer setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    for (NSInteger i = 0; i < count; i++)
    {
        UIImage *image = [UIImage imageNamed:optionButtonImageNames[i]];
        button = [[CDAOptionButton alloc] initWithFrame:CGRectMake(width * i, 0.0, width, KTAStandardTouchDimension)
                                               andImage:image
                                              tintColor:[UIColor darkGrayColor]
                                        backgroundColor:[UIColor clearColor]];
        [button setTranslatesAutoresizingMaskIntoConstraints: NO];
        [button setTag:i];
        [button addTarget:self
                   action:@selector(toggleOptionsWithConstraints:)
         forControlEvents:UIControlEventTouchUpInside];
        [optionButtons addObject:button];
        [self.view addSubview:button];
        if (i == 0.0)
        {
            [NSLayoutConstraint activateConstraints: @[
                                                       [button.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor],
                                                       [button.topAnchor constraintEqualToAnchor: self.view.topAnchor],
                                                       [button.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                                       [button.widthAnchor constraintEqualToConstant:width]
                                                       ]];
        }
        else
        {
            CDAOptionButton *previousButton = (CDAOptionButton *)[optionButtons objectAtIndex: i - 1];
            [NSLayoutConstraint activateConstraints: @[
                                                       [button.leadingAnchor constraintEqualToAnchor: previousButton.trailingAnchor],
                                                       [button.topAnchor constraintEqualToAnchor: previousButton.topAnchor],
                                                       [button.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                                       [button.widthAnchor constraintEqualToConstant:width]
                                                       ]];
        }
    }

}

- (void)handleOptionBlockForButton:(id)sender
{
    AccessoryInputOption chosenOption = [sender tag];
    BOOL show = YES;
    
    if (!_presentingAttachmentType) {
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

- (void)deselectAllButtons
{
    for (UIButton *button in _optionButtons) {
        [button setBackgroundColor:[UIColor clearColor]];
        [button.imageView setTintColor:[UIColor blackColor]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
