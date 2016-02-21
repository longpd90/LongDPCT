//
//  ServerObjectBase.m
//  DispatchCenter
//
//  Created by Helpser on 10/06/15.
//  Copyright (c) 2015 Helpser. All rights reserved.
//

#import "ServerObjectBase.h"

@implementation ServerObjectBase
- (void)parseResponse:(NSDictionary*)response {
    
    if ([response objectForKey:@"code"]) {
        self.srvCode = [[response objectForKey:@"code"] intValue];
    }
}

- (void)parseErrorResponse:(NSDictionary*)response {
    
    if ([response objectForKey:@"code"]) {
        self.errorCode = [[response objectForKey:@"code"] intValue];
    }
    if ([response objectForKey:@"message"]) {
        self.errorMessage = [response stringForKey:@"message"];
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
 
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        
    }
       return self;
}

@end
