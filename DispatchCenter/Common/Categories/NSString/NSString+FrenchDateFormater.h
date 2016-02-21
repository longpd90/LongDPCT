//
//  NSString+FrenchDateFormater.h
//  TimerWithBlock
//
//  Created by Benjamin SENECHAL on 20/06/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FrenchDateFormater)

- (NSString *)makeDateWithFormat:(NSString *)format;
- (NSString *)dateMMDDYY;
- (CGRect)rectForStringWithWidth:(CGFloat)width andFont:(UIFont*)font;
- (NSDate *)dateFromFomratStringMMDDYY;
- (NSString *)dateMMDDYYVersionTwo;

@end
