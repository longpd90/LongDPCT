//
//  NSDictionary+Utils.h
//  DispatchCenter
//
//  Created by VietHQ on 10/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)

- (BOOL)hasKey:(NSString *)key;

- (NSString*)stringForKey:(id)key;

- (NSNumber*)numberForKey:(id)key;

- (NSDecimalNumber *)decimalNumberForKey:(id)key;

- (NSArray*)arrayForKey:(id)key;

- (NSDictionary*)dictionaryForKey:(id)key;

- (NSInteger)integerForKey:(id)key;

- (NSUInteger)unsignedIntegerForKey:(id)key;

- (BOOL)boolForKey:(id)key;

- (int16_t)int16ForKey:(id)key;

- (int32_t)int32ForKey:(id)key;

- (int64_t)int64ForKey:(id)key;

- (char)charForKey:(id)key;

- (short)shortForKey:(id)key;

- (float)floatForKey:(id)key;

- (double)doubleForKey:(id)key;

- (long long)longLongForKey:(id)key;

- (unsigned long long)unsignedLongLongForKey:(id)key;

- (NSDate *)dateForKey:(id)key dateFormat:(NSString *)dateFormat;

//CG
- (CGFloat)CGFloatForKey:(id)key;

- (CGPoint)pointForKey:(id)key;

- (CGSize)sizeForKey:(id)key;

- (CGRect)rectForKey:(id)key;

@end
