//
//  NSDate+Extra.m
//  DispatchCenter
//
//  Created by Phung Long on 11/3/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "NSDate+Extra.h"

@implementation NSDate (Extra)

- (NSDate *)earlierDateWithTimeInterval:(NSTimeInterval)interval {
    NSDate *localDate = [self dateByAddingTimeInterval:-interval];
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    
    return [localDate dateByAddingTimeInterval:timeZoneSeconds];
}

- (NSComparisonResult)compareDay:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentDateComponents = [calendar components:
                                               NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                          fromDate:self];
    NSDateComponents *compareDateComponents = [calendar components:
                                               NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                          fromDate:date];
    
    return [[calendar dateFromComponents:currentDateComponents] compare:
            [calendar dateFromComponents:compareDateComponents]];
}


#pragma mark Action convert Date
- (NSString *)longDateString {
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    // dateformate.dateStyle = NSDateFormatterFullStyle;
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateformate setLocale:[NSLocale currentLocale]];
    [dateformate setLocale:[NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] firstObject]]];
    NSString *stringFromDate = [dateformate stringFromDate:self];
    return stringFromDate;
}

- (BOOL)isLaterThanDate:(NSDate *)date {
    return (self.timeIntervalSince1970 > date.timeIntervalSince1970);
}
- (NSString *)longDateStringJapanes {
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    // dateformate.dateStyle = NSDateFormatterFullStyle;
    [dateformate setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    [dateformate setLocale:[NSLocale currentLocale]];
    NSString *stringFromDate = [dateformate stringFromDate:self];
    return stringFromDate;
}


#pragma mark - CaculateBirthDay To Age
- (NSString*)convertToAge {
    NSDate *now = [NSDate date];
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       
                                       components:NSCalendarUnitYear
                                       
                                       fromDate:self
                                       
                                       toDate:now
                                       
                                       options:0];
    
    NSInteger age = [ageComponents year];
    NSString *ageString = [NSString stringWithFormat:@"%ld",(long)age];
    return ageString;
}

#pragma mark - check Same day
- (BOOL)isSameDayWithDate:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |   NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}


+ (NSString *)calculateWorkTime:(NSDate *)startTime endTime:(NSDate *)endTime {
    //worktime
    NSString *workTimeLabel;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString *startDate = [dateFormatter stringFromDate:startTime];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *endDate = [dateFormatter stringFromDate:endTime];
    
    if ([startTime isSameDayWithDate:endTime]) {
        workTimeLabel = [NSString stringWithFormat:@"%@ ~ %@", startDate, endDate];
    }
    else {
        workTimeLabel = [NSString stringWithFormat:@"%@ ~ 翌%@", startDate, endDate];
    }
    return workTimeLabel;
}

- (NSString *)stringValueFormattedBy:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    [dateFormatter setDateFormat:formatString];
    NSString *string = [dateFormatter stringFromDate:self];
    return string;
}

@end
