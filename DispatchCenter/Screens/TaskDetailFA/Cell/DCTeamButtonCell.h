//
//  DCTeamButtonCell.h
//  DispatchCenter
//
//  Created by VietHQ on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCTeamButtonCell : UITableViewCell

@property (nonatomic, copy) void(^clickChatButton)(NSIndexPath* idxPath);
@property (nonatomic, copy) void(^clickCallButton)(NSIndexPath* idxPath);
@property (nonatomic, copy) void(^clickLocationButton)(NSIndexPath* idxPath);

@property (weak, nonatomic) IBOutlet UIButton *mChatButton;
@property (weak, nonatomic) IBOutlet UIButton *mCallButton;
@property (weak, nonatomic) IBOutlet UIButton *mLocationButton;

@property (nonatomic,strong) NSIndexPath *mIdxPath;

@property (nonatomic, strong) NSString *mPhoneNumber;

@end
