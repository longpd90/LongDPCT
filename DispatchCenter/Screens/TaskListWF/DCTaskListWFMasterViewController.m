//
//  DCTaskListWFMasterViewController.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskListWFMasterViewController.h"
#import "TaskListCell/DCTaskListMasterCell.h"
#import "DCTaskListWFViewController.h"
#import "DCTaskWF.h"
#import "DCApis.h"
#import "DCTaskCountWF.h"
#import "DCChatViewController.h"



static NSString *const kDCTaskListMasterCellIndentifier = @"kDCTaskListMasterCellIndentifier";


@interface DCTaskListWFMasterViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *taskListMasterTableView;
    
    NSMutableArray *listTaskMaster;
    UIRefreshControl *pullLoadingView;
    UIActivityIndicatorView *indicatorView;
    float contentOffSet;
    
}

@end

@implementation DCTaskListWFMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self callAPI];
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
    
    
}

- (void) setupViewController {
    [taskListMasterTableView registerNib:[UINib nibWithNibName:@"DCTaskListMasterCell" bundle:nil]
                  forCellReuseIdentifier:kDCTaskListMasterCellIndentifier];
    
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]] leftOrRight:NO target:self actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
    
    pullLoadingView = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -50, MAIN_SCREEN.size.width, 50)];
    pullLoadingView.backgroundColor = [UIColor clearColor];
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    indicatorView.center = pullLoadingView.center;
    [taskListMasterTableView addSubview:pullLoadingView];
}

- (void) callAPI {
    [LoadingViewHelper showLoading];
    [DCApis getTaskCountComplete:^(BOOL success, ServerObjectBase *response) {
        if (success) {
            DCTaskCountWF *dcResponse = (DCTaskCountWF *)response;
            if (dcResponse) {
                listTaskMaster = [dcResponse.result copy];
                [taskListMasterTableView reloadData];

            }
        } else {
            NSLog(@"loading task count FAILED \n");
        }
        [indicatorView stopAnimating];
        [pullLoadingView endRefreshing];
        [LoadingViewHelper hideLoading];
        if (!APP_DELEGATE.mMyProfile) {
            [APP_DELEGATE loadProfileIfNeed];
        }

    }];

}



#pragma mark - TableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (listTaskMaster.count > 0)
        return listTaskMaster.count;
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCTaskListMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:kDCTaskListMasterCellIndentifier forIndexPath:indexPath];
    if (!cell) {
        
    }
    DCtaskGroupWF *obj = (DCtaskGroupWF *)[listTaskMaster objectAtIndex:indexPath.row];
    [cell fillDataToCell:obj];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DCtaskGroupWF *obj = (DCtaskGroupWF *)[listTaskMaster objectAtIndex:indexPath.row];
    DCTaskListWFViewController *vc = [[DCTaskListWFViewController alloc] initWithNibName:@"DCTaskListWFViewController" bundle:nil];
    vc.object = obj;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0f;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    contentOffSet = taskListMasterTableView.contentOffset.y;
    if (taskListMasterTableView.contentOffset.y <= 0) {
        [indicatorView startAnimating];
//        [self callAPI];
    } else {
        
        NSLog(@"table view offset === %@",NSStringFromCGPoint(taskListMasterTableView.contentOffset));
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < contentOffSet) {
        NSLog(@"scroolll down \n");
        [self callAPI];
        contentOffSet = 0;
    }
    
    if (scrollView.contentOffset.y < 0) {
        NSLog(@"scroolll down \n");
        
    }
    
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        // we are at the end
        NSLog(@"scroolll down to the end \n");
      
    }
    
}

@end
