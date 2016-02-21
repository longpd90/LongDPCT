//
//  DCLoginViewController.h
//  DispatchCenter
//
//  Created by VietHQ on 10/12/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <TwitterKit/TwitterKit.h>

typedef enum {
    DCSigninModeNormal = 0,
    DCSigninModeFacebook,
    DCSigninModeGoogle,
    DCSigninModeTwiter
    
} DCSigninMode;

@interface DCLoginViewController : UIViewController 

@property (assign ,nonatomic) DCSigninMode signinMode;

- (IBAction)signupByFacebookButtonClicked:(id)sender;

- (IBAction)signupByGoogleButtonClicked:(id)sender;

- (IBAction)clickTwitterButton:(id)sender;

@end
