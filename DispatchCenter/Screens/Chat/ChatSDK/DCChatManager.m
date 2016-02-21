//
//  DCChatManager.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCChatManager.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterIOS7Style.h"
#import "DCChatViewController.h"

#define PHOTO_COMPRESSION_RATE      1.0
const NSUInteger kApplicationID = 29267;
NSString *const kAuthKey        = @"NpDhFE7JdxcRknp";
NSString *const kAuthSecret     = @"Jh7pTGhVtcvN7n4";
NSString *const kAcconuntKey    = @"B6dm9x9yTmf6pXkrjVce";

typedef void(^SuccessBlock)(BOOL success);

@interface DCChatManager()<QBChatDelegate> {
    SuccessBlock loginSuccessBlock;
    NSUInteger currentUserID;
    
    BOOL didLoginChat;
}

@end

@implementation DCChatManager

#pragma mark - Private methods
- (void)doLoginChatUserID:(NSUInteger)userID password:(NSString*)password responseHandler:(void (^)(BOOL success))responseHandler {
    [[QBChat instance] addDelegate:self];


    QBUUser *currentUser = [QBUUser user];
    currentUser.ID = userID; // your current user's ID
    currentUser.password = password; // your current user's password

    loginSuccessBlock = responseHandler;
    // login to Chat
    [[QBChat instance] connectWithUser:currentUser completion:^(NSError * _Nullable error) {
        
    }];
    currentUserID = userID;
}

- (void)registerUser:(NSString*)user password:(NSString*)password successBlock:(void (^)(QBResponse *response, QBUUser *user))successBlock
          errorBlock:(QBRequestErrorBlock)errorBlock{
    QBUUser *loginUser = [QBUUser user];
    loginUser.login = user;
    loginUser.password = password;
    
    [QBRequest signUp:loginUser successBlock:successBlock errorBlock:errorBlock];
}

- (void)joinGroup:(QBChatDialog*)dlg responseHandler:(void (^)(BOOL success, QBChatDialog *dialog))responseHandler {
    __block QBChatDialog *dlgBlock = dlg;

    [dlg joinWithCompletionBlock:^(NSError * _Nullable error) {
        if (error) {
            DLogError(@"%@", @"Join room failed");
            responseHandler(NO,nil);
            return ;
        }
        DLogError(@"%@", @"Join room success");

        responseHandler(YES,dlgBlock);
    }];
}

- (void)leaveDialog:(QBChatDialog*)dlg {
    if (dlg.isJoined) {
        [dlg leaveWithCompletionBlock:^(NSError * _Nullable error) {
            if (error) {
                DLogError(@"%@", @"Leave room error");
            } else {
                DLogError(@"%@", @"Leave room success");
            }
        }];
    }
}

#pragma mark - QBChatDelegate
- (void)chatDidLogin {
    NSLog(@"Login successs: %@", @"");
    didLoginChat = YES;
    if (loginSuccessBlock) {
        loginSuccessBlock (YES);
    }
}

- (void)chatDidNotLoginWithError:(NSError *)error {
    NSLog(@"error: %@", error);
    currentUserID = -1;
    if (loginSuccessBlock) {
        loginSuccessBlock (NO);
    }
}

- (void)chatRoomDidReceiveMessage:(QBChatMessage *)message fromDialogID:(NSString *)dialogID {
    NSLog(@"Did got message: %@", message.text);
    
    if (self.didGetMessage) {
        self.didGetMessage (message);
    }
   // push notification
//    if (!message.myMessage) {
//        if([MAIN_NAVIGATION.visibleViewController isKindOfClass:[DCChatViewController class]]) {
//            DCChatViewController *chatViewController = (DCChatViewController *)MAIN_NAVIGATION.visibleViewController;
//            if ([dialogID isEqualToString:chatViewController.currentChatDialog.ID]  ) {
//                return;
//            }
//        }
//                
//        [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterIOS7Style new];
//        [JCNotificationCenter
//         enqueueNotificationWithTitle:@"Message"
//         message:message.text
//         tapHandler:^{
//             [MAIN_NAVIGATION pushViewController:[DCChatViewController makeMeWithRoomID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomID roomJID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil] animated:YES];
//         }];
//    }
}

#pragma mark - Properties
- (void)setDidGetMessage:(ChatDidGetMessageBlock)didGetMessage {
    // TODO: how about multi room??
    _didGetMessage = didGetMessage;
}

#pragma mark - Public methods
+ (DCChatManager*)sharedInstance {
    static DCChatManager *shared;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [DCChatManager new];
    });
    
    return shared;
}

