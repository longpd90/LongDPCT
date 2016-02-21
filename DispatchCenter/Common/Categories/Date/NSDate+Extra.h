//
//  NSDate+Extra.h
//  DispatchCenter
//
//  Created by Phung Long on 11/3/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extra)
- (NSDate *)earlierDateWithTimeInterval:(NSTimeInterval)interval;
- (BOOL)isLaterThanDate:(NSDate *)date;
- (NSString *)longDateString;
- (NSString *)longDateStringJapanes;
- (NSString*)convertToAge;
- (BOOL)isSameDayWithDate:(NSDate*)date2;
- (NSComparisonResult)compareDay:(NSDate *)date;
- (NSString *)stringValueFormattedBy:(NSString *)formatString;
+ (NSString *)calculateWorkTime:(NSDate *)startTime endTime:(NSDate *)endTime;
@end
