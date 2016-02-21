//
//  DCDetailTaskFAViewcontroller.m
//  DispatchCenter
//
//  Created by VietHQ on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCDetailTaskFAViewcontroller.h"
#import "DCTaskOneColumnTxtCell.h"
#import "DCTaskTwoColumnTxtCell.h"
#import "DCTaskButtonCell.h"
#import "DCPaymentTaskCell.h"
#import "DCTaskProgressCell.h"
#import "DCTeamButtonCell.h"
#import "DCTeamInfoCell.h"
#import "DCTaskFAReviewCell.h"
#import "DCTaskTextViewCell.h"
#import "DCTaskTwoButtonCell.h"
#import "DCApis.h"
#import "DCChatViewController.h"
#import "DCTaskDetailFAInfo.h"
#import "DCPaymentTaskDeitalModel.h"
#import "DCProgressHistoryModel.h"
#import "DCTeamTaskModel.h"
#import "DCActionSheetCallTeamLeader.h"
#import "DCReviewSectionModel.h"
#import "DCTrackingLocationViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "DCInvoiceDetailFAViewController.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterIOS7Style.h"

typedef NS_ENUM( NSInteger, DCDetailTaskFAVCSectionType)
{
    DCDetailTaskFAVCSectionTypeTaskDone,
    DCDetailTaskFAVCSectionTypePayment,
    DCDetailTaskFAVCSectionTypeProgress,
    DCDetailTaskFAVCSectionTypeTeam,
    DCDetailTaskFAVCSectionTypeReview
};


typedef NS_ENUM( NSInteger, DCDetailTaskFAVCReviewType)
{
    DCDetailTaskFAVCReviewTypeStarAvg,
    DCDetailTaskFAVCReviewTypeStarKnowHisJob,
    DCDetailTaskFAVCReviewTypeEquipment,
    DCDetailTaskFAVCReviewTypePricing
};

static CGFloat const kHeaderHeight = 30.0f;
static CGFloat const kMarginLeft = 15.0f;
static CGFloat const kDefaultHeightOneColumnTxt = 58.0f;
static CGFloat const kDefaultHeightTwoColumnTxt = 30.0f;
static CGFloat const kDefaultHeightBtn = 60.0f; // yellow btn
static CGFloat const kDefaultPaymentHeight = 119.0f;
static CGFloat const kDefaultCheckboxProgressHeight = 40.0f;
static CGFloat const kDefaultTeamBtnHeight = 40.0f;
static CGFloat const kDefaultTeamPersionHeight = 70.0f;
static CGFloat const kDefaultReviewHeight = 40.0f;
static CGFloat const kDefaultCommentHeight = 113.0f;



//static NSInteger const kNumbProgressCell = 8;
static NSInteger const kNumbReviewCell = 7;



static NSString* const kIdentifierOneColumnText = @"kIdentifierOneColumnText";
static NSString* const kIdentifierTwoColumnText = @"kIdentifierTwoColumnText";
static NSString* const kIdentifierBtn = @"kIdentifierBtn";
static NSString* const kIdentifierPayment =@"kIdentifierPayment";
static NSString* const kIdentifierProgress = @"kIdentifierProgress";
static NSString* const kIdentifierTeamBtn = @"kIdentifierTeamBtn";
static NSString* const kIdentifierTeamPersion = @"kIdentifierTeamPersion";
static NSString* const kIdentifierReview = @"kIdentifierReview";
static NSString* const kIdentifierComment = @"kIdentifierComment";
static NSString* const kIdentifierTwoButton = @"kIdentifierTwoButton";

@interface DCDetailTaskFAViewcontroller ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *mTblTask;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (nonatomic, strong) DCTaskDetailFAInfo *mTaskDetailModel;

@property (nonatomic, strong) NSMutableArray *mArrSecTaskDone;
@property (nonatomic, strong) NSMutableArray *mArrPaymentList;
@property (nonatomic, strong) NSMutableArray *mArrProgressList;

@property (nonatomic, strong) DCTeamTaskModel *mTeamModel;
@property (nonatomic, assign) BOOL mIsEditReview;

@property (nonatomic, copy) NSArray *mArrReviewTemp;
@property (nonatomic, strong) NSString *mCommentTemp;
@property (nonatomic, assign) BOOL isPaid;
@property (nonatomic, assign) NSInteger bankNumberSelect;

@end

@implementation DCDetailTaskFAViewcontroller

#pragma mark - Init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self)
    {
        self.mArrSecTaskDone = [[NSMutableArray alloc] initWithCapacity:30];
        self.mArrPaymentList = [[NSMutableArray alloc] initWithCapacity:30];
        self.mArrProgressList = [[NSMutableArray alloc] initWithCapacity:10];
        self.mTeamModel = nil;
    }
    
    return self;
}

