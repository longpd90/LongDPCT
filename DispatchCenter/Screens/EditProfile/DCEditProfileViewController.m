//
//  DCEditProfileViewController.m
//  DispatchCenter
//
//  Created by VietHQ on 10/20/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCEditProfileViewController.h"
#import "DCTitleWithBottomView.h"
#import "DCShowInfoCellView.h"
#import "DCSuggestionsView.h"
#import "DCCountryPicker.h"
#import "DCValidateEditProfileModel.h"
#import "DCApis.h"
#import "DCListCountryInfo.h"
#import "DCMyProfile.h"
#import "DCPhoneModel.h"
#import "DCStateInfo.h"
#import "DCCheckIdModel.h"
#import "DCDistrictsInfo.h"
#import "DCUnderLineLabel.h"
#import "DCMapViewController.h"
#import "DCSmsCodeAlert.h"
#import "DCSupportPhoneModel.h"
#import "DCMapInfo.h"
#import "DCChatViewController.h"
#import "DCInputSmsCodeVC.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterIOS7Style.h"

#define IPHONE_KEYBOARD_PORTRAIT_HEIGHT 216

static CGFloat const kPaddingTopCell = 45.0f;
static NSUInteger const kTagAlertSmsCode = 2000;

@interface DCEditProfileViewController()<DCShowInfoCellViewDelegate, UIScrollViewDelegate, DCSuggestionsViewDelegate>

// container
@property (weak, nonatomic) IBOutlet UIScrollView *mContainerScrollView;


// section profile
@property (weak, nonatomic) IBOutlet DCTitleWithBottomView *mProfileSecitonLabel;
@property (weak, nonatomic) IBOutlet DCShowInfoCellView *mFirstNameView;
@property (weak, nonatomic) IBOutlet DCShowInfoCellView *mLastNameView;


// section mobile number
@property (weak, nonatomic) IBOutlet DCTitleWithBottomView *mMobileNumbLabel;
@property (weak, nonatomic) IBOutlet DCShowInfoCellView *mMobileNumberView;


// section address
@property (weak, nonatomic) IBOutlet DCTitleWithBottomView *mAddressLabel;
@property (weak, nonatomic) IBOutlet DCShowInfoCellView *mStreetAddressView;
@property (weak, nonatomic) IBOutlet DCShowInfoCellView *mAddress2View;
@property (weak, nonatomic) IBOutlet DCShowInfoCellView *mSubDistrictView;
@property (weak, nonatomic) IBOutlet DCShowInfoCellView *mDistrictView;
@property (weak, nonatomic) IBOutlet DCShowInfoCellView *mStateView;
@property (weak, nonatomic) IBOutlet DCShowInfoCellView *mCountryView;
@property (weak, nonatomic) IBOutlet DCShowInfoCellView *mZipCodeView;


// section button
@property (weak, nonatomic) IBOutlet UIButton *mSubmitButton;
@property (weak, nonatomic) IBOutlet UIButton *mLogOutButton;

@property (strong, nonatomic) NSArray *mArrShowInfoView;

@property (assign, nonatomic) UIEdgeInsets mEdgeInsets;
@property (assign, nonatomic) CGFloat mHeightKeyBoard;

@property (weak, nonatomic) DCShowInfoCellView *mCurrentEditView;
@property (strong, nonatomic) DCSuggestionsView *mSuggestionsView;

@property( strong, nonatomic) NSArray *mCountryList;
@property( strong, nonatomic) NSArray *mProvincesList;
@property( strong, nonatomic) NSArray *mDistrictList;
@property( strong, nonatomic) NSArray *mSubDistrictList;


// location
@property (weak, nonatomic) IBOutlet UIImageView *mIconMap;
@property (weak, nonatomic) IBOutlet DCUnderLineLabel *mLocationLabel;


// support phone
@property (strong, nonatomic) DCSupportPhoneModel *mSupportPhoneCmd;


@property (assign, nonatomic) BOOL mIsOpenOTP;
@property (assign, nonatomic) BOOL isEditProfile; //add by MinhHT, check status isEdit profile or not, for button Back action Pop/not viewcontroller

@end

@implementation DCEditProfileViewController

