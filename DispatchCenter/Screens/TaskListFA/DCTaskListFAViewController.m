//
//  DCTaskListFAViewController.m
//  DispatchCenter
//
//  Created by VietHQ on 10/12/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskListFAViewController.h"
#import "DCBaseActiveTaskCell.h"
#import "DCApis.h"
#import "DCCalFrameActiveTask.h"
#import "DCActiveTaskInfo.h"
#import "DCActiveTaskModel.h"
#import "DCDetailTaskFAViewcontroller.h"
#import "DCChatViewController.h"


typedef NS_ENUM(NSInteger, DCActiveTaskViewControllerGroup)
{
    DCActiveTaskViewControllerGroupActive = 0,
    DCActiveTaskViewControllerGroupNotActive
};

static NSString *const kActiveTaskCellIndentifier = @"kActiveTaskCellIndentifier";
static CGFloat const kHeaderHeight = 30.0f;

@interface DCTaskListFAViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    BOOL isReload;
    
    UIRefreshControl *pullLoadingView;
    UIActivityIndicatorView *indicatorView;
    CGFloat _lastContentOffset;
}

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;

@property (weak, nonatomic) IBOutlet UITableView *mListTaskTblView;

@property (nonatomic, strong) NSMutableArray *mArrGroupActive;
@property (nonatomic, strong) NSMutableArray *mArrGroupNotActive;

@property (nonatomic, strong) NSMutableArray *mArrCellHeightActive;
@property (nonatomic, strong) NSMutableArray *mArrCellHeightNotActive;

@end

@implementation DCTaskListFAViewController

#pragma mark - init
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.mArrGroupActive = [[NSMutableArray alloc] initWithCapacity:200];
        self.mArrGroupNotActive = [[NSMutableArray alloc] initWithCapacity:200];
        
        self.mArrCellHeightActive = [[NSMutableArray alloc] initWithCapacity:100];
        self.mArrCellHeightNotActive = [[NSMutableArray alloc] initWithCapacity:100];
    }
    
    return self;
}

#pragma mark - view life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]] leftOrRight:NO target:self actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
    
    self.mTitleLabel.backgroundColor = [UIColor backgroundNavRegVC];
    
    self.mTitleLabel.text = NSLocalizedString(@"str_actived_task", nil);
    
    pullLoadingView = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -50, MAIN_SCREEN.size.width, 50)];
    pullLoadingView.backgroundColor = [UIColor clearColor];
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    indicatorView.center = pullLoadingView.center;
    [self.mListTaskTblView addSubview:pullLoadingView];
    
    ////////////////// LIST ACTIVE TASK TBL VIEW ////////////////////
    [self.mListTaskTblView registerNib:[UINib nibWithNibName:@"DCBaseActiveTaskCell" bundle:nil]
                forCellReuseIdentifier:kActiveTaskCellIndentifier];
    
    self.mListTaskTblView.delegate = self;
    self.mListTaskTblView.dataSource = self;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;

    ///////////////// GET DATA FROM SERVER /////////////////////////
    isReload = NO;
    [self getListActiveTask];
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

#pragma mark - load data
-(void)getListActiveTask
{
    __weak typeof (self) thiz = self;
    [LoadingViewHelper showLoadingWithText:NLS(@"Processing...")];
    [DCApis getTaskWithGroupWithComplete:^(BOOL success, ServerObjectBase *response) {
        [LoadingViewHelper hideLoading];
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                [strongSelf.mArrGroupActive removeAllObjects];
                [strongSelf.mArrGroupNotActive removeAllObjects];
                [strongSelf.mArrCellHeightActive removeAllObjects];
                [strongSelf.mArrCellHeightNotActive removeAllObjects];
                
//                if (isReload) {
//                    
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    hud.mode = MBProgressHUDModeText;
//                    hud.labelText = @" Task successfully";
//                    hud.removeFromSuperViewOnHide = YES;
//                    
//                    [hud hide:YES afterDelay:1.0f];
//                    
//                }
                
                DCActiveTaskInfo *pTaskParseModel = (DCActiveTaskInfo*)response;
                
                [strongSelf.mArrGroupActive addObjectsFromArray:pTaskParseModel.mArrActiveTask];
                [strongSelf.mArrGroupNotActive addObjectsFromArray:pTaskParseModel.mArrNotActiveTask];
                //DLogInfo(@" ~ %@", pTaskParseModel.mArrActiveTask);
                
                [strongSelf.mArrCellHeightActive addObjectsFromArray:pTaskParseModel.mArrFrameForActive];
                [strongSelf.mArrCellHeightNotActive addObjectsFromArray:pTaskParseModel.mArrFrameForNotActive];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.mListTaskTblView reloadData];
                });

            }
            
            else
            {
                //TODO: error
            }
            [indicatorView stopAnimating];
            [pullLoadingView endRefreshing];
        }
    }];
}

