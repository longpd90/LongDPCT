//
//  DCTeamLeaderContactView.h
//  DispatchCenter
//
//  Created by VietHQ on 10/29/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DCTeamLeaderContactView;
@protocol  DCTeamLeaderContactViewDelegate<NSObject>

-(void)teamLeaderContactViewDidChat:(DCTeamLeaderContactView*)teamLeaderView;
-(void)teamLeaderContactViewDidCall:(DCTeamLeaderContactView*)teamLeaderView;

@end

@interface DCTeamLeaderContactView : UIView

@property(weak,nonatomic) id<DCTeamLeaderContactViewDelegate> mDelegate;

-(void)setName:(NSString*)name;
-(void)setStatus:(NSString*)status;
-(void)setStar:(CGFloat)star;
-(void)setAvaWithURL:(NSString*)url;

@end
