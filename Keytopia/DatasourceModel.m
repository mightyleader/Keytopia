//
//  Datasource.m
//  Keytopia
//
//  Created by Rob Stearn on 07/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "DatasourceModel.h"

@interface DatasourceModel ()

@property (nonatomic) NSArray *internalData;

@end

@implementation DatasourceModel

- (instancetype)init
{
  self = [super init];
  if (self) {
    NSMutableArray *mutableData = [NSMutableArray array];
    for (NSInteger i = 0; i <= 100; i++)
      {
      NSString *thingToAddToArray = [NSString stringWithFormat:@"%li", (long)i];
      [mutableData addObject:thingToAddToArray];
      }
    _internalData =  [NSArray arrayWithArray:mutableData];
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

- (void)addToDatasource:(id)addition
{
  _internalData = [[self class] addObject:addition toArray:_internalData];
}

#pragma mark - Private class methods

+ (NSArray *)addObject:(id)object toArray:(NSArray *)array
{
  NSMutableArray *mutable = [NSMutableArray arrayWithArray:array];
  if (object) {
    [mutable addObject:object];
  }
  return [NSArray arrayWithArray:mutable];
}

@end
