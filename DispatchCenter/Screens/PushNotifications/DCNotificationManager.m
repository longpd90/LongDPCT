//
//  DCNotificationManager.m
//  DispatchCenter
//
//  Created by Phung Long on 11/23/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCNotificationManager.h"
#import "DCNotificationEntity.h"
#import "DCDetailTaskFAViewcontroller.h"
#import "DCTaskDetailWFViewController.h"
#import "DCChatViewController.h"

@implementation DCNotificationManager

static DCNotificationManager *notificationsManager;

+ (DCNotificationManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notificationsManager = [[DCNotificationManager alloc] init];
    });
    
    return notificationsManager;
}

- (id)init{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

- (UIViewController *)processPushNotification:(NSDictionary*)userInfo {
    DCNotificationEntity *notificationEntity = [DCNotificationEntity parseNotificationFromDict:userInfo];
    if (notificationEntity) {
        if ([notificationEntity.page isEqualToString:@"task_details"]) {
            if (IS_WF_APP) {
                DCTaskDetailWFViewController *vc = [[DCTaskDetailWFViewController alloc] initWithNibName:@"DCTaskDetailWFViewController" bundle:nil];
                vc.taskDetailInfor.uID = [NSNumber numberWithInteger:notificationEntity.filter];
                return vc;
            } else {
                DCDetailTaskFAViewcontroller *pTaskDetailVC = [[DCDetailTaskFAViewcontroller alloc] initWithNibName:@"DCDetailTaskFAViewcontroller" bundle:nil];
                pTaskDetailVC.mIdx = notificationEntity.filter;
                return pTaskDetailVC;
            }

        } else {
            if (IS_WF_APP) {
                if ([notificationEntity.diaglogID isEqualToString:APP_DELEGATE.dialogID]) {
                    DCChatViewController *chatViewController = [DCChatViewController makeMeWithRoomID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomID roomJID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil] ;
                    return chatViewController;
                } else {
                    DCChatViewController *chatViewController = [DCChatViewController makeMeWithRoomID:kDCWFChatRoomIDValue roomJID:kDCWFChatRoomJIDValue phoneNum:nil] ;
                    chatViewController.chatMode = DCChatModeWF;
                    return chatViewController;
                }
                
            } else {
                DCChatViewController *chatViewController = [DCChatViewController makeMeWithRoomID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomID roomJID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil] ;
                return chatViewController;
            }
            
        }
    }
    return nil;
}



@end
