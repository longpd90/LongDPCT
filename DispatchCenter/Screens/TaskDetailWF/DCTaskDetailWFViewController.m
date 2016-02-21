//
//  DCTaskDetailWFViewController.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskDetailWFViewController.h"
#import "DCTaskWF.h"
#import "DCTableProgressCell.h"
#import "DCTableReviewCell.h"
#import "DCUtility.h"
#import "DCApis.h"
#import "DCChatViewController.h"
#import "DCTrackingLocationViewController.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterIOS7Style.h"

#define STATE_TASK_NEW          0
#define STATE_TASK_PENDING      1
#define STATE_TASK_IN_PROGRESS  2
#define STATE_TASK_COMPLETED    3
#define STATE_TASK_CANCEL       4

#define LINE_SEPARATOR_HEIGHT   1

static NSString *commentStr = @"1 sal;gjaksg ;askjgl;akjsg; \n 2 askg;as  3 ;kasjg;lajks 4 a;sldjkg;agjksd 5 dkkdlskdldksl\ 6 asldklkasdgas \n 7 asldkg;aksgjas \n 8 klasdgjl\n 9 alsdgkjlasdg\n 10 asdlgkj;asdg\n 11 sklasgj;asdgasdg \n 12 askgjas;gjas gdadsg\n";
@interface DCTaskDetailWFViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIActionSheetDelegate>


@property (nonatomic, strong) NSMutableArray *arrReviewContent;

@end

@implementation DCTaskDetailWFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.arrReviewContent = [[NSMutableArray alloc] initWithArray:@[NSLocalizedString(@"Average Rating",nil),
                                                                    NSLocalizedString(@"Knows this job",nil),
                                                                    NSLocalizedString(@"Was on time",nil),
                                                                    NSLocalizedString(@"Had the right equipment",nil),
                                                                    NSLocalizedString(@"Pricing",nil)]];
//     self.taskState = STATE_TASK_IN_PROGRESS;
//    self.taskState = TaskListTypeCompletedTaskList;
    
    
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]] leftOrRight:NO target:self actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
    
    //call API get tasks/:id
    [self sendRequestGetTaskDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
    DLogInfo(@" ======> %f", self.view.frame.origin.y);
    
}

#pragma mark - Actions
- (void)didSelectChatBtn:(id)sender {
    if (IS_FA_APP) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        [MAIN_NAVIGATION pushViewController:[DCChatViewController makeMeWithRoomID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomID roomJID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil] animated:YES];
    }
}

- (void)didSelectMenuBtn:(id)sender {
    [DCDropDownMenuViewController showMe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRequestGetTaskDetail {
    [LoadingViewHelper showLoading];
    [DCApis getTaskDetailWithId:[self.taskDetailInfor.uID integerValue] complete:^(BOOL success, ServerObjectBase *response) {
        [LoadingViewHelper hideLoading];
        if (success && response) {
            
            
            
            DCTaskDetailWFInfo *info = (DCTaskDetailWFInfo*)response;
            self.taskDetailInfor = info;
            
            //show detail info based on data
            [self showDetailInforOnView];
            
           
            
          
            
            //show view based on task status
            
            
             [self setupPositionForComponents];
            
            [self setupViewBasedOnTaskState];
            
            //reload progress list if necessary
            //need recode
            if (needReloadProgress) {
                //Show toast
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = NSLocalizedString(@"Task successfully",nil);
                hud.margin = 10.f;
                [hud hide:YES afterDelay:1.0f];
                [self.tblConfirmProgress reloadData];
                [self.tblReviewRates reloadData];
            } else  {
                
            }

        }
        else {
            
        }
    }];
}

- (void)showDetailInforOnView {
    
//    @interface DCTaskWFDetail : ServerObjectBase
//    
//    @property (nonatomic, strong) NSString *code;
//    @property (nonatomic, strong) NSString *name;
//    @property (nonatomic, strong) NSDate *due_date;
//    @property (nonatomic, strong) NSString *task;
//    @property (nonatomic, strong) NSNumber *amount_untaxed;
//    @property (nonatomic, strong) NSString *task_no;
//    @property (nonatomic, strong) NSNumber *amount_total;
//    @property (nonatomic, assign) BOOL active;
//    @property (nonatomic, strong) NSNumber *uID;
//    @property (nonatomic, strong) NSNumber *amount_tax;
//    @property (nonatomic, assign) BOOL summary;
//    @property (nonatomic, assign) TaskListType typeTask;
    lblTaskContent.text = self.taskDetailInfor.summaryText;
    lblTaskDate.text = [NSString stringWithFormat:@"%@", [DCUtility autoConvertDateString:self.taskDetailInfor.created_date toStringWithFormat:kDateOutput]];
   //test set hard value
//    self.taskDetailInfor.amount_total = [NSNumber numberWithFloat:917990.7122];
//    lblTaskPrice.text = [NSString stringWithFormat:@"฿%@",[self formatedPrice:[self.taskDetailInfor.amount_total integerValue]]];
    lblTaskPrice.text = [NSString stringWithFormat:@"฿%@",self.taskDetailInfor.amount_total];
    lblTaskId.text = [NSString stringWithFormat:@"%@", self.taskDetailInfor.task_no ];
    NSString *districtProvince = [NSString stringWithFormat:@""];
    if (!self.taskDetailInfor.taskAddress.district && self.taskDetailInfor.taskAddress.province) {
        districtProvince = [NSString stringWithFormat:@"%@",self.taskDetailInfor.taskAddress.province.provinceName];
    } else if (self.taskDetailInfor.taskAddress.district && !self.taskDetailInfor.taskAddress.province) {
        districtProvince = [NSString stringWithFormat:@"%@",self.taskDetailInfor.taskAddress.district.districtName];
    } else if (self.taskDetailInfor.taskAddress.district && self.taskDetailInfor.taskAddress.province) {
        districtProvince = [NSString stringWithFormat:@"%@,\n%@ %@",self.taskDetailInfor.taskAddress.district.districtName,self.taskDetailInfor.taskAddress.province.provinceName,self.taskDetailInfor.taskAddress.zip];
    } else {
        //do nothing
    }
    lblLocation.text = [NSString stringWithFormat:@"%@\n%@ ", self.taskDetailInfor.taskAddress.subdistrict ? self.taskDetailInfor.taskAddress.subdistrict.subdistrictName : @"", districtProvince];
    
    if (!self.taskDetailInfor.taskAddress.district.districtName && !self.taskDetailInfor.taskAddress.province.provinceName && !self.taskDetailInfor.taskAddress.subdistrict.subdistrictName && !self.taskDetailInfor.taskAddress.zip) {
        lblLocation.text = @"";
    }
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
}

- (NSString*)formatedPrice: (NSInteger)price {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init] ;
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setDecimalSeparator:@"."];
    
    NSString *finalValue = [formatter stringFromNumber:[NSNumber numberWithInteger:price]];
    return finalValue;

}
/*
 * Setup position for components adapt to size content of Text
 */
