//
//  DCInputSmsCodeVC.m
//  DispatchCenter
//
//  Created by VietHQ on 10/8/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInputSmsCodeVC.h"
#import "DCSetPassWordVC.h"
#import "DCApis.h"
#import "DCThanksToRegViewController.h"

@interface DCInputSmsCodeVC ()

@property (weak, nonatomic) IBOutlet UILabel *mEnterVerificaitonLabel;
@property (weak, nonatomic) IBOutlet UITextField *mInputSmsCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *mContinueButton;
@property (weak, nonatomic) IBOutlet UILabel *mMissVerificationLabel;
@property (weak, nonatomic) IBOutlet UIButton *mResendCodeButton;

@end

@implementation DCInputSmsCodeVC

#pragma mark - init
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.mStrPhoneWithCode = @"";
    }
    
    return self;
}

#pragma mark - view life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    DLogInfo(@"userinfo :%@",APP_DELEGATE.loginInfo);
    NSLog(@"access token :%@",APP_DELEGATE.loginInfo.token);
    
    
    // enter verification label setting
    self.mEnterVerificaitonLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.mEnterVerificaitonLabel.numberOfLines = 0;
    self.mEnterVerificaitonLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"str_verification_code", nil), self.mStrPhoneWithCode];
    
    // input text field
    self.mInputSmsCodeTextField.secureTextEntry = YES;
    self.mInputSmsCodeTextField.textAlignment = NSTextAlignmentCenter;
    self.mInputSmsCodeTextField.font = [UIFont systemFontOfSize:20];
    self.mInputSmsCodeTextField.keyboardType = UIKeyboardTypeNumberPad;

    // continue btn
    self.mContinueButton.backgroundColor = [UIColor yellowButton];
    self.mContinueButton.layer.cornerRadius = 2.0f;
    self.mContinueButton.clipsToBounds = YES;
    
    // resend btn
    self.mResendCodeButton.backgroundColor = [UIColor lightYellowButton];
    
    // tap event for close keyboard
    UITapGestureRecognizer *pCloseKeyBoardTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(tapForCloseKeyboardCallback)];
    [self.view addGestureRecognizer:pCloseKeyBoardTap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mInputSmsCodeTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - action callback
- (IBAction)clickContinueBtnCallback:(id)sender
{
    __weak typeof (self) thiz = self;
    [LoadingViewHelper showLoadingWithText:NLS(@"Processing...")];
    [DCApis vertifyOtp:self.mInputSmsCodeTextField.text complete:^(BOOL success, ServerObjectBase *response) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                if (self.loginMode == DCLoginModeNormal) {
                    if (!strongSelf.mIsEditProfile) //if not from Edit profile flow, it means from Change password flow ??
                    {
                        APP_DELEGATE.loginInfo.userStatus = DCUserStatusVerifiedPhone;
                        [APP_DELEGATE.loginInfo storeToFile];
                        
                        DCSetPassWordVC *pVC = [[DCSetPassWordVC alloc] initWithNibName:nil bundle:nil];
                        [strongSelf.navigationController pushViewController:pVC animated:YES];
                    }
                    else
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:DC_NOTI_OTP_SUPPORT object:nil];
                    }
                } else {
                    
                    APP_DELEGATE.loginInfo.userStatus = DCUserStatusVerifed;
                    [APP_DELEGATE.loginInfo storeToFile];
                    if (IS_FA_APP)
                    {
                        [APP_DELEGATE didLoginWithInfo:APP_DELEGATE.loginInfo afterSignup:YES];
                    }
                    else
                    {
                        DCThanksToRegViewController *pVC = [[DCThanksToRegViewController alloc] initWithNibName:nil bundle:nil];
                        [MAIN_NAVIGATION pushViewController:pVC animated:YES];
                    }
                    
                    // save profile
                    APP_DELEGATE.mMyProfile.mStatus = DCMyProfileStatusVerify;
                    [APP_DELEGATE.mMyProfile storeToFile];

                }
                
            }
            else
            {
                //TODO: error
            }

        }
        
        [LoadingViewHelper hideLoading];
    }];
}

- (IBAction)clickResendBtnCallback:(id)sender
{
    
}

-(void)tapForCloseKeyboardCallback
{
    [self.view endEditing:YES];
}

@end
