//
//  DCAppDelegate.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/5/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCAppDelegate.h"
#import "DCRegisterViewController.h"
#import "DCChatManager.h"
#import "DCChatViewController.h"
#import "DCLoginViewController.h"
#import "DCTaskListWFMasterViewController.h"
#import "DCInputSmsCodeVC.h"
#import "DCSetPassWordVC.h"
#import "DCUtility.h"
#import "DCApis.h"
#import "LocationController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "DCCommandDefine.h"
#import "DCNotificationManager.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterIOS7Style.h"
#import "DCIntroducingViewController.h"


static NSString * const kClientIDFA = kGoogleClientIDFA;
static NSString * const kClientIDWF = kGoogleClientIDWF;

static NSString *const kTwitterConsumerKey = @"Kwa2UoFiSz6fcTMXFzi280YoF";
static NSString *const kTwitterConsumerSecret = @"NHJH4bYPtFCsZphbvRMgAEBTWvycoDoqe95RHbwfjeVFIkb7GM";


@interface DCAppDelegate ()

@property(nonatomic, strong) UIView *mYellowLineView;

@end

@implementation DCAppDelegate

+ (DCAppDelegate*)sharedInstance {
    
    return (DCAppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Twitter kit
//    [Fabric with:@[[Twitter class]]];
    [[Twitter sharedInstance] startWithConsumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
//    [Fabric with:@[[Twitter sharedInstance]]];
    
    // Override point for customization after application launch.
    [DCChatManager setupQB];
    CMD_LOAD_USER_QB_IF_NEED();
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window makeKeyAndVisible];
    
    [self readSettings];
    
    [self checkLoginUserStatus];

    [self showYellowLineBottomNav];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // create location
    if (IS_WF_APP)
    {
//        [LocationController shareLocationController];
//        [LocationController startUpdate];
        [GIDSignIn sharedInstance].clientID = kClientIDWF;

    } else {
        [GIDSignIn sharedInstance].clientID = kClientIDFA;
    }
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    if (IS_WF_APP) {
        if ([[url scheme] isEqualToString:FACEBOOK_SCHEME_WF]) {
            return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation];
        }
    } else {
        if ([[url scheme] isEqualToString:FACEBOOK_SCHEME_FA]) {
            return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation];
        }
    }
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    QBMSubscription *subscription = [QBMSubscription subscription];
    subscription.notificationChannel = QBMNotificationChannelAPNS;
    subscription.deviceUDID = deviceIdentifier;
    subscription.deviceToken = deviceToken;
    
    [QBRequest createSubscription:subscription successBlock:^(QBResponse *response, NSArray *objects) {
        
        NSLog(@"Successfull response!");
        
    } errorBlock:^(QBResponse *response) {
        NSLog(@"error response!");
    }];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // push notification
//    NSString *message = userInfo[QBMPushMessageApsKey][QBMPushMessageAlertKey];
//    if ( application.applicationState == UIApplicationStateActive ) {
//        [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterIOS7Style new];
//        [JCNotificationCenter
//         enqueueNotificationWithTitle:@"Notification"
//         message:message
//         tapHandler:^{
//             [self pushToViewControllerDetail:userInfo];
//         }];
//    } else {
//        [self pushToViewControllerDetail:userInfo];
//    }
}

- (void)pushToViewControllerDetail:(NSDictionary *)userInfo {
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    UIViewController *pVC = [[DCNotificationManager shareInstance] processPushNotification:userInfo];
    [navController pushViewController:pVC animated:YES];
}

#pragma mark - Private methods
- (void)readSettings {
    self.loginInfo = [DCLoginInfo readSaved];
    self.mMyProfile = [DCMyProfile readSaved];
    self.mySettings = [DCSetting readSaved];
    //check first time using App or not
    NSUserDefaults *usrDefault = [NSUserDefaults standardUserDefaults];
    self.alreadyLaunchedApp = [usrDefault boolForKey:ALREADY_FIRST_TIME_LAUNCH];
}

- (UIViewController*)makeMainNaviWithRootVC:(UIViewController*)vc {
    UINavigationController *pNav = [[DCCustomNaviViewController alloc] initWithRootViewController:vc];
    return pNav;
}

- (void)showLogin {
    self.window.rootViewController = [self makeMainNaviWithRootVC:[[DCLoginViewController alloc] initWithNibName:@"DCLoginViewController" bundle:nil]];
    [self showYellowLineBottomNav];
}

- (void)showIntroScreen {
    self.window.rootViewController = [self makeMainNaviWithRootVC:[[DCIntroducingViewController alloc] initWithNibName:nil bundle:nil]];
    
  
}

- (void)showMainScreen {
    
    // room to chat room
//    if (self.loginInfo.userInfo.qbUserInfo.roomID.length > 0 && self.loginInfo.userInfo.qbUserInfo.roomJID.length > 0) {
//        [DCChat joinDialogWithID:self.loginInfo.userInfo.qbUserInfo.roomID roomJID:self.loginInfo.userInfo.qbUserInfo.roomJID currentUserID:[QBSession currentSession].currentUser.ID responseHandler:^(BOOL success, QBChatDialog *dialog) {
//            if (success) {
//                self.dialogID = dialog.ID;
//                NSLog(@"join to chat success");
//            } else {
//                NSLog(@"join to chat failed");
//            }
//        }];
//        
//    }
//    
//    if (kDCWFChatRoomJIDValue && kDCWFChatRoomIDValue) {
//        [DCChat joinDialogWithID:kDCWFChatRoomIDValue roomJID:kDCWFChatRoomJIDValue currentUserID:[QBSession currentSession].currentUser.ID responseHandler:^(BOOL success, QBChatDialog *dialog) {
//            if (success) {
//                NSLog(@"join to chat success");
//            } else {
//                NSLog(@"join to chat failed");
//            }
//        }];
//    }
    
    if (IS_WF_APP) {
        self.window.rootViewController = [self makeMainNaviWithRootVC:[[DCTaskListWFMasterViewController alloc] initWithNibName:@"DCTaskListWFMasterViewController" bundle:nil]];
    } else {
        self.window.rootViewController = [self makeMainNaviWithRootVC:[DCChatViewController makeMeWithRoomID:self.loginInfo.userInfo.qbUserInfo.roomID roomJID:self.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil]];
    }
    

}