- (void)setupPositionForComponents {
    
    CGRect recLabel = lblTaskContent.frame;
    lblTaskContent.numberOfLines = 0;

    CGSize sizeTxt = CGSizeMake( CGRectGetWidth(recLabel) - 30.0f, FLT_MAX);
    CGRect rec = [lblTaskContent.text boundingRectWithSize: sizeTxt
                                                   options: NSStringDrawingUsesLineFragmentOrigin
                                                attributes: @{ NSFontAttributeName: lblTaskContent.font}
                                                   context: nil];
    recLabel.size.height = rec.size.height;
    lblTaskContent.frame = recLabel;
    
    CGRect tempFrame = CGRectMake(lineSeparatorContent.frame.origin.x, CGRectGetMaxY(lblTaskContent.frame) + 10, lineSeparatorContent.frame.size.width, lineSeparatorContent.frame.size.height);
    lineSeparatorContent.frame = tempFrame;
    
    tempFrame.origin.y += 10;
    tempFrame.size.height = vwTaskStatus.frame.size.height;
    vwTaskStatus.frame = tempFrame;
    
    tempFrame.origin.y += vwTaskStatus.frame.size.height + 10;
    tempFrame.size.height = LINE_SEPARATOR_HEIGHT;
    lineSeparatorStatus.frame = tempFrame;
    
    tempFrame.origin.y += 10;
    tempFrame.size.height = vwTaskDate.frame.size.height;
    vwTaskDate.frame = tempFrame;
    
    tempFrame.origin.y += vwTaskDate.frame.size.height + 10;
    tempFrame.size.height = LINE_SEPARATOR_HEIGHT;
    lineSeparatorTaskId.frame = tempFrame;
    
    tempFrame.origin.y += 10;
    tempFrame.size.height = vwTaskPrice.frame.size.height;
    vwTaskPrice.frame = tempFrame;
    
    tempFrame.origin.y += vwTaskPrice.frame.size.height + 10;
    tempFrame.size.height = LINE_SEPARATOR_HEIGHT;
    lineSeparatorPrice.frame = tempFrame;
    
    tempFrame.origin.y += 10;
    tempFrame.size.height = vwTaskLocation.frame.size.height;
    vwTaskLocation.frame = tempFrame;
    
    tempFrame.origin.y += vwTaskLocation.frame.size.height + 10;
    tempFrame.origin.x = 0;
    tempFrame.size.height = LINE_SEPARATOR_HEIGHT;
    tempFrame.size.width = CGRectGetWidth(MAIN_SCREEN);
    lineSeparatorLocation.frame = tempFrame;
    
    tempFrame.size.height = CGRectGetMaxY(lineSeparatorLocation.frame) + 1.0f;
    tempFrame.origin.y = 0;
    self.vwInfor.frame = tempFrame;
    
    [self.scrView addSubview:self.vwInfor];
   
}

- (void)setupViewBasedOnTaskState {
    
    lblTaskState.text = NSLocalizedString(self.taskDetailInfor.name,nil);
    
    if ([self.taskDetailInfor.name isEqualToString:@"New"]) {
        self.taskState = TaskListTypeNewTaslList;
        self.vwRejectOrAcceptTask.hidden = NO;
        self.vwRequestSupport.hidden = NO;
        btnRejectTask.hidden = NO;
        imgReject.frame = CGRectMake(btnRejectTask.titleLabel.frame.origin.x - 17, btnRejectTask.titleLabel.frame.origin.y + 2, 14, 14);
        btnAcceptTask.hidden = NO;
        imgAccept.frame = CGRectMake(btnAcceptTask.titleLabel.frame.origin.x - 17, btnAcceptTask.titleLabel.frame.origin.y + 2, 14, 14);
        btnCompletedTask.hidden = YES;
        btnStartTask.hidden = YES;
        
        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), self.vwRequestSupport.frame.size.height);
        self.vwRequestSupport.frame = tempFrame;
        [self.scrView addSubview:self.vwRequestSupport];
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwRequestSupport.frame), CGRectGetWidth(MAIN_SCREEN), self.vwRejectOrAcceptTask.frame.size.height);
        self.vwRejectOrAcceptTask.frame = tempFrame;
        [self.scrView addSubview:self.vwRejectOrAcceptTask];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
//        [self setupComponentsForTaskInProgress];
        
    } else if ([self.taskDetailInfor.name isEqualToString:@"Order Confirmed"]) {
        self.taskState = TaskListTypeInProgressTaskList;
   
        
        self.vwRejectOrAcceptTask.hidden = NO;
        self.vwRequestSupport.hidden = NO;
        btnRejectTask.hidden = NO;
        imgReject.frame = CGRectMake(btnRejectTask.titleLabel.frame.origin.x - 17, btnRejectTask.titleLabel.frame.origin.y + 2, 14, 14);
        btnAcceptTask.hidden = NO;
        imgAccept.frame = CGRectMake(btnAcceptTask.titleLabel.frame.origin.x - 17, btnAcceptTask.titleLabel.frame.origin.y + 2, 14, 14);
        btnCompletedTask.hidden = YES;
        btnLocationTask.hidden = YES;
        btnStopTask.hidden = YES;
        
        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame) - 0.5, CGRectGetWidth(MAIN_SCREEN), self.vwRequestSupport.frame.size.height);
        self.vwRequestSupport.frame = tempFrame;
        [self.scrView addSubview:self.vwRequestSupport];
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwRequestSupport.frame), CGRectGetWidth(MAIN_SCREEN), self.vwRejectOrAcceptTask.frame.size.height);
        self.vwRejectOrAcceptTask.frame = tempFrame;
        [self.scrView addSubview:self.vwRejectOrAcceptTask];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