#pragma mark - view life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mIsEditReview = NO;
    
    ////////////////////// LOAD DATA AT THE FIRST TIME //////////////////
    if (self.mIdx)
    {
        [self getTaskDetailInfor];
    }
    
    ///////////////////// SETTING NAVIGATION ////////////////////////////
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]] leftOrRight:NO target:self actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
    self.navigationController.navigationBar.translucent = NO;
    self.mTitleLabel.font = [UIFont largeBoldFont];
    self.mTitleLabel.backgroundColor = [UIColor backgroundNavRegVC];
    
    ////////////////// TBL VIEW //////////////////    
    self.view.backgroundColor = [UIColor backgroundNavRegVC];
    [self.mTblTask registerNib:[UINib nibWithNibName:@"DCTaskOneColumnTxtCell" bundle:nil]
        forCellReuseIdentifier:kIdentifierOneColumnText];
    [self.mTblTask registerNib:[UINib nibWithNibName:@"DCTaskTwoColumnTxtCell" bundle:nil]
        forCellReuseIdentifier:kIdentifierTwoColumnText];
    [self.mTblTask registerNib:[UINib nibWithNibName:@"DCTaskButtonCell" bundle:nil]
        forCellReuseIdentifier:kIdentifierBtn];
    [self.mTblTask registerNib:[UINib nibWithNibName:@"DCPaymentTaskCell" bundle:nil]
        forCellReuseIdentifier:kIdentifierPayment];
    [self.mTblTask registerNib:[UINib nibWithNibName:@"DCTaskProgressCell" bundle:nil]
        forCellReuseIdentifier:kIdentifierProgress];
    [self.mTblTask registerNib:[UINib nibWithNibName:@"DCTeamButtonCell" bundle:nil]
        forCellReuseIdentifier:kIdentifierTeamBtn];
    [self.mTblTask registerNib:[UINib nibWithNibName:@"DCTeamInfoCell" bundle:nil]
        forCellReuseIdentifier:kIdentifierTeamPersion];
    [self.mTblTask registerNib:[UINib nibWithNibName:@"DCTaskFAReviewCell" bundle:nil]
        forCellReuseIdentifier:kIdentifierReview];
    [self.mTblTask registerNib:[UINib nibWithNibName:@"DCTaskTextViewCell" bundle:nil]
        forCellReuseIdentifier:kIdentifierComment];
    [self.mTblTask registerNib:[UINib nibWithNibName:@"DCTaskTwoButtonCell" bundle:nil]
        forCellReuseIdentifier:kIdentifierTwoButton];
    
    self.mTblTask.estimatedRowHeight = UITableViewAutomaticDimension;
    self.mTblTask.delegate = self;
    self.mTblTask.dataSource = self;
    
    self.mTblTask.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // display title label
    MAIN_NAVIGATION.navigationBar.translucent = NO;
}

- (void)getTaskDetailInfor {
    [LoadingViewHelper showLoadingWithText:@""];
    __weak typeof (self) thiz = self;
    [DCApis getTaskDetailWithId:self.mIdx complete:^(BOOL success, ServerObjectBase *response) {
        [LoadingViewHelper hideLoading];
        if (success) {
            __strong typeof (thiz) strongSelf = thiz;
            if (strongSelf)
            {
                [strongSelf.mArrSecTaskDone removeAllObjects];
                [strongSelf.mArrPaymentList removeAllObjects];
                [strongSelf.mArrProgressList removeAllObjects];
                
                strongSelf.mTaskDetailModel = (DCTaskDetailFAInfo*)response;
                [strongSelf.mArrSecTaskDone addObjectsFromArray: strongSelf.mTaskDetailModel.mArrSecTaskDone];
                [strongSelf.mArrPaymentList addObjectsFromArray:strongSelf.mTaskDetailModel.mPaymentList];
                [strongSelf.mArrProgressList addObjectsFromArray:strongSelf.mTaskDetailModel.mProgressList];
                strongSelf.mTeamModel = strongSelf.mTaskDetailModel.mTeamModel;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.mTblTask reloadData];
                });
            }
        } else {
            
        }
        
        
     
    }];
}

#pragma mark - action callback
-(void)didSelectChatBtn:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didSelectMenuBtn:(id)sender
{
    [DCDropDownMenuViewController showMe];
}

- (BOOL)isInvoicePaid {
    return [[self.mTaskDetailModel.mStrInvoiceStatus lowercaseString] isEqualToString:@"paid"];
}

- (BOOL)isInvoiceNotExists {
    return self.mTaskDetailModel.mStrInvoiceStatus == nil;
}

#pragma mark - tbl delegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == DCDetailTaskFAVCSectionTypeTaskDone)
    {
        return 10;
    }
    
    if (section == DCDetailTaskFAVCSectionTypePayment)
    {
        static NSInteger minNumbCell = 1; // payment term, next payment, button
        
        if ([self isInvoiceNotExists]) {
            return 0;
        }
        
        else if ([self isInvoicePaid]) {
            return self.mArrPaymentList.count + minNumbCell ; //show only "Payment term" cell
        } else {
            return self.mArrPaymentList.count == 0 ?  2 : self.mArrPaymentList.count + minNumbCell + 2;
        }
        
//        return self.mArrPaymentList.count > 0 ? self.mArrPaymentList.count + minNumbCell : minNumbCell - 1;
    }
    
    if (section == DCDetailTaskFAVCSectionTypeProgress)
    {
        //return kNumbProgressCell;
        return self.mArrProgressList.count;
    }
    
    if (section == DCDetailTaskFAVCSectionTypeTeam)
    {
        static NSInteger minNumb = 1; // btn
        return !self.mTeamModel ? minNumb : self.mTeamModel.mArrMember.count + 1 + minNumb; // members + leader + btn
    }
    
    if (section == DCDetailTaskFAVCSectionTypeReview)
    {
        return kNumbReviewCell;
    }
    
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if ([self isInvoiceNotExists]) {
//        return 4;
//    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == DCDetailTaskFAVCSectionTypeTaskDone)
    {
        return [self heightForCellInSectionTaskDone:indexPath];
    }
    
    if (indexPath.section == DCDetailTaskFAVCSectionTypePayment)
    {
        return [self heightForCellInSectionPayment:indexPath];
    }
    
    if (indexPath.section == DCDetailTaskFAVCSectionTypeProgress)
    {
        return [self heightForCellInSectionProgress:indexPath];
    }
    
    if (indexPath.section == DCDetailTaskFAVCSectionTypeTeam)
    {
        return [self heightForCellInSectionTeam:indexPath];
    }
    
    if (indexPath.section == DCDetailTaskFAVCSectionTypeReview)
    {
        return [self heightForCellInSectionReview:indexPath];
    }
    
    return 50.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == DCDetailTaskFAVCSectionTypePayment && [self isInvoiceNotExists]) {
        return 0;
    }
    return section == 0 ? 0 : kHeaderHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect s = [UIScreen mainScreen].bounds;
    UIView *pHeader = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, CGRectGetWidth(s), kHeaderHeight)];
    pHeader.backgroundColor = [UIColor yellowButton];
    
    UILabel *pLbl = [[UILabel alloc] initWithFrame:CGRectMake( kMarginLeft, 0.0f, CGRectGetWidth(s) -kMarginLeft, kHeaderHeight)];
    pLbl.text = [self titleForHeaderInSection: section];
    pLbl.textColor = [UIColor whiteColor];
    pLbl.font = [UIFont normalBoldFont];
    [pHeader addSubview:pLbl];
    
    if ([self isInvoiceNotExists] && section == DCDetailTaskFAVCSectionTypePayment) {
        return nil;
    }
    
    return pHeader;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == DCDetailTaskFAVCSectionTypeTaskDone)
    {
        UITableViewCell *pCell = [self cellForSectionTaskDone:indexPath];
        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    
    if (indexPath.section == DCDetailTaskFAVCSectionTypePayment)
    {
        return [self cellForSectionPayment:indexPath];
    }
    
    if (indexPath.section == DCDetailTaskFAVCSectionTypeProgress) {
        return [self cellForSectionProgress:indexPath];
    }
    
    if (indexPath.section == DCDetailTaskFAVCSectionTypeTeam)
    {
        return [self cellForSectionTeam:indexPath];
    }
    
    if (indexPath.section == DCDetailTaskFAVCSectionTypeReview)
    {
        return [self cellForSectionReview:indexPath];
    }
    
    return [self defaultCell];
}

