//
//  OptionButton.m
//  Keytopia
//
//  Created by Rob Stearn on 09/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "CDAOptionButton.h"

@implementation CDAOptionButton

- (instancetype)initWithFrame:(CGRect)frame
                     andImage:(UIImage *)image
                    tintColor:(UIColor *)tint
              backgroundColor:(UIColor *)background
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setImage:image forState:UIControlStateNormal];
    [self setTintColor:tint];
    [self setBackgroundColor:background];
  }
  return self;
}

@end
