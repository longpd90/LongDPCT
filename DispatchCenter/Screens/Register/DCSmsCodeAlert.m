//
//  DCSmsCodeAlert.m
//  DispatchCenter
//
//  Created by VietHQ on 10/8/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCSmsCodeAlert.h"

@interface DCSmsCodeAlert ()

@property (strong, nonatomic) IBOutlet UIView *mContainerView;
@property (weak, nonatomic) IBOutlet UIView *mAlertContainer;
@property (weak, nonatomic) IBOutlet UILabel *mPhoneWithCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mConfirmLabel;
@property (weak, nonatomic) IBOutlet UIButton *mCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *mOkButton;
@property (weak, nonatomic) IBOutlet UIImageView *mPhoneImageView;


@end

@implementation DCSmsCodeAlert

#pragma mark - init func
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

-(void)commonInit
{
    //
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // create container
    self.mContainerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    self.mContainerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self addSubview:self.mContainerView];
    
    //
    self.mAlertContainer.layer.cornerRadius = 4.0f;
    
    //
    self.mPhoneWithCodeLabel.backgroundColor = [UIColor bgSMSCode];
    
    //
    self.mCancelButton.backgroundColor = [UIColor yellowButton];
    self.mOkButton.backgroundColor = [UIColor yellowButton];
    
    //
    self.mConfirmLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.mConfirmLabel.numberOfLines = 0;
    self.mConfirmLabel.textColor = [UIColor grayColor];
    self.mConfirmLabel.text = NSLocalizedString(@"str_sms_code_vertify", nil);
    
    //
    self.mPhoneImageView.image = [UIImage imageNamed:@"ic_register_sms"];
    self.mPhoneImageView.contentMode = UIViewContentModeScaleAspectFit;
    
   
}

#pragma mark - layout
-(void)layoutSubviews
{
    DLogInfo(@"userinfo :%@",APP_DELEGATE.loginInfo);
    NSLog(@"access token :%@",APP_DELEGATE.loginInfo.token);
    self.mContainerView.frame = [UIScreen mainScreen].bounds;
    self.mAlertContainer.center = CGPointMake( CGRectGetWidth(self.mContainerView.frame)*0.5f, self.mAlertContainer.center.y);
}

-(void)setStringPhoneWithCode:(NSString *)str
{
    self.mPhoneWithCodeLabel.text = str;
}

#pragma mark - action callback
- (IBAction)clickCancelBtnCallback:(id)sender
{
    if (self.cancelBtnClick)
    {
        self.cancelBtnClick(self);
    }
}

- (IBAction)clickOKCallback:(id)sender
{
    if (self.OkBtnClick)
    {
        self.OkBtnClick(self);
    }
}

#pragma mark - deinit
-(void)dealloc
{
    DLogInfo(@"deinit alert sms");
}


@end