#pragma mark - txt for header
-(NSString*)titleForHeaderInSection:(NSInteger)secNum
{
    NSArray *pArrSectionStr = @[@"",NSLocalizedString(@"str_payment_detail",nil) , NSLocalizedString(@"str_task_progress",nil), NSLocalizedString(@"str_team",nil), NSLocalizedString(@"str_review",nil)];
    return pArrSectionStr[secNum] ? : @"";
}

#pragma mark - default cell
-(UITableViewCell*)defaultCell
{
    DCTaskOneColumnTxtCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierOneColumnText];
    pCell.mTitleLabel.text = @"title";
    return pCell;
}

#pragma mark - config cell for section task done
-(UITableViewCell*)cellForSectionTaskDone:(NSIndexPath*)idxPath
{
    ///////////////////// SUMMARY ///////////////////////
    if (idxPath.row == 0)
    {
        DCTaskOneColumnTxtCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierOneColumnText];
        pCell.mTitleLabel.text = [self titleForSectionTaskDone:idxPath];
        pCell.mTitleLabel.font = [UIFont normalFont];
        
        [pCell setNeedsUpdateConstraints];
        [pCell updateConstraintsIfNeeded];
        
        [pCell setNeedsLayout];
        [pCell layoutIfNeeded];
        
        pCell.clipsToBounds = YES;
        
        return pCell;
    }
    
    //////////////////// TASK DONE INFO ////////////////
    if (idxPath.row > 0 && idxPath.row < 9)
    {
        DCTaskTwoColumnTxtCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierTwoColumnText];
        pCell.mTitleLabel.text =  [self titleForSectionTaskDone:idxPath] ;
        BOOL showLine = idxPath.row == 1 || idxPath.row == 4 || idxPath.row == 8;
        [pCell showBorderUp:showLine];
        
        pCell.mContentLabel.text = self.mArrSecTaskDone.count > idxPath.row ? self.mArrSecTaskDone[idxPath.row] : @"";
        
        if (idxPath.row == 8) {
            [pCell.mContentLabel setFont:[UIFont boldSystemFontOfSize:14]];
        } else {
            [pCell.mContentLabel setFont:[UIFont systemFontOfSize:14]];
        }
        
        [pCell setNeedsUpdateConstraints];
        [pCell updateConstraintsIfNeeded];

        [pCell setNeedsLayout];
        [pCell layoutIfNeeded];
        
        return pCell;
    }
    
    /////////////////// BUTTON TASK DONE //////////////////////
    if (idxPath.row == 9)
    {
        DCTaskButtonCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierBtn];
        [pCell.mButton setTitle:NSLocalizedString(@"str_task_done", nil) forState:UIControlStateNormal];
        pCell.mIdxPath = idxPath;
        [pCell setClickButtonCallback:^(NSIndexPath *idxPath) {
            DLogInfo(@"click btn task done");
        }];
        
        //in case of Task New
        DCTaskDetailFAInfo *taskDetail = self.mTaskDetailModel;
        if ([taskDetail.mStrTaskName isEqualToString:@"New"] && idxPath.row == 9) {
            DCTaskTwoButtonCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierTwoButton];
            [pCell.mOkButton setTitle:NSLocalizedString(@"str_task_confirm", nil) forState:UIControlStateNormal];
            [pCell.mOkButton setBackgroundImage:[UIImage imageNamed:@"btn_accept"] forState:UIControlStateNormal];
//            [pCell.mOkButton addTarget:self action:@selector(confirmTask:) forControlEvents:UIControlEventTouchUpInside];
            __weak typeof (self) thiz = self;
            [pCell setClickOkBtn:^{
                [thiz confirmTask:nil];
            }];
            
            [pCell.mCancelButton setTitle:NSLocalizedString(@"str_task_cancel", nil) forState:UIControlStateNormal];
            [pCell.mCancelButton setBackgroundImage:[UIImage imageNamed:@"btn_reject"] forState:UIControlStateNormal];
            
            
            [pCell setClickCancelBtn:^{
                [thiz cancelTask:nil];
            }];
            return pCell;
        } else if ([taskDetail.mStrTaskName isEqualToString:@"Awaiting for Customer Approval"]) {
            DCTaskButtonCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierBtn];
            [pCell.mButton setTitle:NSLocalizedString(@"str_task_complete", nil) forState:UIControlStateNormal];
            [pCell.mButton setBackgroundImage:[UIImage imageNamed:@"btn_accept"] forState:UIControlStateNormal];
            
            __weak typeof (self) thiz = self;
            [pCell setClickButtonCallback:^(NSIndexPath *idxPath) {
                [thiz completeTask:nil];
            }];
            return pCell;
        } else {
            [pCell.mButton setHidden:YES];
        }
        
        [pCell setNeedsUpdateConstraints];
        [pCell updateConstraintsIfNeeded];
        
        [pCell setNeedsLayout];
        [pCell layoutIfNeeded];
        
        
        return pCell;
    }
    
    return [self defaultCell];
}

