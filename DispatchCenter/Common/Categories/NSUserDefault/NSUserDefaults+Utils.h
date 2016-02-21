//
//  NSUserDefaults+Utils.h
//  DispatchCenter
//
//  Created by VietHQ on 10/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Utils)

-(void)safeSetValue:(id)value forKey:(NSString*)key;
-(void)safeSetObject:(id)obj forKey:(NSString*)key;

@end