- (void)showVerifyPhone {
    self.window.rootViewController = [self makeMainNaviWithRootVC:[[DCInputSmsCodeVC alloc] initWithNibName:@"DCInputSmsCodeVC" bundle:nil]];
}

- (void)showRegisPassword {
    self.window.rootViewController = [self makeMainNaviWithRootVC:[[DCSetPassWordVC alloc] initWithNibName:@"DCSetPassWordVC" bundle:nil]];
}

- (void)processDisplayScreens {
    self.alreadyLaunchedApp = [USER_DEFAULT_STANDARD boolForKey:ALREADY_FIRST_TIME_LAUNCH];
    if (self.loginInfo == nil) {
        if (self.alreadyLaunchedApp) {
           [self showLogin];
        } else {
            [self showIntroScreen];
        }
        
    } else {
        switch (self.loginInfo.userStatus) {
            case DCUserStatusFirstReg:
                [self showLogin];
                break;
            case DCUserStatusVerifiedPhone:
                [self showVerifyPhone];
                break;
            case DCUserStatusVerifed: {
                [self showMainScreen];
//                [self loadProfileIfNeed];
//                [self loadSettingIfNeed];
            }
                break;
            default:
                [self logout];
                [self showLogin];
                break;
        }
    }
}

- (void) checkLoginUserStatus {
    if (self.loginInfo == nil) {
        if (self.alreadyLaunchedApp) {
            [self showLogin];
        } else {
            [self showIntroScreen];
        }
        
    } else {
        switch (self.loginInfo.userStatus) {
            case DCUserStatusFirstReg:
                [self showLogin];
                break;
            case DCUserStatusVerifiedPhone:
                [self showLogin];
                break;
            case DCUserStatusVerifed: {
                [self showMainScreen];
//                [self loadProfileIfNeed];
//                [self loadSettingIfNeed];
            }
                break;
            default:
                [self logout];
                [self showLogin];
                break;
        }
    }
}

- (void)getMyProfile
{
    [DCApis getUserProfileComplete:^(BOOL success, ServerObjectBase *response) {
        if (success)
        {
            APP_DELEGATE.mMyProfile = (DCMyProfile*)response;
            [APP_DELEGATE.mMyProfile storeToFile];
        }
        else
        {
        
        }
        [self loadSettingIfNeed];
    }];
}

- (void)getSettings {
    [DCApis getSettingStatuscomplete:^(BOOL success, ServerObjectBase *response) {
            if (success)
            {
                APP_DELEGATE.mySettings = (DCSetting*)response;
                [APP_DELEGATE.mySettings storeToFile];
            }
            else
            {
                //TODO: show error
                NSLog(@"setting error ");
            }

    }];
}

#pragma mark - Public methods
- (void)didLoginWithInfo:(DCLoginInfo*)info afterSignup:(BOOL)afterSignup {
    self.loginInfo = info;
    [self.loginInfo storeToFile];
    CMD_LOAD_USER_QB_IF_NEED();
    [self processDisplayScreens];
    [self.mYellowLineView removeFromSuperview];
    self.mYellowLineView = nil;
    [self showYellowLineBottomNav];
}

- (void)loadProfileIfNeed
{
    if (!self.mMyProfile)
    {
        [self getMyProfile];
    } else {
        [self loadSettingIfNeed];
        self.mMyProfile = [DCMyProfile readSaved];
    }
}

- (void)loadSettingIfNeed {
    if (!self.mySettings) {
        [self getSettings];
    } else {
        self.mySettings = [DCSetting readSaved];
    }

}

- (void)logout {
    
    [DCChat logOut:^(QBResponse *response) {
        
    }];
    [DCLoginInfo removeSaved];
    self.loginInfo = nil;
    
    [DCMyProfile removeSave];
    self.mMyProfile = nil;
    self.mySettings = nil;
    
    [self.mYellowLineView removeFromSuperview];
    self.mYellowLineView = nil;
    [self processDisplayScreens];
}

- (void)showYellowLineBottomNav
{
    UINavigationController *pRootView = (UINavigationController*)APP_DELEGATE.window.rootViewController;
    
    if (!self.mYellowLineView)
    {
        // add bottom view
        CGRect bottomBorderRect = CGRectMake(0, CGRectGetHeight(pRootView.navigationBar.frame), CGRectGetWidth(pRootView.navigationBar.frame), 2.0f);
        self.mYellowLineView = [[UIView alloc] initWithFrame:bottomBorderRect];
        self.mYellowLineView.backgroundColor = [UIColor navBarBorderRegVC];
        [pRootView.navigationBar addSubview:self.mYellowLineView];
    }
    else
    {
        self.mYellowLineView.hidden = NO;
    }
}

- (void)hideYellowLineBottomNav
{
    self.mYellowLineView.hidden = YES;
}


@end
