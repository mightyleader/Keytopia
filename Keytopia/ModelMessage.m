//
//  ModelMessage.m
//  Keytopia
//
//  Created by Rob Stearn on 08/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "ModelMessage.h"

@interface ModelMessage ()

@property (nonatomic) NSString *message;
@property (nonatomic) NSDate   *datePosted;
@property (nonatomic) BOOL     sent;

@end

@implementation ModelMessage

- (instancetype)initWithMessage:(NSString *)message
                     datePosted:(NSDate *)postDate
                           sent:(BOOL)sent
{
  self = [super init];
  if (self)
  {
    _message = message;
    _datePosted = postDate;
    _sent = sent;
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
    ModelMessage *objectToTest = object;
    
    BOOL messageMatch = [objectToTest.message isEqualToString:_message];
    BOOL dateMatch = [objectToTest.datePosted isEqualToDate:_datePosted];
    
    if (messageMatch && dateMatch)
      {
      return YES;
      }
    
    return NO;
    }
}

- (NSUInteger)hash
{
  return _message.hash ^ _datePosted.hash;
}


@end
