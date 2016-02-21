//
//  WSCommonErrProcessor.h
//  DispatchCenter
//
//  Created by Helpser on 11/3/14.
//  Copyright (c) 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSCommonErrProcessor : NSObject
+ (WSCommonErrProcessor*)sharedInstance;
// check and process if has common errors
// Return: YES - has common error, NO = don't have common error
- (BOOL)process:(id)error;
- (BOOL)processResponseError:(id)error;
@end
