//
//  ModelStatus.m
//  Keytopia
//
//  Created by Rob Stearn on 08/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "ModelStatus.h"

@interface ModelStatus ()

@property (nonatomic) NSString *message;

@end

@implementation ModelStatus

- (instancetype)initWithMessage:(NSString *)message
{
  self = [super init];
  if (self)
  {
    _message = message;
  }
  return self;
}

@end