#pragma mark - View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"ic_edit"],[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]]
                      leftOrRight:NO target:self
                          actions:@[ [NSValue valueWithPointer:@selector(didEditProfileBtn:)],
                                     [NSValue valueWithPointer:@selector(didSelectChatBtn:)],
                                     [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];

    //////////////// profile section
    self.mProfileSecitonLabel.text = NSLocalizedString(@"str_profile", nil);
    self.mProfileSecitonLabel.font = [UIFont normalBoldFont];
    
    [self.mFirstNameView setPlaceHolder:NSLocalizedString(@"str_first_name", nil)];
    [self.mLastNameView setPlaceHolder:NSLocalizedString(@"str_last_name", nil)];
    
    
    
    /////////////// phone section
    self.mMobileNumbLabel.text = NSLocalizedString(@"str_mobile_number", nil);
    self.mMobileNumbLabel.font = [UIFont normalBoldFont];
    
    [self.mMobileNumberView setPlaceHolder:NSLocalizedString(@"str_mobile_number", nil)];
    [self.mMobileNumberView setKeyboardType:UIKeyboardTypePhonePad];
    
    
    
    ////////////// address section
    self.mAddressLabel.text = NSLocalizedString(@"str_address", nil);
    self.mAddressLabel.font = [UIFont normalBoldFont];
    
    // set place holder
    [self.mCountryView setPlaceHolder:NSLocalizedString(@"str_country", nil)];
    [self.mStreetAddressView setPlaceHolder:NSLocalizedString(@"str_street_address", nil)];
    [self.mAddress2View setPlaceHolder:NSLocalizedString(@"str_address2", nil)];
    [self.mSubDistrictView setPlaceHolder:NSLocalizedString(@"str_sub_district", nil)];
    [self.mDistrictView setPlaceHolder:NSLocalizedString(@"str_district", nil)];
    [self.mStateView setPlaceHolder:NSLocalizedString(@"str_state", nil)];
    [self.mZipCodeView setPlaceHolder:NSLocalizedString(@"str_zip_code", nil)];
    
    // disable keyboard for country cell
    self.mCountryView.mIsEnableKeyBoard = NO;
    
    ///////////// btn
    self.mSubmitButton.backgroundColor = [UIColor yellowButton];
    self.mSubmitButton.layer.cornerRadius = 2.0f;
    self.mSubmitButton.clipsToBounds = YES;
    [self.mSubmitButton setTitle:NSLocalizedString(@"str_submit", nil) forState:UIControlStateNormal];
    
    self.mLogOutButton.backgroundColor = [UIColor yellowButton];
    self.mLogOutButton.layer.cornerRadius = 2.0f;
    self.mLogOutButton.clipsToBounds = YES;
    [self.mLogOutButton setTitle:NSLocalizedString(@"str_logout", nil) forState:UIControlStateNormal];
    
    
    
    ///////////// scroll view
    self.mContainerScrollView.delegate = self;
    UITapGestureRecognizer *pTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.mContainerScrollView addGestureRecognizer:pTap];
    
    
    
    ///////////// array show info view
    self.mArrShowInfoView = @[ self.mFirstNameView,
                               self.mLastNameView,
                               self.mMobileNumberView,
                               self.mStreetAddressView,
                               self.mAddress2View,
                               self.mSubDistrictView,
                               self.mDistrictView,
                               self.mCountryView,
                               self.mStateView,
                               self.mZipCodeView ];
    
    for (DCShowInfoCellView *pView in self.mArrShowInfoView)
    {
        pView.mDelegate = self;
    }
    
    
    //////////// location
    self.mLocationLabel.text = NSLocalizedString(@"str_use_current_geo_location", nil);
    self.mLocationLabel.textColor = [UIColor blackColor];
    
    __weak typeof (self) thiz = self;
    [self.mLocationLabel setTapCallback:^{
        
        if ([thiz.mLocationLabel.textColor isEqual:[UIColor grayColor]])
            return;
    
        
        DCMapViewController *pVC = [[DCMapViewController alloc] initWithNibName:@"DCMapViewController" bundle:nil];
        [MAIN_NAVIGATION pushViewController:pVC animated:YES];
    }];
    self.mLocationLabel.textColor = [self disableColor];
    [self.mLocationLabel sizeToFit];
    
    UIView *pLineLocation = [[UIView alloc] initWithFrame:CGRectMake( CGRectGetMinX(self.mLocationLabel.frame), CGRectGetMaxY(self.mLocationLabel.frame) + 1.5f, CGRectGetWidth(self.mLocationLabel.frame), 1.0f)];
    pLineLocation.backgroundColor = [UIColor grayColor];
    [self.mContainerScrollView addSubview:pLineLocation];
    
    
    
    [MAIN_NAVIGATION addLeftBtnWithImg:[UIImage imageNamed:@"ic_back_btn"] title:NSLocalizedString(@"Back", nil) target:self action:@selector(customBack)];
    
    /////////// add notify
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationCallback:) name:DC_NOTI_LOCATION_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backFromOTPSupport:) name:DC_NOTI_OTP_SUPPORT object:nil];
}

