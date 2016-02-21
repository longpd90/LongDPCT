//
//  DCInvoiceListFAViewController.m
//  DispatchCenter
//
//  Created by VietHQ on 11/3/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceListFAViewController.h"
#import "DCInvoiceCell.h"
#import "DCApis.h"
#import "DCInvoiceForListInfo.h"
#import "DCChatViewController.h"
#import "DCInvoiceDetailFAViewController.h"

static NSString *const kIdentifierInvoice = @"kIdentifierInvoice";
static CGFloat const kHeightCell = 59.0f;

@interface DCInvoiceListFAViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UIRefreshControl *pullLoadingView;
    UIActivityIndicatorView *indicatorView;
    CGFloat _lastContentOffset;
}

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *mInvoiceTblView;
@property (strong, nonatomic) NSMutableArray *mInvoiceList;

@end

@implementation DCInvoiceListFAViewController

#pragma mark - Init method
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.mInvoiceList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    
    return self;
}


#pragma mark - View life circle
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
    [self.mInvoiceTblView registerNib:[UINib nibWithNibName:@"DCInvoiceCell" bundle:nil] forCellReuseIdentifier:kIdentifierInvoice];
    self.mInvoiceTblView.delegate = self;
    self.mInvoiceTblView.dataSource = self;
    self.mInvoiceTblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //////// PULL LOADING VIEW //////////
    pullLoadingView = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -50, MAIN_SCREEN.size.width, 50)];
    pullLoadingView.backgroundColor = [UIColor clearColor];
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    indicatorView.center = pullLoadingView.center;
    [self.mInvoiceTblView addSubview:pullLoadingView];
    
    
    
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
                    [strongSelf.mInvoiceTblView reloadData];
                });
                [indicatorView stopAnimating];
                [pullLoadingView endRefreshing];
                [self.mInvoiceTblView reloadData];
                
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


#pragma mark - UIScrollview delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.mInvoiceTblView.contentOffset.y <= 0 ) {
        [indicatorView startAnimating];
        
        [self loadList];
    } else {
        
        NSLog(@"table view offset === %@",NSStringFromCGPoint(self.mInvoiceTblView.contentOffset));
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
    return kHeightCell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCInvoiceCell *pCell = [self.mInvoiceTblView dequeueReusableCellWithIdentifier:kIdentifierInvoice];
    pCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // set data
    DCInvoiceForListModel *pModel = self.mInvoiceList[indexPath.row];
    pCell.mTitleLabel.text = pModel.mStrTaskName;
    pCell.mTimeLabel.text = [pModel.mInvoiceDate dateMMDDYY] ? [NSString stringWithFormat:NSLocalizedString(@"str_invoice_date", nil), [pModel.mInvoiceDate dateMMDDYY]] : NSLocalizedString(@"Invoice Date:",nil);
    pCell.mStatutLabel.text = NSLocalizedString(pModel.mStatusName,nil);
    
    return pCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: select
    DCInvoiceForListModel *pModel = self.mInvoiceList[indexPath.row];
    
    DCInvoiceDetailFAViewController *pVC = [[DCInvoiceDetailFAViewController alloc] initWithNibName:@"DCInvoiceDetailFAViewController" bundle:nil];
    pVC.mInvoiceId = pModel.mId;
    
    [MAIN_NAVIGATION pushViewController:pVC animated:YES];
}

@end
