//
//  DCUtility.h
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCUtility : NSObject

+ (instancetype)shareDCUtility;

+ (NSString*)autoConvertDateString:(NSString*)dateStr toStringWithFormat:(NSString*)format;
+ (NSDate *)convertStringToDate:(NSString *)input inFormat:(NSString*)format;

@end
