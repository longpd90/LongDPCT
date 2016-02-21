//
//  DCInvoiceDetailWFViewController.m
//  DispatchCenter
//
//  Created by VietHQ on 11/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceDetailWFViewController.h"
#import "DCApis.h"
#import "DCInvoiceDetailFAInfo.h"
#import "DCInvoiceDetailHeaderCell.h"
#import "DCInvoiceDetailTextCell.h"
#import "DCInvoiceTwoColumnCell.h"
#import "DCChatViewController.h"


static CGFloat const kDefaultHeight = 30.0f;

typedef NS_ENUM(NSInteger, DCInvoiceDetailWFCellType)
{
    DCInvoiceDetailWFCellTypeInvoiceNo,
    DCInvoiceDetailWFCellTypeSummary,
    DCInvoiceDetailWFCellTypeTaskNo,
    DCInvoiceDetailWFCellTypeLocation,
    DCInvoiceDetailWFCellTypeTotal
};

@interface DCInvoiceDetailWFViewController ()<UITableViewDelegate, UITableViewDataSource>

@property( strong, nonatomic) DCInvoiceDetailWFInfo *mDetailManager;

@end

@implementation DCInvoiceDetailWFViewController

#pragma mark - View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mTitleLabel.backgroundColor = [UIColor backgroundNavRegVC];
    self.mTitleLabel.text = NSLocalizedString(@"str_detail", nil);
    
    
    
    ///////////////// NAV //////////////////
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]]
                      leftOrRight:NO
                           target:self
                          actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
    
    
    
    ///////////////// TBL VIEW ///////////////////
    [self.mInvoiceDetailTblView registerNib: [UINib nibWithNibName:@"DCInvoiceDetailHeaderCell" bundle:nil]
                     forCellReuseIdentifier: NSStringFromClass([DCInvoiceDetailHeaderCell class])];
    
    [self.mInvoiceDetailTblView registerNib: [UINib nibWithNibName:@"DCInvoiceDetailTextCell" bundle:nil]
                     forCellReuseIdentifier:NSStringFromClass([DCInvoiceDetailTextCell class])];
    
    [self.mInvoiceDetailTblView registerNib:[UINib nibWithNibName:@"DCInvoiceTwoColumnCell" bundle:nil]
                     forCellReuseIdentifier:NSStringFromClass([DCInvoiceTwoColumnCell class])];
    
    self.mInvoiceDetailTblView.delegate = self;
    self.mInvoiceDetailTblView.dataSource = self;
    self.mInvoiceDetailTblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getListDetail];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
}

#pragma mark - APIs
- (void)getListDetail
{
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis getInvoiceDetailWithId:self.mInvoiceId complete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                strongSelf.mDetailManager = (DCInvoiceDetailWFInfo*)response;
                DLogInfo(@"count %li", (long)strongSelf.mDetailManager.mDataWFFirstSection.count);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.mInvoiceDetailTblView reloadData];
                });
            }
            else
            {
                //TODO:
            }
        }
    }];
}


#pragma mark - Action callback
-(void)didSelectChatBtn:(id)sender
{
    if (IS_FA_APP) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        [MAIN_NAVIGATION pushViewController:[DCChatViewController makeMeWithRoomID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomID roomJID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil] animated:YES];
    }
}


-(void)didSelectMenuBtn:(id)sender
{
    [DCDropDownMenuViewController showMe];
}

#pragma mark - Tableview delegate & datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //DLogInfo(@"%li", self.mDetailManager.mDataWFFirstSection.count);
    return self.mDetailManager.mDataWFFirstSection.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > DCInvoiceDetailWFCellTypeSummary && indexPath.row <= DCInvoiceDetailWFCellTypeTotal)
    {
        DCInvoiceTwoColumnCell *pCell = (DCInvoiceTwoColumnCell*)[self twoColumnCell:indexPath];
        CGSize size = [pCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        //DLogInfo(@"H: %f", size.height);
        
        return MAX(kDefaultHeight, size.height + 1.0f);
    }
    
    if (indexPath.row == DCInvoiceDetailWFCellTypeSummary)
    {
        DCInvoiceDetailTextCell *pCell = (DCInvoiceDetailTextCell*)[self summaryCell];
        CGSize size = [pCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return MAX(kDefaultHeight, size.height + 1.0f);
    }
    
    if (indexPath.row == DCInvoiceDetailWFCellTypeInvoiceNo)
    {
        DCInvoiceDetailHeaderCell *pCell = (DCInvoiceDetailHeaderCell*)[self cellOnTop];
        CGSize size = [pCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return MAX(kDefaultHeight, size.height + 1.0f);
    }
    
    return kDefaultHeight; // default
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *pCell = nil;
    
    // invoice date & invoice no
    if ( indexPath.row == DCInvoiceDetailWFCellTypeInvoiceNo)
    {
        pCell = [self cellOnTop];
        return pCell;
    }
    
    // sumary
    if ( indexPath.row == DCInvoiceDetailWFCellTypeSummary)
    {
        pCell = [self summaryCell];
        return pCell;
    }
    
    // task no, locaton, total
    if (indexPath.row > DCInvoiceDetailWFCellTypeSummary && indexPath.row <= DCInvoiceDetailWFCellTypeTotal)
    {
        pCell = [self twoColumnCell:indexPath];
        return pCell;
    }
    
    
    return pCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - Tableview helper
- (UITableViewCell*)cellOnTop
{
    DCTwoColumnCellHelper *pData = [self.mDetailManager dataWFForItemInFirstSection:DCInvoiceDetailWFCellTypeInvoiceNo];
    
    DCInvoiceDetailHeaderCell *pCell = [self.mInvoiceDetailTblView dequeueReusableCellWithIdentifier:NSStringFromClass([DCInvoiceDetailHeaderCell class])];
    [pCell bindingDataForEntity:pData];
    
    pCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return pCell;
}

-(UITableViewCell*)summaryCell
{
    DCTwoColumnCellHelper *pData = [self.mDetailManager dataWFForItemInFirstSection:DCInvoiceDetailWFCellTypeSummary];
    
    DCInvoiceDetailTextCell *pCell = [self.mInvoiceDetailTblView dequeueReusableCellWithIdentifier: NSStringFromClass([DCInvoiceDetailTextCell class])];
    [pCell bindingDataForEntity:pData];
    
    pCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return pCell;
}

-(UITableViewCell*)twoColumnCell:(NSIndexPath*)idxPath
{
    DCTwoColumnCellHelper *pData = [self.mDetailManager dataWFForItemInFirstSection:idxPath.row];
    
    DCInvoiceTwoColumnCell *pCell = [self.mInvoiceDetailTblView dequeueReusableCellWithIdentifier: NSStringFromClass([DCInvoiceTwoColumnCell class])];
    
    if (idxPath.row == DCInvoiceDetailWFCellTypeLocation)
    {
        pCell.mTitleLabel.text = NSLocalizedString(@"str_location", nil);
        pCell.mContentLabel.text = self.mStrLocation ? : @"";
        
        [pCell setNeedsUpdateConstraints];
        [pCell updateConstraintsIfNeeded];
        [pCell setNeedsLayout];
        [pCell layoutIfNeeded];
    }
    else
    {
        [pCell bindingDataForEntity:pData];
    }
    
    pCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return pCell;
}

@end
