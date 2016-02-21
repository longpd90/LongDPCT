//
//  DCRegisterViewController.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/5/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
//
typedef enum {
    DCSignupModeNormal = 0,
    DCSignupModeFacebook,
    DCSignupModeGoogle,
    DCSignupModeTwiter
    
} DCSignupMode;

@interface DCRegisterViewController : UIViewController

@property (strong ,nonatomic) DCMyProfile *myProfile;
@property (assign ,nonatomic) DCSignupMode signupMode;

- (IBAction)signupByFacebookButtonClicked:(id)sender;

- (IBAction)signupByGoogleButtonClicked:(id)sender;

@end