//        [self setupComponentsForTaskInProgress];
        
    } else if ([self.taskDetailInfor.name isEqualToString:@"Cancelled"]) {
        self.taskState = TaskListTypeCancelTask;
        self.vwRejectOrAcceptTask.hidden = YES;
        self.vwRequestSupport.hidden = YES;
        CGFloat hTable = [self tableView:self.tblReviewRates numberOfRowsInSection:0]*44.0f + [self getHeightOfReviewFooter] + 20;
        CGFloat hSituation = hTable + 50.0f;
        

        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), hSituation);
        self.vwRejectOrAcceptTask.hidden = YES;
        self.vwSituation.hidden = NO;
        self.vwSituation.frame = tempFrame;
        self.vwReview.frame = CGRectMake(0, 0, CGRectGetWidth(MAIN_SCREEN), 300);
        self.tblReviewRates.frame = (CGRect){CGPointMake(0.0f, 30.0f), CGSizeMake( CGRectGetWidth(MAIN_SCREEN), hSituation)};
        [self.vwSituation addSubview:self.vwReview];
        [self.scrView addSubview:self.vwSituation];
        
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];

        
    } else if ([self.taskDetailInfor.name isEqualToString:@"Finding You an Operator"]) { //Can Start
        self.taskState = TaskListTypeInProgressTaskList;
        CGFloat hTable = [self tableView:self.tblConfirmProgress numberOfRowsInSection:0]*44.0f;
        CGFloat hSituation = hTable + 30.0f;
        
        
        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), self.vwCallCenter.frame.size.height);
        self.vwCallCenter.hidden = NO;
        self.vwCallCenter.frame = tempFrame;
        
        
       
         self.vwRejectOrAcceptTask.hidden = NO;
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwCallCenter.frame), CGRectGetWidth(MAIN_SCREEN), self.vwRejectOrAcceptTask.frame.size.height);
        self.vwRejectOrAcceptTask.hidden = NO;
        self.vwRejectOrAcceptTask.frame = tempFrame;
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwRejectOrAcceptTask.frame), CGRectGetWidth(MAIN_SCREEN), hSituation);
        self.vwSituation.frame = tempFrame;
        self.vwProgress.frame = CGRectMake(0, 0, CGRectGetWidth(MAIN_SCREEN), hSituation);
        
        self.vwSituation.hidden = NO;
        [self.vwSituation addSubview:self.vwProgress];
        self.vwSituation.backgroundColor = [UIColor grayColor];
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwSituation.frame) , self.vwRequestSupport.frame.size.width, self.vwRequestSupport.frame.size.height);
        self.vwRequestSupport.hidden = NO;
        self.vwRequestSupport.frame = tempFrame;
        [self.scrView addSubview:self.vwRequestSupport];
        
        //self.scrView.contentSize = CGSizeMake(self.view.frame.size.width, self.vwRequestSupport.frame.origin.y + self.vwRequestSupport.frame.size.height + 20);
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];

        
        btnStartTask.hidden = NO;
        btnRejectTask.hidden = YES;
        btnAcceptTask.hidden = YES;
        btnCompletedTask.hidden = YES;
        btnRejectTask.hidden = YES;
    } else if ([self.taskDetailInfor.name isEqualToString:@"Waiting HO Confirm"]) { //Pending, action N/A
        self.taskState = TaskListTypePendingTaskList;
        
//        CGFloat hTable = [self tableView:self.tblConfirmProgress numberOfRowsInSection:0]*44.0f;
//        CGFloat hSituation = hTable + 30.0f;
        
        btnRejectTask.hidden = YES;
        btnCompletedTask.hidden = YES;
        self.vwRejectOrAcceptTask.hidden = YES;
        
        self.vwSituation.hidden = YES;
        
        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), self.vwRequestSupport.frame.size.height);
      
        self.vwRequestSupport.hidden = NO;
        self.vwRequestSupport.frame = tempFrame;
        [self.scrView addSubview:self.vwRequestSupport];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        

        
        [self.scrView setContentSize:CGSizeMake(CGRectGetWidth(MAIN_SCREEN), CGRectGetMaxY(self.vwRequestSupport.frame) + 20)];
        
    } else if ([self.taskDetailInfor.name isEqualToString:@"Operator On the Way"]) { //Can go to location or Stop task
        self.taskState = TaskListTypeInProgressTaskList;
        CGFloat hTable = [self tableView:self.tblConfirmProgress numberOfRowsInSection:0]*44.0f;
        CGFloat hSituation = hTable + 30.0f;
        
        
        
        
        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), self.vwCallCenter.frame.size.height);
        self.vwCallCenter.hidden = NO;
        self.vwCallCenter.frame = tempFrame;
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwCallCenter.frame), CGRectGetWidth(MAIN_SCREEN), self.vwRejectOrAcceptTask.frame.size.height);
        self.vwRejectOrAcceptTask.hidden = NO;
        self.vwRejectOrAcceptTask.frame = tempFrame;
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwRejectOrAcceptTask.frame), CGRectGetWidth(MAIN_SCREEN), hSituation);
        self.vwSituation.frame = tempFrame;
        self.vwProgress.frame = CGRectMake(0, 0, CGRectGetWidth(MAIN_SCREEN), hSituation);
        self.vwSituation.hidden = NO;
        [self.vwSituation addSubview:self.vwProgress];
        
       
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwSituation.frame) , CGRectGetWidth(MAIN_SCREEN), self.vwRequestSupport.frame.size.height);
        self.vwRequestSupport.hidden = NO;
        self.vwRequestSupport.frame = tempFrame;
        [self.scrView addSubview:self.vwRequestSupport];
        
        //self.scrView.contentSize = CGSizeMake(self.view.frame.size.width, self.vwRequestSupport.frame.origin.y + self.vwRequestSupport.frame.size.height + 20);
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];

        
        btnLocationTask.hidden = NO;
        btnStopTask.hidden = NO;
        btnStartTask.hidden = YES;
        btnCompletedTask.hidden = YES;
        btnRejectTask.hidden = YES;
        btnAcceptTask.hidden = YES;
        //self.scrView.contentSize = CGSizeMake(self.view.frame.size.width, self.vwSituation.frame.origin.y + self.vwProgress.frame.size.height + self.vwRequestSupport.frame.size.height + 50);
    } else if ([self.taskDetailInfor.name isEqualToString:@"Operator Working Task"]) { //Can Complted or Stop task
        self.taskState = TaskListTypeInProgressTaskList;
        self.vwRejectOrAcceptTask.hidden = NO;
        
        
        
        CGFloat hTable = [self tableView:self.tblConfirmProgress numberOfRowsInSection:0]*44.0f;
        CGFloat hSituation = hTable + 30.0f;
        
        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), self.vwCallCenter.frame.size.height);
        self.vwCallCenter.hidden = NO;
        self.vwCallCenter.frame = tempFrame;
        
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.self.vwCallCenter.frame), CGRectGetWidth(MAIN_SCREEN), self.vwRejectOrAcceptTask.frame.size.height);
        self.vwRejectOrAcceptTask.hidden = NO;
        self.vwRejectOrAcceptTask.frame = tempFrame;
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.self.vwRejectOrAcceptTask.frame), CGRectGetWidth(MAIN_SCREEN), hSituation);
        self.vwSituation.frame = tempFrame;
        self.vwProgress.frame = CGRectMake(0, 0, CGRectGetWidth(MAIN_SCREEN), hSituation);
        self.vwSituation.hidden = NO;
        [self.vwSituation addSubview:self.vwProgress];
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwSituation.frame) , CGRectGetWidth(MAIN_SCREEN), self.vwRequestSupport.frame.size.height);
        self.vwRequestSupport.hidden = NO;
        self.vwRequestSupport.frame = tempFrame;
        [self.scrView addSubview:self.vwRequestSupport];
        
        
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
        btnAcceptTask.hidden = YES;
        btnStopTask.hidden = NO;
        btnCompletedTask.hidden = NO;
        btnRejectTask.hidden = YES;
        btnLocationTask.hidden = YES;
        
        