- (void)customBack {
    NSLog(@"custom BACK \n");
    if (self.isEditProfile) { //if is Editing profile, touching Back button only toggle to non Editing
        [self didEditProfileBtn:nil];
    } else { //pop to previous view controller in navigation
        [MAIN_NAVIGATION popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    //////////// call api
    [self getProfile];
//    [self getListCountry];
    /////////////// ADD NOTIFY ////////////////
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.mSupportPhoneCmd removePopUp];
    
    ////////////// REMOVE KEYBOARD NOTIFY //////////////
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - color disable
-(UIColor*)disableColor
{
    return [UIColor grayColor];
}
\

#pragma mark - layout subview
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //////////////// POSITION BTN //////////////////
    if ([self.mLocationLabel.textColor isEqual:[self disableColor]])
    {
        self.mSubmitButton.hidden = YES;
        self.mLogOutButton.center = self.mSubmitButton.center;
    }
    else
    {
        self.mSubmitButton.hidden = NO;
        CGRect frame = self.mSubmitButton.frame;
        frame.origin.y = CGRectGetMaxY(frame) + 9.0f;
        
        self.mLogOutButton.frame = frame;
    }
    
    /////////////// SET UP CONTENT SIZE //////////
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.mContainerScrollView.subviews)
    {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    
    self.mContainerScrollView.contentSize = CGSizeMake(contentRect.size.width, contentRect.size.height + 10.0f);
}

#pragma mark - get profile
-(void)getProfile
{
//    if (!APP_DELEGATE.mMyProfile)
//    {
        SHOW_LOADING;
        __weak typeof (self) thiz = self;
        [DCApis getUserProfileComplete:^(BOOL success, ServerObjectBase *response) {
            HIDE_LOADING;
            if (success)
            {
                APP_DELEGATE.mMyProfile = (DCMyProfile*)response;
                DLogInfo(@"Response for api EDit profile %@",  [APP_DELEGATE.mMyProfile description]);
                [APP_DELEGATE.mMyProfile storeToFile];
                [thiz fillProfile];
                 [self getListCountry];
            }
            else
            {
                //TODO: error
                if (self.isEditProfile) {
//                     [thiz showAlertGetFailure];
                }
               
                DLogInfo(@"Response for api EDit profile error %@",  [response description]);
            }
        }];
//    }
//    else
//    {
//        [self fillProfile];
//    }
}

-(void)fillProfile
{
    DCMyProfile *pProfile = APP_DELEGATE.mMyProfile;
    [self.mFirstNameView setText:pProfile.mFirstName];
    [self.mLastNameView setText:pProfile.mLastName];
    pProfile.mMobileNumber = [pProfile.mMobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.mMobileNumberView setText:PHONE_NUMBER_FORMAT_IN_EDIT_PROFILE(pProfile.mMobileNumber, pProfile.mCountry)];
    [self.mStreetAddressView setText:pProfile.mStreetAddress];
    [self.mAddress2View setText:pProfile.mAddress2];
    
    [self.mSubDistrictView setText:pProfile.mSubDistrict];
    self.mSubDistrictView.mId = pProfile.mIdSubDistrict;
    
    [self.mDistrictView setText:pProfile.mDistrict];
    self.mDistrictView.mId = pProfile.mIdDistrict;
    
    [self.mCountryView setText:pProfile.mCountry];
    self.mCountryView.mId = pProfile.mIdCountry;
    
    [self.mStateView setText:pProfile.mState];
    self.mStateView.mId = pProfile.mIdState;
    
    [self.mZipCodeView setText:![pProfile.mZipCode isEqualToString:@"0"] ? pProfile.mZipCode : @""];
}


#pragma mark - Call api
-(void)getListCountry
{
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis getInfoCountryWithCountryName:nil complete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                DCListCountryInfo *pCountryModel = (DCListCountryInfo*)response;
                strongSelf.mCountryList = pCountryModel.mListCountryWithId;
                
                [strongSelf getListProvinces];
            }
            else
            {
                //TODO: show error
            }
        }
    }];
}

-(void)getListProvinces
{
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis getStateWithCode:nil complete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                DCStateInfo *pStateModel = (DCStateInfo*)response;
                strongSelf.mProvincesList = pStateModel.mStateList;
            }
            else
            {
                //TODO: show error
            }
        }
    }];
}

-(void)getListDistrictWithIdProvince:(NSUInteger)idProvinces
{
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis getDistrictWithStateId:idProvinces complete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                DCDistrictsInfo *pDistrictModel = (DCDistrictsInfo*)response;
                strongSelf.mDistrictList = pDistrictModel.mDistrictsList;
                if ([strongSelf.mCurrentEditView isEqual:strongSelf.mDistrictView])
                {
                    [strongSelf.mDistrictView openKeyBoard];
                }
                
            }
            else
            {
                //TODO: error
            }
            
        }
    }];
}

-(void)getListSubDistrictWithIdDistrict:(NSUInteger)idDistrict
{
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis getSubDistrictWithDistrictId:idDistrict complete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                DCSubDistrictsInfo *pSubModel = (DCSubDistrictsInfo*)response;
                strongSelf.mSubDistrictList = pSubModel.mSubDistricstList;
                if ([strongSelf.mCurrentEditView isEqual:strongSelf.mSubDistrictView])
                {
                    [strongSelf.mSubDistrictView openKeyBoard];
                }
                
            }
            else
            {
                //TODO: error
            }
        }
        
    }];
}

-(void)getIdProvince
{
    if (!self.mStateView.mText)
        return;
    
    // update
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis getStateWithCode:self.mStateView.mText complete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        if (success)
        {
            DCStateInfo *pStateModel = (DCStateInfo*)response;
            if (pStateModel.mStateList.count)
            {
                thiz.mStateView.mId = ((DCItemNameId*)[pStateModel.mStateList firstObject]).mId;
            }
            
        }
        else
        {
            //TODO:
        }
    }];   
    
}

-(void)getIdDistrict
{
    if (!self.mDistrictView.mText)
        return;
    
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis getDistrictWithName:self.mDistrictView.mText complete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        if (success)
        {
            DCDistrictsInfo *pInfo = (DCDistrictsInfo*)response;
            thiz.mDistrictView.mId = ((DCItemNameId*)[pInfo.mDistrictsList firstObject]).mId;
        }
        else
        {
        
        }
    }];
}

