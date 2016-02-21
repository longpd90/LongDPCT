//
//  NSString+FrenchDateFormater.m
//  TimerWithBlock
//
//  Created by Benjamin SENECHAL on 20/06/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "NSString+FrenchDateFormater.h"

static NSString *const kMonthDayYearFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

@implementation NSString (FrenchDateFormater)

- (NSString *)makeDateWithFormat:(NSString *)format{
    if ([format isEqual:@"yyyy-MM-ddTHH:mm:ssZ"]) {
        NSRange year = NSMakeRange(0, 4);
        NSRange month = NSMakeRange(5, 2);
        NSRange day = NSMakeRange(8, 2);
        return [NSString stringWithFormat: @"%@/%@/%@", [self substringWithRange:day], [self substringWithRange:month], [self substringWithRange:year]];
    } else if ([format isEqual:@"YYYYMMDD"]) {
        NSRange year = NSMakeRange(0, 4);
        NSRange month = NSMakeRange(4, 2);
        NSRange day = NSMakeRange(6, 2);
        return [NSString stringWithFormat: @"%@/%@/%@", [self substringWithRange:day], [self substringWithRange:month], [self substringWithRange:year]];
    } else if ([format isEqual:@"YYYYMM"]) {
        NSRange year = NSMakeRange(0, 4);
        NSRange month = NSMakeRange(4, 2);
        return [NSString stringWithFormat: @"%@/%@", [self substringWithRange:month], [self substringWithRange:year]];
    } else {
        return @"Not yet supported";
    }
    return [[NSString alloc] init];
}

- (NSString *)dateMMDDYY
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // convert to date
    [dateFormatter setDateFormat:kMonthDayYearFormat];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:self];
    
    // date to str
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:dateFromString];
    
    return stringDate;
}


- (NSDate *)dateFromFomratStringMMDDYY
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'Z'"];
    NSDate *dateResult = [dateFormatter dateFromString:self];
    return dateResult;
}

- (NSString *)dateMMDDYYVersionTwo
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // convert to date
    [dateFormatter setDateFormat:kMonthDayYearFormat];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:self];
    
    // date to str
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:dateFromString];
    
    return stringDate;
}

- (CGRect)rectForStringWithWidth:(CGFloat)width andFont:(UIFont*)font
{
    return [self boundingRectWithSize: CGSizeMake(width, CGFLOAT_MAX)
                              options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes: @{NSFontAttributeName : font}
                              context: nil];
}

@end
