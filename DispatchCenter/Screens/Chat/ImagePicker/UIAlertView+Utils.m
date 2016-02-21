//
//  UIAlertView+Utils.m
//  PostApp
//


#import "UIAlertView+Utils.h"

@implementation UIAlertView (Utils)
+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message withTitleCancel:(NSString *)cancelText{
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:cancelText
                      otherButtonTitles:nil, nil] show];
}

@end
