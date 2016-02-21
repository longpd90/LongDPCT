//
//  DCSetPassWordVC.m
//  DispatchCenter
//
//  Created by VietHQ on 10/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCSetPassWordVC.h"
#import "DCEditTextCell.h"
#import "DCApis.h"
#import "DCMyProfile.h"
#import "DCThanksToRegViewController.h"

static CGFloat const kWidthTitle = 150.0f;

@interface DCSetPassWordVC ()

@property (weak, nonatomic) IBOutlet UILabel *mTitleViewLabel;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mInputPasswordCellView;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mReInputPasswordCellView;
@property (weak, nonatomic) IBOutlet UIButton *mContinueButton;


@end

@implementation DCSetPassWordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.mTitleViewLabel.text = NSLocalizedString(@"str_set_your_password", nil);
    self.mTitleViewLabel.backgroundColor = [UIColor backgroundNavRegVC];
    
    self.mInputPasswordCellView.mTitle.text = NSLocalizedString(@"str_password", nil);
    [self.mInputPasswordCellView setWidthTitle: kWidthTitle];
    [self.mInputPasswordCellView setSecureText:YES];
    [self.mInputPasswordCellView setMStrPlaceHolder:@"****"];
    NSLog(@"text field content === %@ \n",self.mInputPasswordCellView.mTxtField.text);
    
    
    self.mReInputPasswordCellView.mTitle.text = NSLocalizedString(@"str_confirm_password", nil);
    [self.mReInputPasswordCellView setWidthTitle: kWidthTitle];
    [self.mReInputPasswordCellView setSecureText:YES];
    [self.mReInputPasswordCellView setMStrPlaceHolder:@"****"];
     NSLog(@"text field re content === %@ \n",self.mReInputPasswordCellView.mTxtField.text);
    
    
    self.mContinueButton.backgroundColor = [UIColor yellowButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
}

- (IBAction)clickContinueBtnCallback:(id)sender
{
    if ([self.mInputPasswordCellView.mStrContent isEqualToString:self.mReInputPasswordCellView.mStrContent])
    {
        DCMyProfile *pProfile = APP_DELEGATE.mMyProfile;
        NSDictionary *pParams = @{ API_PR_UPD_PROFILE_FIST_NAME : pProfile.mFirstName ? : @"",
                                   API_PR_UPD_PROFILE_LAST_NAME : pProfile.mLastName ? : @"",
                                   API_PR_UPD_PROFILE_PASS :  self.mInputPasswordCellView.mStrContent ? : @""};
        [LoadingViewHelper showLoadingWithText:NLS(@"Processing...")];
        [DCApis updateProfileWithCmd:pParams complete:^(BOOL success, ServerObjectBase *response) {
            if (success)
            {
                [DCApis getUserProfileComplete:^(BOOL success, ServerObjectBase *response) {
                    if (success) {
                        DCMyProfile *prf = (DCMyProfile*)response;
                        prf.mStatus = DCMyProfileStatusVerify;
                        
                        APP_DELEGATE.loginInfo.userInfo = prf;
                        APP_DELEGATE.loginInfo.userStatus = DCUserStatusVerifed;
                        [APP_DELEGATE.loginInfo storeToFile];
                        NSLog(@"Appdelegate login info === %@ \n",APP_DELEGATE.loginInfo);
                        if (IS_FA_APP)
                        {
                            [APP_DELEGATE didLoginWithInfo:[DCLoginInfo readSaved] afterSignup:YES];
                        }
                        else
                        {
                            DCThanksToRegViewController *pVC = [[DCThanksToRegViewController alloc] initWithNibName:nil bundle:nil];
                            [MAIN_NAVIGATION pushViewController:pVC animated:YES];
                        }
                        
                        // save profile
                        APP_DELEGATE.mMyProfile = prf;
                        [APP_DELEGATE.mMyProfile storeToFile];
                    }
                    [LoadingViewHelper hideLoading];
                }];
            }
            else
            {
                [LoadingViewHelper hideLoading];
            
            }
        }];
    }
    else
    {
        [UIAlertView alertViewtWithTitle:@"" message:NSLocalizedString(@"msg_password_not_equals", nil) callback:^(UIAlertView *al, NSInteger idx) {
            //
        } cancelButtonTitle:NSLocalizedString(@"str_ok", nil) otherButtonTitles: nil];
    }
}

@end
