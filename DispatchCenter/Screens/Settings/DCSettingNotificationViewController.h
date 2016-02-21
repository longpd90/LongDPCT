//
//  DCSettingNotificationViewController.h
//  DispatchCenter
//
//  Created by Phung Long on 11/3/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCSettingNotificationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *previewSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *vibrationSwitch;

@end
