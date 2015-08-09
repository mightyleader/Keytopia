//
//  Datasource.h
//  Keytopia
//
//  Created by Rob Stearn on 07/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

@import Foundation;
#import "ModelProtocol.h"

@interface KeytopiaDatasource : NSObject

- (NSInteger)count;
- (id)objectAtIndex:(NSInteger)index;
- (void)addToDatasource:(id<KeytopiaModelProtocol>)addition;

@end
