//
//  DCLoginViewController.m
//  DispatchCenter
//
//  Created by VietHQ on 10/12/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCLoginViewController.h"
#import "DCEditTextCell.h"
#import "DCCommandDefine.h"
#import "DCLoginValidateModel.h"
#import "DCApis.h"
#import "DCRegisterViewController.h"
#import "DCResetPasswordViewcontroller.h"
#import "DCMyProfile.h"

@interface DCLoginViewController ()<GIDSignInDelegate,GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UIButton *mLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *mContinueButton;

@property (weak, nonatomic) IBOutlet DCEditTextCell *mUserNameCellView;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mPasswordCellView;

@property (weak, nonatomic) IBOutlet UITextView *mCreateAccountTextField;
@property (weak, nonatomic) IBOutlet UITextView *mResetAccountTextField;
@property (weak, nonatomic) IBOutlet UIButton *mTwitterButton;

@property (strong, nonatomic) DCMyProfile *myProfile;
@property (strong, nonatomic) GIDGoogleUser *googleUser;


@end

@implementation DCLoginViewController

#pragma mark - view life circle
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self settingNav];
    self.myProfile = [[DCMyProfile alloc] init];
    self.mUserNameCellView.mTitle.text = NSLocalizedString(@"str_username", );
    self.mUserNameCellView.mTitle.textColor = [UIColor darkGrayColor];
    self.mUserNameCellView.mStrPlaceHolder = NSLocalizedString(@"str_username", nil);
    self.mUserNameCellView.mTxtField.textColor = [UIColor lightGrayColor];
    
    self.mUserNameCellView.mTxtField.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.mPasswordCellView.mTitle.text = NSLocalizedString(@"str_password", nil);
    self.mPasswordCellView.mTitle.textColor = [UIColor darkGrayColor];
    self.mPasswordCellView.mStrPlaceHolder = @"****";
    [self.mPasswordCellView setSecureText:YES];
    
    
    self.mLoginButton.enabled = NO;
    self.mLoginButton.backgroundColor = [UIColor backgroundNavRegVC];
    self.mContinueButton.backgroundColor = [UIColor yellowButton];
    self.mContinueButton.layer.cornerRadius = 2.0f;
    self.mContinueButton.clipsToBounds = YES;
    
    self.mTwitterButton.backgroundColor = [UIColor twitterColor];
    self.mTwitterButton.layer.cornerRadius = 2.0f;
    self.mTwitterButton.clipsToBounds = YES;
    
    /* create account textfield */
    self.mCreateAccountTextField.text = NSLocalizedString(@"str_create_acc", nil);
    self.mCreateAccountTextField.textColor = [UIColor darkGrayColor];
    [self setColorForTxtView:self.mCreateAccountTextField strLink:NSLocalizedString(@"str_acc_link", nil)];
    
    
    /* forgot password textfield */
    self.mResetAccountTextField.text = NSLocalizedString(@"str_forgot_pass", nil);
    self.mResetAccountTextField.textColor = [UIColor darkGrayColor];
    [self setColorForTxtView:self.mResetAccountTextField strLink:NSLocalizedString(@"str_reset_pass_link", nil)];
    
    UITapGestureRecognizer *pCreateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLinkEventCallback:)];
    [self.mCreateAccountTextField addGestureRecognizer:pCreateTap];
    
    UITapGestureRecognizer *pResetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLinkEventCallback:)];
    [self.mResetAccountTextField addGestureRecognizer:pResetTap];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self settingNav];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // google signin
    
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
}
-(void)settingNav
{
    [APP_DELEGATE showYellowLineBottomNav];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - set color for link in textview
-(void)setColorForTxtView:(UITextView*)txtView strLink:(NSString*)link
{
    NSMutableAttributedString *pStrAttributed = [[NSMutableAttributedString alloc]initWithString:txtView.text];
    NSRange rangeLink = [txtView.text rangeOfString:link];
    [pStrAttributed addAttribute: NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[txtView.text rangeOfString:txtView.text]];
    [pStrAttributed addAttribute: NSForegroundColorAttributeName value:[UIColor yellowButton] range: rangeLink];
    [txtView setAttributedText:pStrAttributed];
}

#pragma mark - action
- (IBAction)clickContinueCallback:(id)sender
{
    DCLoginValidateModel *pValidate = [[DCLoginValidateModel alloc] initWithEmail: self.mUserNameCellView.mStrContent
                                                                      andPassword: self.mPasswordCellView.mStrContent];
    
    if ([pValidate stringValidate])
    {
        UIAlertView *pAlert = [UIAlertView alertViewtWithTitle:@"" message:[pValidate stringValidate] callback:^(UIAlertView *al, NSInteger idx) {
            //
        } cancelButtonTitle:NSLocalizedString(@"str_ok", nil) otherButtonTitles: nil];
        [pAlert show];
    }
    else
    {
        [LoadingViewHelper showLoadingWithText:NLS(@"Processing...")];
        [DCApis loginByEmail:self.mUserNameCellView.mStrContent password:self.mPasswordCellView.mStrContent complete:^(BOOL success, ServerObjectBase *response) {
            
            [LoadingViewHelper hideLoading];
            if (success)
            {
                DCLoginInfo *info = (DCLoginInfo*)response;
                [USER_DEFAULT_STANDARD setObject:info.token forKey:kDCAccessTokenKey];
                info.userStatus = DCUserStatusVerifed;
                [APP_DELEGATE didLoginWithInfo:info afterSignup:NO];
                //[APP_DELEGATE loadProfileIfNeed];
            }
            else
            {
                //TODO: error
            }
        }];
    }
}

- (void)loginWithMode:(DCSignupMode )signupMode {
    
    NSDictionary *params;
    switch (signupMode){
        case DCSignupModeNormal:
            params = nil;
            break;
        case DCSignupModeFacebook:
            params = @{  API_PR_SOCIAL_MODE : @"facebook",
                         API_PR_SOCIAL_TOKEN :API_PR_FACEBOOK_TOKEN_VALUE };
            break;
        case DCSignupModeGoogle:
            params = @{  API_PR_SOCIAL_MODE : @"google_plus",
                         API_PR_SOCIAL_TOKEN : API_PR_GOOGLE_TOKEN_VALUE };
            break;
        case DCSignupModeTwiter:
            params = @{  API_PR_SOCIAL_MODE : @"twitter",
                         API_PR_SOCIAL_TOKEN : API_PR_TWITER_TOKEN_VALUE,
                         API_PR_SOCIAL_TOKEN_SECRECT :API_PR_TWITER_TOKEN_SECRECT_VALUE  };
            break;
        default:
            break;
    }
    
    [LoadingViewHelper showLoadingWithText:NLS(@"Processing...")];
    [DCApis loginWithSocial:params complete:^(BOOL success, ServerObjectBase *response) {
        [LoadingViewHelper hideLoading];
        if (success)
        {
            DCLoginInfo *info = (DCLoginInfo*)response;
            [USER_DEFAULT_STANDARD setObject:info.token forKey:kDCAccessTokenKey];

            info.userStatus = DCUserStatusVerifed;
            [APP_DELEGATE didLoginWithInfo:info afterSignup:NO];
            //[APP_DELEGATE loadProfileIfNeed];
        }
        else
        {
            ServerObjectBase *errorRespone = (ServerObjectBase *)response;
            if (errorRespone.errorCode == 4002) {
                switch (signupMode){
                    case DCSignupModeNormal:
                        break;
                    case DCSignupModeFacebook:
                        [self fetchFacebookUserInfo];
                        break;
                    case DCSignupModeGoogle:
                        [self fecthGoogleUserInfo];
                        break;
                    case DCSignupModeTwiter:
                        [self getTwitterProfile];
                        break;
                    default:
                        break;
                }
            }
            //TODO: error
        }
    }];
}

- (void)gotoSignUp {
    DCRegisterViewController *pRegVC = [[DCRegisterViewController alloc] initWithNibName:nil bundle:nil];
    pRegVC.myProfile = self.myProfile;
    if (self.signinMode == DCSigninModeGoogle) {
        pRegVC.signupMode = DCSignupModeGoogle;
    } else if (self.signinMode == DCSigninModeFacebook){
        pRegVC.signupMode = DCSignupModeFacebook;

    }else if (self.signinMode == DCSigninModeTwiter){
        pRegVC.signupMode = DCSignupModeTwiter;
        
    }else {
        pRegVC.signupMode = DCSignupModeNormal;
        
    }
    [self.navigationController pushViewController:pRegVC animated:YES];

}

- (void)clickLinkEventCallback:(UITapGestureRecognizer*)tapGes
{
    UITextView *pTextView = (UITextView*)tapGes.view;
    CGPoint lo = [tapGes locationInView:pTextView];
    
    if ([pTextView isEqual:self.mCreateAccountTextField])
    {
        __weak typeof (self) thiz = self;
        CMD_CLICK_LINK_EVENT_IN_TEXTVIEW( pTextView, NSLocalizedString(@"str_acc_link", nil), lo, ^{
            DLogInfo(@"click create acc callback");
            
            DCRegisterViewController *pRegVC = [[DCRegisterViewController alloc] initWithNibName:nil bundle:nil];
            [thiz.navigationController pushViewController:pRegVC animated:YES];
            
        });
        
        return;
    }
    
    if ([pTextView isEqual:self.mResetAccountTextField])
    {
        __weak typeof (self) thiz = self;
        CMD_CLICK_LINK_EVENT_IN_TEXTVIEW( pTextView, NSLocalizedString(@"str_reset_pass_link", nil), lo, ^{
            DLogInfo(@"click reset password callback");
            
            DCResetPasswordViewcontroller *pResetPassVC = [[DCResetPasswordViewcontroller alloc] initWithNibName:nil bundle:nil];
            [thiz.navigationController pushViewController:pResetPassVC animated:YES];
        });

        return;
    }
}

#pragma mark - signup with twiter

- (IBAction)clickTwitterButton:(id)sender
{
    self.signinMode = DCSignupModeTwiter;
    [[Twitter sharedInstance] logOut];
    [[Twitter sharedInstance] logOutGuest];
    [self getTwitterSession];
}

- (void)getTwitterSession {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        if (session) {
            [USER_DEFAULT_STANDARD setObject:session.authToken forKey:API_PR_TWITER_TOKEN_KEY];
            [USER_DEFAULT_STANDARD setObject:session.authTokenSecret forKey:API_PR_TWITER_TOKEN_SECRECT_KEY];
            [self loginWithMode:DCSignupModeTwiter];
            
        } else {
            DLogError(@"%@", error);
        }
    }];

}

