//
//  DCSupportPhoneModel.m
//  DispatchCenter
//
//  Created by VietHQ on 10/10/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCSupportPhoneModel.h"
#import "DCPopupSupportPhoneView.h"
#import "DCContactSupportVC.h"
#import "DCMobileSupportViewController.h"

@interface DCSupportPhoneModel()

@property( nonatomic, strong) DCPopupSupportPhoneView *mPopUpView;

@end

@implementation DCSupportPhoneModel

-(void)openSupportView
{
    self.mPopUpView ? [self removePopUp] : [self showPopup];
}

-(void)removePopUp
{
    [self.mPopUpView removeFromSuperview];
    self.mPopUpView = nil;
}

-(void)showPopup
{
    CGRect s = [UIScreen mainScreen].bounds;
    self.mPopUpView = [[DCPopupSupportPhoneView alloc] initWithFrame:CGRectMake(CGRectGetWidth(s) - 170.0f, 60.0f, 150.0f, 40.0f)];
    self.mPopUpView.backgroundColor = [UIColor whiteColor];
    self.mPopUpView.layer.cornerRadius = 2.0f;
    [APP_DELEGATE.window addSubview:self.mPopUpView];
    
    // add gesture
    UITapGestureRecognizer *pOpenContactSupportView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openContactSupportView)];
    
    [self.mPopUpView addGestureRecognizer:pOpenContactSupportView];

}

-(void)openContactSupportView
{
    DCMobileSupportViewController *pVC = [[DCMobileSupportViewController alloc] initWithNibName:nil bundle:nil];
    [MAIN_NAVIGATION pushViewController:pVC animated:YES];
    
    [self removePopUp];
}

-(void)dealloc
{
    [self.mPopUpView removeFromSuperview];
    self.mPopUpView = nil;
}

@end
