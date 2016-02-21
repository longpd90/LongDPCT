//
//  DCBaseActiveTaskCell.h
//  DispatchCenter
//
//  Created by VietHQ on 10/12/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DCCalFrameActiveTask;

typedef NS_ENUM( NSInteger, DCBaseActiveTaskCellType)
{
    DCBaseActiveTaskCellTypeNew,
    DCBaseActiveTaskCellTypePending
};

@interface DCBaseActiveTaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mTaskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (assign, nonatomic) DCBaseActiveTaskCellType mGroupType;

-(void)showBottomLine:(BOOL)value;
-(void)calculateFrameWithObject:(DCCalFrameActiveTask*)calModel;

@end
