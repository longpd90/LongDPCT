//
//  DCChatManager.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>
#import "QBChatMessage+Custom.h"

#define DCChat  [DCChatManager sharedInstance]

typedef void(^ChatDidGetMessageBlock)(QBChatMessage *message);

@interface DCChatManager : NSObject
+ (DCChatManager*)sharedInstance;
+ (void)setupQB;

@property (nonatomic, copy) ChatDidGetMessageBlock didGetMessage;
- (void)setDidGetMessage:(ChatDidGetMessageBlock)didGetMessage;

- (BOOL)isMyMessage:(QBChatMessage*)msg;

- (void)loginChatUser:(NSString*)user password:(NSString*)password responseHandler:(void (^)(BOOL success))responseHandler;
- (void)logOut:(void(^)(QBResponse *response))completion;

- (void)startChatWithUserID:(NSUInteger)userID name:(NSString*)name responseHandler:(void (^)(BOOL success, QBChatDialog *dialog))responseHandler;
- (void)loadChatHistoryInDialogID:(NSString*)chatDialogID
                             skip:(int)skip take:(int)take
                  responseHandler:(void (^)(BOOL success, NSArray *result))responseHandler;

- (void)loadChatHistoryInDialogID:(NSString*)chatDialogID
                             skip:(int)skip take:(int)take
                        startDate:(NSDate *)start
                          endDate:(NSDate *)end
                  responseHandler:(void (^)(BOOL success, NSArray *result))responseHandler ;

- (void)joinDialogWithID:(NSString*)dialogID
                 roomJID:(NSString*)roomJID
           currentUserID:(NSInteger)userID
         responseHandler:(void (^)(BOOL success, QBChatDialog *dialog))responseHandler;
- (void)leaveDialog:(QBChatDialog*)dlg;
- (void)loadDiaglogsWith:(QBResponsePage *)page
                         success:(void (^)(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page))success
                         failure:(void (^)(QBResponse *response))failure;
- (void)dowloadChatPhotoInMessage:(QBChatMessage*)message responseHandler:(void (^)(BOOL success, UIImage *photo))responseHandler;
- (void)sendMessage:(NSString*)msg inGroup:(QBChatDialog*)groupDialog  failure:(void (^)(NSError *error))failure;
- (void)sendMessage:(NSString *)msg toDialog:(QBChatDialog *)dialog withAttachedImage:(UIImage *)image responseHandler:(void (^)(BOOL success))responseHandler;
@end
