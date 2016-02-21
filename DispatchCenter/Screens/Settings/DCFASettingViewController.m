//
//  DCSettingViewController.m
//  DispatchCenter
//
//  Created by Phung Long on 11/3/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCFASettingViewController.h"
#import "DCChatViewController.h"
#import "DCSettingNotificationViewController.h"
#import "DCSettingPrivacyViewController.h"
#import "DCApis.h"
#import "DCSetting.h"

@interface DCFASettingViewController ()
@end

@implementation DCFASettingViewController


#pragma mark - init
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
    }
    return self;
}

#pragma mark - view life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]] leftOrRight:NO target:self actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
    [self.logoutButton setTitle:NSLocalizedString(@"str_logout", nil) forState:UIControlStateNormal];
    self.logoutButton.layer.borderWidth = 1.0f;
    self.logoutButton.layer.borderColor = kDCGlobalGrayColorBase.CGColor;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
    [self loadSettingStatus];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - api
- (void)loadSettingStatus
{
    // id = 0, load all list
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis getSettingStatuscomplete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        __strong typeof(thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                APP_DELEGATE.mySettings = (DCSetting*)response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf refreshNotificationStatus];
                });
            }
            else
            {
                //TODO: show error
            }
        }
    }];
}

- (void)refreshNotificationStatus {
    
    if (APP_DELEGATE.mySettings.notification) {
        self.notificationStatusLabel.text = NSLocalizedString(@"On",nil);
        self.notificationStatusLabel.textColor = kDCGlobalYellowColorBase;
    } else {
        self.notificationStatusLabel.text = NSLocalizedString(@"Off",nil);
        self.notificationStatusLabel.textColor = kDCGlobalGrayColorBase;
    }
    
    if (APP_DELEGATE.mySettings.privacy) {
        self.shareLocationStatusLabel.text = NSLocalizedString(@"On",nil);
        self.shareLocationStatusLabel.textColor = kDCGlobalYellowColorBase;
        
    } else {
        self.shareLocationStatusLabel.text = NSLocalizedString(@"Off",nil);
        self.shareLocationStatusLabel.textColor = kDCGlobalGrayColorBase;
    }
}


#pragma mark - Actions
- (void)didSelectChatBtn:(id)sender {
    if (IS_FA_APP) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        [MAIN_NAVIGATION pushViewController:[DCChatViewController makeMeWithRoomID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomID roomJID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil] animated:YES];
    }

}

- (void)didSelectMenuBtn:(id)sender {
    [DCDropDownMenuViewController showMe];
}


- (IBAction)logoutButtonClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Are you sure you want to logout?",nil) message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Log Out",nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [APP_DELEGATE logout];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)settingNotifications:(id)sender {
    [MAIN_NAVIGATION pushViewController:[[DCSettingNotificationViewController alloc] initWithNibName:@"DCSettingNotificationViewController" bundle:nil] animated:YES];
}

- (IBAction)settingLocation:(id)sender {
    [MAIN_NAVIGATION pushViewController:[[DCSettingPrivacyViewController alloc] initWithNibName:@"DCSettingPrivacyViewController" bundle:nil] animated:YES];
}

@end
