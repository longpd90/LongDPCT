//
//  WSRequester.h
//  DispatchCenter
//
//  Created by Helpser on 10/06/15.
//  Copyright (c) 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSErrorCodes.h"
#import "ServerObjectBase.h"

// success: NO - network error, server not response...
typedef void(^ServerResponseHandler) (BOOL success, ServerObjectBase *response);

@interface WSRequester : NSObject

@property BOOL bgCalling; // Don't start from a user action (Ex: don't show user message in this case)

- (void)sendGETRequestWithURL:(NSString*)urlStr responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler withToken:(BOOL)withToken;

- (void)sendPOSTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler withToken:(BOOL)withToken;

- (void)sendPOSTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters andImgData:(NSData*)imgData responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler withToken:(BOOL)withToken;

- (void)sendPUTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler withToken:(BOOL)withToken;

- (void)sendGETRequestWithURL:(NSString*)urlStr
                   parameters:(id)params
          responseObjectClass:(Class)responseObjectClass
              responseHandler:(ServerResponseHandler)responseHandler
                    withToken:(BOOL)withToken;
- (void)sendPUTRequestWithURL:(NSString*)urlStr
                   parameters:(id)params
          responseObjectClass:(Class)responseObjectClass
              responseHandler:(ServerResponseHandler)responseHandler
                    withToken:(BOOL)withToken;


@end