//        [self setupComponentsForTaskInProgress];
        
    } else if ([self.taskDetailInfor.name isEqualToString:@"Awaiting for Customer Approval"]) {
        self.taskState = TaskListTypeInProgressTaskList;
        
        
        
        
        CGFloat hTable = [self tableView:self.tblConfirmProgress numberOfRowsInSection:0]*44.0f;
        CGFloat hSituation = hTable + 30.0f;
        
        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), self.vwCallCenter.frame.size.height);
        self.vwCallCenter.hidden = NO;
        self.vwCallCenter.frame = tempFrame;
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwCallCenter.frame) , CGRectGetWidth(MAIN_SCREEN), hSituation);
        btnCompletedTask.hidden = YES;
        btnStopTask.hidden = YES;
        self.vwRejectOrAcceptTask.hidden = YES;
        
        self.vwSituation.frame = tempFrame;
        self.vwProgress.frame = CGRectMake(0, 0, CGRectGetWidth(MAIN_SCREEN), hSituation);
        self.vwSituation.hidden = NO;
        [self.vwSituation addSubview:self.vwProgress];
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwSituation.frame), CGRectGetWidth(MAIN_SCREEN), self.vwRequestSupport.frame.size.height);
        self.vwRequestSupport.hidden = NO;
        self.vwRequestSupport.frame = tempFrame;
        [self.scrView addSubview:self.vwRequestSupport];
      
         //self.scrView.contentSize = CGSizeMake(self.view.frame.size.width, self.vwRequestSupport.frame.origin.y + self.vwRequestSupport.frame.size.height + 50);
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];

        
    
//        [self setupComponentsForTaskInProgress];
    } else if ([self.taskDetailInfor.name isEqualToString:@"Stop Task"]) {
        self.taskState = TaskListTypeInProgressTaskList;
        
        CGFloat hTable = [self tableView:self.tblConfirmProgress numberOfRowsInSection:0]*44.0f;
        CGFloat hSituation = hTable + 30.0f;
        
        self.vwRejectOrAcceptTask.hidden = YES;
        self.vwSituation.hidden = NO;
        
        btnStartTask.hidden = YES;
        btnStopTask.hidden = YES;
        btnAcceptTask.hidden = YES;
        btnLocationTask.hidden = YES;
        btnRejectTask.hidden = YES;
        btnCompletedTask.hidden = YES;
        
        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), self.vwCallCenter.frame.size.height );
        self.vwCallCenter.hidden = NO;
        self.vwCallCenter.frame = tempFrame;
        
         tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwCallCenter.frame), CGRectGetWidth(MAIN_SCREEN), hSituation );
        self.vwSituation.frame = tempFrame;
        self.vwProgress.frame = CGRectMake(0, 0, CGRectGetWidth(MAIN_SCREEN), hSituation);
        self.vwSituation.hidden = NO;
        [self.vwSituation addSubview:self.vwProgress];
        [self.scrView addSubview:self.vwSituation];
        
         tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwSituation.frame), CGRectGetWidth(MAIN_SCREEN), self.vwRequestSupport.frame.size.height);
        self.vwRequestSupport.hidden = NO;
        self.vwRequestSupport.frame = tempFrame;
        [self.scrView addSubview:self.vwRequestSupport];
        
        
        self.scrView.contentSize = CGSizeMake(self.view.frame.size.width, self.vwRequestSupport.frame.origin.y + self.vwRequestSupport.frame.size.height + 50);
        

