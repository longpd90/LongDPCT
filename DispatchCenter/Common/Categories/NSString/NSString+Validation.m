//
//  NSString+Validation.m
//  DispatchCenter
//
//  Created by VietHQ on 10/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

-(BOOL)isValidEmail
{
    NSString *email = [self lowercaseString];
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:email];
}

-(BOOL)isNotNullString
{
    return (![self isEqual:[NSNull null]] && self.length);
}

-(BOOL)isPhoneNumber
{
    if ([[self substringToIndex:1] isEqualToString:@"+"] ||
        [[self substringToIndex:1] isNumber])
    {
        NSCharacterSet* notDigits = [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"] invertedSet];
        if ([self rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)isNumber
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([self rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }
    
    return NO;
}

-(BOOL)isNotBlankString {
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [self stringByTrimmingCharactersInSet:whiteSpace];
    
    if (trimmed.length == 0) {
        return NO;
    }
    return YES;
}

@end
