//
//  DCOthersViewController.m
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 11/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCOthersViewController.h"
#import "DCChatViewController.h"

@interface DCOthersViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *tvContent;

@end

@implementation DCOthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
    if (self.otherViewType == OTHER_VIEW_END_USER_LICENSE_AGREEMENT) {
        
    } else {
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]] leftOrRight:NO target:self actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
    }
    // Do any additional setup after loading the view from its nib.
    switch (self.otherViewType) {
        case OTHER_VIEW_HELP: {
            self.lblTitle.text = @"Help";
        }
            break;
        case OTHER_VIEW_TERM_CONDITION: {
            self.lblTitle.text = NSLocalizedString(@"Terms & Conditions", nil);
        }
            break;
        case OTHER_VIEW_PRIVACY_POLICY: {
            self.lblTitle.text = NSLocalizedString(@"Privacy Policy",nil);
        }
            break;
        case OTHER_VIEW_END_USER_LICENSE_AGREEMENT: {
            self.lblTitle.text = NSLocalizedString(@"End User License Agreement",nil);
            
        }
            break;
            
        default:
            break;
    }
    [self.tvContent scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