- (void)confirmTask:(id)sender {
    NSLog(@"Touch CONFIRM \n");
    NSMutableDictionary *updateInfoDict = [[NSMutableDictionary alloc] init];
    [updateInfoDict setValue:@"confirm" forKey:@"action"];
    [updateInfoDict setValue:@"task" forKey:@"type"];
    [updateInfoDict setValue:nil forKey:@"reason"];
    [LoadingViewHelper showLoading];
    [DCApis updateTaskProgressWithId:[self.mTaskDetailModel.mTaskId integerValue] withCmd:updateInfoDict complete:^(BOOL success, ServerObjectBase *response) {
        if (success) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = NSLocalizedString(@"Task successfully",nil);
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.0f];
            [self getTaskDetailInfor];
        } else {
            //TODO
            //Inform that failure request
            //            [self sendRequestGetTaskDetail];
        }
        [LoadingViewHelper hideLoading];
    }];
}

- (void)cancelTask:(id)sender {
    NSLog(@"Touch CANCEL \n");
    NSMutableDictionary *updateInfoDict = [[NSMutableDictionary alloc] init];
    [updateInfoDict setValue:@"cancel" forKey:@"action"];
    [updateInfoDict setValue:@"task" forKey:@"type"];
    [updateInfoDict setValue:nil forKey:@"reason"];
    [LoadingViewHelper showLoading];
    [DCApis updateTaskProgressWithId:[self.mTaskDetailModel.mTaskId integerValue] withCmd:updateInfoDict complete:^(BOOL success, ServerObjectBase *response) {
        if (success) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = NSLocalizedString(@"Task successfully",nil);
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.0f];
             [self getTaskDetailInfor];
        } else {
            //TODO
            //Inform that failure request
            //            [self sendRequestGetTaskDetail];
        }
        [LoadingViewHelper hideLoading];
    }];

}

- (void)completeTask:(id)sender {
    NSLog(@"Touch COMPLETE \n");
    NSMutableDictionary *updateInfoDict = [[NSMutableDictionary alloc] init];
    [updateInfoDict setValue:@"complete" forKey:@"action"];
    [updateInfoDict setValue:@"task" forKey:@"type"];
    [updateInfoDict setValue:nil forKey:@"reason"];
    [LoadingViewHelper showLoading];
    [DCApis updateTaskProgressWithId:[self.mTaskDetailModel.mTaskId integerValue] withCmd:updateInfoDict complete:^(BOOL success, ServerObjectBase *response) {
        if (success) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = NSLocalizedString(@"Task successfully",nil);
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.0f];
             [self getTaskDetailInfor];
        } else {
            //TODO
            //Inform that failure request
            //            [self sendRequestGetTaskDetail];
        }
        [LoadingViewHelper hideLoading];
    }];
}

-(NSString*)titleForSectionTaskDone:(NSIndexPath*)idx
{
    if (idx.row == 0)
    {
        return self.mArrSecTaskDone.count ? self.mArrSecTaskDone[0] : @"Summary";
    }
    
    NSArray *pArrTitles = @[ NSLocalizedString(@"str_create_date", nil),
                             NSLocalizedString(@"str_task", nil),
                             NSLocalizedString(@"str_total_amount", nil),
                             NSLocalizedString(@"str_due_date", nil),
                             NSLocalizedString(@"str_contact_name", nil),
                             NSLocalizedString(@"str_contact_mobile", nil),
                             NSLocalizedString(@"str_location", nil),
                             NSLocalizedString(@"str_status", nil)];
    
    return pArrTitles[idx.row-1];
}

-(CGFloat)heightForCellInSectionTaskDone:(NSIndexPath*)idxPath;
{
    if (idxPath.section == DCDetailTaskFAVCSectionTypeTaskDone)
    {
        if (idxPath.row == 0)
        {
            
            if (!self.mTaskDetailModel.mStrSummary.length)
            {
                return 0.0f;
            }
            
            return  MAX( kDefaultHeightOneColumnTxt, [self heightForOneColumnTextCellWithText:[self titleForSectionTaskDone:idxPath] withFont:[UIFont normalFont]]);
        }
        
        if (idxPath.row > 0 && idxPath.row < 9)
        {
            DCTaskTwoColumnTxtCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierTwoColumnText];
            pCell.mTitleLabel.text = [self titleForSectionTaskDone:idxPath];
            pCell.mContentLabel.text = self.mArrSecTaskDone.count > idxPath.row ? self.mArrSecTaskDone[idxPath.row] : @"";
            
            [pCell setNeedsUpdateConstraints];
            [pCell updateConstraintsIfNeeded];
            
            [pCell setNeedsLayout];
            [pCell layoutIfNeeded];
            
            CGSize size = [pCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            
            //DLogInfo(@"size %f", size.height);
            
            return MAX( kDefaultHeightTwoColumnTxt,size.height+1.0f);
        }
        
        if (idxPath.row == 9) {
            DCTaskDetailFAInfo *taskDetail = self.mTaskDetailModel;
            if (![taskDetail.mStrTaskName isEqualToString:@"New"] && ![taskDetail.mStrTaskName isEqualToString:@"Awaiting for Customer Approval"]) {
                return 0;
            } else {
                return kDefaultHeightBtn;
            }
        }
        
    }
    
    // default value
    return kDefaultHeightBtn;
}

