//
//  ServerObjectBase.h
//  DispatchCenter
//
//  Created by Helpser on 10/06/15.
//  Copyright (c) 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSNames.h"

@interface ServerObjectBase : NSObject
@property int srvCode;
@property int errorCode;
@property(strong, nonatomic)NSString *errorMessage;
- (void)parseResponse:(NSDictionary*)response;
- (void)parseErrorResponse:(NSDictionary*)response;
@end