+ (void)setupQB {
    [QBSettings setApplicationID:kApplicationID];
    [QBSettings setAuthKey:kAuthKey];
    [QBSettings setAuthSecret:kAuthSecret];
    [QBSettings setAccountKey:kAcconuntKey];
    [QBSettings setAutoReconnectEnabled:YES];
    [QBSettings setStreamManagementSendMessageTimeout:20];
    [QBSettings setStreamResumptionEnabled:YES];
}

- (void)loginChatUser:(NSString*)user password:(NSString*)password responseHandler:(void (^)(BOOL success))responseHandler{
    if (didLoginChat == YES) {
        // TODO: did login but by other user???
        if (responseHandler) {
            responseHandler (YES);
        }
        return;
    }
    
    [QBRequest logInWithUserLogin:user password:password successBlock:^(QBResponse *response, QBUUser *user) {
        // set Chat delegate
        [self doLoginChatUserID:user.ID password:password responseHandler:responseHandler];
    } errorBlock:^(QBResponse *response) {
        if (response.status == QBResponseStatusCodeUnAuthorized) {
            [self registerUser:user password:password successBlock:^(QBResponse *response, QBUUser *user) {
                [self doLoginChatUserID:user.ID password:password responseHandler:responseHandler];
            } errorBlock:^(QBResponse *response) {
                NSLog(@"Register error: %@", [response description]);
                
                if (responseHandler) {
                    responseHandler (NO);
                }
            }];
        } else {
            NSLog(@"Register error: %@", [response description]);
            if (responseHandler) {
                responseHandler (NO);
            }
        }
    }];
}

- (void)logOut:(void(^)(QBResponse *response))completion {
    
//    __weak __typeof(self)weakSelf = self;
    
//    weakSelf.isAuthorized = NO;
    [QBRequest logOutWithSuccessBlock:^(QBResponse *response) {
        //Notify subscribes about logout
        if (QBChat.instance.isConnected) {
            [QBChat.instance disconnectWithCompletionBlock:^(NSError * _Nullable error) {
                
            }];
        }
        
        if (completion) {
            completion(response);
        }
        
    } errorBlock:^(QBResponse *response) {
        
        NSLog(@"Logout error: %@", [response description]);
        
        if (completion) {
            completion(response);
        }
    }];
    currentUserID = -1;
    didLoginChat = NO;
}

- (void)startChatWithUserID:(NSUInteger)userID name:(NSString*)name responseHandler:(void (^)(BOOL success, QBChatDialog *dialog))responseHandler {
    QBChatDialog *chatDialog = [[QBChatDialog alloc] initWithDialogID:nil type:QBChatDialogTypeGroup];
    chatDialog.name = @"Chat";
    chatDialog.occupantIDs = @[@(userID)];
    
    [QBRequest createDialog:chatDialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog) {
        [self joinGroup:createdDialog responseHandler:responseHandler];
    } errorBlock:^(QBResponse *response) {
        NSLog(@"Create dialog error: %@", [response description]);
        if (responseHandler) {
            responseHandler (NO, nil);
        }
    }];
}

- (void)loadChatHistoryInDialogID:(NSString*)chatDialogID skip:(int)skip take:(int)take responseHandler:(void (^)(BOOL success, NSArray *result))responseHandler {
    QBResponsePage *page = [QBResponsePage responsePageWithLimit:take skip:skip];
    
    NSMutableDictionary* parameters = [@{@"sort_desc" : @"date_sent"} mutableCopy];
    
    QBChatMessage* lastMessage = nil;
    
    if (lastMessage != nil) {
        parameters[@"date_sent[gt]"] = @([lastMessage.dateSent timeIntervalSince1970]);
    }
    [QBRequest messagesWithDialogID:chatDialogID
                    extendedRequest:parameters
                            forPage:page
                       successBlock:^(QBResponse *response, NSArray *messages, QBResponsePage *page) {
                           NSArray* sortedMessages = [[messages reverseObjectEnumerator] allObjects];
                           
                          if (responseHandler) {
                              responseHandler(YES, sortedMessages);
                          }
                       } errorBlock:^(QBResponse *response) {
                           // case where we may have deleted dialog from another device
                           
                           if (responseHandler) {
                               responseHandler(NO, nil);
                           }
                       }];
}

- (void)loadChatHistoryInDialogID:(NSString*)chatDialogID skip:(int)skip take:(int)take startDate:(NSDate *)start endDate:(NSDate *)end responseHandler:(void (^)(BOOL success, NSArray *result))responseHandler {
    QBResponsePage *page = [QBResponsePage responsePageWithLimit:take skip:skip];
    
    NSMutableDictionary* parameters = [@{@"sort_desc" : @"date_sent"} mutableCopy];
    
    QBChatMessage* lastMessage = nil;
    
    if (lastMessage != nil) {
        parameters[@"date_sent[gt]"] = @([lastMessage.dateSent timeIntervalSince1970]);
    }
    
    parameters[@"date_sent[gte]"] = @([start timeIntervalSince1970]);
    parameters[@"date_sent[lte]"] = @([end timeIntervalSince1970]);
    
    [QBRequest messagesWithDialogID:chatDialogID
                    extendedRequest:parameters
                            forPage:page
                       successBlock:^(QBResponse *response, NSArray *messages, QBResponsePage *page) {
                           NSArray* sortedMessages = [[messages reverseObjectEnumerator] allObjects];
                           
                           if (responseHandler) {
                               responseHandler(YES, sortedMessages);
                           }
                       } errorBlock:^(QBResponse *response) {
                           // case where we may have deleted dialog from another device
                           
                           if (responseHandler) {
                               responseHandler(NO, nil);
                           }
                       }];
}

