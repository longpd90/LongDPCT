//
//  WSCommonErrProcessor.m
//  DispatchCenter
//
//  Created by Helpser on 11/3/14.
//  Copyright (c) 2015 Helpser. All rights reserved.
//

#import "WSCommonErrProcessor.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "ServerObjectBase.h"

@implementation WSCommonErrProcessor
+ (WSCommonErrProcessor*)sharedInstance {
    static WSCommonErrProcessor *processor = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        processor = [WSCommonErrProcessor new];
    });
    
    return processor;
}

- (void)showMessageWithTitle:(NSString*)title message:(NSString*)message isUpdateAlert:(BOOL)isUpdateAlert{
    static UIAlertView *alert = nil;
    static UIAlertView *confirmAlert = nil; // Confirm Yes/No alert
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        alert = [[UIAlertView alloc] initWithTitle:(title ? : @"") message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"str_alert_title_ok", @"") otherButtonTitles:nil];
        if (isUpdateAlert) {
            confirmAlert = [[UIAlertView alloc] initWithTitle:(title ? : @"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"str_alert_title_ok", @"") otherButtonTitles:nil];
        }
    });
    // check if alert already shown ==>do nothing
    BOOL isShowing = ((alert && alert.visible) || (confirmAlert && confirmAlert.visible));
    if (isShowing == NO) {
        if (isUpdateAlert) {
            confirmAlert.title = title;
            confirmAlert.message = message;
            confirmAlert.delegate = self;
            [confirmAlert show];
        } else {
            alert.title = title;
            alert.message = message;
            [alert show];
        }
    } else {
        
        DLogInfo(@"Alert already shown");
    }
}

- (void)networkCheckError {
    if (([AFNetworkReachabilityManager sharedManager].reachable == NO)) {
        [self showMessageWithTitle:@"" message:NSLocalizedString(@"msg_network_error", @"") isUpdateAlert:NO];
    } else {
        [self showMessageWithTitle:@"" message:NSLocalizedString(@"msg_cannot_connect_to_the_host", @"") isUpdateAlert:NO];
    }
//    // Allocate a reachability object
//    Reachability *reach = [[Reachability reachabilityWithHostname:@"www.apple.com"] retain];
//
//    // Set the blocks
//    reach.reachableBlock = ^(Reachability*reach)
//    {
//        [reach stopNotifier];
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//
//            if (APP_DELEGATE.isAfterFiveSec) { // Modify by CanhLD
//                [self showMessageWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"cannot_connect_to_the_host", @"") isUpdateAlert:NO];
//            }
//
//        });
//    };
//
//    reach.unreachableBlock = ^(Reachability*reach)
//    {
//        [reach stopNotifier];
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//
//            if (APP_DELEGATE.isAfterFiveSec) { //Modify by CanhLD
//                [self showMessageWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"network_error", @"") isUpdateAlert:NO];
//            }
//
//        });
//    };
//
//    // Start the notifier, which will cause the reachability object to retain itself!
//    [reach startNotifier];
}

- (BOOL)process:(id)error {
    if (error == nil) {
        [self showMessageWithTitle:nil message:NSLocalizedString(@"msg_unknown_error_message_code", @"") isUpdateAlert:NO];
        return YES;
    }
    
    if ([error isKindOfClass:[NSError class]]) {
        DLogError(@"error %@", error);
        [self networkCheckError];
        return YES;
    } else if ([error isKindOfClass:[ServerObjectBase class]]) {
        int errorCode = ((ServerObjectBase*)error).srvCode;
        
        switch (errorCode) {
//            case ERR_CODE_INVALID_TOKEN:
//            case ERR_CODE_NOT_LOGIN: // TODO: se xu ly auto login sau
////                [APP_DELEGATE autoLogin];
//                [APP_DELEGATE logout];
//                return YES;
//                break;
//                //            case ERR_CODE_ACC_LOCKED:
//                                [self showMessageWithTitle:@"" message:NSLocalizedString(@"account_is_locked", @"") isUpdateAlert:NO];
//                                return YES;
//                
//            case ERR_CODE_UNKNOWN_ERROR:
//            case ERR_CODE_INVALID_PARAMETER:
//            case ERR_CODE_INSERT_DB_FAILED:
//            case ERR_CODE_UPDATE_DB_FAILED:
//            case ERR_CODE_DELETE_DB_FAILED:
//                [self showMessageWithTitle:nil message:NSLocalizedString(@"msg_unknown_error_message_code", @"") isUpdateAlert:NO];
//                return YES;
//                break;
//            case ERR_CODE_API_OUT_OF_DATE:
//                [self showMessageWithTitle:@"" message:NSLocalizedString(@"need_update_the_app_msg", @"") isUpdateAlert:YES];
//                return YES;
//                // Add by CanhLD
//            case ERR_CODE_INVALID_BIRTHDAY:
//                [self showMessageWithTitle:@"" message:NSLocalizedString(@"birthday_invalid", @"") isUpdateAlert:NO];
//                return YES;
//                
            default:
                break;
        }
    }
    
    return NO;
}


- (BOOL)processResponseError:(id)error {
    if (error == nil) {
        [self showMessageWithTitle:nil message:NSLocalizedString(@"msg_unknown_error_message_code", @"") isUpdateAlert:NO];
        return YES;
    }
    
    if ([error isKindOfClass:[ServerObjectBase class]]) {
        ServerObjectBase * errorResponse = (ServerObjectBase*)error;
        if (errorResponse.errorCode != 4002) {
            if (errorResponse.errorMessage != nil) {
                [self showMessageWithTitle:@"" message:errorResponse.errorMessage isUpdateAlert:NO];
            }
        }
        return YES;

    } else {
        [self networkCheckError];
        return YES;

    }
    
    return NO;
}

@end
