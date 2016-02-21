//
//  DCTrackingLocation.h
//  DispatchCenter
//
//  Created by VietHQ on 10/29/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DCTeamTaskModel.h"
#import "DCTaskDetailWFInfo.h"

@interface DCTrackingLocationViewController : UIViewController

@property( nonatomic, strong) DCMemberModel *mTeamLeaderModel;
@property( nonatomic, strong) DCTeamMember *mTeamMember;
@property( nonatomic, strong) DCTaskTeam *mTeam;
@property( nonatomic, strong) NSString *memberPhoneNumber;

@property( nonatomic, assign) CLLocationCoordinate2D mTaskLo;
@property( nonatomic, assign) NSUInteger mUserId;
@property( nonatomic, assign) CGFloat mAvgStar;
@property( nonatomic, strong) DCQBUserInfo *mQBInfo;

@end