#pragma mark - UIScrollview delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.mListTaskTblView.contentOffset.y <= 0 ) {
        [indicatorView startAnimating];
        isReload = YES;
        [self getListActiveTask];
    } else {
        
        NSLog(@"table view offset === %@",NSStringFromCGPoint(self.mListTaskTblView.contentOffset));
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < 0) {
        NSLog(@"scroolll down \n");
        
    }
    
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        // we are at the end
        NSLog(@"scroolll down to the end \n");
        [self getListActiveTask];
    }
    
}
#pragma mark - tableview delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberCellInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellInIdxPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0 : kHeaderHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCBaseActiveTaskCell *pCell = [tableView dequeueReusableCellWithIdentifier:kActiveTaskCellIndentifier];
    
    
    /////////// CELL IN SECTION ACTIVE TASK /////////////
    if (indexPath.section == DCActiveTaskViewControllerGroupActive)
    {
        pCell.mGroupType = DCBaseActiveTaskCellTypeNew;
        if (self.mArrGroupActive.count)
        {
            [pCell calculateFrameWithObject:self.mArrCellHeightActive[indexPath.row]];
            DCActiveTaskModel *pModel = [self getActiveTaskInfoInIdxPath:indexPath];
            
            pCell.mTaskNameLabel.text = pModel.mTask;
            //DLogInfo(@" ~ task name %@", pModel.mTask);
            
            pCell.mStatusLabel.text = NSLocalizedString(pModel.mStrName,nil);
            pCell.mTimeLabel.text = pModel.mDueDate;
            //DLogInfo(@" ~ date %@", pModel.mDueDate);
            
            [pCell showBottomLine: indexPath.row < (self.mArrGroupActive.count - 1)];
        }
    }
    
    
    ////////// CELL IN SECTION NOT ACTIVE //////////////
    if (indexPath.section == DCActiveTaskViewControllerGroupNotActive)
    {
        if (self.mArrGroupNotActive.count)
        {
            pCell.mGroupType = DCBaseActiveTaskCellTypePending;
            [pCell calculateFrameWithObject:self.mArrCellHeightNotActive[indexPath.row]];
            DCActiveTaskModel *pModel = [self getActiveTaskInfoInIdxPath:indexPath];
            
            pCell.mTaskNameLabel.text = pModel.mTask;
            pCell.mStatusLabel.text = NSLocalizedString(pModel.mStrName,nil);
            pCell.mTimeLabel.text = pModel.mDueDate;
            
            [pCell showBottomLine: indexPath.row < (self.mArrGroupNotActive.count )];
        }
    }
    
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCDetailTaskFAViewcontroller *pTaskDetailVC = [[DCDetailTaskFAViewcontroller alloc] initWithNibName:@"DCDetailTaskFAViewcontroller" bundle:nil];
    
    DCActiveTaskModel *pActiveTask = [self getActiveTaskInfoInIdxPath:indexPath];
    //DLogInfo(@" ~ id: %li", pActiveTask.mId);
    pTaskDetailVC.mIdx = pActiveTask.mId;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:pTaskDetailVC animated:YES];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect s = [UIScreen mainScreen].bounds;
    UIView *pHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(s), 30.0f)];
    pHeaderView.backgroundColor = [UIColor yellowButton];
    
    UILabel *pTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 0.0f, CGRectGetWidth(s)-8.0f, 30.0f)];
    pTitleLabel.textColor = [UIColor whiteColor];
    pTitleLabel.text = [self titleForSection:section];
    
    [pHeaderView addSubview:pTitleLabel];
    
    return pHeaderView;
}

#pragma mark - tableview helper
-(NSString*)titleForSection:(NSInteger)section
{
    if (section == DCActiveTaskViewControllerGroupNotActive)
    {
        return NSLocalizedString(@"str_completed_task", nil);
    }
    
    return @"";
}

-(NSInteger)numberCellInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.mArrGroupActive.count;
    }
    
    if (section == 1)
    {
        return self.mArrGroupNotActive.count;
    }
    
    return 0;
}

-(CGFloat)heightForCellInIdxPath:(NSIndexPath*)idxPath
{
    if ( idxPath.section == DCActiveTaskViewControllerGroupActive &&
         self.mArrCellHeightActive.count)
    {
        DCCalFrameActiveTask *pCalFrame = (DCCalFrameActiveTask*)self.mArrCellHeightActive[idxPath.row];
        return pCalFrame.mCellHeight;
    }
    
    if ( idxPath.section == DCActiveTaskViewControllerGroupNotActive &&
         self.mArrCellHeightNotActive.count)
    {
        DCCalFrameActiveTask *pCalFrame = (DCCalFrameActiveTask*)self.mArrCellHeightNotActive[idxPath.row];
        return pCalFrame.mCellHeight;
    }
    
    return [DCCalFrameActiveTask minCellHeight];

}

-(DCActiveTaskModel*)getActiveTaskInfoInIdxPath:(NSIndexPath*)idx
{
    if (idx.section == DCActiveTaskViewControllerGroupActive)
    {
        if (self.mArrGroupActive.count)
        {
            return self.mArrGroupActive[idx.row];
        }
    }
    
    if (idx.section == DCActiveTaskViewControllerGroupNotActive)
    {
        if (self.mArrGroupNotActive.count)
        {
            return self.mArrGroupNotActive[idx.row];
        }
    }
    
    return nil;
}

@end
