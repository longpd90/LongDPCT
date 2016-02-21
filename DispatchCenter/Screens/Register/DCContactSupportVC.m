//
//  DCContactSupportVC.m
//  DispatchCenter
//
//  Created by VietHQ on 10/10/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCContactSupportVC.h"
#import "DCApis.h"
#import "DCMobileSupportViewController.h"

@interface DCContactSupportVC ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mContactSupportLabel;
@property (weak, nonatomic) IBOutlet UITextField *mInuputTextField;
@property (weak, nonatomic) IBOutlet UITextView *mInputTextView;
@property (weak, nonatomic) IBOutlet UIButton *mContinueButton;
@property (weak, nonatomic) IBOutlet UIView *mLine;
@property (strong, nonatomic) NSString *mStrPlaceHolder;


@end

@implementation DCContactSupportVC

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.mStrPlaceHolder = NSLocalizedString(@"str_contact_support_describe", nil);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MAIN_NAVIGATION.navigationBar.translucent = NO;
    self.mContinueButton.backgroundColor = [UIColor yellowButton];
    [self.mContinueButton setTitle:NSLocalizedString(@"str_submit", nil) forState:UIControlStateNormal];
    
    self.mInputTextView.text = self.mStrPlaceHolder;
    self.mInputTextView.textColor = [UIColor colorTextContent];
    self.mInputTextView.delegate = self;
    
    
    CGRect frameContactSupportLbl = self.mContactSupportLabel.frame;
    UIView *pBottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(frameContactSupportLbl),CGRectGetWidth(frameContactSupportLbl), 3.0f)];
    pBottomBorder.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pBottomBorder.backgroundColor = [UIColor yellowButton];
    
    [self.mContactSupportLabel addSubview:pBottomBorder];
    //DLogInfo(@" ===> phone number %@", self.mPhoneNumber);
    if (self.viewType == kViewTypeContactUs) {
        self.mContactSupportLabel.text = NSLocalizedString(@"Contact Us",nil);
        [self.mContinueButton setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    } else if (self.viewType == kViewTypeContactSupport) {
        self.mContactSupportLabel.text = NSLocalizedString(@"Contact Support", nil);
    }
}

#pragma mark - Insert vc
-(BOOL)insertVC
{
    NSArray *pArrVC = MAIN_NAVIGATION.viewControllers;
    UIViewController *pBeforeLastVC = [pArrVC objectAtIndex:pArrVC.count - 2];
    if ([pBeforeLastVC isKindOfClass:[DCMobileSupportViewController class]])
    {
        DCContactSupportVC *pVC = [[DCContactSupportVC alloc] initWithNibName:nil bundle:nil];
        NSMutableArray *pNewArrVC = [[NSMutableArray alloc] initWithCapacity:pArrVC.count+1];
        [pNewArrVC addObjectsFromArray:pArrVC];
        [pNewArrVC insertObject:pVC atIndex:pArrVC.count - 1];
        
        MAIN_NAVIGATION.viewControllers = pNewArrVC;
        
        return YES;
    }
    
    return NO;
}

#pragma mark - continue button
- (IBAction)clickContinueCallback:(id)sender
{
    [self.view endEditing:YES];
    
    
    self.mInputTextView.text = [self.mInputTextView.text isEqualToString:self.mStrPlaceHolder] ? @"" : self.mInputTextView.text;
    
    //check blank text field
    NSString *pStrSend = [self.mInputTextView text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [pStrSend stringByTrimmingCharactersInSet:whitespace];
    
    
    if ( [trimmed length] == 0 || [pStrSend isEqualToString:@""] || [pStrSend isEqualToString:@"Please describe your problem" ])
    {
        [UIAlertView alertViewtWithTitle:@"" message:NSLocalizedString(@"msg_contact_support_problem", nil) callback:NULL cancelButtonTitle:NSLocalizedString(@"str_ok", nil) otherButtonTitles: nil];
    }
    else
    {
        [self createDataToSend];
        SHOW_LOADING;
        __weak typeof (self) thiz = self;
        [DCApis sendProblemToContactSupport:pStrSend phoneNumber:self.mPhoneNumber complete:^(BOOL success, ServerObjectBase *response) {
            HIDE_LOADING;
            __strong typeof(thiz) strongSelf = thiz;
            if (strongSelf)
            {
                if (success)
                {
                    [strongSelf insertVC];
                    
                    [strongSelf resetDataToSend];
                    strongSelf.mInputTextView.hidden = YES;
                    strongSelf.mContinueButton.hidden = YES;
                    strongSelf.mLine.hidden = YES;
                    
                    UILabel *pSuccessLabel = [[UILabel alloc] initWithFrame:(CGRect){strongSelf.mInputTextView.frame.origin, CGSizeZero}];
                    pSuccessLabel.font = [UIFont normalFont];
                    pSuccessLabel.numberOfLines = 0;
                    pSuccessLabel.text = NSLocalizedString(@"msg_support_ok", nil);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.view addSubview:pSuccessLabel];
                        [pSuccessLabel sizeToFit];
                    });
                }
                else
                {
                    
                }
            }
        }];
    }
    
}

#pragma mark - Textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:self.mStrPlaceHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

#pragma mark textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.mInputTextView.text isEqualToString:self.mStrPlaceHolder])
    {
        self.mInputTextView.text = @"";
    }
    
    self.mInputTextView.textColor = [UIColor blackColor];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!self.mInuputTextField.text.length)
    {
        self.mInuputTextField.text = self.mStrPlaceHolder;
        self.mInuputTextField.textColor = [UIColor colorTextContent]; //defaul color
    }
    else
    {
        self.mInuputTextField.textColor = [UIColor blackColor];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.mInuputTextField resignFirstResponder];
    
    return YES;
}

#pragma mark - create data to send
-(void)createDataToSend
{
    NSUserDefaults *pDefaul = [NSUserDefaults standardUserDefaults];
    [pDefaul safeSetObject:self.mPhoneNumber forKey:USER_KEY_PHONE_SAVE];
    [pDefaul safeSetValue:@(self.mIdCountry) forKey:USER_KEY_ID_COUNTRY];
    [pDefaul safeSetObject:self.mStrCountryName forKey:USER_KEY_COUNTRY_NAME];
}

-(void)resetDataToSend
{
    NSUserDefaults *pDefaul = [NSUserDefaults standardUserDefaults];
    [pDefaul removeObjectForKey:USER_KEY_PHONE_SAVE];
    [pDefaul removeObjectForKey:USER_KEY_ID_COUNTRY];
    [pDefaul removeObjectForKey:USER_KEY_COUNTRY_NAME];
    [pDefaul synchronize];
}

@end
