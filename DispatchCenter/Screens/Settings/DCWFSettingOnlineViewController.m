//
//  DCWFSettingOnlineViewController.m
//  DispatchCenter
//
//  Created by Phung Long on 11/5/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCWFSettingOnlineViewController.h"
#import "DCChatViewController.h"
#import "DCApis.h"

@interface DCWFSettingOnlineViewController ()

@end

@implementation DCWFSettingOnlineViewController

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
    [_onlineSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
    [self refreshOnlineStatus];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshOnlineStatus {
    if (APP_DELEGATE.mySettings.online != NO) {
        [_onlineSwitch setOn:YES animated:YES];
    } else {
        [_onlineSwitch setOn:NO animated:YES];
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

- (void)setState:(UISwitch *)sender
{
    BOOL state = [sender isOn];
    [self updateSettingStatusWithOnlineStatus:state];
}


- (void)updateSettingStatusWithOnlineStatus:(BOOL)onlineStatus {
    
    NSMutableDictionary *settingStatus = [NSMutableDictionary new];
    if (APP_DELEGATE.mySettings.notification == YES) {
        [settingStatus setObject:@"enable" forKey:@"notification"];
    } else {
        [settingStatus setObject:@"disable" forKey:@"notification"];
    }
    NSMutableDictionary *privacy = [NSMutableDictionary new];
    if (APP_DELEGATE.mySettings.privacy == YES) {
        [privacy setObject:@"enable" forKey:@"share_location"];
    } else {
        [privacy setObject:@"disable" forKey:@"share_location"];
    }
    [settingStatus setObject:privacy forKey:@"privacy"];
    
    if (onlineStatus == YES) {
        [settingStatus setObject:@"enable" forKey:@"online"];
    } else {
        [settingStatus setObject:@"disable" forKey:@"online"];
    }
    __weak typeof (self) thiz = self;
    
    [DCApis updateSettingStatus:settingStatus complete:^(BOOL success, ServerObjectBase *response) {
        __strong typeof(thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (!success)
            {
                [_onlineSwitch setOn:!onlineStatus animated:YES];

            } else {
                APP_DELEGATE.mySettings.online = [_onlineSwitch isOn];
            }

        }
    }];
}

@end
