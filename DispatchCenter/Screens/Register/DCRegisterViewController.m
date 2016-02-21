//
//  DCRegisterViewController.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/5/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCRegisterViewController.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>
#import "DCEditTextCell.h"
#import "DCCountryPicker.h"
#import "UIColor+HexColor.h"
#import "NSString+Validation.h"
#import "DCSmsCodeAlert.h"
#import "DCValidateRegisterModel.h"
#import "DCInputSmsCodeVC.h"
#import "DCPhoneModel.h"
#import "DCSupportPhoneModel.h"
#import "DCApis.h"
#import "DCMyProfile.h"
#import "DCListCountryInfo.h"
#import "DCCommandDefine.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "DCOthersViewController.h"

static CGFloat const kFontSizeUIView = 12.5;
static NSString* const kAgreeLink = @"DCRegisterAgreeLink";
static NSInteger const kTagAlertSmsCode = 100;
static NSString* const kDefaultCountryField = @"Thailand";
static NSString* const kDefaultCodeMap =@"+66"; // Thailand

@interface DCRegisterViewController ()<DCEditTextCellDelegate, UITextViewDelegate,GIDSignInDelegate,GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mContainer;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mFirstNameCell;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mLastNameCell;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mEmailCell;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mCountryCell;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mPhoneCell;
@property (weak, nonatomic) IBOutlet UITextView *mTxtAgreement;
@property (weak, nonatomic) IBOutlet UIButton *mContinueButton;
@property (weak, nonatomic) IBOutlet UIButton *mRegButton;

@property(strong, nonatomic) NSString *mCurrentCodeMap;
@property(strong, nonatomic) NSString *mCurrentCountry;
@property(strong, nonatomic) DCSupportPhoneModel *mSupportPhoneCmd;

@property(strong, nonatomic) NSArray *mListCountrySupport;
@property (weak, nonatomic) IBOutlet UIButton *mTwitterButton;
@property (strong, nonatomic) GIDGoogleUser *googleUser;


@end

@implementation DCRegisterViewController

#pragma mark - view life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mCurrentCodeMap = kDefaultCodeMap;
    self.mCurrentCountry = kDefaultCountryField;
    [self commonInit];
    [self getListCountry];
    
    if (self.myProfile) {
        [self.mFirstNameCell setTextContent:self.myProfile.mFirstName];
        [self.mLastNameCell setTextContent: self.myProfile.mLastName];
        [self.mEmailCell setTextContent:self.myProfile.mEmail];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /////////////// SET UP CONTENT SIZE //////////
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.mContainer.subviews)
    {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.mContainer.scrollEnabled = YES;
    self.mContainer.contentSize = CGSizeMake(contentRect.size.width, contentRect.size.height + 10.0f);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // google signin
    
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.mSupportPhoneCmd)
    {
        [self.mSupportPhoneCmd removePopUp];
    }
}

