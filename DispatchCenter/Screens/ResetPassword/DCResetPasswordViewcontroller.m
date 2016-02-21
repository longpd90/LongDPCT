//
//  DCResetPasswordViewcontroller.m
//  DispatchCenter
//
//  Created by VietHQ on 10/19/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCResetPasswordViewcontroller.h"
#import "DCEditTextCell.h"
#import "DCPhoneModel.h"
#import "DCApis.h"
#import "DCSmsCodeAlert.h"
#import "DCInputSmsCodeVC.h"
#import "DCListCountryInfo.h"
#import "DCSmsCodeAlert.h"

#import "DCCountryPicker.h"
static NSInteger const kTagAlertSmsCode = 100;
static NSString* const kDefaultCountryField = @"Thailand";
static NSString* const kDefaultCodeMap =@"+66"; // Thailand

@interface DCResetPasswordViewcontroller ()<DCEditTextCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mIntroLabel;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mCountryCellView;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mPhoneCellView;
@property (weak, nonatomic) IBOutlet UIButton *mContinueButton;

@property (strong, nonatomic) NSArray *mListCountrySupport;
@property (strong, nonatomic) NSString *mCurrentCodeMap;
@property (strong, nonatomic) NSString *mCurrentCountry;

@end

@implementation DCResetPasswordViewcontroller

#pragma mark - init
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.mCurrentCodeMap = kDefaultCodeMap;
        self.mCurrentCountry = kDefaultCountryField;
    }
    
    return self;
}

#pragma mark - View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    

    NSLog(@"array of view controller %@ \n",self.navigationController.viewControllers);
    
    ///////////// SETTING UI ////////////////
    self.mTitleLabel.backgroundColor = [UIColor backgroundNavRegVC];
    self.mTitleLabel.text = NSLocalizedString(@"str_reset_pass", nil);
    
    self.mIntroLabel.numberOfLines = 0;
    self.mIntroLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.mIntroLabel.text = NSLocalizedString(@"str_reset_intro", nil);
    
    self.mCountryCellView.mTitle.text = NSLocalizedString(@"str_country", nil);
    self.mCountryCellView.mDelegate = self;
    self.mCountryCellView.mIsEnableKeyBoard = NO;
    [self.mCountryCellView setTextContent:COUNTRY_NAME_WITH_CODE_MAP(kDefaultCountryField)];

    
    
    self.mPhoneCellView.mTitle.text = NSLocalizedString(@"str_phone", nil);
    self.mPhoneCellView.mStrPlaceHolder = NSLocalizedString(@"str_phone_number", nil);
    self.mPhoneCellView.mDelegate = self;

    
    self.mContinueButton.backgroundColor = [UIColor yellowButton];
    self.mContinueButton.layer.cornerRadius = 2.0f;
    self.mContinueButton.clipsToBounds = YES;
    
    ///////////// GET LIST COUNTRY FOR COUNTRY CELL ////////////
    [self getListCountry];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
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


#pragma mark - Action callback
- (IBAction)clickContinueButton:(id)sender
{
    NSLog(@"Continue \n");
    [self showAlertConfirmSmsCode];
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
//    [pSMSCodeAlertView setStringPhoneWithCode: [NSString stringWithFormat:@"(%@) %@", self.mCurrentCodeMap, self.mPhoneCell.mStrContent]];
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
            DCInputSmsCodeVC *pInputVC = [[DCInputSmsCodeVC alloc] initWithNibName:nil bundle:nil];
//            pInputVC.mStrPhoneWithCode = [NSString stringWithFormat:@"(%@) %@", strongSelf.mCurrentCodeMap, strongSelf.mPhoneCell.mStrContent];
            [strongSelf.navigationController pushViewController:pInputVC animated:YES];
        }
    }];
    
    [self.view endEditing:YES];
    [APP_DELEGATE.window addSubview:pSMSCodeAlertView];
}


#pragma mark - edit text cell delegate
- (void)editTextCellbeginEditText:(DCEditTextCell *)cell
{
    ///////////////////// COUNTRY CELL ///////////////////////
    if ([cell isEqual:self.mCountryCellView])
    {
        DCCountryPicker *pCountryPickerView = [[DCCountryPicker alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        
        // click button select
        __weak typeof (self) thiz = self;
        [pCountryPickerView setSelectCountryEvent:^(NSString *selectCountry, NSString *codeMap) {
            __strong typeof(thiz) strongSelf = thiz;
            if (strongSelf)
            {
                [strongSelf.mCountryCellView setTextContent:COUNTRY_NAME_WITH_CODE_MAP(selectCountry)];
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
        pCountryPickerView.mStrSelectCountry = self.mCountryCellView.mStrContent;
        
        [APP_DELEGATE.window addSubview:pCountryPickerView];
        
        [self.view endEditing:YES];
        
        return;
    }
    
    ////////////////////// PHONE CELL //////////////////////
    if ([cell isEqual:self.mPhoneCellView])
    {
        [self.mPhoneCellView setKeyboardType:UIKeyboardTypePhonePad];
        return;
    }
}

- (void)editTextCellEndEditText:(DCEditTextCell *)cell
{
    
}

@end
