
//  WSRequester.m
//  DispatchCenter
//
//  Created by Helpser on 10/06/15.
//  Copyright (c) 2015 Helpser. All rights reserved.
//

#import "WSRequester.h"
#import "WSCommonErrProcessor.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

#define WS_TIMEOUT      60
@interface WSRequester () {
    AFHTTPRequestOperationManager *requestOperationManager;
    
    NSOperation *requestOpr;
    
    BOOL isCancelling;
}
@end

@implementation WSRequester
- (id)init {
    if (self = [super init]) {
        requestOperationManager = [AFHTTPRequestOperationManager manager];
        NSMutableSet *set = [NSMutableSet setWithSet:requestOperationManager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
//        [set addObject:@"text/plain"];
//        [set addObject:@"application/json"];
        //        [set addObject:@"application/octet-stream"];
        requestOperationManager.responseSerializer.acceptableContentTypes = set;
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//
        [requestSerializer setValue:@"071401b0-6e22-4647-bb8a-37ea76cec624" forHTTPHeaderField:@"Application-Key"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        
        requestOperationManager.requestSerializer = requestSerializer;
        requestOperationManager.requestSerializer.timeoutInterval = WS_TIMEOUT;
//        [requestOperationManager.requestSerializer setAuthorizationHeaderFieldWithUsername:API_AUTHEN_USERNAME password:API_AUTHEN_PASS];
        self.bgCalling = NO;
    }
    
    return self;
}


- (NSString*)makeFullAPIMethodWithAction:(NSString*)action {
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@", API_ROOT_URL, action]);
    return [NSString stringWithFormat:@"%@/%@", API_ROOT_URL, action];
}

- (ServerObjectBase*)serverObjFromClass:(Class)c {
    id result = [c new];
    if ([result isKindOfClass:[ServerObjectBase class]]) {
        return result;
    } else {
        return nil;
    }
}

#pragma mark - Public methods
- (void)sendGETRequestWithURL:(NSString*)urlStr responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler withToken:(BOOL)withToken {
    DLogInfo(@"Calling api:%@", urlStr);
    if (withToken) {
        [requestOperationManager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", (kDCAccessTokenValue ? : @"")] forHTTPHeaderField:@"Authorization"];
    } else {
        [requestOperationManager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
    [requestOperationManager.requestSerializer setValue:@"071401b0-6e22-4647-bb8a-37ea76cec624" forHTTPHeaderField:@"Application-Key"];
//    NSDate *methodStart = [NSDate date];
    [requestOperationManager GET:[self makeFullAPIMethodWithAction:urlStr] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLogInfo(@"Response for api %@: %@", urlStr, [responseObject description]);
//        NSDate *methodFinish = [NSDate date];
//        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
//        NSLog(@"api: %@\nexecutionTime = %f",urlStr, executionTime);
        
        ServerObjectBase *result = [self serverObjFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[WSCommonErrProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLogError(@"%@", [error description]);
        
        ServerObjectBase *result =[ServerObjectBase new];
        if (operation.responseObject != nil) {
            [result parseErrorResponse:operation.responseObject];
            if (self.bgCalling == NO) {
                [[WSCommonErrProcessor sharedInstance] processResponseError:result];
            }
        } else {
            [[WSCommonErrProcessor sharedInstance] process:error];
        }
        
        if (responseHandler) {
            responseHandler (NO, result);
        }
    }];
}

- (void)sendGETRequestWithURL:(NSString*)urlStr
                   parameters:(id)params
          responseObjectClass:(Class)responseObjectClass
              responseHandler:(ServerResponseHandler)responseHandler
                    withToken:(BOOL)withToken {
    DLogInfo(@"Calling api:%@", urlStr);
    if (withToken) {
        [requestOperationManager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", (kDCAccessTokenValue ? : @"")] forHTTPHeaderField:@"Authorization"];
    } else {
        [requestOperationManager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
    
    //    NSDate *methodStart = [NSDate date];
    [requestOperationManager GET:[self makeFullAPIMethodWithAction:urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLogInfo(@"Response for api %@: %@", urlStr, [responseObject description]);
        //        NSDate *methodFinish = [NSDate date];
        //        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
        //        NSLog(@"api: %@\nexecutionTime = %f",urlStr, executionTime);
        
        ServerObjectBase *result = [self serverObjFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[WSCommonErrProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLogError(@"%@", [error description]);
        
        ServerObjectBase *result =[ServerObjectBase new];
        if (operation.responseObject != nil) {
            [result parseErrorResponse:operation.responseObject];
            if (self.bgCalling == NO) {
                [[WSCommonErrProcessor sharedInstance] processResponseError:result];
            }
        } else {
            [[WSCommonErrProcessor sharedInstance] process:error];
        }
        
        if (responseHandler) {
            responseHandler (NO, result);
        }
    }];
}


- (NSDictionary*)addTokenTocPramDict:(NSDictionary*)param {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:param];
    [result setObject:(kDCAccessTokenValue ? : @"") forKey:API_PR_NAME_TOKEN];
    DLogInfo(@"token %@", result);
    return result;
}

- (void)sendPOSTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler withToken:(BOOL)withToken{
    if (withToken) {
//        parameters = [self addTokenTocPramDict:parameters];
        [requestOperationManager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", (kDCAccessTokenValue ? : @"")] forHTTPHeaderField:@"Authorization"];
    } else {
        [requestOperationManager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
    DLogInfo(@"Calling api %@: %@", api, [parameters description]);
    [requestOperationManager POST:[self makeFullAPIMethodWithAction:api] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLogInfo(@"Response for api %@: %@", api, [responseObject description]);
        ServerObjectBase *result = [self serverObjFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[WSCommonErrProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLogError(@"%@", [error description]);
        ServerObjectBase *result =[ServerObjectBase new];
        if (operation.responseObject != nil) {
            [result parseErrorResponse:operation.responseObject];
            if (self.bgCalling == NO) {
                if (![[(NSDictionary *)[parameters dictionaryForKey:API_PR_SOCIAL_CHANNEL]stringForKey:kDCDoNotShowAlertView ] isEqualToString:@"true"]){
                    [[WSCommonErrProcessor sharedInstance] processResponseError:result];
                }
            }
        } else {
            [[WSCommonErrProcessor sharedInstance] process:error];
        }

        
        if (responseHandler) {
            responseHandler (NO, result);
        }
    }];
}

- (void)sendPOSTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters andImgData:(NSData*)imgData responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler withToken:(BOOL)withToken {
    if (withToken) {
        parameters = [self addTokenTocPramDict:parameters];
    }
    
    DLogInfo(@"Calling api %@: %@", api, [parameters description]);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:0
                                                         error:&error];
    [requestOperationManager POST:[self makeFullAPIMethodWithAction:api] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        if (imgData != nil) {
            [formData appendPartWithFileData:imgData name:@"image" fileName:@"img.jpg" mimeType:@"image/jpeg"];
        }
        [formData appendPartWithFormData:jsonData name:@"param"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLogInfo(@"Response for api %@: %@", api, [responseObject description]);
        ServerObjectBase *result = [self serverObjFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[WSCommonErrProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLogError(@"%@", [error description]);
        
        ServerObjectBase *result =[ServerObjectBase new];
        if (operation.responseObject != nil) {
            [result parseErrorResponse:operation.responseObject];
            if (self.bgCalling == NO) {
                if (![[(NSDictionary *)[parameters dictionaryForKey:API_PR_SOCIAL_CHANNEL]stringForKey:kDCDoNotShowAlertView ] isEqualToString:@"true"]){
                    [[WSCommonErrProcessor sharedInstance] processResponseError:result];
                }
            }
        } else {
            [[WSCommonErrProcessor sharedInstance] process:error];
        }

        
        if (responseHandler) {
            responseHandler (NO, result);
        }
    }];
}

- (void)sendPUTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler withToken:(BOOL)withToken{
    if (withToken) {
        //        parameters = [self addTokenTocPramDict:parameters];
        [requestOperationManager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", (kDCAccessTokenValue ? : @"")] forHTTPHeaderField:@"Authorization"];
    } else {
        [requestOperationManager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
    
    DLogInfo(@"Calling api %@: %@", api, [parameters description]);
    [requestOperationManager PUT:[self makeFullAPIMethodWithAction:api] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLogInfo(@"Response for api %@: %@", api, [responseObject description]);
        ServerObjectBase *result = [self serverObjFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[WSCommonErrProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLogError(@"%@", [error description]);
        
        ServerObjectBase *result =[ServerObjectBase new];
        if (operation.responseObject != nil) {
            [result parseErrorResponse:operation.responseObject];
            if (self.bgCalling == NO) {
                [[WSCommonErrProcessor sharedInstance] processResponseError:result];
            }
        } else {
            [[WSCommonErrProcessor sharedInstance] process:error];
        }

        
        if (responseHandler) {
            responseHandler (NO, result);
        }
    }];
}

- (void)sendPUTRequestWithURL:(NSString*)urlStr
                   parameters:(id)params
          responseObjectClass:(Class)responseObjectClass
              responseHandler:(ServerResponseHandler)responseHandler
                    withToken:(BOOL)withToken {
    DLogInfo(@"Calling api:%@", urlStr);
    if (withToken) {
        [requestOperationManager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", (kDCAccessTokenValue ? : @"")] forHTTPHeaderField:@"Authorization"];
    } else {
        [requestOperationManager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
    
    //    NSDate *methodStart = [NSDate date];
    [requestOperationManager PUT:[self makeFullAPIMethodWithAction:urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLogInfo(@"Response for api %@: %@", urlStr, [responseObject description]);
        //        NSDate *methodFinish = [NSDate date];
        //        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
        //        NSLog(@"api: %@\nexecutionTime = %f",urlStr, executionTime);
        
        ServerObjectBase *result = [self serverObjFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[WSCommonErrProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLogError(@"%@", [error description]);
        
        ServerObjectBase *result =[ServerObjectBase new];
        if (operation.responseObject != nil) {
            [result parseErrorResponse:operation.responseObject];
            if (self.bgCalling == NO) {
                [[WSCommonErrProcessor sharedInstance] processResponseError:result];
            }
        } else {
            [[WSCommonErrProcessor sharedInstance] process:error];
        }
        
        if (responseHandler) {
            responseHandler (NO, result);
        }
    }];
}



@end
