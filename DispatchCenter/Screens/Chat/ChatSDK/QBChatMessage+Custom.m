//
//  QBChatMessage+Custom.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/14/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "QBChatMessage+Custom.h"
#import <objc/runtime.h>
#import "DCChatManager.h"

//#import "Objective"
@implementation QBChatMessage (Custom)
@dynamic myMessage;

- (BOOL)myMessage {
    return ([DCChat isMyMessage:self]);
}

- (BOOL)isPhotoMsg {
    if (self.attachments.count > 0) {
        QBChatAttachment *att = (QBChatAttachment*)self.attachments[0];
        if ([att.type isEqualToString:@"photo"] || [att.type isEqualToString:@"image"]) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)photoID {
    if (self.attachments.count > 0) {
        QBChatAttachment *att = (QBChatAttachment*)self.attachments[0];
        if ([att.type isEqualToString:@"image"]) {
            return [att.ID integerValue];
        }
    }
    
    return -1;
}
@end
