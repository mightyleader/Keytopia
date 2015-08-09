//
//  ModelMessage.m
//  Keytopia
//
//  Created by Rob Stearn on 08/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "KeytopiaModelMessage.h"
#import "UIColor+ColorHelper.h"

@interface KeytopiaModelMessage ()

@property (nonatomic) NSString *message;
@property (nonatomic) NSDate   *datePosted;
@property (nonatomic) BOOL     sent;

@end

@implementation KeytopiaModelMessage

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
    _backgroundColor = [UIColor randomColourObjectWithAlpha:1.0];
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
    KeytopiaModelMessage *objectToTest = object;
    
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
