//
//  DCMobileSupportViewController.m
//  DispatchCenter
//
//  Created by VietHQ on 11/2/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCMobileSupportViewController.h"
#import "DCEditTextCell.h"
#import "DCPhoneModel.h"
#import "DCCountryPicker.h"
#import "DCContactSupportVC.h"
#import "DCListCountryInfo.h"

static NSString* const kDefaultCountryField = @"Thailand";
static NSString* const kDefaultCodeMap =@"+66"; // Thailand


@interface DCMobileSupportViewController ()<DCEditTextCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mContactSupportLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mCountryCellView;
@property (weak, nonatomic) IBOutlet DCEditTextCell *mMobileNumberCellView;
@property (weak, nonatomic) IBOutlet UIButton *mContinueButton;
@property (strong, nonatomic) NSString *mCurrentCodeMap;
@property (strong, nonatomic) NSString *mCurrentCountry;
@property (assign, nonatomic) NSUInteger mCurrentIdCountry;
@property (strong, nonatomic) NSArray *mListCountrySupport;

@end

@implementation DCMobileSupportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    self.mCurrentCodeMap = kDefaultCodeMap;
    self.mCurrentCountry = kDefaultCountryField;
    self.mCurrentIdCountry = 0;
    
    
    //
    CGRect frameContactSupportLbl = self.mContactSupportLabel.frame;
    UIView *pBottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(frameContactSupportLbl),CGRectGetWidth(frameContactSupportLbl), 3.0f)];
    pBottomBorder.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pBottomBorder.backgroundColor = [UIColor yellowButton];
    
    [self.mContactSupportLabel addSubview:pBottomBorder];
    
    
    
    //
    self.mTitleLabel.text = NSLocalizedString(@"str_confirm_country_phone", nil);
    self.mTitleLabel.numberOfLines = 0;
    
    
    
    //
    self.mCountryCellView.mTitle.text = NSLocalizedString(@"str_country", nil);
    self.mCountryCellView.mDelegate = self;
    self.mCountryCellView.mIsEnableKeyBoard = NO;
    [self.mCountryCellView showThreeDot:YES];
    [self.mCountryCellView setTextContent:COUNTRY_NAME_WITH_CODE_MAP(kDefaultCountryField)];
    
    
    //
    self.mMobileNumberCellView.mTitle.text = NSLocalizedString(@"str_phone", nil);
    self.mMobileNumberCellView.mStrPlaceHolder = NSLocalizedString(@"str_phone_number", nil);
    self.mMobileNumberCellView.mDelegate = self;
    
    
    
    //
    self.mContinueButton.layer.cornerRadius = 2.0f;
    self.mContinueButton.clipsToBounds = YES;
    self.mContinueButton.backgroundColor = [UIColor yellowButton];
}

#pragma mark - DCEditTextCell Delegate
-(void)editTextCellbeginEditText:(DCEditTextCell *)cell
{
    ///////////////////// COUNTRY CELL ///////////////////////
    if ([cell isEqual:self.mCountryCellView])
    {
        DCCountryPicker *pCountryPickerView = [[DCCountryPicker alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        
        // click button select
        __weak typeof (self) thiz = self;
        __block DCCountryPicker *countryPicker = pCountryPickerView;
        [pCountryPickerView setSelectCountryEvent:^(NSString *selectCountry, NSString *codeMap) {
            __strong typeof(thiz) strongSelf = thiz;
            if (strongSelf)
            {
                [strongSelf.mCountryCellView setTextContent:COUNTRY_NAME_WITH_CODE_MAP(selectCountry)];
                strongSelf.mCurrentCodeMap = codeMap;
                strongSelf.mCurrentCountry = selectCountry;
                DLogInfo(@"%@", countryPicker.mCountryWithIdList);
                
                for (DCItemNameId *pItem in countryPicker.mCountryWithIdList)
                {
                    if ([pItem.mName isEqualToString:selectCountry])
                    {
                        strongSelf.mCurrentIdCountry = pItem.mId;
                    }
                }
                
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
    if ([cell isEqual:self.mMobileNumberCellView])
    {
        [self.mMobileNumberCellView setKeyboardType:UIKeyboardTypePhonePad];
        return;
    }
}

-(void)editTextCellEndEditText:(DCEditTextCell *)cell
{

}

#pragma mark - Action callback
- (IBAction)clickContinueCallback:(id)sender
{
    [self.view endEditing:YES];
    if (!self.mMobileNumberCellView.mStrContent.length)
    {
        [UIAlertView alertViewtWithTitle:@""
                                 message:NSLocalizedString( @"msg_input_phone_number", nil)
                                callback:NULL
                       cancelButtonTitle:NSLocalizedString( @"str_ok", nil)
                       otherButtonTitles: nil];
        
        return;
    }
    
    DCContactSupportVC *pVC = [[DCContactSupportVC alloc] initWithNibName:nil bundle:nil];
    NSString *pPhoneNumber = [NSString stringWithFormat:@"(%@)%@", self.mCurrentCodeMap, self.mMobileNumberCellView.mStrContent];
    pVC.mPhoneNumber = pPhoneNumber;
    pVC.mStrCountryName = self.mCurrentCountry;
    pVC.mIdCountry = self.mCurrentIdCountry;
    
    //DLogInfo(@"%@ %li", self.mCurrentCountry, self.mCurrentIdCountry);
    
    [MAIN_NAVIGATION pushViewController:pVC animated:YES];
}


@end