-(void)updateProfile
{
    DCMyProfile *pMyProfile = [self createObjectToUpdate];
    NSDictionary *pParams = [pMyProfile jsonEditProfile];
    
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis updateProfileWithCmd:pParams complete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                // save update to app
                DCMyProfile *pPrf = APP_DELEGATE.mMyProfile;
                
                pPrf.mFirstName = strongSelf.mFirstNameView.mText;
                pPrf.mLastName = strongSelf.mLastNameView.mText;
                NSString *pPhoneDisplay = PHONE_NUMBER_FORMAT_IN_EDIT_PROFILE(strongSelf.mMobileNumberView.mText, strongSelf.mCountryView.mText);
                NSString *pPhoneNumberToSave = [pPhoneDisplay stringByReplacingOccurrencesOfString:@" " withString:@""];
                pPrf.mMobileNumber = pPhoneNumberToSave;
                pPrf.mStreetAddress = strongSelf.mStreetAddressView.mText;
                pPrf.mAddress2 = strongSelf.mAddress2View.mText;
                
                pPrf.mDistrict = strongSelf.mDistrictView.mText;
                pPrf.mIdDistrict = strongSelf.mDistrictView.mId;
                
                pPrf.mSubDistrict = strongSelf.mSubDistrictView.mText;
                pPrf.mIdSubDistrict = strongSelf.mSubDistrictView.mId;
                
                pPrf.mState = strongSelf.mStateView.mText;
                pPrf.mIdState = strongSelf.mStateView.mId;
                DLogInfo(@"%li", strongSelf.mStateView.mId);
                
                pPrf.mCountry = strongSelf.mCountryView.mText;
                pPrf.mIdCountry = strongSelf.mCountryView.mId;
                
                pPrf.mZipCode = strongSelf.mZipCodeView.mText;
                
                APP_DELEGATE.mMyProfile = pPrf;
                APP_DELEGATE.mMyProfile.mPhoneNumber = [NSString stringWithFormat:@"(%@) %@", CODE_MAP_FOR_COUNTRY(self.mCountryView.mText), APP_DELEGATE.mMyProfile.mPhoneNumber];
                [APP_DELEGATE.mMyProfile storeToFile];
                
                if (!strongSelf.mIsOpenOTP)
                {
                    [strongSelf showAlertUpdateSuccessful];
                }
                
                strongSelf.mIsOpenOTP = NO;
                [self fillProfile];
            }
            else
            {
                //TODO: error
            }
        }
    }];
}

-(void)showAlertUpdateSuccessful
{
    [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterIOS7Style new];
    [JCNotificationCenter
     enqueueNotificationWithTitle:nil
     message:NSLocalizedString(@"msg_update_profile_success", nil)
     tapHandler:^{
         
     }];
    
//    UIAlertView *pAlert = [UIAlertView alertViewtWithTitle:@""
//                                                   message:NSLocalizedString(@"msg_update_profile_success", nil)
//                                                  autoShow:NO
//                                                  callback:NULL
//                                         cancelButtonTitle:NSLocalizedString(@"str_ok", nil)
//                                         otherButtonTitles:nil];
//    
//    [pAlert show];

}

-(void)showAlertGetFailure
{
    UIAlertView *pAlert = [UIAlertView alertViewtWithTitle:@""
                                                   message:NSLocalizedString(@"msg_update_profile_fail", nil)
                                                  autoShow:NO
                                                  callback:NULL
                                         cancelButtonTitle:NSLocalizedString(@"str_ok", nil)
                                         otherButtonTitles:nil];
    
    [pAlert show];
    
}

#pragma mark - prepare submit helper
-(DCMyProfile*)createObjectToUpdate
{
    DCMyProfile *pMyProfile = [[DCMyProfile alloc] init];
    pMyProfile.mFirstName = self.mFirstNameView.mText;
    pMyProfile.mLastName = self.mLastNameView.mText;
    pMyProfile.mMobileNumber = self.mMobileNumberView.mText;
    pMyProfile.mStreetAddress = self.mStreetAddressView.mText;
    pMyProfile.mAddress2 = self.mAddress2View.mText;
    
    pMyProfile.mDistrict = self.mDistrictView.mText;
    pMyProfile.mIdDistrict = self.mDistrictView.mId;
    
    pMyProfile.mSubDistrict = self.mSubDistrictView.mText;
    pMyProfile.mIdSubDistrict = self.mSubDistrictView.mId;
    
    pMyProfile.mState = self.mStateView.mText;
    pMyProfile.mIdState = self.mStateView.mId;
    
    DLogInfo(@"%li", pMyProfile.mIdState);
    
    pMyProfile.mCountry = self.mCountryView.mText;
    pMyProfile.mIdCountry = self.mCountryView.mId;
    
    pMyProfile.mZipCode = self.mZipCodeView.mText;
    
    return pMyProfile;
}

