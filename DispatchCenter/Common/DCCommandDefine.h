//
//  DCCommandDefine.h
//  DispatchCenter
//
//  Created by VietHQ on 10/12/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#ifndef __DC_CMD_DEFINE__
#define __DC_CMD_DEFINE__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import <Quickblox/Quickblox.h>

typedef  void(^cmdClickLinkInTxtView)();
void CMD_CLICK_LINK_EVENT_IN_TEXTVIEW(UITextView *txtView, NSString *strLink, CGPoint locationClick, cmdClickLinkInTxtView callback);
void CMD_GET_TWITTER_PROFILE(NSString *userId);
void CMD_LOAD_USER_QB_IF_NEED();

#endif //__DC_CMD_DEFINE__