- (void)getTwitterProfile {
    TWTRSessionStore *pStore = [Twitter sharedInstance].sessionStore;
    TWTRSession *pSession = pStore.session;

    [pStore saveSessionWithAuthToken:pSession.authToken
                     authTokenSecret:pSession.authTokenSecret
                          completion:^(id<TWTRAuthSession>  _Nullable session, NSError * _Nullable error) {
                              if (session)
                              {
                                  CMD_GET_TWITTER_PROFILE(session.userID);
                              }
                              else
                              {
                                  DLogError(@"%@", error);
                              }
                          }];

}

- (void)getTwitterProfileCallback:(NSNotification*)sender
{
    TWTRUser *pTWTUser = [sender valueForKey:@"object"];
    NSArray * fullName = [pTWTUser.name separatedStringBySpaces];
    self.myProfile.mFirstName = [fullName objectAtIndex:0];
    if (fullName.count > 1) {
        self.myProfile.mLastName = [fullName objectAtIndex:1];
    }
    [self gotoSignUp];
    
}

#pragma mark - sign up with facebook

- (IBAction)signupByFacebookButtonClicked:(id)sender {
    self.signinMode = DCSignupModeFacebook;
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"Facebook error...");
        }
        else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Facebook cancelled...");
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            NSLog(@"Facebook success...");
            [USER_DEFAULT_STANDARD setObject:[FBSDKAccessToken currentAccessToken].tokenString forKey:API_PR_FACEBOOK_TOKEN_KEY];
            [self loginWithMode:DCSignupModeFacebook];
        }
    }];
}


