//
//  PDLChatViewController.h
//  PDLChatDemo
//
//  Created by Phung Long on 10/13/15.
//  Copyright (c) 2015 Phung Long. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JSQMessages.h"
#import <Quickblox/Quickblox.h>
#import "QBChatMessage+Custom.h"

#define DCChat  [DCChatManager sharedInstance]
typedef void(^ChatDidGetMessageBlock)(QBChatMessage *message);


@interface DCMessagesModelData : NSObject

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSDictionary *users;

- (void)addPhotoMediaMessage:(QBChatMessage*)message isLoadMore:(BOOL)loadMore;

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion;

- (void)addVideoMediaMessage;
//- (void)loadMessages:(NSArray *)allMessages;
- (void)loadMoreMessages:(NSArray *)messages;
- (void)addMessagesToChat:(QBChatMessage *)messageModel;


@end
