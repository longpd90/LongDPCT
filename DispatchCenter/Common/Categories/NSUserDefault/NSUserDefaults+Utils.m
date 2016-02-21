//
//  NSUserDefaults+Utils.m
//  DispatchCenter
//
//  Created by VietHQ on 10/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "NSUserDefaults+Utils.h"

@implementation NSUserDefaults (Utils)

-(void)safeSetValue:(id)value forKey:(NSString*)key
{
    if (!key) {
        return;
    }
    
    [self setValue:value forKey:key];
    [self synchronize];
}

-(void)safeSetObject:(id)obj forKey:(NSString*)key
{
    if (!key) {
        return;
    }
    
    [self setObject:obj forKey:key];
    [self synchronize];
}

@end
