//
//  DCSettingViewController.h
//  DispatchCenter
//
//  Created by Phung Long on 11/3/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCFASettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *notificationStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLocationStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logoutButtonClicked:(id)sender;
- (IBAction)settingNotifications:(id)sender;
- (IBAction)settingLocation:(id)sender;


@end
