//
//  DCActionSheetCallTeamLeader.h
//  DispatchCenter
//
//  Created by VietHQ on 10/27/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCActionSheetCallTeamLeader : NSObject
@property(nonatomic, strong) NSString *mStrPhoneNumber;
-(void)showActionSheetInView:(UIView*)view withNumber:(NSString*)number;

@end
