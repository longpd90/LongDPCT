//
//  PDLBubbleImageFactory.h
//  PDLChatDemo
//
//  Created by Phung Long on 10/14/15.
//  Copyright (c) 2015 Phung Long. All rights reserved.
//

#import "JSQMessagesBubbleImageFactory.h"

@interface DCBubbleImageFactory : JSQMessagesBubbleImageFactory

- (JSQMessagesBubbleImage *)outgoingMessages;
- (JSQMessagesBubbleImage *)incomingMessages;

@end