- (void)commonInit
{
    [self settingNavBar];
    
    /* setting btn */
    self.mRegButton.backgroundColor = [UIColor backgroundNavRegVC];
    self.mContinueButton.backgroundColor = [UIColor yellowButton];
    self.mContinueButton.layer.cornerRadius = 2.0f;
    self.mContinueButton.clipsToBounds = YES;
    
    
    /* setting cells */
    self.mFirstNameCell.mTitle.text = NSLocalizedString(@"str_first_name", nil);
    self.mFirstNameCell.mStrPlaceHolder = self.mFirstNameCell.mTitle.text;
    self.mFirstNameCell.mDelegate = self;
    
    self.mLastNameCell.mTitle.text = NSLocalizedString(@"str_last_name", nil);
    self.mLastNameCell.mStrPlaceHolder = self.mLastNameCell.mTitle.text;
    self.mLastNameCell.mDelegate = self;
    
    self.mEmailCell.mTitle.text = NSLocalizedString(@"str_email", nil);
    self.mEmailCell.mStrPlaceHolder = self.mEmailCell.mTitle.text;
    self.mEmailCell.mDelegate = self;
    self.mEmailCell.mTxtField.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.mCountryCell.mTitle.text = NSLocalizedString(@"str_country", nil);
    self.mCountryCell.mDelegate = self;
    self.mCountryCell.mIsEnableKeyBoard = NO;
    [self.mCountryCell showThreeDot:YES];
    [self.mCountryCell setTextContent:COUNTRY_NAME_WITH_CODE_MAP(kDefaultCountryField)];
    
    self.mPhoneCell.mTitle.text = NSLocalizedString(@"str_phone", nil);
    self.mPhoneCell.mStrPlaceHolder = NSLocalizedString(@"str_phone_number", nil);
    self.mPhoneCell.mDelegate = self;
    
    
    /* agreement */
    self.mTxtAgreement.delegate = self;
    self.mTxtAgreement.text = NSLocalizedString(@"str_agreement", nil);
    
    UITapGestureRecognizer *pTapAgreement = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAgreementCallback:)];
    [self.mTxtAgreement addGestureRecognizer:pTapAgreement];
    
    // set attributed
    NSMutableAttributedString *pStrAttributed = [[NSMutableAttributedString alloc]initWithString:self.mTxtAgreement.text];
    NSRange rangeLink = [self.mTxtAgreement.text rangeOfString:NSLocalizedString(@"str_agreement_link", nil)];
    [pStrAttributed addAttribute: NSForegroundColorAttributeName value:[UIColor yellowButton] range: rangeLink];
    [self.mTxtAgreement setAttributedText:pStrAttributed];
    
    self.mTxtAgreement.font = [UIFont systemFontOfSize:kFontSizeUIView];
    
    /* another setting */
    self.mTxtAgreement.editable = NO;
    self.mContainer.scrollEnabled = NO;
    
    /* twitter button */
    self.mTwitterButton.backgroundColor = [UIColor twitterColor];
    self.mTwitterButton.layer.cornerRadius = 2.0f;
    self.mTwitterButton.clipsToBounds = YES;
    
    
    /////////////////// NOTIFY ////////////////////
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTwitterProfileCallback:) name:DC_NOTI_TWITTER_REG object:nil];
}

-(void)settingNavBar
{
    // add bottom view
    [APP_DELEGATE showYellowLineBottomNav];
    
    // button show popup
    if (IS_FA_APP)
    {
        self.mSupportPhoneCmd = [[DCSupportPhoneModel alloc] init];
        
        [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_3dot_menu"]]
                          leftOrRight:NO
                               target:self.mSupportPhoneCmd
                              actions:@[[NSValue valueWithPointer:@selector(openSupportView)]]];
    }
}

#pragma mark - get list country
-(void)getListCountry
{
    __weak typeof (self) thiz = self;
    [DCApis getInfoCountryWithCountryName:nil complete:^(BOOL success, ServerObjectBase *response) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                DCListCountryInfo *pCountryModel = (DCListCountryInfo*)response;
                //DLogInfo(@"list country: %@", pCountryModel.mListCountry);
                strongSelf.mListCountrySupport = pCountryModel.mListCountry;
            }
            else
            {
                
            }
            
        }
    }];
    
}

#pragma mark - tap agreement link
-(void)tapAgreementCallback:(UITapGestureRecognizer*)tapGes
{
    UITextView *textView = (UITextView *)tapGes.view;
    
    CMD_CLICK_LINK_EVENT_IN_TEXTVIEW(textView, NSLocalizedString(@"str_agreement_link", nil), [tapGes locationInView:textView], ^{
        DLogInfo(@"click agreement link");
        //TODO: event when click agreement
        // switch view for fa or wf
        DCOthersViewController *pVC = IS_FA_APP ? [[DCOthersViewController alloc] initWithNibName:nil bundle:nil] :
        [[DCOthersViewController alloc] initWithNibName:nil bundle:nil];
        pVC.otherViewType = OTHER_VIEW_END_USER_LICENSE_AGREEMENT;
        
        [MAIN_NAVIGATION pushViewController:pVC animated:YES];
    });
}

