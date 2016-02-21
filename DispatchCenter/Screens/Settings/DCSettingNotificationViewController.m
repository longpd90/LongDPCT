//
//  DCSettingNotificationViewController.m
//  DispatchCenter
//
//  Created by Phung Long on 11/3/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCSettingNotificationViewController.h"
#import "DCChatViewController.h"
#import "DCApis.h"

@interface DCSettingNotificationViewController ()

@end

@implementation DCSettingNotificationViewController

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
    [_previewSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [_soundSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [_vibrationSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
    [self refreshNotificationStatus];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshNotificationStatus {
    if (IS_WF_APP) {
        if (![kDCWFShowPreviewValue isEqualToString:kDCOffStatusValue]) {
            [_previewSwitch setOn:YES animated:YES];
        } else {
            [_previewSwitch setOn:NO animated:YES];
        }
        if (![kDCWFINAppSoundValue isEqualToString:kDCOffStatusValue]) {
            [_soundSwitch setOn:YES animated:YES];
        } else {
            [_soundSwitch setOn:NO animated:YES];
        }
        if (![kDCWFINAppVibrationValue isEqualToString:kDCOffStatusValue]) {
            [_vibrationSwitch setOn:YES animated:YES];
        } else {
            [_vibrationSwitch setOn:NO animated:YES];
        }
    } else {
        if (![kDCFAShowPreviewValue isEqualToString:kDCOffStatusValue]) {
            [_previewSwitch setOn:YES animated:YES];
        } else {
            [_previewSwitch setOn:NO animated:YES];
        }
        if (![kDCFAINAppSoundValue isEqualToString:kDCOffStatusValue]) {
            [_soundSwitch setOn:YES animated:YES];
        } else {
            [_soundSwitch setOn:NO animated:YES];
        }
        if (![kDCFAINAppVibrationValue isEqualToString:kDCOffStatusValue]) {
            [_vibrationSwitch setOn:YES animated:YES];
        } else {
            [_vibrationSwitch setOn:NO animated:YES];
        }
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
    [self updateSettingStatusWithNotification:sender];
}

- (void)updateSettingStatusWithNotification:(UISwitch *)tempSwitch {
    
    NSMutableDictionary *settingStatus = [NSMutableDictionary new];
    if (_previewSwitch.isOn == YES ||
        _soundSwitch.isOn == YES ||
        _vibrationSwitch.isOn == YES) {
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
    
    if (APP_DELEGATE.mySettings.online == YES) {
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
                [tempSwitch setOn:![tempSwitch isOn] animated:YES];
                
            } else {
                [self saveNotificationStatus];
            }
            
        }
    }];
}

- (void)saveNotificationStatus {
    if (IS_WF_APP) {
        if ([_previewSwitch isOn] == YES) {
            [USER_DEFAULT_STANDARD setValue:kDCOnStatusValue forKey:kDCWFShowPreviewKey];
        } else {
            [USER_DEFAULT_STANDARD setValue:kDCOffStatusValue forKey:kDCWFShowPreviewKey];
        }
        if ([_previewSwitch isOn] == YES) {
            [USER_DEFAULT_STANDARD setValue:kDCOnStatusValue forKey:kDCWFINAppSoundKey];
        } else {
            [USER_DEFAULT_STANDARD setValue:kDCOffStatusValue forKey:kDCWFINAppSoundKey];
        }
        if ([_vibrationSwitch isOn] == YES) {
            [USER_DEFAULT_STANDARD setValue:kDCOnStatusValue forKey:kDCWFINAppVibrationKey];
        } else {
            [USER_DEFAULT_STANDARD setValue:kDCOffStatusValue forKey:kDCWFINAppVibrationKey];
        }
    } else {
        if ([_previewSwitch isOn] == YES) {
            [USER_DEFAULT_STANDARD setValue:kDCOnStatusValue forKey:kDCFAShowPreviewKey];
        } else {
            [USER_DEFAULT_STANDARD setValue:kDCOffStatusValue forKey:kDCFAShowPreviewKey];
        }
        if ([_previewSwitch isOn] == YES) {
            [USER_DEFAULT_STANDARD setValue:kDCOnStatusValue forKey:kDCFAINAppSoundKey];
        } else {
            [USER_DEFAULT_STANDARD setValue:kDCOffStatusValue forKey:kDCFAINAppSoundKey];
        }
        if ([_vibrationSwitch isOn] == YES) {
            [USER_DEFAULT_STANDARD setValue:kDCOnStatusValue forKey:kDCFAINAppVibrationKey];
        } else {
            [USER_DEFAULT_STANDARD setValue:kDCOffStatusValue forKey:kDCFAINAppVibrationKey];
        }
    }
    [USER_DEFAULT_STANDARD synchronize];
    
}
@end