//        [self setupComponentsForTaskInProgress];
    } else if ([self.taskDetailInfor.name isEqualToString:@"Rejected"]) {
        self.taskState = TaskListTypeCompletedTaskList;
       
        CGFloat hTable = [self tableView:self.tblReviewRates numberOfRowsInSection:0]*44.0f + [self getHeightOfReviewFooter] + 30.f;
        CGFloat hSituation = hTable + 50.f;
        
        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), hSituation);
        self.vwRejectOrAcceptTask.hidden = YES;
        self.vwSituation.hidden = NO;
        self.vwSituation.frame = tempFrame;
        self.vwReview.frame = CGRectMake(0, 0, CGRectGetWidth(MAIN_SCREEN), hSituation);
        [self.vwSituation addSubview:self.vwReview];
        
        self.vwReview.hidden = NO;
        self.vwRequestSupport.hidden = YES;
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
         self.scrView.contentSize = CGSizeMake(CGRectGetWidth(MAIN_SCREEN), CGRectGetMaxY(self.vwSituation.frame) + 20);
        
    } else if ([self.taskDetailInfor.name isEqualToString:@"Task Complete"]) {        
        self.taskState = TaskListTypeCompletedTaskList;
        CGFloat hTable = [self tableView:self.tblReviewRates numberOfRowsInSection:0]*44.0f + [self getHeightOfReviewFooter] + 30.f;
        CGFloat hSituation = hTable + 80.0f;
        
        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), hSituation);

        self.vwRejectOrAcceptTask.hidden = YES;
        self.vwSituation.frame = tempFrame;
        self.vwSituation.hidden = NO;
        self.vwReview.frame = CGRectMake(0, 0, CGRectGetWidth(MAIN_SCREEN), hSituation);
        [self.vwSituation addSubview:self.vwReview];
        
        
        self.vwReview.frame = (CGRect){self.vwReview.frame.origin, self.vwSituation.frame.size};
        self.tblReviewRates.frame = (CGRect){CGPointMake(0.0f, 30.0f), CGSizeMake( CGRectGetWidth(MAIN_SCREEN), hTable)};
        
        
        tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwSituation.frame), self.vwRequestSupport.frame.size.width, self.vwRequestSupport.frame.size.height);
        self.vwRequestSupport.hidden = YES;
        self.vwRequestSupport.frame = tempFrame;
        [self.scrView addSubview:self.vwRequestSupport];
        
        //self.scrView.contentSize = CGSizeMake(self.view.frame.size.width, self.vwRequestSupport.frame.origin.y + self.vwRequestSupport.frame.size.height + 20);
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];

    } else if ([self.taskDetailInfor.name isEqualToString:@"Completed"]) {
        self.taskState = TaskListTypeCompletedTaskList;
        CGFloat hTable = [self tableView:self.tblReviewRates numberOfRowsInSection:0]*44.0f + [self getHeightOfReviewFooter] + 30.f;
        CGFloat hSituation = hTable + 50.0f;
        
        CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), hSituation);
        self.vwRejectOrAcceptTask.hidden = YES;
        self.vwSituation.hidden = NO;
        self.vwSituation.frame = tempFrame;
        self.vwReview.frame = CGRectMake(0, 0, CGRectGetWidth(MAIN_SCREEN), hSituation);
        [self.vwSituation addSubview:self.vwReview];
        self.vwReview.hidden = NO;
    }
    
    //set contentSize for scrollView
//    if (self.taskState == TaskListTypeInProgressTaskList) {
//        self.scrView.contentSize = CGSizeMake(self.view.frame.size.width, self.vwSituation.frame.origin.y + self.vwProgress.frame.size.height + self.vwRequestSupport.frame.size.height + 20);
//    } else if (self.taskState == TaskListTypeCompletedTaskList) {
//        self.scrView.contentSize = CGSizeMake(self.view.frame.size.width, self.vwSituation.frame.origin.y + self.vwReview.frame.size.height + 20);
//    } else {
//        self.scrView.contentSize = CGSizeMake(self.view.frame.size.width, self.vwSituation.frame.origin.y + 20);
//    }

}

- (CGFloat)getHeightOfReviewFooter {
    UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN.size.width - 20, 0)];
    
    
    lblComment.text = self.taskDetailInfor.review.comment ? self.taskDetailInfor.review.comment : @"";
//    lblComment.text = commentStr;
 //   [lblComment sizeToFit];
    lblComment.numberOfLines = 0;
    CGRect recLabel = lblComment.frame;
    CGSize sizeTxt = CGSizeMake( CGRectGetWidth(lblComment.frame) - 30.0f, FLT_MAX);
    CGRect rec = [lblComment.text boundingRectWithSize: sizeTxt
                                               options: NSStringDrawingUsesLineFragmentOrigin
                                            attributes: @{ NSFontAttributeName: lblComment.font}
                                               context: nil];
    recLabel.size.height = rec.size.height;
    
    return recLabel.size.height + 20;
}

- (void)setupComponentsForTaskInProgress {
    CGFloat hTable = [self tableView:self.tblConfirmProgress numberOfRowsInSection:0]*44.0f;
    CGFloat hSituation = hTable + 30.0f;
    
    CGRect tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), self.vwRejectOrAcceptTask.frame.size.height);
    self.vwRejectOrAcceptTask.hidden = NO;
    self.vwRejectOrAcceptTask.frame = tempFrame;
    [self.scrView addSubview:self.vwRejectOrAcceptTask];
    
    DLogInfo(@"%@", NSStringFromCGRect(self.vwRejectOrAcceptTask.frame));
    
    tempFrame = CGRectMake(0, (self.taskState == TaskListTypeInProgressTaskList) | TaskListTypePendingTaskList ? CGRectGetMaxY(self.vwRejectOrAcceptTask.frame) : CGRectGetMaxY(self.vwInfor.frame), CGRectGetWidth(MAIN_SCREEN), hSituation );
    self.vwSituation.frame = tempFrame;
    self.vwSituation.hidden = NO;
    [self.vwSituation addSubview:self.vwProgress];
    [self.scrView addSubview:self.vwSituation];
    
    
    
    CGRect frameWorkingOnTask = (CGRect){ self.vwProgress.frame.origin, self.vwSituation.frame.size};
    
    self.vwProgress.frame = frameWorkingOnTask;
    
    tempFrame = CGRectMake(0, CGRectGetMaxY(self.vwSituation.frame) + 20, CGRectGetWidth(MAIN_SCREEN), self.vwRequestSupport.frame.size.height);
    self.vwRequestSupport.hidden = NO;
    self.vwRequestSupport.frame = tempFrame;
    [self.scrView addSubview:self.vwRequestSupport];
    
   
