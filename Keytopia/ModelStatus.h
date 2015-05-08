//
//  ModelStatus.h
//  Keytopia
//
//  Created by Rob Stearn on 08/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

@import Foundation;
#import "ModelProtocol.h"

@interface ModelStatus : NSObject <ModelProtocol>

@property (nonatomic, readonly) NSString *message;

- (instancetype)initWithMessage:(NSString *)message;

@end
