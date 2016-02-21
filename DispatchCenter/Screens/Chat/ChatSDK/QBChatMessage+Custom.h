//
//  QBChatMessage+Custom.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/14/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Quickblox/Quickblox.h>

@interface QBChatMessage (Custom)
@property (readonly, nonatomic) BOOL myMessage;
@property (readonly, nonatomic) BOOL isPhotoMsg;
@property (readonly, nonatomic) NSInteger photoID;
@end