//    btnCompletedTask.hidden = NO;
//    btnStopTask.hidden = NO;
//    btnRejectTask.hidden = YES;
//    btnAcceptTask.hidden =YES;
//    btnStartTask.hidden = YES;
    //self.scrView.contentSize = CGSizeMake(self.view.frame.size.width, self.vwSituation.frame.origin.y + self.vwSituation.frame.size.height + self.vwRequestSupport.frame.size.height + 50);
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

-(void)viewWillLayoutSubviews
{
    /////////////// SET UP CONTENT SIZE //////////
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrView.subviews)
    {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    
    self.scrView.contentSize = CGSizeMake(contentRect.size.width - 50, contentRect.size.height + 10.0f);
    
    if(vwConfirmStopTask)
    {
        self->vwConfirmStopTask.frame = MAIN_SCREEN;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableview datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    switch (self.taskState) {
//        case TaskListTypeInProgressTaskList: {
//            return [self.taskDetailInfor.progressHistory count];
//        }
//            
//            break;
//        case TaskListTypePendingTaskList: {
//            return [self.taskDetailInfor.progressHistory count];
//        }
//            break;
//        case TaskListTypeCompletedTaskList: {
//            return [self.arrReviewContent count];
//        }
//            break;
//        default:
//            break;
//    }
    if (tableView == self.tblConfirmProgress) {
        return [self.taskDetailInfor.progressHistory count];
    } else if (tableView == self.tblReviewRates) {
        return [self.arrReviewContent count];
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellProgressIdentifier = @"CellProgressIdentifer";
    static NSString *cellReviewIdentifier = @"CellReviewIdentifier";
    DCTableProgressCell *cellProgress;
    DCTableReviewCell *cellReview;
    if ((self.taskState == TaskListTypeInProgressTaskList || self.taskState == TaskListTypePendingTaskList) && tableView == self.tblConfirmProgress) {
        cellProgress = (DCTableProgressCell*)[tableView dequeueReusableCellWithIdentifier:cellProgressIdentifier];
        if (cellProgress == nil) {
//            cellProgress = [[DCTableProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellProgressIdentifier];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DCTableProgressCell" owner:nil options:nil];
            cellProgress = [nibs firstObject];
        }
        [cellProgress setProgressInforWithIndex:indexPath.row withTitleContent:self.taskDetailInfor];
        return cellProgress;
    } else if ((self.taskState == TaskListTypeCompletedTaskList || self.taskState == TaskListTypeCancelTask) && tableView == self.tblReviewRates) {
        cellReview = (DCTableReviewCell*)[tableView dequeueReusableCellWithIdentifier:cellReviewIdentifier];
        
        if (cellReview == nil) {
//            cellReview = [[DCTableReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReviewIdentifier];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DCTableReviewCell" owner:nil options:nil];
            cellReview = [nibs firstObject];
        }
//        cellReview.textLabel.text = [self.arrProgressContent objectAtIndex:indexPath.row];
        [cellReview setReviewInfoWithIndex:indexPath.row withTaskInfor:self.taskDetailInfor];
        return cellReview;
    }
    
    
    
    
   return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    if (tableView == self.tblConfirmProgress) {
        return 0;
    } else if (tableView == self.tblReviewRates) {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.tblConfirmProgress) {
        return 0;
    } else if (tableView == self.tblReviewRates) {
        UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN.size.width - 20, 20)];
        lblComment.text = self.taskDetailInfor.review.comment ? self.taskDetailInfor.review.comment : @"";
//        lblComment.text = commentStr;
        lblComment.numberOfLines = 0;
        CGRect recLabel = lblComment.frame;
        CGSize sizeTxt = CGSizeMake( CGRectGetWidth(lblComment.frame) - 30.0f, FLT_MAX);
        CGRect rec = [lblComment.text boundingRectWithSize: sizeTxt
                                                       options: NSStringDrawingUsesLineFragmentOrigin
                                                    attributes: @{ NSFontAttributeName: lblComment.font}
                                                       context: nil];
        recLabel.size.height = rec.size.height;
//        [lblComment sizeToFit];
        return recLabel.size.height + 20;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vwReview.frame.size.width, 30)];
    if (tableView == self.tblConfirmProgress) {
        footerView = nil;
    } else if (tableView == self.tblReviewRates) {
        UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, MAIN_SCREEN.size.width - 20, 50)];
        lblComment.text =  self.taskDetailInfor.review.comment;
        
//        lblComment.text = commentStr;
        lblComment.numberOfLines = 0;
        lblComment.font = [UIFont boldSystemFontOfSize:15];
        
        CGRect recLabel = lblComment.frame;
        CGSize sizeTxt = CGSizeMake( CGRectGetWidth(lblComment.frame) , FLT_MAX);
        CGRect rec = [lblComment.text boundingRectWithSize: sizeTxt
                                                       options: NSStringDrawingUsesLineFragmentOrigin
                                                    attributes: @{ NSFontAttributeName: lblComment.font}
                                                       context: nil];
        recLabel.size.height = rec.size.height;
        //        [lblComment sizeToFit];
        lblComment.frame = recLabel;
        
        CGRect tempFrame = CGRectMake(0, 10, MAIN_SCREEN.size.width, recLabel.size.height + 20);
        footerView.frame = tempFrame;
        [footerView addSubview:lblComment];
        footerView.backgroundColor = [UIColor clearColor];
    }
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   if (self.taskState == TaskListTypeInProgressTaskList && [tableView isEqual:self.tblConfirmProgress]) {
       
    
    DCTableProgressCell *cell = (DCTableProgressCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.btnCheck.selected = !cell.btnCheck.selected;
   }
}