-(CGFloat)heightForOneColumnTextCellWithText:(NSString*)txt withFont:(UIFont*)font
{
    DCTaskOneColumnTxtCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierOneColumnText];
    pCell.mTitleLabel.text = txt;
    pCell.mTitleLabel.font = font;
    
    [pCell setNeedsUpdateConstraints];
    [pCell updateConstraintsIfNeeded];
    
    [pCell setNeedsLayout];
    [pCell layoutIfNeeded];
    
    CGSize size = [pCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

#pragma mark - config cell for section Payment
-(UITableViewCell*)cellForSectionPayment:(NSIndexPath*)idxPath
{
    ///////////////////// TWO COLUMN TEXT CELL ////////////////////////
    NSInteger numbOfRow = [self tableView:self.mTblTask numberOfRowsInSection:DCDetailTaskFAVCSectionTypePayment];
    
    BOOL isTermPay = idxPath.row == 0;
    BOOL isNextPay ;
    if ([self isInvoicePaid]) {
        isNextPay = NO;
    } else {
        isNextPay = self.mArrPaymentList.count ? (idxPath.row == numbOfRow - 2) : idxPath.row == 1;
    }
    BOOL isTermOrNextPayment = isTermPay || isNextPay;
    if (isTermOrNextPayment)
    {
        DCTaskTwoColumnTxtCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierTwoColumnText];
        
        pCell.mTitleLabel.text = [self titleForSectionPayment:idxPath];
        
        isTermPay ? (pCell.mContentLabel.text = self.mTaskDetailModel.mStrPaymentTerm) :
                    (pCell.mContentLabel.text = self.mTaskDetailModel.mStrNextPayment);
//        if (isNextPay && [[self.mTaskDetailModel.mStrInvoiceStatus lowercaseString] isEqualToString:@"paid"]) {
//            pCell.hidden = YES;
//        }
        
        [pCell.mContentLabel setFont:[UIFont systemFontOfSize:14]];
        
        [pCell showBorderUp:((idxPath.row == numbOfRow - 2) && (idxPath.row != 0))];
        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    
    
    ///////////////// PAYMENT CELL ///////////////////
    BOOL isButtonCell;
    if ([self isInvoicePaid]) {
        isButtonCell = NO;
    } else {
       isButtonCell = idxPath.row == numbOfRow -1;
    }
    if (!isTermOrNextPayment && !isButtonCell)
    {
        DCPaymentTaskCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierPayment];
        
        if (idxPath.row <= self.mArrPaymentList.count) //start from 1 to number of ArrPaymentList
        {
            DCPaymentTaskDeitalModel *pModel = self.mArrPaymentList[idxPath.row -1 ] ;
            pCell.mPaymentMethodContentLabel.text = NSLocalizedString(pModel.mMethodName,nil);
            pCell.mPaymentDateContentLabel.text = pModel.mPayDate;
            pCell.mPaymentTotalAmountContentLabel.text = [NSString stringWithFormat:@"%@", pModel.mPaidAmount];
            pCell.mStatusContentLabel.text = NSLocalizedString(pModel.mStatus,nil);
            
        }
        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    
    
    ////////////////////// BTN /////////////////////////
    if (isButtonCell)
    {
        DCTaskButtonCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierBtn];
        if (idxPath.row <= self.mArrPaymentList.count ) //start from 1 to number of ArrPaymentList
        {
            DCPaymentTaskDeitalModel *pModel = self.mArrPaymentList[idxPath.row - 1 ] ; ;
         if ([[pModel.mStatus lowercaseString] isEqualToString:@"paid"]) {
             self.isPaid = YES;
            [pCell.mButton setHidden:YES];
             pCell.frame = CGRectZero;
         } else {
             [pCell.mButton setHidden:NO];
         }
        } else if (self.mArrPaymentList.count == 0) {
            [pCell.mButton setHidden:YES];
            pCell.frame = CGRectZero;
        } else {
            [pCell.mButton setHidden:NO];
        }
        [pCell.mButton setTitle:NSLocalizedString(@"Pay",nil) forState:UIControlStateNormal];
        [pCell setClickButtonCallback:^(NSIndexPath *indexPath) {
            
            DCInvoiceDetailFAViewController *pVC = [[DCInvoiceDetailFAViewController alloc] initWithNibName:@"DCInvoiceDetailFAViewController" bundle:nil];
            pVC.mInvoiceId = self.mTaskDetailModel.invoiceID;
            
            [MAIN_NAVIGATION pushViewController:pVC animated:YES];
            
            DLogInfo(@"click btn payment");
        }];
        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    
    return [self defaultCell];
}

-(NSString*)titleForSectionPayment:(NSIndexPath*)idxPath
{
    return idxPath.row == 0 ? NSLocalizedString(@"Payment Term",nil) : NSLocalizedString(@"Next Payment",nil);
}

-(CGFloat)heightForCellInSectionPayment:(NSIndexPath*)idxPath
{
    if (idxPath.section != DCDetailTaskFAVCSectionTypePayment)
    {
        return 0.0f;
    }
    
    NSInteger numbOfRow = [self tableView:self.mTblTask numberOfRowsInSection:DCDetailTaskFAVCSectionTypePayment];
    BOOL isFirst = idxPath.row == 0 ;
    if (isFirst) //Payment Term cell
    {
        return kDefaultHeightTwoColumnTxt;
    }
    
    BOOL isBeforeLast = idxPath.row == numbOfRow - 2;
    BOOL isLast = idxPath.row == numbOfRow -1;
    if ([self isInvoicePaid] && !isFirst) {
        return kDefaultPaymentHeight;
    } else if (![self isInvoicePaid]) {
        if (isBeforeLast) { //Next payment text cell
            return kDefaultHeightTwoColumnTxt;
        } else if (isLast && self.mArrPaymentList == 0) { //Button cell
            return kDefaultHeightTwoColumnTxt;
        } else if (isLast && self.mArrPaymentList > 0) {
            return kDefaultHeightBtn;
        } else {
            return kDefaultPaymentHeight;
        }
    }
    
    
//    if (!isFirst && !isLast)
//    {
//        return kDefaultPaymentHeight;
//    }
    
//    if (isLast && numbOfRow == 2) {
//        if (self.mArrPaymentList.count > 0) {
//            return kDefaultPaymentHeight;
//        } else {
//            return kDefaultHeightTwoColumnTxt;
//        }
//    }
    return kDefaultHeightBtn;
}

#pragma mark - config for Progress section
-(UITableViewCell*)cellForSectionProgress:(NSIndexPath*)idxPath
{
    if (idxPath.section != DCDetailTaskFAVCSectionTypeProgress)
    {
        return [self defaultCell];
    }
    
    DCTaskProgressCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierProgress];
//    pCell.mTitleLabel.text = [self titleForCellInSectionProgress:idxPath];
    
    if (idxPath.row < self.mArrProgressList.count)
    {
        DCProgressHistoryModel *pModel = self.mArrProgressList[idxPath.row];
        pCell.mCheckBoxButton.selected = [pModel isCheck];
        pCell.mTitleLabel.text = NSLocalizedString(pModel.mStrName,nil);
    }

    pCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return pCell;
}