- (void)fetchFacebookUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@",result);
                 self.myProfile = [[DCMyProfile alloc] initWithFacebookProfile:result];
                 [self gotoSignUp];
                }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
}

#pragma mark - signup with google
- (IBAction)signupByGoogleButtonClicked:(id)sender {
    self.signinMode = DCSignupModeGoogle;
//    if ([[GIDSignIn sharedInstance] hasAuthInKeychain]) {
//        [self loginWithMode:DCSignupModeGoogle];
//    } else {
    [[GIDSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] signIn];
//    }
    
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        return;
    }
    // Perform any operations on signed in user here.
    //    NSString *userId = user.userID;                  // For client-side use only!
    NSString *accessToken = user.authentication.accessToken; // Safe to send to the server
    [USER_DEFAULT_STANDARD setObject:accessToken forKey:API_PR_GOOGLE_TOKEN_KEY];
    _googleUser = user;
    [self loginWithMode:DCSignupModeGoogle];
}

- (void)fecthGoogleUserInfo {
    
    NSArray * fullName = [_googleUser.profile.name separatedStringBySpaces];
    self.myProfile.mFirstName = [fullName objectAtIndex:0];
    if (fullName.count>1) {
        self.myProfile.mLastName = [fullName objectAtIndex:1];
    }
    self.myProfile.mEmail = _googleUser.profile.email;
    [self gotoSignUp];
    
    // ...
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
}


@end
