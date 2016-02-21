//
//  UIAlertView+Utils.h
//  PostApp
//


#import <UIKit/UIKit.h>

@interface UIAlertView (Utils)

+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message withTitleCancel:(NSString *)cancelText;

@end