#pragma mark - show sms alert
-(void)showSMSAlert
{
    /*
     * when open otp, wont show alert update successful
     */
    self.mIsOpenOTP = YES;
    
    ////////////////// DELETE IF HAS POP UP ///////////////
    if ([APP_DELEGATE.window viewWithTag:kTagAlertSmsCode])
    {
        DCSmsCodeAlert *pAlertSmsCodeView = (DCSmsCodeAlert*)[APP_DELEGATE.window viewWithTag:kTagAlertSmsCode];
        [pAlertSmsCodeView removeFromSuperview];
    }
    
    ///////////////// CREATE NEW ///////////////////////
    DCSmsCodeAlert *pSMSCodeAlertView = [[DCSmsCodeAlert alloc] initWithFrame:[UIScreen mainScreen].bounds];
    pSMSCodeAlertView.mIsEditProfile = YES;
    NSString *pStrMobileNumber = nil;
    if ([[self.mMobileNumberView.mText substringToIndex:1] isEqualToString:@"+"])
    {
        pStrMobileNumber = self.mMobileNumberView.mText;
    }
    else
    {
        pStrMobileNumber = [NSString stringWithFormat:@"(%@) %@", CODE_MAP_FOR_COUNTRY(self.mCountryView.mText), self.mMobileNumberView.mText];
    }
    
    [pSMSCodeAlertView setStringPhoneWithCode: pStrMobileNumber];
    pSMSCodeAlertView.tag = kTagAlertSmsCode;
    
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
            DLogInfo(@"...verify phone number");
            DCInputSmsCodeVC *pVC = [[DCInputSmsCodeVC alloc] initWithNibName:nil bundle:nil];
            pVC.mIsEditProfile = YES;
            [strongSelf updateProfile];
            
            [MAIN_NAVIGATION pushViewController:pVC animated:YES];
        }
    }];
    
    [APP_DELEGATE.window addSubview:pSMSCodeAlertView];
}

#pragma mark - Action callback
-(void)didSelectChatBtn:(id)sender
{
    [self.mSupportPhoneCmd removePopUp];
    if (IS_FA_APP) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
    [MAIN_NAVIGATION pushViewController:[DCChatViewController makeMeWithRoomID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomID roomJID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil] animated:YES];
    }

}

-(void)didSelectMenuBtn:(id)sender
{
    if (!self.mSupportPhoneCmd)
    {
        self.mSupportPhoneCmd = [[DCSupportPhoneModel alloc] init];
    }
    
    [self.mSupportPhoneCmd openSupportView];
}

-(void)didEditProfileBtn:(id)sender
{
    [self.mSupportPhoneCmd removePopUp];
    self.isEditProfile = !self.isEditProfile;
    
    if ( ![self.mLocationLabel.textColor isEqual:[self disableColor]])
    {
        self.mLocationLabel.textColor = [self disableColor];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
        for (DCShowInfoCellView *pView in self.mArrShowInfoView)
        {
            [pView editTxt:NO];
        }

    }
    else
    {
        for (DCShowInfoCellView *pView in self.mArrShowInfoView)
        {
            [pView editTxt:YES];
        }
        
        self.mLocationLabel.textColor = [UIColor blackColor];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];

    }
}

- (IBAction)clickSubmitBtn:(id)sender
{
    [self.view endEditing:YES];
    
    
    ///////// CHECK LENGHT ////////////
    // remove space to save and check
    NSString *pPhoneNumberToSave = [self.mMobileNumberView.mText stringByReplacingOccurrencesOfString:@" " withString:@""];
    APP_DELEGATE.mMyProfile.mMobileNumber = [APP_DELEGATE.mMyProfile.mMobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLogInfo(@"app delegate myProfile phone %@", APP_DELEGATE.mMyProfile.mMobileNumber);
    DCValidateEditProfileModel *pValidateModel = [[DCValidateEditProfileModel alloc] initWithFirstName:self.mFirstNameView.mText
                                                                                              lastName:self.mLastNameView.mText
                                                                                          mobileNumber:pPhoneNumberToSave
                                                                                               country:self.mCountryView.mText];
    
    if ([pValidateModel stringValidate].length)
    {
        UIAlertView *pAlert = [UIAlertView alertViewtWithTitle:@""
                                                       message:[pValidateModel stringValidate]
                                                      callback:NULL cancelButtonTitle:NSLocalizedString(@"str_ok", nil)
                                             otherButtonTitles:nil];
        
        [pAlert show];
        return;
    }
    
    //////////// CHECK MOBILE PHONE ////////////
    if (![pPhoneNumberToSave isEqualToString:APP_DELEGATE.mMyProfile.mMobileNumber])
    {
        DLogInfo(@"app delegate myProfile phone %@", APP_DELEGATE.mMyProfile.mMobileNumber);
        [self showSMSAlert];
        return;
    }
    
    
    ////////////// CHECK ID VALID ////////////////////
    if (![self isIdAddressValid])
    {
        NSMutableString *pStrAlert = [[NSMutableString alloc] initWithCapacity:200];
        if (!self.mStateView.mId)
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_province_not_found", nil)];
        }
        if (!self.mDistrictView.mId)
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_district_not_found", nil)];
        }
        if (!self.mSubDistrictView.mId)
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_subdistrict_not_found", nil)];
        }
        
        UIAlertView *pAlert = [UIAlertView alertViewtWithTitle: @""
                                                       message: pStrAlert
                                                      autoShow: NO
                                                      callback: NULL
                                             cancelButtonTitle: NSLocalizedString(@"str_ok", nil)
                                             otherButtonTitles: nil];
        [pAlert show];
        
        return;
    }
    
        
    ////////////// IF ALL FIELD OK //////////////////
    [self updateProfile];
}

- (IBAction)clickLogOutBtn:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"str_confirm_logout", nil) message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"str_logout", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [APP_DELEGATE logout];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"str_cancel",nil) style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)singleTapGestureCaptured:(UITapGestureRecognizer*)tapGes
{
    [self.view endEditing:YES];
    [self showSuggestionsTableview:NO];
    [UIView animateWithDuration:1.0f animations:^{
        self.mContainerScrollView.frame = CGRectMake(0, 0, self.mContainerScrollView.frame.size.width, self.mContainerScrollView.frame.size.height);
    }];
    
}

