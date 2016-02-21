//
//  DCTaskDetailWFViewController.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTaskDetailWFInfo.h"
#import "DCTaskWF.h"
#import "DCSetting.h"

typedef enum callSupportType {
    kPhoneCallTypeHO,
    kPhoneCallTypeFA
}phoneCallSupportType;

@interface DCTaskDetailWFViewController : UIViewController {
    
    __weak IBOutlet UILabel *lblTaskContent;
    __weak IBOutlet UILabel *lblTaskState;
    __weak IBOutlet UILabel *lblTaskDate;
    __weak IBOutlet UILabel *lblTaskId;
    __weak IBOutlet UILabel *lblTaskPrice;
    __weak IBOutlet UILabel *lblLocation;
    __weak IBOutlet UIButton *btnAcceptTask;
    __weak IBOutlet UIButton *btnRejectTask;
    __weak IBOutlet UIButton *btnStartTask;
    __weak IBOutlet UIButton *btnLocationTask;
    __weak IBOutlet UIButton *btnCompletedTask;
    __weak IBOutlet UIButton *btnStopTask;
    __weak IBOutlet UIView *lineSeparatorContent;
    __weak IBOutlet UIView *lineSeparatorStatus;
    __weak IBOutlet UIView *lineSeparatorTaskId;
    __weak IBOutlet UIView *lineSeparatorPrice;
    __weak IBOutlet UIView *lineSeparatorLocation;
    __weak IBOutlet UIView *vwTaskStatus;
    __weak IBOutlet UIView *vwTaskDate;
    __weak IBOutlet UIView *vwTaskPrice;
    __weak IBOutlet UIView *vwTaskLocation;
    __weak IBOutlet UIButton *btnMsgCenter;
    __weak IBOutlet UIButton *btnPhoneCenter;
    __weak IBOutlet UIButton *btnLocationCenter;
    IBOutlet UIView *vwConfirmStopTask;
    __weak IBOutlet UITextView *reasonTxtView;
    __weak IBOutlet UIImageView *imgReject;
    __weak IBOutlet UIImageView *imgAccept;
    
    BOOL needReloadProgress;
    NSUInteger phoneCallTarget;
    
}

@property (assign, nonatomic) NSInteger taskState;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (weak, nonatomic) IBOutlet UIView *vwInfor;
@property (weak, nonatomic) IBOutlet UIView *vwSituation;
@property (strong, nonatomic) IBOutlet UIView *vwReview;
@property (strong, nonatomic) IBOutlet UIView *vwProgress;
@property (weak, nonatomic) IBOutlet UIView *vwCallCenter;
@property (weak, nonatomic) IBOutlet UIView *vwRejectOrAcceptTask;
@property (weak, nonatomic) IBOutlet UIView *vwRequestSupport;
@property (weak, nonatomic) IBOutlet UITableView *tblReviewRates;
@property (weak, nonatomic) IBOutlet UITableView *tblConfirmProgress;
@property (nonatomic, strong) DCTaskDetailWFInfo *taskDetailInfor;
@property (nonatomic, strong) DCSetting* settingStatus;

- (IBAction)btnStartOnTouched:(id)sender;

@end
