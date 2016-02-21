//
//  DCUtility.m
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCUtility.h"

@implementation DCUtility

+ (instancetype)shareDCUtility
{
    static DCUtility* _sharedUtility = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _sharedUtility = [DCUtility new];
    });
    
    return _sharedUtility;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (NSString*)autoConvertDateString:(NSString*)dateStr toStringWithFormat:(NSString*)format {
    if ([dateStr isKindOfClass:[NSString class]] == NO || dateStr.length <= 0 || dateStr.length <= 0 || [dateStr isEqualToString:@"null"]) {
        return nil;
    }
    
    NSDateFormatter* formater = [NSDateFormatter new];
    
    [formater setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    
    NSUInteger dateLength = [dateStr length];
    BOOL dateHasSlash = ([dateStr rangeOfString:@"/"].location != NSNotFound);
    NSString* dateFormatString = @"";
    if(dateLength > 19 &&  dateLength < 21) {
        dateFormatString = kDateNeed;
    } else if (dateLength >= 25) {
        dateFormatString = kDatetimeISOFormat;
    } else if (dateLength <= 10) {
        if (dateHasSlash) {
            dateFormatString = kDateOnlyWithSlashFormatShort;
        } else {
            dateFormatString = kDateOnlyWithHyphenFormatShort;
        }
    } else {
        if (dateHasSlash) {
            dateFormatString = kDatetimeWithSlashFormatShort;
        } else {
            dateFormatString = kDatetimeWithHyphenFormatShort;
        }
    }
    [formater setDateFormat:dateFormatString];
    [formater setLocale:[NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] firstObject]]];
    
    NSDate* date = [formater dateFromString:dateStr];
    [formater setDateFormat:format];
    NSString* string = [formater stringFromDate:date];
    if (string == nil || [string length] == 0) {
        DLogError(@"unable to parse date using format %@ from value: %@", dateFormatString, dateStr);
        string = nil;
    }
    
    return string;
}

+ (NSDate *)convertStringToDate:(NSString *)input inFormat:(NSString *)format
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:format];
    NSDate* dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:input];
    return dateFromString;
}
@end