#pragma mark - IBActions

- (IBAction)btnStartOnTouched:(id)sender {
    NSLog(@"Touch START \n");
    NSMutableDictionary *updateInfoDict = [[NSMutableDictionary alloc] init];
    [updateInfoDict setValue:@"start_task" forKey:@"action"];
    [updateInfoDict setValue:@"task" forKey:@"type"];
    [updateInfoDict setValue:nil forKey:@"reason"];
    [LoadingViewHelper showLoading];
    [DCApis updateTaskProgressWithId:[self.taskDetailInfor.uID integerValue] withCmd:updateInfoDict complete:^(BOOL success, ServerObjectBase *response) {
        if (success ) {
            // save room chat
//            [USER_DEFAULT_STANDARD setObject:self.taskDetailInfor.mStrCustomer_qb_room_id forKey:kDCWFChatRoomIDKey];
//            [USER_DEFAULT_STANDARD setObject:self.taskDetailInfor.mStrCustomer_qb_room_jId forKey:kDCWFChatRoomJIDKey];
            [self sendRequestGetTaskDetail];
        } else {
            //TODO
            //Inform that failure request
            [self sendRequestGetTaskDetail];
        }
        [LoadingViewHelper hideLoading];
    }];
    needReloadProgress = YES;
}

- (IBAction)btnRejectOnTouched:(id)sender {
    NSLog(@"Touch REJECT \n");
    NSMutableDictionary *updateInfoDict = [[NSMutableDictionary alloc] init];
    [updateInfoDict setValue:@"reject" forKey:@"action"];
    [updateInfoDict setValue:@"task" forKey:@"type"];
    [updateInfoDict setValue:[NSString stringWithFormat:@"%ld", (long)[self.taskDetailInfor.uID integerValue]] forKey:@"id"];
    [updateInfoDict setValue:nil forKey:@"reason"];
    [LoadingViewHelper showLoading];
    [DCApis updateTaskProgressWithId:[self.taskDetailInfor.uID integerValue] withCmd:updateInfoDict complete:^(BOOL success, ServerObjectBase *response) {
        if (success ) {
            [self sendRequestGetTaskDetail];
        } else {
            //TODO
            //Inform that failure request
            [self sendRequestGetTaskDetail];
        }
        [LoadingViewHelper hideLoading];
    }];
    needReloadProgress = YES;
}

- (IBAction)btnAcceptOnTouched:(id)sender {
    NSLog(@"Touch ACCEPT \n");
    NSMutableDictionary *updateInfoDict = [[NSMutableDictionary alloc] init];
    [updateInfoDict setValue:@"accept" forKey:@"action"];
    [updateInfoDict setValue:@"task" forKey:@"type"];
    [updateInfoDict setValue:nil forKey:@"reason"];
    [LoadingViewHelper showLoading];
    [DCApis updateTaskProgressWithId:[self.taskDetailInfor.uID integerValue] withCmd:updateInfoDict complete:^(BOOL success, ServerObjectBase *response) {
        if (success ) {
            [self sendRequestGetTaskDetail];
        } else {
            //TODO
            //Inform that failure request
            [self sendRequestGetTaskDetail];
        }
        [LoadingViewHelper hideLoading];
    }];
    needReloadProgress = YES;
}

- (IBAction)btnLocationOnTouched:(id)sender {
    NSLog(@"Touch LOCATION \n");
    NSMutableDictionary *updateInfoDict = [[NSMutableDictionary alloc] init];
    [updateInfoDict setValue:@"at_location" forKey:@"action"];
    [updateInfoDict setValue:@"task" forKey:@"type"];
    [updateInfoDict setValue:nil forKey:@"reason"];
    [LoadingViewHelper showLoading];
    [DCApis updateTaskProgressWithId:[self.taskDetailInfor.uID integerValue] withCmd:updateInfoDict complete:^(BOOL success, ServerObjectBase *response) {
        if (success ) {
            [self sendRequestGetTaskDetail];
        } else {
            //TODO
            //Inform that failure request
            [self sendRequestGetTaskDetail];
        }
        [LoadingViewHelper hideLoading];
    }];
    needReloadProgress = YES;
}

- (IBAction)btnCompletedTaskOnTouched:(id)sender {
    NSLog(@"Touch COMPLETED \n");
    NSMutableDictionary *updateInfoDict = [[NSMutableDictionary alloc] init];
    [updateInfoDict setValue:@"done" forKey:@"action"];
    [updateInfoDict setValue:@"task" forKey:@"type"];
    [updateInfoDict setValue:nil forKey:@"reason"];
    [LoadingViewHelper showLoading];
    [DCApis updateTaskProgressWithId:[self.taskDetailInfor.uID integerValue] withCmd:updateInfoDict complete:^(BOOL success, ServerObjectBase *response) {
        if (success ) {
            [self sendRequestGetTaskDetail];
        } else {
            //TODO
            //Inform that failure request
            [self sendRequestGetTaskDetail];
        }
        [LoadingViewHelper hideLoading];
    }];
    needReloadProgress = YES;
}

- (IBAction)btnStopTaskOnTouched:(id)sender {
    NSLog(@"Touch STOP \n");
    [self.view addSubview:vwConfirmStopTask];
    reasonTxtView.delegate = self;
    reasonTxtView.layer.borderColor = [[UIColor grayColor] CGColor];
    reasonTxtView.layer.borderWidth = 1.f;
    reasonTxtView.text = NSLocalizedString(@"Reason",nil);
    reasonTxtView.textColor = [UIColor lightGrayColor];
    [reasonTxtView setNeedsDisplay];
}

#pragma mark - UIView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor = [UIColor darkGrayColor];
    if ([textView.text isEqualToString:NSLocalizedString(@"Reason", nil)]) {
        textView.text = @"";
        
    } else {
        
    }
}

- (IBAction)cancelStopTaskOnTouched:(id)sender {
    [vwConfirmStopTask removeFromSuperview];
}

