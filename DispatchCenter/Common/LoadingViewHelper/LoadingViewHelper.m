//
//  LoadingViewHelper.m
//  
//
//  Created on 7/27/13.
//

#import "LoadingViewHelper.h"

@implementation LoadingViewHelper

static MBProgressHUD *mainHUD;
static unsigned int progressID;

+ (void)showLoadingWithText:(NSString*)text {
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        mainHUD = [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
        progressID = 0;
    });
    
    if (mainHUD != nil) {
        if (mainHUD.mode != MBProgressHUDModeIndeterminate) {
            mainHUD.mode = MBProgressHUDModeIndeterminate;
        }
        
        mainHUD.labelText = text;
        [mainHUD show:YES];
        if(![mainHUD isDescendantOfView:APP_DELEGATE.window]) {
            [APP_DELEGATE.window addSubview:mainHUD];
        };
        [APP_DELEGATE.window bringSubviewToFront:mainHUD];
    }
}

+ (void)showLoading {
    [self showLoadingWithText:NLS(@"Loading...")];
}

+ (unsigned int)startShowProgressWithText:(NSString*)text {
    [self showLoadingWithText:text];
    
    [self shareMainHUD].mode = MBProgressHUDModeDeterminate;
    
    progressID++;
    
    return progressID;
}

+ (void)hideLoading {
    if (mainHUD.hidden == NO) {
        [mainHUD hide:YES];
    }
}

+ (void)hideLoadingWithMsg:(NSString*)msg {
    mainHUD.labelText = msg;
    [mainHUD hide:YES afterDelay:1];
}

+ (MBProgressHUD *)shareMainHUD{
    if (mainHUD == nil) {
        mainHUD = [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
        [self hideLoading];
    }
    
    return mainHUD;
}

+ (void)updateProgress:(int)progress total:(int)total {
    MBProgressHUD *mainHUD = [self shareMainHUD];
    if (mainHUD.mode == MBProgressHUDModeDeterminate) {
        mainHUD.progress = progress / (float)total;
    }
}

+ (void)updateProgress:(int)progress total:(int)total forProgressID:(unsigned int)prgID{
    if (prgID == progressID) {
        [self updateProgress:progress total:total];
    }
}

@end
