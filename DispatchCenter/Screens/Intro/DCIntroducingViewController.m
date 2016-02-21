//
//  DCIntroducingViewController.m
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 12/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCIntroducingViewController.h"
#import "DCLoginViewController.h"
#import "DCRegisterViewController.h"

@interface DCIntroducingViewController ()

@end

@implementation DCIntroducingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)continueTouched:(id)sender {
    if (APP_DELEGATE.loginInfo) {
        [self showLogin];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ALREADY_FIRST_TIME_LAUNCH];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ALREADY_FIRST_TIME_LAUNCH];
        [self showLogin];
    }
}

- (void)showLogin {
    DCLoginViewController *loginVC =  [[DCLoginViewController alloc] initWithNibName:@"DCLoginViewController" bundle:nil];
    [MAIN_NAVIGATION pushViewController:loginVC animated:YES];
    [APP_DELEGATE showYellowLineBottomNav];
}

- (void)showRegister {
    DCRegisterViewController *registerVC =  [[DCRegisterViewController alloc] initWithNibName:nil bundle:nil];
    [MAIN_NAVIGATION pushViewController:registerVC animated:YES];
    [APP_DELEGATE showYellowLineBottomNav];
}
@end