#pragma mark - update address from map callback
-(void)updateLocationCallback:(NSNotification*)notify
{
    //DLogInfo(@"notify %@", notify);
    DCMyProfile *pProfile = [notify valueForKey:@"object"];
    
    [self.mStreetAddressView setText:pProfile.mStreetAddress];
    [self.mAddress2View setText:pProfile.mAddress2];
    
    [self.mCountryView setText:pProfile.mCountry];
    
    [self.mStateView setText:pProfile.mState]; //province
    
    [self.mDistrictView setText:pProfile.mDistrict];
    [self.mSubDistrictView setText:pProfile.mSubDistrict];
    [self.mZipCodeView setText:pProfile.mZipCode];
    
    // reset all location id
    self.mStateView.mId = 0;
    self.mDistrictView.mId = 0;
    self.mSubDistrictView.mId = 0;
    
    //
    //[self getIdProvince];
    //[self getIdDistrict];
    
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    NSDictionary *pDictCountryCode = DICT_COUNTRY_CODE();
    NSString *pCodeCountry = pDictCountryCode[pProfile.mCountry] ? : @"";

    [DCApis getMapInfoWithZipId:pProfile.mZipCode andCountryCode:pCodeCountry complete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                DCMapInfo *pMapInfo = (DCMapInfo*)response;
                [strongSelf.mStateView setText:pMapInfo.mState.mName];
                strongSelf.mStateView.mId = pMapInfo.mState.mId;
                
                [strongSelf.mDistrictView setText:pMapInfo.mDistrict.mName];
                strongSelf.mDistrictView.mId = pMapInfo.mDistrict.mId;
                
                [strongSelf.mSubDistrictView setText:pMapInfo.mSubDistrict.mName];
                strongSelf.mSubDistrictView.mId = pMapInfo.mSubDistrict.mId;
            }
            else
            {
                //TODO: show error..
            }
        }
    }];
}

-(void)backFromOTPSupport:(NSNotification*)noti
{
    [self showAlertUpdateSuccessful];
    [MAIN_NAVIGATION popViewControllerAnimated:YES];
}

#pragma mark - keyboard event
-(void)keyboardWillShow:(NSNotification*)notify
{
    //DLogInfo(@"%@", notify);
    
    //////////// CACULATE KEYBOARD HEIGHT ////////////
    NSDictionary *pKeyboardInfo = [notify userInfo];
    
    DLogInfo("txt %@", self.mCurrentEditView.mText);
    
    if (!self.mHeightKeyBoard)
    {
        NSValue *pKeyboardFrameBegin = [pKeyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        self.mHeightKeyBoard = CGRectGetHeight( [pKeyboardFrameBegin CGRectValue]);
    }
    
    /////////////// ADD SEARCH VIEW ///////////
    [self addSuggestionsTableview];
    [self showSuggestionsTableview:NO];

    
    ////////////// SET POSITION VIEW //////////////
    CGFloat originY = CGRectGetMinY(self.mCurrentEditView.frame);
    NSTimeInterval duration = [[pKeyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    __weak typeof (self) thiz = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        thiz.mContainerScrollView.contentOffset = CGPointMake(0.0f, originY - kPaddingTopCell /* delta */);
    } completion:^(BOOL finished) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            [strongSelf showSuggestTableViewIfNeed];
        }
    }];
}

-(void)keyboardWillHide:(NSNotification*)notify
{
    // hide suggestTableView
    [self showSuggestionsTableview:NO];
    
    // anim hide keyboard
    NSDictionary *pKeyboardInfo = [notify userInfo];
    NSTimeInterval duration = [[pKeyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    __weak typeof (self) thiz = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        thiz.mContainerScrollView.contentOffset = CGPointMake(0.0f, 0.0f);
    } completion:NULL];
}

#pragma mark - Suggestions tableview
-(void)addSuggestionsTableview
{
    // create one time
    if (self.mSuggestionsView || !self.mHeightKeyBoard)
    {
        return;
    }
    
    CGFloat originY = CGRectGetMinY(self.mFirstNameView.frame);
    CGRect frame = CGRectMake(8.0f, originY + 10.0f, CGRectGetWidth(MAIN_SCREEN) - 16.0f, (self.mHeightKeyBoard - originY - 10.0f));
    self.mSuggestionsView = [[DCSuggestionsView alloc] initWithFrame:frame];
    self.mSuggestionsView.mMaxHeight = CGRectGetHeight(frame);
    self.mSuggestionsView.mDelegate = self;
    [self.view addSubview:self.mSuggestionsView];
}

-(void)showSuggestionsTableview:(BOOL)value
{
    self.mSuggestionsView.hidden = !value;
}


-(void)showSuggestTableViewIfNeed
{
    // for state/provices
    if ([self.mCurrentEditView isEqual:self.mStateView])
    {
        [self addDataForSuggestionsTableView:self.mProvincesList];
        [self showSuggestionsTableview:YES];
        return;
    }
    
    // for districts
    if ([self.mCurrentEditView isEqual:self.mDistrictView])
    {
        [self addDataForSuggestionsTableView:self.mDistrictList];
        [self showSuggestionsTableview:YES];
        return;
    }
    
    // for sub district
    if ([self.mCurrentEditView isEqual:self.mSubDistrictView])
    {
        [self addDataForSuggestionsTableView:self.mSubDistrictList];
        [self showSuggestionsTableview:YES];
        return;
    }
}