-(NSString*)titleForCellInSectionProgress:(NSIndexPath*)idxPath
{
    if (idxPath.section != DCDetailTaskFAVCSectionTypeProgress)
    {
        return nil;
    }
    
//    NSArray *pArrTitle = @[ NSLocalizedString(@"str_order_confirmed", nil),
//                            NSLocalizedString(@"str_finding_you_an_operator", nil) ,
//                            NSLocalizedString(@"str_operator_on_the_way", nil) ,
//                            NSLocalizedString(@"str_operator_at_location", nil) ,
//                            NSLocalizedString(@"str_operator_working_task", nil),
//                            NSLocalizedString(@"str_operator_complete_task", nil) ,
//                            NSLocalizedString(@"str_awaiting_for_customer_approval", nil),
//                            NSLocalizedString(@"str_task_complete", nil) ];
    if (idxPath.row < self.mArrProgressList.count)
    {
        DCProgressHistoryModel *pModel = self.mArrProgressList[idxPath.row];
        return pModel.mStrStatusName ?  : @"";
    }
    return nil;
}

-(CGFloat)heightForCellInSectionProgress:(NSIndexPath*)idxPath
{
    return kDefaultCheckboxProgressHeight;
}

#pragma mark - config for team section
-(UITableViewCell*)cellForSectionTeam:(NSIndexPath*)idxPath
{
    if (idxPath.section != DCDetailTaskFAVCSectionTypeTeam)
    {
        return [self defaultCell];
    }
    
    if (idxPath.row == 0)
    {
        DCTeamButtonCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierTeamBtn];
        pCell.mPhoneNumber = [self.mTaskDetailModel.mTeamModel.mLeader.mStrPhoneNumb copy];
        pCell.mIdxPath = idxPath;
        
        NSString *pStrPhone = [pCell.mPhoneNumber copy];
        __weak typeof (self) thiz = self;
        DCActionSheetCallTeamLeader *pShowPhoneModel = [[DCActionSheetCallTeamLeader alloc] init];
        [pCell setClickCallButton:^(NSIndexPath *idxPath) {
            //DLogInfo(@"click call btn");
            if (pStrPhone == nil) {
                [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Phone number is empty", nil) callback:^(UIAlertView *al, NSInteger idx) {
                    
                } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
                
//                [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterIOS7Style new];
//                [JCNotificationCenter
//                 enqueueNotificationWithTitle:nil
//                 message:NSLocalizedString(@"Phone number is empty", nil)
//                 tapHandler:^{
//                     
//                 }];
            } else {
                [pShowPhoneModel showActionSheetInView:thiz.view withNumber:pStrPhone];
            }
        }];
        
        [pCell setClickChatButton:^(NSIndexPath *idxPath) {

            //DLogInfo(@"click chat btn");
            __strong typeof (thiz) strongSelf = thiz;
            if (strongSelf)
            {
                DCChatViewController *chatViewController = [DCChatViewController makeMeWithRoomID:strongSelf.mTaskDetailModel.mStrCustomer_qb_room_id roomJID:strongSelf.mTaskDetailModel.mStrCustomer_qb_room_jId phoneNum:nil];
                chatViewController.chatMode = DCChatModeFA;
                [MAIN_NAVIGATION pushViewController:chatViewController animated:YES];
            }
        }];
        
        [pCell setClickLocationButton:^(NSIndexPath *idxPath) {
            //DLogInfo(@"click location btn");
            __strong typeof (thiz) strongSelf = thiz;
            if (strongSelf)
            {
                DCTrackingLocationViewController *pTrackingVC = [[DCTrackingLocationViewController alloc] initWithNibName:nil bundle:nil];
                pTrackingVC.mTeamLeaderModel = strongSelf.mTaskDetailModel.mTeamModel.mLeader;
                pTrackingVC.mTaskLo = strongSelf.mTaskDetailModel.mLocationTask;
                pTrackingVC.mUserId = strongSelf.mTaskDetailModel.mTeamModel.mLeader.mUserId;
                pTrackingVC.mAvgStar = strongSelf.mTaskDetailModel.mReviewModel.mAvgStar;
                pTrackingVC.mQBInfo = [[DCQBUserInfo alloc] init];
                pTrackingVC.mQBInfo.roomID = strongSelf.mTaskDetailModel.mStrCustomer_qb_room_id;
                pTrackingVC.mQBInfo.roomJID = strongSelf.mTaskDetailModel.mStrCustomer_qb_room_jId;
                [MAIN_NAVIGATION pushViewController:pTrackingVC animated:YES];
            }
         }];

        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    
    BOOL isLeader = idxPath.row == 1;
    if (isLeader)
    {
        DCTeamInfoCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierTeamPersion];
        pCell.mNameLabel.text = self.mTeamModel.mLeader.mStrName;
        pCell.mPositionLabel.text = NSLocalizedString(@"str_team_leader", nil);
        pCell.mAvaImageView.backgroundColor = [UIColor grayColor];
        [pCell.mAvaImageView sd_setImageWithURL:[NSURL URLWithString:self.mTeamModel.mLeader.mStrImageURL]
                               placeholderImage: nil];
        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    else
    {
        DCTeamInfoCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierTeamPersion];
        BOOL memberIdx = idxPath.row - 2;
        if (memberIdx < self.mTeamModel.mArrMember.count)
        {
            DCMemberModel *pMember = (DCMemberModel*)self.mTeamModel.mArrMember[memberIdx];
            //DLogInfo(@"~ id %li", idxPath.row);
            pCell.mNameLabel.text = pMember.mStrName;
            pCell.mPositionLabel.text = NSLocalizedString(@"str_team_member", nil);
            pCell.mAvaImageView.backgroundColor = [UIColor grayColor];
            [pCell.mAvaImageView sd_setImageWithURL:[NSURL URLWithString:pMember.mStrImageURL]
                                   placeholderImage: nil];

        }
        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    
    
    return [self defaultCell];
}

