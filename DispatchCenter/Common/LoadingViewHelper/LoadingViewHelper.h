//
//  LoadingViewHelper.h
//
//
//  Created on 7/27/13.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface LoadingViewHelper : NSObject
+ (void)showLoadingWithText:(NSString*)text;
+ (void)showLoading;
+ (void)hideLoading;
+ (void)hideLoadingWithMsg:(NSString*)msg;
+ (MBProgressHUD *)shareMainHUD;
+ (unsigned int)startShowProgressWithText:(NSString*)text;
+ (void)updateProgress:(int)progress total:(int)total;
+ (void)updateProgress:(int)progress total:(int)total forProgressID:(unsigned int)prgID;
@end
