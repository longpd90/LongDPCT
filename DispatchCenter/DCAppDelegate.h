//
//  DCAppDelegate.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/5/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCLoginInfo.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "DCSetting.h"

@interface DCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DCLoginInfo *loginInfo;
@property (strong, nonatomic) DCMyProfile *mMyProfile;
@property (strong, nonatomic) NSString *dialogID;
@property (strong, nonatomic) DCSetting *mySettings;
@property (assign, nonatomic) BOOL alreadyLaunchedApp;

+ (DCAppDelegate*)sharedInstance;

- (void)didLoginWithInfo:(DCLoginInfo*)info afterSignup:(BOOL)afterSignup;
- (void)showYellowLineBottomNav;
- (void)hideYellowLineBottomNav;

- (void)logout;
- (void)loadProfileIfNeed;
- (void)loadSettingIfNeed;
@end

