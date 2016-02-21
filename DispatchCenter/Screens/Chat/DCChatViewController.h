//
//  PDLChatViewController.h
//  PDLChatDemo
//
//  Created by Phung Long on 10/13/15.
//  Copyright (c) 2015 Phung Long. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "JSQMessages.h"
#import "DCMessagesModelData.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "DCTaskDetailWFInfo.h"

typedef enum {
    DCChatModeNormal = 0,
    DCChatModeFA,
    DCChatModeWF
} DCChatMode;


@class DCChatViewController;

@protocol PDLChatViewControllerDelegate <NSObject>

- (void)didDismissPDLChatViewController:(DCChatViewController *)vc;

@end

@interface DCChatViewController : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate>
@property (nonatomic) DCChatMode chatMode;
@property (weak, nonatomic) id<PDLChatViewControllerDelegate> delegateModal;
@property (strong, nonatomic) IBOutlet UIView *callingAlert;
@property (strong, nonatomic) DCTaskDetailWFInfo *taskDetailFA;
@property (strong, nonatomic) DCMessagesModelData *messagesData;
@property (strong, nonatomic) NSString *roomID;
@property (strong, nonatomic) NSString *roomJID;
@property (strong, nonatomic) NSString *phoneCall;
@property (nonatomic, strong) QBChatDialog *currentChatDialog;

- (IBAction)agreeToCallTouched:(id)sender;
- (IBAction)cancelCallTouched:(id)sender;
+ (DCChatViewController*)makeMeWithRoomID:(NSString*)roomID roomJID:(NSString*)roomJID phoneNum:(NSString*)phoneNum;
@end
