//
//  DCCommandDefine.m
//  DispatchCenter
//
//  Created by VietHQ on 10/12/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCCommandDefine.h"

void CMD_CLICK_LINK_EVENT_IN_TEXTVIEW(UITextView *txtView, NSString *strLink, CGPoint locationClick, cmdClickLinkInTxtView callback)
{
    // Location of the tap in text-container coordinates
    NSLayoutManager *layoutManager = txtView.layoutManager;
    CGPoint location = locationClick;
    location.x -= txtView.textContainerInset.left;
    location.y -= txtView.textContainerInset.top;
    
    // Find the character that's been tapped on
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:txtView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    //DLogInfo(@"click char at idx %li", characterIndex);
    
    NSRange rangeLink = [txtView.text rangeOfString:strLink];
    if (rangeLink.location != NSNotFound)
    {
        if ( characterIndex > rangeLink.location &&
            characterIndex < rangeLink.length + rangeLink.location)
        {
            //TODO: click agreement link
            //DLogInfo(@"click link");
            if (callback)
            {
                callback();
            }
        }
    }
}

void CMD_GET_TWITTER_PROFILE(NSString *userId)
{
    TWTRAPIClient *pTWTAPI = [[TWTRAPIClient alloc] initWithUserID:userId];
    [pTWTAPI loadUserWithID:userId completion:^(TWTRUser * _Nullable user, NSError * _Nullable error) {
        if (user)
        {
            //DLogInfo(@"Twitter: %@", user.userID);
            //DLogInfo(@"Twitter: %@", user.name);
            //DLogInfo(@"Twitter: %@", user.screenName);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DC_NOTI_TWITTER_REG object:user];
        }
        else
        {
            //DLogError(@"%@", error);
        }
    }];
}

void CMD_LOAD_USER_QB_IF_NEED()
{
    /*
     * if FA app, go chat view first, get qbuser in chat view
     */
    
    if (IS_FA_APP)
    {
        return;
    }
    
    if (![[QBSession currentSession] currentUser])
    {
        if (APP_DELEGATE.loginInfo)
        {
            //__weak typeof (self) thiz = self;
            [QBRequest logInWithUserLogin:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.login
                                 password:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.password
             
                             successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
                                 
                             }
                               errorBlock:^(QBResponse *response) {
                                   
                               }];
        }
        
    }
}