- (void)loadDiaglogsWith:(QBResponsePage *)page
            success:(void (^)(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page))success
                 failure:(void (^)(QBResponse *response))failure
{    
    [QBRequest dialogsForPage:page extendedRequest:nil successBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page) {
        success(response,dialogObjects,dialogsUsersIDs,page);
    } errorBlock:^(QBResponse *response) {
        failure(response);
    }];
}

- (void)joinDialogWithID:(NSString*)dialogID roomJID:(NSString*)roomJID currentUserID:(NSInteger)userID responseHandler:(void (^)(BOOL success, QBChatDialog *dialog))responseHandler {
    if (dialogID.length > 0) {
        [DCChat loginChatUser:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.login password:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.password responseHandler:^(BOOL success) {
            if (success) {
                QBChatDialog *chatDialog = [[QBChatDialog alloc] initWithDialogID:dialogID type:QBChatDialogTypeGroup];
                chatDialog.roomJID = roomJID;
                if (chatDialog.isJoined == NO) {
                    [self joinGroup:chatDialog responseHandler:responseHandler];
                } else {
                    if (responseHandler) {
                        responseHandler (YES, chatDialog);
                    }
                }
            } else {
                if (responseHandler) {
                    responseHandler (NO, nil);
                }
            }
        }];
    } else {
        if (responseHandler) {
            responseHandler (NO, nil);
        }
    }
}

- (void)dowloadChatPhotoInMessage:(QBChatMessage*)message responseHandler:(void (^)(BOOL success, UIImage *photo))responseHandler {
    if (message.isPhotoMsg) {
        [QBRequest downloadFileWithID:message.photoID successBlock:^(QBResponse *response, NSData *fileData) {
            
            UIImage *image = [UIImage imageWithData:fileData];

            if (responseHandler) {
                responseHandler (YES, image);
            }
            
        } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
            
            
        } errorBlock:^(QBResponse *response) {
            DLogError(@"Download photo error: %@", [response description]);
            if (responseHandler) {
                responseHandler (NO, nil);
            }
        }];

    } else {
        DLogError(@"This is not photo message");
        if (responseHandler) {
            responseHandler (NO, nil);
        }
    }
}

- (void)sendMessage:(NSString*)msg inGroup:(QBChatDialog*)groupDialog  failure:(void (^)(NSError *error))failure{
    QBChatMessage *message = [QBChatMessage message];
    [message setText:msg];
    message.dateSent = [NSDate date];
    //
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [message setCustomParameters:params];
    //
    [groupDialog sendMessage:message completionBlock:^(NSError * _Nullable error) {
        failure(error);
    }];
}

- (void)sendMessage:(NSString *)msg toDialog:(QBChatDialog *)dialog withAttachedImage:(UIImage *)image responseHandler:(void (^)(BOOL success))responseHandler {
    NSData *imageData = UIImageJPEGRepresentation(image, PHOTO_COMPRESSION_RATE);
    
    [QBRequest TUploadFile:imageData fileName:@"attachment" contentType:@"image/jpeg" isPublic:YES successBlock:^(QBResponse *response, QBCBlob *blob) {
        QBChatMessage *message = [QBChatMessage message];
        [message setText:msg];
        message.dateSent = [NSDate date];
        //
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"save_to_history"] = @YES;
        [message setCustomParameters:params];
        QBChatAttachment *attachment = [QBChatAttachment new];
        attachment.type = @"image";
        attachment.ID = [@(blob.ID) stringValue];
        attachment.url = [blob publicUrl];
        
        message.attachments = @[attachment];
        message.text = @"Attachment image";
        
        [dialog sendMessage:message completionBlock:^(NSError * _Nullable error) {
            
        }];
        
        if (responseHandler) {
            responseHandler(YES);
        }
        
    } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
        
    } errorBlock:^(QBResponse *response) {
        DLogError(@"Upload photo error: %@", [response description]);
        
        if (responseHandler) {
            responseHandler(NO);
        }
    }];
}

- (BOOL)isMyMessage:(QBChatMessage*)msg {
    return msg.senderID == currentUserID;
}
@end
