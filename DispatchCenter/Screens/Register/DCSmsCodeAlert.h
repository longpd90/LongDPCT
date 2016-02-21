//
//  DCSmsCodeAlert.h
//  DispatchCenter
//
//  Created by VietHQ on 10/8/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCSmsCodeAlert : UIView

@property(nonatomic, copy) void(^cancelBtnClick)(DCSmsCodeAlert *smsAlert);
@property(nonatomic, copy) void(^OkBtnClick)(DCSmsCodeAlert *smsAlert);
@property(nonatomic, assign) BOOL mIsEditProfile;
-(void)setStringPhoneWithCode:(NSString*)str;

@end
