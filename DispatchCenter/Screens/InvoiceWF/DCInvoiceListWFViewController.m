//
//  DCInvoiceListWFViewController.m
//  DispatchCenter
//
//  Created by VietHQ on 11/4/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceListWFViewController.h"
#import "DCApis.h"
#import "DCInvoiceForListInfo.h"
#import "DCChatViewController.h"
#import "DCInvoiceWFCell.h"
#import "DCInvoiceDetailWFViewController.h"

static NSString *const kIdentifierInvoice = @"kIdentifierInvoice";
static CGFloat const kMinHeightCell = 79.0f;

@interface DCInvoiceListWFViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UIRefreshControl *pullLoadingView;
    UIActivityIndicatorView *indicatorView;
    CGFloat _lastContentOffset;
}

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *mInvoiceTableView;
@property (strong, nonatomic) NSMutableArray *mInvoiceList;

@end

@implementation DCInvoiceListWFViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.mInvoiceList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]]
                      leftOrRight:NO
                           target:self
                          actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
    
    
    ///////////// TITLE ///////////////
    self.mTitleLabel.backgroundColor = [UIColor backgroundNavRegVC];
    self.mTitleLabel.text = NSLocalizedString(@"str_invoice_title", nil);
    
    ///////////// TBL VIEW //////////////
    [self.mInvoiceTableView registerNib:[UINib nibWithNibName:@"DCInvoiceWFCell" bundle:nil] forCellReuseIdentifier:kIdentifierInvoice];
    self.mInvoiceTableView.delegate = self;
    self.mInvoiceTableView.dataSource = self;
    self.mInvoiceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //////// PULL LOADING VIEW //////////
    pullLoadingView = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -50, MAIN_SCREEN.size.width, 50)];
    pullLoadingView.backgroundColor = [UIColor clearColor];
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    indicatorView.center = pullLoadingView.center;
    [self.mInvoiceTableView addSubview:pullLoadingView];
    
    //////////// LOAD DATAS /////////////
    [self loadList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
}


#pragma mark - Load datas
- (void)loadList
{
    // id = 0, load all list
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis getInvoiceListWithComplete:^(BOOL success, ServerObjectBase *response){
        HIDE_LOADING;
        __strong typeof(thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                [strongSelf.mInvoiceList removeAllObjects];
                
                DCInvoiceForListInfo *pInvoiceContainer = (DCInvoiceForListInfo*)response;
                [strongSelf.mInvoiceList addObjectsFromArray:pInvoiceContainer.mInvoiceList];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.mInvoiceTableView reloadData];
                });
                
                [indicatorView stopAnimating];
                [pullLoadingView endRefreshing];
                [self.mInvoiceTableView reloadData];
            }
            else
            {
                //TODO: show error
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

#pragma mark - Tableview helper
-(void)fillDataToInvoiceWFCell:(DCInvoiceWFCell*)cell atIdxPath:(NSIndexPath*)idxPath
{
    DCInvoiceForListModel *pModel = (DCInvoiceForListModel*)self.mInvoiceList[idxPath.row];
    cell.mTitleLabel.text = pModel.mShortAddress;
    cell.mSumaryLabel.text = pModel.mStrTaskName;
    cell.mDateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"str_invoice_date", nil), [pModel.mInvoiceDate dateMMDDYYVersionTwo] ? : @""];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}

#pragma mark - UIScrollview delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.mInvoiceTableView.contentOffset.y <= 0 ) {
        [indicatorView startAnimating];
        
        [self loadList];
    } else {
        
        NSLog(@"table view offset === %@",NSStringFromCGPoint(self.mInvoiceTableView.contentOffset));
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
        [self loadList];
    }
    
}


#pragma mark - Tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mInvoiceList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCInvoiceWFCell *pCell = [self.mInvoiceTableView dequeueReusableCellWithIdentifier:kIdentifierInvoice];
    
    // fill data for updating height
    [self fillDataToInvoiceWFCell:pCell atIdxPath:indexPath];
    
    CGSize size = [pCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return MAX( kMinHeightCell, size.height + 1.0f);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCInvoiceWFCell *pCell = [self.mInvoiceTableView dequeueReusableCellWithIdentifier:kIdentifierInvoice];
    pCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self fillDataToInvoiceWFCell:pCell atIdxPath:indexPath];
        
    return pCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: select
    DCInvoiceDetailWFViewController *pVC = [[DCInvoiceDetailWFViewController alloc] initWithNibName:nil bundle:nil];
    DCInvoiceForListModel *pModel = (DCInvoiceForListModel*)self.mInvoiceList[indexPath.row];
    pVC.mInvoiceId = pModel.mId;
    pVC.mStrLocation = pModel.mShortAddress;
    
    [MAIN_NAVIGATION pushViewController:pVC animated:YES];
}



@end