-(CGFloat)heightForCellInSectionTeam:(NSIndexPath*)idxPath
{
    if (idxPath.section != DCDetailTaskFAVCSectionTypeTeam)
    {
        return 0;
    }
    
    // btn on top team section
    if (idxPath.row == 0)
    {
        return kDefaultTeamBtnHeight;
    }
    
    // team cell
    return kDefaultTeamPersionHeight;
}

#pragma mark - UIText view delegate 
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.mCommentTemp = textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.mCommentTemp = textView.text;
    NSLog(@"comment tmp editign ==== %@",self.mCommentTemp);
}

#pragma mark - config cell for section review
-(UITableViewCell*)cellForSectionReview:(NSIndexPath*)idxPath
{
    if (idxPath.section != DCDetailTaskFAVCSectionTypeReview)
    {
        return [self defaultCell];
    }
    
    ////////////// REVIEW BY STAR ////////////
    NSInteger numCellInSec = [self tableView:self.mTblTask numberOfRowsInSection:DCDetailTaskFAVCSectionTypeReview];
    if (idxPath.row < numCellInSec - 2)
    {
        DCTaskFAReviewCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierReview];
        pCell.mTitleLabel.text = [self titleForCellInSectionReview:idxPath];
        pCell.mIdxPath = idxPath;
        
        if (idxPath.row == DCDetailTaskFAVCReviewTypeStarAvg)
        {
            [pCell settingStar:self.mTaskDetailModel.mReviewModel.mAvgStar];
        }
        else if( self.mTaskDetailModel.mReviewModel.mArrStarModel.count > idxPath.row - 1)
        {
            DCStarModel *pStar = self.mTaskDetailModel.mReviewModel.mArrStarModel[idxPath.row-1];
            [pCell settingStar:pStar.mStarValue];
            if (!self.mIsEditReview)
            {
                NSMutableArray *pArrTemp = [[NSMutableArray alloc] initWithCapacity:5];
                for (DCStarModel *pStar in self.mTaskDetailModel.mReviewModel.mArrStarModel)
                {
                    [pArrTemp addObject:@(pStar.mStarValue)];
                }
                self.mArrReviewTemp = nil;
                self.mArrReviewTemp = [pArrTemp copy];
            }
        }
        else
        {
            [pCell settingStar:0];
        }
        
        // update star value for sending data to server
        __weak typeof (self) thiz = self;
        [pCell setUpdateStar:^(CGFloat starValue, NSIndexPath *idxPath) {
            //DLogInfo(@"star %li at row %li", (long)starValue, (long)idxPath.row);
            __strong typeof (thiz) strongSelf = thiz;
            if (strongSelf)
            {
                if (strongSelf.mTaskDetailModel.mReviewModel.mArrStarModel == nil) {
                    strongSelf.mTaskDetailModel.mReviewModel.mArrStarModel = [[NSMutableArray alloc] initWithCapacity:5];
                }
                
                NSArray *pStarArr = strongSelf.mTaskDetailModel.mReviewModel.mArrStarModel;
                DLogInfo(@"length %li", (long)pStarArr.count);
                if (idxPath.row > 0 && pStarArr.count > idxPath.row - 1)
                {
                    DCStarModel *pStarModel = pStarArr[idxPath.row - 1];
                    pStarModel.mStarValue = starValue;
                }
            }
        }];
        
        if ( !self.mIsEditReview)
        {
            [pCell enableEditStarByTouch:NO];
        }
        else
        {
            BOOL isAvgReviewCell = idxPath.row == 0;
            [pCell enableEditStarByTouch: isAvgReviewCell ? NO : YES];
        }
        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    
    ///////////// COMMENT CELL ///////////////
    if (idxPath.row == numCellInSec - 2 && self.mIsEditReview)
    {
        DCTaskTextViewCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierComment];
        pCell.mCommentTextView.text = self.mTaskDetailModel.mReviewModel.mStrComment.length ? self.mTaskDetailModel.mReviewModel.mStrComment : @"";
        pCell.mCommentTextView.delegate = self;
        self.mCommentTemp = [pCell.mCommentTextView.text copy];
        [pCell setUpdateReviewComment:^(NSString *strComment) {
            self.mCommentTemp = strComment;
        }];
        
        pCell.clipsToBounds = YES;
        
        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    else if (idxPath.row == numCellInSec - 2 && !self.mIsEditReview)
    {
        DCTaskOneColumnTxtCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierOneColumnText];
        pCell.mTitleLabel.text = self.mTaskDetailModel.mReviewModel.mStrComment.length ? self.mTaskDetailModel.mReviewModel.mStrComment : @"";
        

        
        pCell.mTitleLabel.font = [UIFont normalBoldFont];
        
        [pCell setNeedsUpdateConstraints];
        [pCell updateConstraintsIfNeeded];
        
        [pCell setNeedsLayout];
        [pCell layoutIfNeeded];
        
        pCell.clipsToBounds = YES;

        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    
    ///////////// BTN CELL //////////////////
    if (idxPath.row == numCellInSec - 1 && self.mIsEditReview)
    {
        DCTaskTwoButtonCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierTwoButton];
//        pCell.mOkButton.backgroundColor = [UIColor yellowButton];
//        pCell.mCancelButton.backgroundColor = [UIColor yellowButton];
        [pCell.mOkButton setTitle:NSLocalizedString(@"str_confirm_review", nil) forState:UIControlStateNormal];
        [pCell.mOkButton setBackgroundImage:[UIImage imageNamed:@"bg_login_button"] forState:UIControlStateNormal];
        [pCell.mCancelButton setTitle:NSLocalizedString(@"str_cancel_review", nil) forState:UIControlStateNormal];
        [pCell.mCancelButton setBackgroundImage:[UIImage imageNamed:@"bg_login_button"] forState:UIControlStateNormal];
        
        __weak typeof (self) thiz = self;
        [pCell setClickOkBtn:^{
            __strong typeof(thiz) strongSelf = thiz;
            if (strongSelf)
            {
                [strongSelf.view endEditing:YES];
                strongSelf.mTaskDetailModel.mReviewModel.mStrComment = strongSelf.mCommentTemp;
                DLogInfo(@"mComment temp === %@\n", strongSelf.mCommentTemp);
//                strongSelf.mCommentTemp = nil;
                DLogInfo(@"dict review send to server %@", [strongSelf.mTaskDetailModel.mReviewModel jsonDataSendToServer]);
                SHOW_LOADING;
                
                [DCApis updateTaskReviewFAWithCmd: [strongSelf.mTaskDetailModel.mReviewModel jsonDataSendToServer]
                                        andIdTask: strongSelf.mIdx complete:^(BOOL success, ServerObjectBase *response) {
                                            HIDE_LOADING;
                                            
                                            if (strongSelf)
                                            {
                                                if (success)
                                                {
                                                    strongSelf.mIsEditReview = NO;
                                                    strongSelf.mCommentTemp = nil;
                                                    NSDictionary *pReviewUpdate = ((DCReviewSectionModel*)response).mReviewUpdateDict;
                                                    strongSelf.mTaskDetailModel.mReviewModel = [[DCReviewSectionModel alloc] initWithDrawDictFromServer:pReviewUpdate];
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [strongSelf.mTblTask reloadData];
                                                    });
                                                }
                                                else
                                                {
                                                    //TODO: error
                                                }
                                            }
                                        }];

            }
        }];
        

        [pCell setClickCancelBtn:^{
            __strong typeof (thiz) strongSelf = thiz;
            if (strongSelf)
            {
                strongSelf.mIsEditReview = NO;
                NSArray *pArrStar = self.mTaskDetailModel.mReviewModel.mArrStarModel;
                for (NSInteger i = 0; i < pArrStar.count; ++i)
                {
                    DCStarModel *pStarModel = pArrStar[i];
                    pStarModel.mStarValue = [self.mArrReviewTemp[i] floatValue];
                }
                strongSelf.mCommentTemp = nil; // reset temp
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.mTblTask reloadData];
                });
            }

        }];
        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    else if( idxPath.row == numCellInSec - 1 && !self.mIsEditReview)
    {
        DCTaskButtonCell *pCell = [self.mTblTask dequeueReusableCellWithIdentifier:kIdentifierBtn];
        [pCell.mButton setHidden:NO];
        [pCell.mButton setBackgroundImage:[UIImage imageNamed:@"bg_login_button"] forState:UIControlStateNormal];
        if (self.mTaskDetailModel.mReviewModel.mAvgStar != 0 || self.mTaskDetailModel.mReviewModel.mStrComment.length > 0) {
           
            [pCell.mButton setTitle:NSLocalizedString(@"str_edit_review", nil) forState:UIControlStateNormal];
        } else {
            [pCell.mButton setTitle:NSLocalizedString(@"str_review", nil) forState:UIControlStateNormal];
        }
        [pCell setClickButtonCallback:^(NSIndexPath *idxPath) {
            self.mIsEditReview = YES;
            [self.mTblTask reloadData];
        }];
        pCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return pCell;
    }
    
    return [self defaultCell];
}

