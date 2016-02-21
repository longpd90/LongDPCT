//
//  DCWFSettingViewController.h
//  DispatchCenter
//
//  Created by Phung Long on 11/4/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCWFSettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *onlineStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLocationStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)settingLocation:(id)sender;
- (IBAction)settingOnlineStatus:(id)sender;
- (IBAction)settingNotification:(id)sender;
- (IBAction)logoutButtonClicked:(id)sender;

@end
