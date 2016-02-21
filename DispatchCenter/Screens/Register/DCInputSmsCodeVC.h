//
//  DCInputSmsCodeVC.h
//  DispatchCenter
//
//  Created by VietHQ on 10/8/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DCLoginModeNormal,
    DCLoginModeSocial
}DCLoginMode;

@interface DCInputSmsCodeVC : UIViewController
@property(nonatomic, assign) DCLoginMode loginMode;
@property(nonatomic, copy) NSString *mStrPhoneWithCode;
@property(nonatomic, assign) BOOL mIsEditProfile;

@end
