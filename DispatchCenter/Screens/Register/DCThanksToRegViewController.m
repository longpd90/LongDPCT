//
//  DCThanksToRegViewController.m
//  DispatchCenter
//
//  Created by VietHQ on 11/4/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCThanksToRegViewController.h"

@interface DCThanksToRegViewController ()




@end

@implementation DCThanksToRegViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.mode == DCThanksRegist) {
        self.mTitleLabel.text = NSLocalizedString(@"str_title_thanks_vc", nil);
        self.mStatutsLabel.text = NSLocalizedString(@"str_thanks_status", nil);

    } else {
        self.mTitleLabel.text = NSLocalizedString(@"Thank you", nil);
        self.mStatutsLabel.text = NSLocalizedString(@"Your payment has been processed \nThank you for your payment. Your transaction has been completed, and a receipt for your purchase has been emailed to you. Our accounts department has been advised", nil);
        self.mTaskListButton.hidden = YES;
    }
    self.mTitleLabel.backgroundColor = [UIColor backgroundNavRegVC];
    
    self.mStatutsLabel.numberOfLines = 0;
    [self.mStatutsLabel sizeToFit];
    
    self.mTaskListButton.backgroundColor = [UIColor yellowButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
}

- (IBAction)clickTaskListBtn:(id)sender
{
    [APP_DELEGATE didLoginWithInfo:APP_DELEGATE.loginInfo afterSignup:YES];
}


@end