- (IBAction)confirmStopTaskOnTouched:(id)sender {
    
    //check blank text field
    NSString *pStrSend = [reasonTxtView text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [pStrSend stringByTrimmingCharactersInSet:whitespace];
    
    if ([reasonTxtView.text isEqualToString:NSLocalizedString(@"Reason",nil)] || [trimmed length] == 0) {
        //do nothing
    } else {
        
    NSMutableDictionary *updateInfoDict = [[NSMutableDictionary alloc] init];

    [updateInfoDict setValue:@"stop_task" forKey:@"action"];
    [updateInfoDict setValue:@"task" forKey:@"type"];
    [updateInfoDict setValue:[NSString stringWithFormat:@"%ld", (long)[self.taskDetailInfor.uID integerValue]] forKey:@"id"];
    [updateInfoDict setValue:reasonTxtView.text forKey:@"reason"];
    [LoadingViewHelper showLoading];
    [DCApis updateTaskProgressWithId:[self.taskDetailInfor.uID integerValue] withCmd:updateInfoDict complete:^(BOOL success, ServerObjectBase *response) {
        if (success ) {
            [self sendRequestGetTaskDetail];
        } else {
            //TODO
            //Inform that failure request
            [self sendRequestGetTaskDetail];
        }
        [LoadingViewHelper hideLoading];
    }];
        needReloadProgress = YES;
        [vwConfirmStopTask removeFromSuperview];
    }
}

- (IBAction)chatBtnTouched:(id)sender {
    // save room chat
//    [USER_DEFAULT_STANDARD setObject:self.taskDetailInfor.mStrCustomer_qb_room_id forKey:kDCWFChatRoomIDKey];
//    [USER_DEFAULT_STANDARD setObject:self.taskDetailInfor.mStrCustomer_qb_room_jId forKey:kDCWFChatRoomJIDKey];

    DCChatViewController *chatViewController = [DCChatViewController makeMeWithRoomID:self.taskDetailInfor.mStrCustomer_qb_room_id roomJID:self.taskDetailInfor.mStrCustomer_qb_room_jId phoneNum:nil];
    chatViewController.chatMode = DCChatModeWF;
    chatViewController.taskDetailFA = self.taskDetailInfor;
    [MAIN_NAVIGATION pushViewController:chatViewController animated:YES];
}

- (IBAction)phoneCallCenterTouched:(id)sender {
    
    
    if (self.taskDetailInfor.mobileNum == nil) {
        [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Phone number is empty", nil) callback:^(UIAlertView *al, NSInteger idx) {
            
        } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
    } else {
        //Call FA
        __weak typeof (self) thiz = self;
        phoneCallTarget = kPhoneCallTypeFA;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"str_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:NSLocalizedString(@"str_call", nil),self.taskDetailInfor.mobileNum == nil ? @"" : self.taskDetailInfor.mobileNum], nil];
        phoneCallTarget = kPhoneCallTypeFA;
        [actionSheet showInView:thiz.view];
    }

    
}



- (IBAction)locationTrackTouched:(id)sender {
    __weak typeof (self) thiz = self;
     __strong typeof (thiz) strongSelf = thiz;
    DCTrackingLocationViewController *pTrackingVC = [[DCTrackingLocationViewController alloc] initWithNibName:nil bundle:nil];
    pTrackingVC.mTeamMember = [strongSelf.taskDetailInfor.team.teamMembers firstObject];
    pTrackingVC.mTeam = strongSelf.taskDetailInfor.team;
    pTrackingVC.mTaskLo = strongSelf.taskDetailInfor.taskAddress.geoLocation;
    pTrackingVC.mUserId = [strongSelf.taskDetailInfor.team.teamId integerValue ];
    pTrackingVC.mAvgStar = [strongSelf.taskDetailInfor.review.avgScore floatValue];
    pTrackingVC.mQBInfo = [[DCQBUserInfo alloc] init];
    pTrackingVC.mQBInfo.roomID = strongSelf.taskDetailInfor.mStrCustomer_qb_room_id;
    pTrackingVC.mQBInfo.roomJID = strongSelf.taskDetailInfor.mStrCustomer_qb_room_jId;
    pTrackingVC.memberPhoneNumber = strongSelf.taskDetailInfor.mobileNum;
    [MAIN_NAVIGATION pushViewController:pTrackingVC animated:YES];
}

- (IBAction)chatSupportTouched:(id)sender {
    if (IS_FA_APP) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        [MAIN_NAVIGATION pushViewController:[DCChatViewController makeMeWithRoomID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomID roomJID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil] animated:YES];
    }
}

- (IBAction)phoneSupportTouched:(id)sender {

    if (APP_DELEGATE.mySettings.phoneNumber == nil) {
        [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Phone number is empty", nil) callback:^(UIAlertView *al, NSInteger idx) {
            
        } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
    } else {
        //Call HO
        __weak typeof (self) thiz = self;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"str_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"str_callcenter", nil), nil];
        phoneCallTarget = kPhoneCallTypeHO;
        [actionSheet showInView:thiz.view];
    }

   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [reasonTxtView resignFirstResponder];
}

#pragma mark - UIActionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (phoneCallTarget == kPhoneCallTypeFA) {
            NSString *pPhoneNumber = [@"telprompt://" stringByAppendingString:self.taskDetailInfor.mobileNum == nil ? @"" : self.taskDetailInfor.mobileNum];

            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pPhoneNumber]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pPhoneNumber]];
            } else {
                [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Can not call this phone number", nil) callback:^(UIAlertView *al, NSInteger idx) {
                    
                } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
            }
   
        } else if (phoneCallTarget == kPhoneCallTypeHO) {
            NSString *pPhoneNumber = [@"telprompt://" stringByAppendingString:APP_DELEGATE.mySettings.phoneNumber == nil ? @"" : APP_DELEGATE.mySettings.phoneNumber];
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pPhoneNumber]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pPhoneNumber]];
            } else {
                [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Can not call this phone number", nil) callback:^(UIAlertView *al, NSInteger idx) {
                    
                } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
            }
        }
    }
}

@end
