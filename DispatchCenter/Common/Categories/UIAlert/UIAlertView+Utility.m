//
//  UIAlertView+Utility.m
//  iDiApp
//
//  Created by DispatchCenter on 11/25/13.
//  Copyright (c) 2013 Hung. All rights reserved.
//

#import "UIAlertView+Utility.h"

@interface __UIAlertViewWithBlock : UIAlertView<UIAlertViewDelegate>{
    UIAlertViewSimpleHandler callback;
}

- (id) initWithTitle:(NSString *)title message:(NSString *)message callback: (UIAlertViewSimpleHandler) callback cancelButtonTitle:(NSString *) cancelButtonTitle;
@end


@implementation UIAlertView (Utility)

+ (NSString*)appName {
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    return [info objectForKey:(NSString*)kCFBundleNameKey];
}

+ (UIAlertView *) showMessage: (NSString *) message
{
    return [self showMessage:message withTitle:[self appName]];
}

+ (UIAlertView *) showMessage: (NSString *) message withTitle: (NSString *) title
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    return alertView;
}

+ (UIAlertView *) alertViewtWithTitle:(NSString *)title message:(NSString *)message autoShow:(BOOL) autoShow callback: (UIAlertViewSimpleHandler) callback cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    __UIAlertViewWithBlock * alertView = [[__UIAlertViewWithBlock alloc] initWithTitle:title message:message callback:callback cancelButtonTitle:cancelButtonTitle];
    
    if(otherButtonTitles)
    {
        [alertView addButtonWithTitle:otherButtonTitles];
        va_list args;
        va_start(args, otherButtonTitles);
        NSString * arg = nil;
        while ((arg = va_arg(args,id))) {
            [alertView addButtonWithTitle:arg];
        }
        va_end(args);
    }
    
    if(autoShow) {[alertView show]; }
    return alertView;
}

+ (UIAlertView *) alertViewtWithTitle:(NSString *)title message:(NSString *)message callback: (UIAlertViewSimpleHandler) callback cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    return [self alertViewtWithTitle:title message:message autoShow:YES callback:callback cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
}



+ (UIAlertView *) alertViewtWithTextInputTitle:(NSString *)title text:(NSString *) text placeHolderText: (NSString *) placeHolderText callback: (UIAlertViewTextInputHandler) callback cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    __UIAlertViewWithBlock * alertView = [[__UIAlertViewWithBlock alloc] initWithTitle:title message:@"\n" callback:^(UIAlertView * alertView, NSInteger buttonIndex){
        if(!callback) return;
        UITextField * textField = (UITextField *) [alertView viewWithTag:100];
        callback(alertView, textField.text, buttonIndex);
    }cancelButtonTitle:cancelButtonTitle];
    
    if(otherButtonTitles)
    {
        [alertView addButtonWithTitle:otherButtonTitles];
        va_list args;
        va_start(args, otherButtonTitles);
        NSString * arg = nil;
        while ((arg = va_arg(args,id))) {
            [alertView addButtonWithTitle:arg];
        }
        va_end(args);
    }
    
    UITextField *keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 42.0, 260.0, 31)];
    keyTextField.borderStyle = UITextBorderStyleRoundedRect;
    keyTextField.placeholder = placeHolderText;
    keyTextField.text = text;
    keyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    keyTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    keyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    keyTextField.tag = 100;
    [alertView addSubview:keyTextField];
    [alertView show];
    [keyTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0f];
    
    return alertView;
}

+ (UIAlertView *) alertViewtWithTextInputTitle:(NSString *)title text1:(NSString *) text1 placeHolderText1: (NSString *) placeHolderText1 text2:(NSString *) text2 placeHolderText2: (NSString *) placeHolderText2 callback: (UIAlertViewTwoTextInputHandler) callback cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    __UIAlertViewWithBlock * alertView = [[__UIAlertViewWithBlock alloc] initWithTitle:title message:@"\n\n\n" callback:^(UIAlertView * alertView, NSInteger buttonIndex){
        if(!callback) return;
        UITextField * textField1 = (UITextField *) [alertView viewWithTag:100];
        UITextField * textField2 = (UITextField *) [alertView viewWithTag:101];
        callback(alertView, textField1.text, textField2.text, buttonIndex);
    }cancelButtonTitle:cancelButtonTitle];
    
    if(otherButtonTitles)
    {
        [alertView addButtonWithTitle:otherButtonTitles];
        va_list args;
        va_start(args, otherButtonTitles);
        NSString * arg = nil;
        while ((arg = va_arg(args,id))) {
            [alertView addButtonWithTitle:arg];
        }
        va_end(args);
    }
    
    UITextField *textField1 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 42.0, 260.0, 31)];
    textField1.borderStyle = UITextBorderStyleRoundedRect;
    textField1.placeholder = @"key";
    textField1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField1.autocorrectionType = UITextAutocorrectionTypeNo;
    textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField1.tag = 100;
    textField1.placeholder = placeHolderText1;
    textField1.text = text1;
    
    UITextField *textField2 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 80.0, 260.0, 31)];
    textField2.placeholder = @"value";
    textField2.borderStyle = UITextBorderStyleRoundedRect;
    textField2.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField2.autocorrectionType = UITextAutocorrectionTypeNo;
    textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField2.tag = 101;
    textField2.placeholder = placeHolderText2;
    textField2.text = text2;
    
    [alertView addSubview:textField1];
    [alertView addSubview:textField2];
    
    [textField1 release];
    [textField2 release];
    
    [alertView show];
    [textField1 performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0f];
    
    return alertView;
}


+ (UIAlertView *) alertViewtWithTextViewInputTitle:(NSString *)title text:(NSString *) text callback: (UIAlertViewTextInputHandler) callback cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    __UIAlertViewWithBlock * alertView = [[__UIAlertViewWithBlock alloc] initWithTitle:title message:@"\n\n\n" callback:^(UIAlertView * alertView, NSInteger buttonIndex){
        if(!callback) return;
        UITextView * textView = (UITextView *) [alertView viewWithTag:100];
        callback(alertView, textView.text, buttonIndex);
    }cancelButtonTitle:cancelButtonTitle];
    
    if(otherButtonTitles)
    {
        [alertView addButtonWithTitle:otherButtonTitles];
        va_list args;
        va_start(args, otherButtonTitles);
        NSString * arg = nil;
        while ((arg = va_arg(args,id))) {
            [alertView addButtonWithTitle:arg];
        }
        va_end(args);
    }
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(12.0, 42.0, 260.0, 69)];
    textView.text = text;
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.tag = 100;
    [alertView addSubview:textView];
    [alertView show];
    [textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0f];
    
    return alertView;
}

@end



@implementation __UIAlertViewWithBlock

- (id) initWithTitle:(NSString *)title message:(NSString *)message callback: (UIAlertViewSimpleHandler) aCallback cancelButtonTitle:(NSString *) cancelButtonTitle
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if(self)
    {
        callback = [aCallback copy];
    }
    
    return self;
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(callback != nil) {
        callback(alertView, buttonIndex);
        Block_release(callback);
        callback = nil;
    }
}

@end
