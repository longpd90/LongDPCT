//
//  DCDropDownMenuViewController.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCDropDownMenuViewController.h"
#import "DCTaskListWFMasterViewController.h"
#import "DCTaskListFAViewController.h"
#import "DCEditProfileViewController.h"
#import "DCFASettingViewController.h"
#import "DCWFSettingViewController.h"
#import "DCInvoiceListFAViewController.h"
#import "DCInvoiceListWFViewController.h"
#import "DCOthersViewController.h"
#import "DCHelpViewController.h"
#import "DCContactSupportVC.h"


@interface DCDropDownMenuViewController () {
    
    __weak IBOutlet UIView *menuHolderWFView;
    __weak IBOutlet UIView *menuHolderFAView;
}

@end

@implementation DCDropDownMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    menuHolderFAView.hidden = (CURR_APP_TYPE == APP_TYPE_WF);
//    menuHolderWFView.hidden = (CURR_APP_TYPE == APP_TYPE_FA);
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

+ (void)showMe {
    DCDropDownMenuViewController *menu = [[DCDropDownMenuViewController alloc] initWithNibName:@"DCDropDownMenuViewController" bundle:nil];
    [APP_DELEGATE.window.rootViewController addChildViewController:menu];
    menu.view.frame = CGRectMake(0, 0, APP_DELEGATE.window.bounds.size.width, APP_DELEGATE.window.bounds.size.height);
    [APP_DELEGATE.window addSubview:menu.view];
}

- (void)hideMe {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)backgroundTouched:(id)sender {
    [self hideMe];
}
- (IBAction)showTaskListBtnTouched:(id)sender {
    [self hideMe];
    BOOL popExisted = NO;
    if (IS_WF_APP) {
        for (id viewController in MAIN_NAVIGATION.viewControllers) {
            if ([viewController isKindOfClass:[DCTaskListWFMasterViewController class]]) {
                popExisted = YES;
                [MAIN_NAVIGATION popToViewController:viewController animated:YES];
                break;
            } else {
                popExisted = NO;
            }
        }
        if (popExisted == NO) {
             [MAIN_NAVIGATION pushViewController:[[DCTaskListWFMasterViewController alloc] initWithNibName:@"DCTaskListWFMasterViewController" bundle:nil] animated:YES];
        }
            
        
    } else {
        for (id viewController in MAIN_NAVIGATION.viewControllers) {
            if ([viewController isKindOfClass:[DCTaskListFAViewController class]]) {
                popExisted = YES;
                [MAIN_NAVIGATION popToViewController:viewController animated:YES];
                break;
            } else {
                popExisted = NO;
            }
        }
        if (popExisted == NO) {
            [MAIN_NAVIGATION pushViewController:[[DCTaskListFAViewController alloc] initWithNibName:@"DCTaskListFAViewController" bundle:nil] animated:YES];
        }
    }
}
- (IBAction)logoutBtnTouched:(id)sender {
    [self hideMe];
    if (IS_WF_APP) {
        [MAIN_NAVIGATION pushViewController:[[DCWFSettingViewController alloc] initWithNibName:@"DCWFSettingViewController" bundle:nil] animated:YES];
    } else {
        [MAIN_NAVIGATION pushViewController:[[DCFASettingViewController alloc] initWithNibName:@"DCFASettingViewController" bundle:nil] animated:YES];
    }
}
- (IBAction)profileTouched:(id)sender {
    [self hideMe];
    
    [MAIN_NAVIGATION pushViewController:[[DCEditProfileViewController alloc] initWithNibName:@"DCEditProfileViewController" bundle:nil] animated:YES];
}
- (IBAction)invoiceBtnTouched:(id)sender
{
    [self hideMe];
    
    // switch view for fa or wf
    UIViewController *pVC = IS_FA_APP ? [[DCInvoiceListFAViewController alloc] initWithNibName:nil bundle:nil] :
                                        [[DCInvoiceListWFViewController alloc] initWithNibName:nil bundle:nil];
    
    [MAIN_NAVIGATION pushViewController:pVC animated:YES];
}

- (IBAction)helpBtnTouched:(id)sender {
    [self hideMe];
    // switch view for fa or wf
    DCHelpViewController *pVC = [[DCHelpViewController alloc] initWithNibName:nil bundle:nil] ;
    
    
    [MAIN_NAVIGATION pushViewController:pVC animated:YES];
}

- (IBAction)termsBtnTouched:(id)sender {
    [self hideMe];
    // switch view for fa or wf
    DCOthersViewController *pVC = IS_FA_APP ? [[DCOthersViewController alloc] initWithNibName:nil bundle:nil] :
    [[DCOthersViewController alloc] initWithNibName:nil bundle:nil];
    pVC.otherViewType = OTHER_VIEW_TERM_CONDITION;
    
    [MAIN_NAVIGATION pushViewController:pVC animated:YES];
}

- (IBAction)privacyBtnTouched:(id)sender {
    [self hideMe];
    // switch view for fa or wf
    DCOthersViewController *pVC = IS_FA_APP ? [[DCOthersViewController alloc] initWithNibName:nil bundle:nil] :
    [[DCOthersViewController alloc] initWithNibName:nil bundle:nil];
    pVC.otherViewType = OTHER_VIEW_PRIVACY_POLICY;
    
    [MAIN_NAVIGATION pushViewController:pVC animated:YES];
}

- (IBAction)contactUsBtnTouched:(id)sender {
    [self hideMe];
    // switch view for fa or wf
    DCContactSupportVC *pVC =  [[DCContactSupportVC alloc] initWithNibName:nil bundle:nil];
    pVC.viewType = kViewTypeContactUs;
    
    [MAIN_NAVIGATION pushViewController:pVC animated:YES];
}



@end
