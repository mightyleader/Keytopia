//
//  UIColor+UIColor_ColorHelper.m
//  Keytopia
//
//  Created by Rob Stearn on 01/07/2015.
//  Copyright © 2015 cocoadelica. All rights reserved.
//

#import "UIColor+ColorHelper.h"

@implementation UIColor (ColorHelper)

+ (UIColor *)randomColourObjectWithAlpha:(CGFloat)alpha
{
  UIColor *randomColour;
  srand48(time(0));
  CGFloat red = drand48();
  CGFloat blue = drand48();
  CGFloat green = drand48();
  randomColour = [UIColor colorWithRed:red green:blue blue:green alpha:alpha];
  return randomColour;
}


+ (NSString *)randomHTMLColour:(CGFloat)withAlpha
{
  NSMutableString *randomHTMLColour = [NSMutableString string];
  int red, green, blue, alpha;
  srand48(time(0));
  
  if (withAlpha < 1 && withAlpha > 0)
  {
    alpha = ceil(withAlpha * 255);
    [randomHTMLColour appendString:[NSString stringWithFormat:@"%2x", alpha]]; //AA
  }
  else if (withAlpha == 0)
  {
    [randomHTMLColour appendString:@"00"];
  }
  
  red = ceil(drand48() * 255);
  [randomHTMLColour appendString:[NSString stringWithFormat:@"%2x", red]]; //RR
  green = ceil(drand48() * 255);
  [randomHTMLColour appendString:[NSString stringWithFormat:@"%2x", green]]; //GG
  blue = ceil(drand48() * 255);
  [randomHTMLColour appendString:[NSString stringWithFormat:@"%2x", blue]]; //BB
  
  return randomHTMLColour;
}


+ (UIColor *)colourObjectFromHTMLColour:(NSString *)hexColourString
{
  UIColor *colourFromHex = nil;
  NSInteger location, index, range = 2;
  NSInteger length = hexColourString.length * 0.5;
  CGFloat colourcomponents[length];
  
  for (location = 0, index = 0; location < hexColourString.length; location += range, index ++)
  {
    colourcomponents[index] = [UIColor getColourValueFromHexString:hexColourString inRange:NSMakeRange(location, range)];
  }
  
  if (colourcomponents)
  {
    colourFromHex = [UIColor colorWithRed:length == 4?colourcomponents[1]:colourcomponents[0]
                                    green:length == 4?colourcomponents[2]:colourcomponents[1]
                                     blue:length == 4?colourcomponents[3]:colourcomponents[2]
                                    alpha:length == 4?colourcomponents[0]:1.0];
  }
  return colourFromHex;
}

+ (NSString *)colourStringFromColourObject:(UIColor *)colour withAlpha:(BOOL)withAlpha
{
  NSMutableString *stringFromColour = [NSMutableString string];
  CGFloat colourComponents[4];
  [colour getRed:&colourComponents[0] green:&colourComponents[1] blue:&colourComponents[2] alpha:&colourComponents[3]];
  
  for (NSInteger index = 0; index < 4; index++)
  {
    NSString *hexElement = [NSString stringWithFormat:@"%2x", (int)colourComponents[index] * 255];
    [stringFromColour appendString:hexElement];
  }
  
  return stringFromColour;
}

+ (UIColor *)textColorForBackgroundColor:(UIColor *)backgroundColor {
  UIColor *newTextColor;
  const CGFloat *componentColors = CGColorGetComponents(backgroundColor.CGColor);
  CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
  if (colorBrightness < 0.7)
  {
    newTextColor = [UIColor whiteColor];
  }
  else
  {
    newTextColor = [UIColor darkGrayColor];
  }
  
  return newTextColor;
}

#pragma mark - private

+ (CGFloat) getColourValueFromHexString:(NSString *)hexString inRange:(NSRange)range
{
  unsigned hexIntValue = 0;
  NSString *hexSubstring = [hexString substringWithRange:range];
  [[NSScanner scannerWithString:hexSubstring] scanHexInt:&hexIntValue];
  
  return (hexIntValue / 255);
}

@end