#pragma mark - show alert confirm sms code
-(void)showAlertConfirmSmsCode
{
    ////////////////// DELETE IF HAS POP UP ///////////////
    if ([APP_DELEGATE.window viewWithTag:kTagAlertSmsCode])
    {
        DCSmsCodeAlert *pAlertSmsCodeView = (DCSmsCodeAlert*)[APP_DELEGATE.window viewWithTag:kTagAlertSmsCode];
        [pAlertSmsCodeView removeFromSuperview];
    }
  
    ///////////////// CREATE NEW ///////////////////////
    DCSmsCodeAlert *pSMSCodeAlertView = [[DCSmsCodeAlert alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [pSMSCodeAlertView setStringPhoneWithCode: [NSString stringWithFormat:@"(%@) %@", self.mCurrentCodeMap, self.mPhoneCell.mStrContent]];
    pSMSCodeAlertView.tag = kTagAlertSmsCode;
    [self.view endEditing:YES];
    [APP_DELEGATE.window addSubview:pSMSCodeAlertView];
    
    // click cancel btn
    [pSMSCodeAlertView setCancelBtnClick:^(DCSmsCodeAlert *smsAlert){
        [smsAlert removeFromSuperview];
    }];
    
    // click Ok btn
    __weak typeof (self) thiz = self;
    [pSMSCodeAlertView setOkBtnClick:^(DCSmsCodeAlert *smsAlert) {
        [smsAlert removeFromSuperview];
        
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            DCInputSmsCodeVC *pInputVC = [[DCInputSmsCodeVC alloc] initWithNibName:@"DCInputSmsCodeVC" bundle:nil];
            if (self.signupMode == DCSignupModeNormal) {
                pInputVC.loginMode = DCLoginModeNormal;
            } else {
                pInputVC.loginMode = DCLoginModeSocial;
            }
            pInputVC.mStrPhoneWithCode = [NSString stringWithFormat:@"(%@) %@", strongSelf.mCurrentCodeMap, strongSelf.mPhoneCell.mStrContent];
            [strongSelf.navigationController pushViewController:pInputVC animated:YES];
        }
    }];
}

#pragma mark - action
- (IBAction)gg_clickBtnContinueCallback:(id)sender
{
    DCValidateRegisterModel *pValidateObj = [[DCValidateRegisterModel alloc] init];
    
    // set data for validate object
    [pValidateObj setFirstName: self.mFirstNameCell.mStrContent
                      lastName: self.mLastNameCell.mStrContent
                         email: self.mEmailCell.mStrContent
                         phone: self.mPhoneCell.mStrContent
                    andCountry: self.mCountryCell.mStrContent];
    
    
    if ([pValidateObj alertString]) {
        //DLogInfo(@" alert confirm info %@", [pValidateObj alertString]);
        [UIAlertView alertViewtWithTitle:@"" message:[pValidateObj alertString] autoShow:YES callback:^(UIAlertView *al, NSInteger idx) {
            // ..
        } cancelButtonTitle:NSLocalizedString(@"str_ok", nil) otherButtonTitles: nil];
    } else {
        [self signupWithMode:self.signupMode];
    }
}


- (void)signupWithMode:(DCSignupMode)signupMode {
    [LoadingViewHelper showLoadingWithText:NLS(@"Processing...")];

    __weak typeof (self) thiz = self;
    NSString *pStrPhoneWithCode = [NSString stringWithFormat:@"%@%@", self.mCurrentCodeMap, self.mPhoneCell.mStrContent];
    NSDictionary *params;
    
    switch (signupMode){
        case DCSignupModeNormal:
            params = nil;
            break;
        case DCSignupModeFacebook:
            params = @{  API_PR_SOCIAL_MODE : @"facebook",
                         API_PR_SOCIAL_TOKEN : API_PR_FACEBOOK_TOKEN_VALUE };
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
    [DCApis signUpWithFirstName: self.mFirstNameCell.mStrContent
                       lastName:self.mLastNameCell.mStrContent
                          email:self.mEmailCell.mStrContent
                         mobile:pStrPhoneWithCode
                         social:params
                       complete:^(BOOL success, ServerObjectBase *response) {
                           if (success) {
                               __strong typeof(thiz) strongSelf = thiz;
                               if (strongSelf)
                               {
                                   if (response)
                                   {
                                      
                                       APP_DELEGATE.loginInfo = (DCLoginInfo*)response;
                                       
                                       [USER_DEFAULT_STANDARD setObject:APP_DELEGATE.loginInfo.token forKey:kDCAccessTokenKey];
                                       APP_DELEGATE.loginInfo.userStatus = DCUserStatusFirstReg;
                                       [APP_DELEGATE.loginInfo storeToFile];
                                       NSLog(@"token :%@",APP_DELEGATE.loginInfo.token);
                                       NSLog(@" REGISTER login info : %@\n",APP_DELEGATE.loginInfo);
                                       // show confirm view
                                       [strongSelf showAlertConfirmSmsCode];
                                       
                                       // save my profile
                                       DCMyProfile *pMyProfile = [[DCMyProfile alloc] init];
                                       pMyProfile.mFirstName = strongSelf.mFirstNameCell.mStrContent;
                                       pMyProfile.mLastName = strongSelf.mLastNameCell.mStrContent;
                                       pMyProfile.mEmail = strongSelf.mEmailCell.mStrContent;
                                       pMyProfile.mCountry = strongSelf.mCountryCell.mStrContent;
                                       pMyProfile.mMobileNumber = [NSString stringWithFormat:@"%@%@", strongSelf.mCurrentCodeMap, strongSelf.mPhoneCell.mStrContent];
                                       pMyProfile.mStatus = DCMyProfileStatusNone;
                                       
                                       APP_DELEGATE.mMyProfile = pMyProfile;
                                       [APP_DELEGATE.mMyProfile storeToFile];
                                   }
                               }
                           } else {
                               // TODO: error processing
                           }
                           [LoadingViewHelper hideLoading];
                           
                       }];
}

- (void)loginWithMode:(DCSignupMode )signupMode {
    
    NSDictionary *params;
    switch (signupMode){
        case DCSignupModeNormal:
            params = nil;
            break;
        case DCSignupModeFacebook:
            params = @{  API_PR_SOCIAL_MODE : @"facebook",
                         API_PR_SOCIAL_TOKEN : API_PR_FACEBOOK_TOKEN_VALUE,
                         kDCDoNotShowAlertView : @"true"};
            break;
        case DCSignupModeGoogle:
            params = @{  API_PR_SOCIAL_MODE : @"google_plus",
                         API_PR_SOCIAL_TOKEN : API_PR_GOOGLE_TOKEN_VALUE,
                         kDCDoNotShowAlertView : @"true"};
            break;
        case DCSignupModeTwiter:
            params = @{  API_PR_SOCIAL_MODE : @"twitter",
                         API_PR_SOCIAL_TOKEN : API_PR_TWITER_TOKEN_VALUE,
                         API_PR_SOCIAL_TOKEN_SECRECT :API_PR_TWITER_TOKEN_SECRECT_VALUE,
                         kDCDoNotShowAlertView : @"true"};
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
        {            switch (signupMode){
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
    }];
}

- (IBAction)gg_clickRegCallback:(id)sender
{
    //TODO: nothing
}




#pragma mark - DCEditTextCell delegate
-(void)editTextCellbeginEditText:(DCEditTextCell *)cell
{
    ///////////////////// COUNTRY CELL ///////////////////////
    if ([cell isEqual:self.mCountryCell])
    {
        DCCountryPicker *pCountryPickerView = [[DCCountryPicker alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        
        // click button select
        __weak typeof (self) thiz = self;
        [pCountryPickerView setSelectCountryEvent:^(NSString *selectCountry, NSString *codeMap) {
            __strong typeof(thiz) strongSelf = thiz;
            if (strongSelf)
            {
                [strongSelf.mCountryCell setTextContent:COUNTRY_NAME_WITH_CODE_MAP(selectCountry)];
                strongSelf.mCurrentCodeMap = codeMap;
                strongSelf.mCurrentCountry = selectCountry;
                //DLogInfo(@"current code map %@", codeMap);
            }
        }];
        
        //1. set data for country picker first
        if (self.mListCountrySupport)
        {
            pCountryPickerView.mArrDataCountry = self.mListCountrySupport;
        }
        else
        {
            [pCountryPickerView getListCountryFromServer];
        }
        
        //2. after setting data for country picker
        pCountryPickerView.mStrSelectCountry = self.mCountryCell.mStrContent;
        
        [APP_DELEGATE.window addSubview:pCountryPickerView];
        
        [self.view endEditing:YES];
        
        return;
    }
    
    ////////////////////// PHONE CELL //////////////////////
    if ([cell isEqual:self.mPhoneCell])
    {
        [self.mPhoneCell setKeyboardType:UIKeyboardTypePhonePad];
        return;
    }
    
    ////////////////////// EMAIL CELL //////////////////////
    if ([cell isEqual:self.mEmailCell])
    {
        [self.mEmailCell setKeyboardType:UIKeyboardTypeEmailAddress];
    }
}

-(void)editTextCellEndEditText:(DCEditTextCell *)cell
{
    
}


#pragma mark - disable paste option
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *pMenuController = [UIMenuController sharedMenuController];
    if (pMenuController)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

-(void)dealloc
{
    if ( self.mSupportPhoneCmd)
    {
        [self.mSupportPhoneCmd removePopUp];
        self.mSupportPhoneCmd = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - signup with twiter

- (IBAction)clickTwitterButton:(id)sender
{
    self.signupMode = DCSignupModeTwiter;
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
    [self.mFirstNameCell setTextContent:[fullName objectAtIndex:0]];
    if (fullName.count > 1) {
        [self.mLastNameCell setTextContent:[fullName objectAtIndex:1]];
    }
    
}

#pragma mark - sign up with facebook

- (IBAction)signupByFacebookButtonClicked:(id)sender {
    self.signupMode = DCSignupModeFacebook;
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    
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


-(void)fetchFacebookUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@",result);
                 DCMyProfile *pMyProfile = [[DCMyProfile alloc] initWithFacebookProfile:result];
                 [self.mFirstNameCell setTextContent:pMyProfile.mFirstName];
                 [self.mLastNameCell setTextContent: pMyProfile.mLastName];
                 [self.mEmailCell setTextContent:pMyProfile.mEmail];
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
    self.signupMode = DCSignupModeGoogle;
    [[GIDSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] signIn];
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
    
    DCMyProfile *pMyProfile = [[DCMyProfile alloc] init];
    NSArray * fullName = [_googleUser.profile.name separatedStringBySpaces];
    
    pMyProfile.mFirstName = [fullName objectAtIndex:0];
    if (fullName.count>1) {
        pMyProfile.mLastName = [fullName objectAtIndex:1];
    }
    pMyProfile.mEmail = _googleUser.profile.email;
    
    [self.mFirstNameCell setTextContent:pMyProfile.mFirstName];
    [self.mLastNameCell setTextContent: pMyProfile.mLastName];
    [self.mEmailCell setTextContent:pMyProfile.mEmail];
    // ...
    
    // ...
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
}

@end