-(NSArray*)createListNameWithArrOfDCItemNameId:(NSArray*)datas
{
    if (!datas || ![[datas firstObject] isKindOfClass:[DCItemNameId class]])
    {
        return nil;
    }
    
    NSMutableArray *pArrData = [[NSMutableArray alloc] initWithCapacity:datas.count];
    for (DCItemNameId *pItem in datas)
    {
        [pArrData addObject:pItem.mName];
    }

    return pArrData;
}

-(void)addDataForSuggestionsTableView:(NSArray*)datas
{
    self.mSuggestionsView.mArrData = nil;
    self.mSuggestionsView.mArrData = [self createListNameWithArrOfDCItemNameId:datas];
}

#pragma mark - DCShowInfoCellView delegate
-(void)showInfoCellViewBeginEdit:(DCShowInfoCellView *)view
{
    self.mCurrentEditView = view;
    
    ///////////////////// COUNTRY CELL ///////////////////////
    if ([view isEqual:self.mCountryView])
    {
        [self showCountryPicker];
        return;
    }
    
    ////////////// PROVINCE //////////////////
    if ([view isEqual:self.mStateView])
    {
        [self prepareForState];
        return;
    }
    
    ////////////// DISTRICT //////////////////
    if ([self.mCurrentEditView isEqual:self.mDistrictView])
    {
        [self prepareForDistrict];
        return;
    }
    
    ////////////// SUB DISTRICT //////////////////
    if ([self.mCurrentEditView isEqual:self.mSubDistrictView])
    {
        [self prepareForSubDistrict];
        return;
    }

}

-(void)showInfoCellViewEndEdit:(DCShowInfoCellView *)view
{
    if ([self.mCurrentEditView isEqual:self.mStateView])
    {
        // update id for province
        DCCheckIdModel *pModel = [[DCCheckIdModel alloc] initWithNameAndIdList:self.mProvincesList];
        NSInteger idProvinces = [pModel idForName:self.mStateView.mText];
        self.mStateView.mId = idProvinces; // if idProvinces is not valid, use older state id
        
        // reset district, subdistrict if change state
        if (![[self.mStateView.mText lowercaseString] isEqualToString:[APP_DELEGATE.mMyProfile.mState lowercaseString]])
        {
            [self.mDistrictView setText:@""];
            [self.mSubDistrictView setText:@""];
            self.mDistrictView.mId = 0;
            self.mSubDistrictView.mId = 0;
        }
        
        self.mDistrictList = nil; // reset distric after change state
    }
    else if ([self.mCurrentEditView isEqual:self.mDistrictView])
    {
        // update id for district
        DCCheckIdModel *pModel = [[DCCheckIdModel alloc] initWithNameAndIdList:self.mDistrictList];
        NSInteger idDistrict = [pModel idForName:self.mDistrictView.mText];
        self.mDistrictView.mId = idDistrict;
        
        // reset subdistrict if change district
        if (![[self.mDistrictView.mText lowercaseString] isEqualToString:[APP_DELEGATE.mMyProfile.mDistrict lowercaseString]])
        {
            [self.mSubDistrictView setText:@""];
            self.mSubDistrictView.mId = 0;
        }
        
        self.mSubDistrictList = nil; // reset subdistric after chang district
    }
    else if ([self.mCurrentEditView isEqual:self.mSubDistrictView])
    {
        // update for subdistrict
        DCCheckIdModel *pModel = [[DCCheckIdModel alloc] initWithNameAndIdList:self.mSubDistrictList];
        NSInteger idSubDistrict = [pModel idForName:self.mSubDistrictView.mText];
        self.mSubDistrictView.mId = idSubDistrict;
    }
}

-(void)showInfoCellDidChange:(DCShowInfoCellView *)view
{
    if (!self.mSuggestionsView.hidden)
    {
        self.mSuggestionsView.mKeySearch = view.mText;
    }
}

#pragma mark - DCSuggestions tableview delegate
-(void)suggestionsView:(DCSuggestionsView *)view didSelectWord:(NSString *)key
{
    [self showSuggestionsTableview:NO];
    [self.mCurrentEditView setText:key];
    [self.view endEditing:YES];
}

#pragma mark - scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //DLogInfo(@"offset Y %f", scrollView.contentOffset.y);
    [self showSuggestionsTableview:NO];
//    [self scrollViewAdaptToEditCell:self.mCurrentEditView];
  
}

- (void)scrollViewAdaptToEditCell: (DCShowInfoCellView*)view {
    if ([view isEqual:self.mCountryView]) {
    CGRect frame = CGRectMake (0, self.mContainerScrollView.contentSize.height - IPHONE_KEYBOARD_PORTRAIT_HEIGHT - view.frame.origin.y + 50,self.mContainerScrollView.frame.size.width, self.mContainerScrollView.frame.size.height);
    
    [UIView animateWithDuration:1.0f animations:^{
        self.mContainerScrollView.frame = frame;
    }];
    
    
    
   
   }
}

