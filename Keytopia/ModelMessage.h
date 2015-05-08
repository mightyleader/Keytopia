//
//  ModelMessage.h
//  Keytopia
//
//  Created by Rob Stearn on 08/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

@import Foundation;
#import "ModelProtocol.h"

@interface ModelMessage : NSObject <ModelProtocol>

@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSDate   *datePosted;
@property (nonatomic, readonly) BOOL     sent;

- (instancetype)initWithMessage:(NSString *)message
                     datePosted:(NSDate *)postDate
                           sent:(BOOL)sent;

@end