-(NSString*)titleForCellInSectionReview:(NSIndexPath*)idxPath
{
    if (idxPath.section != DCDetailTaskFAVCSectionTypeReview)
    {
        return nil;
    }
    
    NSArray *pArrTitle = @[ NSLocalizedString( @"str_average_rating",nil),
                            NSLocalizedString( @"str_knowing_his_job", nil) ,
                            NSLocalizedString( @"str_was_on_time", nil) ,
                            NSLocalizedString( @"str_had_the_right_equipment", nil) ,
                            NSLocalizedString( @"str_pricing", nil) ];
    return pArrTitle[idxPath.row] ? : @"";
}

-(CGFloat)heightForCellInSectionReview:(NSIndexPath*)idxPath
{
    if (idxPath.section != DCDetailTaskFAVCSectionTypeReview)
    {
        return 0;
    }
    
    NSInteger numCellInSec = [self tableView:self.mTblTask numberOfRowsInSection:DCDetailTaskFAVCSectionTypeReview];
    
    // comment cell
    if (idxPath.row == numCellInSec - 2)
    {
        //NSString *pTxtComment = self.mTaskDetailModel.mReviewModel.mStrComment ? : NSLocalizedString(@"str_no_comment", nil);
        NSString *pTxtComment = self.mTaskDetailModel.mReviewModel.mStrComment ? : @"";
        
        if (!self.mIsEditReview && [pTxtComment isEqualToString:NSLocalizedString(@"str_no_comment", nil)])
        {
            return 0.0f;
        }
        
        return self.mIsEditReview ? kDefaultCommentHeight : MAX( kDefaultHeightOneColumnTxt,
                                                                [self heightForOneColumnTextCellWithText:pTxtComment withFont:[UIFont normalBoldFont]]) ;
    }
    
    // button
    if (idxPath.row == numCellInSec - 1)
    {
        return kDefaultHeightBtn;
    }
    
    return kDefaultReviewHeight;
}

@end
