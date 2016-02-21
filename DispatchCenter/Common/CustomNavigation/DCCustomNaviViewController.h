//
//  DCCustomNaviViewController.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCCustomNaviViewController : UINavigationController
+ (DCCustomNaviViewController*)mainNavigation;
- (void)addLeftBtnWithImg:(UIImage*)img target:(id)target action:(SEL)action;
- (void)addLeftBtnWithImg:(UIImage*)img title:(NSString*)title target:(id)target action:(SEL)action;
- (void)addRightBtnWithImg:(UIImage*)img target:(id)target action:(SEL)action;
// Add multi-buttons to navigation
// Params:
// + btnContent: array of content of button, from left to right, each element of array is text or image (NSString or UIImage)
// + actions: array of actions corresponding with each button, each element of array is NSValue object (type is pointer) or NSNull (Ex:[NSValue valueWithPointer:@selector(xxx)])
// Return: array of buttons in same order with btnContent
- (NSArray*)addMultiBtns:(NSArray*)btnContent leftOrRight:(BOOL)leftOrRight target:(id)target actions:(NSArray*)actions;
@end
