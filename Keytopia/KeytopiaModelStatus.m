//
//  ModelStatus.m
//  Keytopia
//
//  Created by Rob Stearn on 08/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "KeytopiaModelStatus.h"

@interface KeytopiaModelStatus ()

@property (nonatomic) NSString *message;

@end

@implementation KeytopiaModelStatus

- (instancetype)initWithMessage:(NSString *)message
{
  self = [super init];
  if (self)
  {
    _message = message;
  }
  return self;
}

- (BOOL) isEqual:(id)object
{
  if (![object isKindOfClass:[self class]])
    {
    return NO;
    }
  else
    {
    KeytopiaModelStatus *objectToTest = object;
    
    BOOL messageMatch = [objectToTest.message isEqualToString:_message];
    
    if (messageMatch)
      {
      return YES;
      }
    
    return NO;
    }
}

- (NSUInteger)hash
{
  return _message.hash;
}

@end
