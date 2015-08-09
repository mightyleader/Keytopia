//
//  Datasource.m
//  Keytopia
//
//  Created by Rob Stearn on 07/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "KeytopiaDatasource.h"
#import "KeytopiaModelMessage.h"
#import "KeytopiaModelStatus.h"

@interface KeytopiaDatasource ()

@property (nonatomic) NSArray *internalData;

@end

@implementation KeytopiaDatasource

- (instancetype)init
{
  self = [super init];
  if (self) {
    _internalData = [[self class] generateRandomData];
  }
  return self;
}

- (NSInteger)count
{
  return _internalData.count;
}

- (id)objectAtIndex:(NSInteger)index
{
  return _internalData[index];
}

- (void)addToDatasource:(id<KeytopiaModelProtocol>)addition
{
  _internalData = [[self class] addObject:addition toArray:_internalData];
}

#pragma mark - Private class methods

+ (NSArray *)addObject:(id)object toArray:(NSArray *)array
{
  NSMutableArray *mutable = [NSMutableArray arrayWithArray:array];
  
  if (object && [object conformsToProtocol:@protocol(KeytopiaModelProtocol)])
  {
    [mutable addObject:object];
  }
  return [NSArray arrayWithArray:mutable];
}


+ (NSArray *)generateRandomData
{
  NSMutableArray *mutableData = [NSMutableArray array];
  for (NSInteger i = 0; i <= 21; i++)
    {
    id<KeytopiaModelProtocol> thingToAddToArray;
    
    NSInteger modulus = i % 3;
    if (modulus == 0)
      {
      thingToAddToArray = [[KeytopiaModelStatus alloc] initWithMessage:@"User left the room"];
      }
    else
      {
      thingToAddToArray = [[KeytopiaModelMessage alloc] initWithMessage:@"Hey there!"
                                                     datePosted:[NSDate date]
                                                           sent:YES];
      }
    
    [mutableData addObject:thingToAddToArray];
    thingToAddToArray = nil;
    }
  
  return [NSArray arrayWithArray:mutableData];
}

@end