#pragma mark - Edit profile helper
-(void)showCountryPicker
{
    DCCountryPicker *pCountryPickerView = [[DCCountryPicker alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    // click button select
    __weak typeof (self) thiz = self;
    [pCountryPickerView setSelectCountryEvent:^(NSString *selectCountry, NSString *codeMap) {
        __strong typeof(thiz) strongSelf = thiz;
        if (strongSelf)
        {
            [strongSelf.mCountryView setText:selectCountry];
            if (strongSelf.mCountryList)
            {
                for (DCItemNameId *pItem in self.mCountryList)
                {
                    if ([[pItem.mName lowercaseString]  isEqualToString:[selectCountry lowercaseString]])
                    {
                        strongSelf.mCountryView.mId = pItem.mId;
                    }
                }
                
                
            }
            DLogInfo(@"select country %@", selectCountry);
        }
    }];
    
    //1. set data for country picker first
    if (self.mCountryList)
    {
        NSMutableArray *pArrData = [[NSMutableArray alloc] initWithCapacity:self.mCountryList.count];
        NSMutableArray *pArrCountryCode = [[NSMutableArray alloc] initWithCapacity:self.mCountryList.count];
        for (DCItemNameId *pItem in self.mCountryList)
        {
            [pArrData addObject:pItem.mName];
            [pArrCountryCode addObject:pItem.mISOName];
        }
        
        pCountryPickerView.mArrDataCountry = [pArrData copy];
    }
    else
    {
        [pCountryPickerView getListCountryFromServer];
    }
    
    //2. after setting data for country picker
    pCountryPickerView.mStrSelectCountry = COUNTRY_NAME_WITH_CODE_MAP( self.mCountryView.mText);
    
    [APP_DELEGATE.window addSubview:pCountryPickerView];
    
    [self.view endEditing:YES];

}

-(void)prepareForState
{
    if ( ![self.mCurrentEditView isEqual:self.mStateView])
        return;
    
    // TODO: logic state, if choose many country (now only Thailand)
}

-(void)prepareForDistrict
{
    if ( ![self.mCurrentEditView isEqual:self.mDistrictView])
        return;
    
    // do not allow open keyboard before get list district
    self.mDistrictView.mIsEnableKeyBoard = NO;
    
    // update id for province
    DCCheckIdModel *pModel = [[DCCheckIdModel alloc] initWithNameAndIdList:self.mProvincesList];
    NSInteger idProvinces = [pModel idForName:self.mStateView.mText];
    self.mStateView.mId = idProvinces ? : self.mStateView.mId; // if idProvinces is not valid, use older state id
    
    if ( !self.mStateView.mId)
    {
        UIAlertView *pAlert = [UIAlertView alertViewtWithTitle:@"" message:NSLocalizedString(@"msg_province_id_invalid", nil) callback:^(UIAlertView *al, NSInteger idx) {
            [self.mDistrictView showPlaceHolder:YES];
        } cancelButtonTitle:NSLocalizedString(@"str_ok", nil) otherButtonTitles:nil];
        [pAlert show];
        
        // close keyboard
        self.mDistrictView.mIsEnableKeyBoard = NO;
        [self.view endEditing:YES];
    }
    else if (!self.mDistrictList)
    {
        [self getListDistrictWithIdProvince:self.mStateView.mId];
    }
    else
    {
        self.mDistrictView.mIsEnableKeyBoard = YES;
    }
}

-(void)prepareForSubDistrict
{
    if ( ![self.mCurrentEditView isEqual:self.mSubDistrictView])
        return;
    
    // do not allow open keyboard befor get list subdistrict
    self.mSubDistrictView.mIsEnableKeyBoard = NO;
    
    // update id for district
    DCCheckIdModel *pModel = [[DCCheckIdModel alloc] initWithNameAndIdList:self.mDistrictList];
    NSInteger idDistrict = [pModel idForName:self.mDistrictView.mText];
    self.mDistrictView.mId = idDistrict ? : self.mDistrictView.mId;
    
    
    if ( !self.mDistrictView.mId)
    {
        UIAlertView *pAlert = [UIAlertView alertViewtWithTitle:@"" message:NSLocalizedString(@"msg_district_id_invalid", nil) callback:^(UIAlertView *al, NSInteger idx) {
            [self.mSubDistrictView showPlaceHolder:YES];
        } cancelButtonTitle:NSLocalizedString(@"str_ok", nil) otherButtonTitles:nil];
        [pAlert show];
        
        // close keyboard
        self.mDistrictView.mIsEnableKeyBoard = NO;
        [self.view endEditing:YES];
    }
    else if( !self.mSubDistrictList)
    {
        [self getListSubDistrictWithIdDistrict:self.mDistrictView.mId];
    }
    else
    {
        self.mSubDistrictView.mIsEnableKeyBoard = YES;
    }
}

-(BOOL)isIdAddressValid
{
    if (self.mStateView.mText.length)
    {
        if (!self.mStateView.mId)
        {
            return NO;
        }
    }
    
    if (self.mDistrictView.mText.length)
    {
        if (!self.mDistrictView.mId)
        {
            return NO;
        }
    }

    if (self.mSubDistrictView.mText.length)
    {
        if (!self.mSubDistrictView.mId)
        {
            return NO;
        }
    }

    
    return YES;
}

#pragma mark - deinit
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.mSupportPhoneCmd)
    {
        [self.mSupportPhoneCmd removePopUp];
        self.mSupportPhoneCmd = nil;
    }
}

@end
