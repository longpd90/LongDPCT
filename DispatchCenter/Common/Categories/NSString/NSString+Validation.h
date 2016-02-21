//
//  NSString+Validation.h
//  DispatchCenter
//
//  Created by VietHQ on 10/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

-(BOOL)isValidEmail;
-(BOOL)isNotNullString;
-(BOOL)isPhoneNumber;
-(BOOL)isNumber;
-(BOOL)isNotBlankString;

@end
