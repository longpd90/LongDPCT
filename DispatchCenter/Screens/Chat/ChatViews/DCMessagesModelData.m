//
//  PDLChatViewController.h
//  PDLChatDemo
//
//  Created by Phung Long on 10/13/15.
//  Copyright (c) 2015 Phung Long. All rights reserved.
//


#import "DCMessagesModelData.h"
#import "DCBubbleImageFactory.h"
#import "QBChatMessage+Custom.h"

typedef void(^SuccessBlock)(BOOL success);

@interface DCMessagesModelData()<QBChatDelegate> {
    SuccessBlock loginSuccessBlock;
    NSUInteger currentUserID;
}

@end

@implementation DCMessagesModelData

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (!self.messages) {
            self.messages = [NSMutableArray new];
        }
        
        DCBubbleImageFactory *bubbleFactory = [[DCBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessages];
        self.incomingBubbleImageData = [bubbleFactory incomingMessages];
    }
    
    return self;
}

- (void)addTextMessage:(NSString *)message {
    JSQMessage *textMessage = [[JSQMessage alloc] initWithSenderId:@"abc"
                       senderDisplayName:@"xyz"
                                    date:[NSDate date]
                                    text:message];
    [self.messages addObject:textMessage];

}
- (void)addMessagesToChat:(QBChatMessage *)messageModel
{
    JSQMessage *message = [[JSQMessage alloc] initWithMessage:messageModel];
    [self.messages addObject:message];
}

//- (void)loadMessages:(NSArray *)allMessages
//{
//    for (QBChatMessage *messageModel in allMessages) {
//        if (messageModel.isPhotoMsg) {
//            [self addPhotoMediaMessage:messageModel isLoadMore:NO];
//        } else {
//            if (messageModel.text.length > 0) {
//                JSQMessage *message = [[JSQMessage alloc] initWithMessage:messageModel];
//                [self.messages addObject:message];
//            }
//        }
//    }
//}

- (void)loadMoreMessages:(NSArray *)messages {
    for (NSInteger i = messages.count -1; i >= 0 ; i --) {
        QBChatMessage *messageModel = (QBChatMessage *)[messages objectAtIndex:i];
        if (messageModel.isPhotoMsg) {
            [self addPhotoMediaMessage:messageModel isLoadMore:YES];
        } else {
            if (messageModel.text.length > 0) {
                JSQMessage *message = [[JSQMessage alloc] initWithMessage:messageModel];
                [self.messages insertObject:message atIndex:0];
            }
        }
    }
}

- (void)addPhotoMediaMessage:(QBChatMessage*)message isLoadMore:(BOOL)loadMore
{
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithQBMessage:message];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:[NSString stringWithFormat:@"%lu",(unsigned long)message.senderID]
                                                   displayName:@"text"
                                                         media:photoItem];
    photoMessage.myMessage = message.myMessage;
    photoMessage.date = message.dateSent;
    if (loadMore) {
        [self.messages insertObject:photoMessage atIndex:0];
    } else {
        [self.messages addObject:photoMessage];

    }
}

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMessage *locationMessage = [JSQMessage messageWithSenderId:nil
                                                      displayName:nil
                                                            media:locationItem];
    [self.messages addObject:locationMessage];
}

- (void)addVideoMediaMessage
{
    // don't have a real video, just pretending
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:nil
                                                   displayName:nil
                                                         media:videoItem];
    [self.messages addObject:videoMessage];
}


@end
