//
//  ModelMessage.h
//  Keytopia
//
//  Created by Rob Stearn on 08/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "ModelProtocol.h"

@interface KeytopiaModelMessage : NSObject <KeytopiaModelProtocol>

@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSDate   *datePosted;
@property (nonatomic, readonly) UIColor  *backgroundColor;
@property (nonatomic, readonly) BOOL     sent;

- (instancetype)initWithMessage:(NSString *)message
                     datePosted:(NSDate *)postDate
                           sent:(BOOL)sent;

@end
