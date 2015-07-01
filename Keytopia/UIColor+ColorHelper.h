//
//  UIColor+UIColor_ColorHelper.h
//  Keytopia
//
//  Created by Rob Stearn on 01/07/2015.
//  Copyright © 2015 cocoadelica. All rights reserved.
//

@import UIKit;

@interface UIColor (ColorHelper)

+ (UIColor *)randomColourObjectWithAlpha:(CGFloat)alpha;

+ (NSString *)randomHTMLColour:(CGFloat)withAlpha;

+ (UIColor *)colourObjectFromHTMLColour:(NSString *)hexColourString;

+ (NSString *)colourStringFromColourObject:(UIColor *)colour withAlpha:(BOOL)withAlpha;

+ (UIColor *)textColorForBackgroundColor:(UIColor *)backgroundColor;

@end
