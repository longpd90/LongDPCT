//
//  DCActionSheetCallTeamLeader.m
//  DispatchCenter
//
//  Created by VietHQ on 10/27/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCActionSheetCallTeamLeader.h"

@interface DCActionSheetCallTeamLeader()<UIActionSheetDelegate>



@end

@implementation DCActionSheetCallTeamLeader

-(void)showActionSheetInView:(UIView*)view withNumber:(NSString*)number
{
    self.mStrPhoneNumber = number;
    UIActionSheet *pActionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                              delegate: self
                                                     cancelButtonTitle: NSLocalizedString(@"str_cancel", nil)
                                                destructiveButtonTitle: nil
                                                     otherButtonTitles: [ NSString stringWithFormat:NSLocalizedString(@"str_call", nil), number], nil] ;
    
    [pActionSheet showInView:view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index === %ld \n", (long)buttonIndex);
    if (buttonIndex == 0)
    {
        NSString *pPhoneNumber = [@"telprompt://" stringByAppendingString: self.mStrPhoneNumber];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pPhoneNumber]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pPhoneNumber]];
        } else {
            [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Can not call this phone number", nil) callback:^(UIAlertView *al, NSInteger idx) {
                
            } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
        }
    }
}

-(void)dealloc
{
    
}

@end
