//
//  DCTaskListWFViewController.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskListWFViewController.h"
#import "DCTaskWF.h"
#import "DCTaskListWFTypeInProgressCell.h"
#import "DCTaskListWFTypeNewCell.h"
#import "DCTaskListWFTypePendingAndCompletedCell.h"
#import "DCTaskListWFHeaderCell.h"
#import "DCApis.h"
#import "DCTaskCountWF.h"
#import "DCTaskDetailWFViewController.h"
#import "DCUtility.h"
#import "DCChatViewController.h"

#define IN_PROGRESS     @"in_progress"
//#define TO_DAY      @"Today"
//#define TOMORROW    @"Tomorrow"
//#define NEXT_3_DAYS @"Next 3 Days"

#define TO_DAY          0
#define TOMORROW        1
#define NEXT_3_DAYS     2
#define AFTER_3_DAYS    3

typedef enum : NSUInteger {
    TypeSecsionAllSection,
    TypeSecsionToDayAnTomorrow,
    TypeSecsionToDayAnThreeDay,
    TypeSecsionTomorrowAnThreeDay,
    TypeSecsionAfterThreeDay,
    TypeSecsionEmpty
} TypeSecsion;



static NSString *const kDCTaskListWFTypeInProgressCellIndentifier = @"kDCTaskListWFTypeInProgressCellIndentifier";
static NSString *const kDCTaskListWFTypeNewCellIndentifier = @"kDCTaskListWFTypeNewCellIndentifier";
static NSString *const kDCTaskListWFTypePendingAndCompletedCellIndentifier = @"kDCTaskListWFTypePendingAndCompletedCellIndentifier";
static NSString *const kDCTaskListWFHeaderCellIndentifier = @"kDCTaskListWFHeaderCellIndentifier";
@interface DCTaskListWFViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UILabel *titleTaskList;
    IBOutlet UITableView *taskListWFTableView;
    NSMutableArray *data;
    NSMutableArray *dataInprogressToDay;
    NSMutableArray *dataInprogressTomorrow;
    NSMutableArray *dataInprogressNextThreeDay;
    NSMutableArray *dataInprogressAfterThreeDay;
    NSMutableArray *dataInprogressSum;
    NSMutableArray *dataSectionNameSum;
    __weak IBOutlet UILabel *lblUpdateResult;
    BOOL isReload;
    
    UIRefreshControl *pullLoadingView;
    UIActivityIndicatorView *indicatorView;
}

@end

@implementation DCTaskListWFViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    if (_object)
        titleTaskList.text = NSLocalizedString(_object.name,nil);
    [taskListWFTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [taskListWFTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self setupViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
    isReload = NO;
    [self callAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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


- (void) setupViewController {
    //add reloading view to tableview
    if ([_object.code isEqualToString:IN_PROGRESS]) {
        
    } else {
        pullLoadingView = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -50, MAIN_SCREEN.size.width, 50)];
        pullLoadingView.backgroundColor = [UIColor clearColor];
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        indicatorView.center = pullLoadingView.center;
        [taskListWFTableView addSubview:pullLoadingView];
    }
    
    [taskListWFTableView registerNib:[UINib nibWithNibName:@"DCTaskListWFTypeInProgressCell" bundle:nil]
                  forCellReuseIdentifier:kDCTaskListWFTypeInProgressCellIndentifier];
    [taskListWFTableView registerNib:[UINib nibWithNibName:@"DCTaskListWFTypeNewCell" bundle:nil]
              forCellReuseIdentifier:kDCTaskListWFTypeNewCellIndentifier];
    [taskListWFTableView registerNib:[UINib nibWithNibName:@"DCTaskListWFTypePendingAndCompletedCell" bundle:nil]
              forCellReuseIdentifier:kDCTaskListWFTypePendingAndCompletedCellIndentifier];
    [taskListWFTableView registerNib:[UINib nibWithNibName:@"DCTaskListWFHeaderCell" bundle:nil]
              forCellReuseIdentifier:kDCTaskListWFHeaderCellIndentifier];
    
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]] leftOrRight:NO target:self actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
}



- (void) callAPI {
    [LoadingViewHelper showLoading];
    [DCApis getTaskGroupFWWithCode:_object.code complete:^(BOOL success, ServerObjectBase *response) {
        if (success) {
            DCTaskWF *rp = (DCTaskWF *)response;
            if (isReload) {
              
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = NSLocalizedString(@"str_success_task",nil);
                hud.removeFromSuperViewOnHide = YES;
            
                [hud hide:YES afterDelay:1.0f];
            
            }
            data = [rp.result copy];
        }
        [indicatorView stopAnimating];
        [pullLoadingView endRefreshing];
        [self refineDataInprogress];
        [taskListWFTableView reloadData];
        [LoadingViewHelper hideLoading];
    }];

}


#pragma mark - private method

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                           cls:(Class)cls
                        object:(DCTaskWFDetail *)obj{
    if (cls == [DCTaskListWFTypeNewCell class]) {
        DCTaskListWFTypeNewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDCTaskListWFTypeNewCellIndentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.info = [data objectAtIndex:indexPath.row];
        cell.taskGroup = _object;
        [cell fillDataToCell:obj];
        return cell;
    } else if (cls == [DCTaskListWFTypePendingAndCompletedCell class]) {
        DCTaskListWFTypePendingAndCompletedCell *cell = [tableView dequeueReusableCellWithIdentifier:kDCTaskListWFTypePendingAndCompletedCellIndentifier forIndexPath:indexPath];
        cell.taskGroup = _object;
        [cell fillDataToCell:obj];
        return cell;
    } else if (cls == [DCTaskListWFTypeInProgressCell class]) {
        DCTaskListWFTypeInProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:kDCTaskListWFTypeInProgressCellIndentifier forIndexPath:indexPath];
        cell.taskGroup = _object;
        [cell fillDataToCell:obj];
        return cell;
    }
    
    return nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (taskListWFTableView.contentOffset.y <= 0) {
        [indicatorView startAnimating];
        [self callAPI];
    } else {
    
    NSLog(@"table view offset === %@",NSStringFromCGPoint(taskListWFTableView.contentOffset));
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
        [self callAPI];
    }

}



#pragma mark - TableView Delegate And DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    int sectionCount = 0;
    if ([_object.code isEqualToString:IN_PROGRESS]) {
       return [dataInprogressSum count];
//        if (dataInprogressToDay.count > 0) {
//            sectionCount++;
//        }
//        if (dataInprogressTomorrow.count > 0) {
//            sectionCount++;
//        }
//        if (dataInprogressNextThreeDay.count > 0) {
//            sectionCount++;
//        }
//        if (dataInprogressAfterThreeDay.count > 0) {
//            sectionCount++;
//        }
//        return 4;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (data.count > 0){
        if ([_object.code isEqualToString:IN_PROGRESS]) {
            return [[dataInprogressSum objectAtIndex:section] count];
//       
//            if (section == TO_DAY)
//                return dataInprogressToDay.count;
//            else if (section == TOMORROW)
//                return dataInprogressTomorrow.count;
//            else if (section == NEXT_3_DAYS)
//                return dataInprogressNextThreeDay.count;
//            else if (section == AFTER_3_DAYS)
//                return dataInprogressAfterThreeDay.count;
        } else {
            return data.count;
        }
    }
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCTaskWFDetail *obj = nil;
    if ([_object.code isEqualToString:IN_PROGRESS]) {
        obj = [[dataInprogressSum objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
//        switch (indexPath.section) {
//            case TO_DAY:
//                obj = [dataInprogressToDay objectAtIndex:indexPath.row];
//                break;
//            case TOMORROW:
//                obj = [dataInprogressTomorrow objectAtIndex:indexPath.row];
//                break;
//            case NEXT_3_DAYS:
//                obj = [dataInprogressNextThreeDay objectAtIndex:indexPath.row];
//                break;
//            case AFTER_3_DAYS:
//                obj = [dataInprogressAfterThreeDay objectAtIndex:indexPath.row];
//                break;
//            default:
//                break;
//        }
    } else {
        obj = (DCTaskWFDetail *)[data objectAtIndex:indexPath.row];
    }
    
    if (obj.typeTask == TaskListTypeNewTaslList)
        return [self tableView:tableView cellForRowAtIndexPath:indexPath cls:[DCTaskListWFTypeNewCell class] object:obj];
    else if (obj.typeTask == TaskListTypeInProgressTaskList)
        return [self tableView:tableView cellForRowAtIndexPath:indexPath cls:[DCTaskListWFTypeInProgressCell class] object:obj];
    else if (obj.typeTask == TaskListTypeCompletedTaskList
             || obj.typeTask == TaskListTypePendingTaskList
             || obj.typeTask == TaskListTypeCancelTask
             || obj.typeTask == TaskListTypeRejectedTask)
        return [self tableView:tableView cellForRowAtIndexPath:indexPath cls:[DCTaskListWFTypePendingAndCompletedCell class] object:obj];
    else
        return [self tableView:tableView cellForRowAtIndexPath:indexPath cls:[DCTaskListWFTypePendingAndCompletedCell class] object:obj];
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_object.code isEqualToString:IN_PROGRESS])
        return 25.0f;
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([_object.code isEqualToString:IN_PROGRESS]) {
//        if (dataInprogressToDay.count <= 0 && section == TO_DAY)
//            return nil;
//        if (dataInprogressTomorrow.count <= 0 && section == TOMORROW)
//            return nil;
//        if (dataInprogressNextThreeDay.count <=0 && section == NEXT_3_DAYS)
//            return nil;
//        if (dataInprogressAfterThreeDay.count <=0 && section == AFTER_3_DAYS) {
//            return nil;
//        }
        DCTaskListWFHeaderCell *header = [tableView dequeueReusableCellWithIdentifier:kDCTaskListWFHeaderCellIndentifier];
        
        
        [header fillDataToCell:[dataSectionNameSum objectAtIndex:section]];
        return header.contentView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [MAIN_NAVIGATION pushViewController:[[DCTaskDetailWFViewController alloc] initWithNibName:@"DCTaskDetailWFViewController" bundle:nil] animated:YES];
    DCTaskDetailWFViewController *vc = [[DCTaskDetailWFViewController alloc] initWithNibName:@"DCTaskDetailWFViewController" bundle:nil];
    vc.taskState = [(DCTaskWFDetail*)[data objectAtIndex:indexPath.row] typeTask] ;
//    NSInteger section = indexPath.section;
    if ([_object.code isEqualToString:IN_PROGRESS]) {
        vc.taskDetailInfor = (DCTaskDetailWFInfo*)[[dataInprogressSum objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//         if (section == TO_DAY) {
//             vc.taskDetailInfor = (DCTaskDetailWFInfo*)[dataInprogressToDay objectAtIndex:indexPath.row];
//         } else if (section == TOMORROW) {
//             vc.taskDetailInfor = (DCTaskDetailWFInfo*)[dataInprogressTomorrow objectAtIndex:indexPath.row];
//         } else if (section == NEXT_3_DAYS) {
//             vc.taskDetailInfor = (DCTaskDetailWFInfo*)[dataInprogressNextThreeDay objectAtIndex:indexPath.row];
//         } else if (section == AFTER_3_DAYS) {
//             vc.taskDetailInfor = (DCTaskDetailWFInfo*)[dataInprogressAfterThreeDay objectAtIndex:indexPath.row];
//         }
     
    } else {
        vc.taskDetailInfor = (DCTaskDetailWFInfo *)[data objectAtIndex:indexPath.row];
    }
    
    [MAIN_NAVIGATION pushViewController:vc animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCTaskWFDetail *obj = (DCTaskWFDetail *)[data objectAtIndex:indexPath.row];
    if (obj.typeTask == TaskListTypeNewTaslList)
        return 165.0f;
    else if (obj.typeTask == TaskListTypeInProgressTaskList)
        return obj.height > 0 ? obj.height : 135.0f;
    else
        return 115.0f;
}

#pragma mark -  compare NSDate


- (void) refineDataInprogress{
    if ([_object.code isEqualToString:IN_PROGRESS]){
        if (dataInprogressToDay.count > 0)
            [dataInprogressToDay removeAllObjects];
        if (dataInprogressTomorrow.count > 0)
            [dataInprogressTomorrow removeAllObjects];
        if (dataInprogressNextThreeDay.count > 0)
            [dataInprogressNextThreeDay removeAllObjects];
        if (dataInprogressAfterThreeDay.count > 0) {
            [dataInprogressAfterThreeDay removeAllObjects];
        }
        dataInprogressToDay = [NSMutableArray new];
        dataInprogressTomorrow = [NSMutableArray new];
        dataInprogressNextThreeDay = [NSMutableArray new];
        dataInprogressAfterThreeDay = [NSMutableArray new];
        dataInprogressSum = [NSMutableArray new];
        dataSectionNameSum = [NSMutableArray new];
    }

    NSDate *currentDate  = [self getNextDayByCustomer:0];
    NSDate *tomorrowDate  = [self getNextDayByCustomer:1];
    NSDate *nextThreeDayDate = [self getNextDayByCustomer:3];
    if (data.count > 0) {
        for (DCTaskWFDetail *obj in data) {
            if (obj.due_date.length > 0) {
                NSString *strDate = [DCUtility autoConvertDateString:obj.due_date toStringWithFormat:kDateOnlyWithHyphenFormat];
                NSDate *dateCP = [DCUtility convertStringToDate:strDate inFormat:kDateOnlyWithHyphenFormat];
                if ([dateCP compare:currentDate] == NSOrderedSame || [dateCP compare:currentDate] == NSOrderedAscending)
                    [dataInprogressToDay addObject:obj];
                else if ([dateCP compare:tomorrowDate] == NSOrderedSame)
                    [dataInprogressTomorrow addObject:obj];
                else if ([dateCP compare:tomorrowDate] == NSOrderedDescending && ([dateCP compare:nextThreeDayDate] == NSOrderedAscending || [dateCP compare:nextThreeDayDate] == NSOrderedSame)){
                    DLogInfo(@"DateCp->>%@,tmmr->>%@,threeday->>%@",dateCP,tomorrowDate,nextThreeDayDate);;
            
                    [dataInprogressNextThreeDay addObject:obj];
                } else if ([dateCP compare:nextThreeDayDate] == NSOrderedDescending) {
                    [dataInprogressAfterThreeDay addObject:obj];
                }
                
            }
        }
    }
    
    /*
     #define TO_DAY      @"Today"
     #define TOMORROW    @"Tomorrow"
     #define NEXT_3_DAYS @"Next 3 Days"
     #define AFTER_3_DAYS @"More than 3 Days"
     */
    
    if (dataInprogressToDay.count > 0) {
        [dataInprogressSum addObject:dataInprogressToDay];
        [dataSectionNameSum addObject:NSLocalizedString(@"Today", nil)];
    }
    if (dataInprogressTomorrow.count > 0) {
        [dataInprogressSum addObject:dataInprogressTomorrow];
        [dataSectionNameSum addObject:NSLocalizedString(@"Tomorrow",nil)];
    }
    if (dataInprogressNextThreeDay.count > 0) {
        [dataInprogressSum addObject:dataInprogressNextThreeDay];
        [dataSectionNameSum addObject:NSLocalizedString(@"Next 3 Days",nil)];
    }
    if (dataInprogressAfterThreeDay.count > 0) {
        [dataInprogressSum addObject:dataInprogressAfterThreeDay];
        [dataSectionNameSum addObject:NSLocalizedString(@"More than 3 Days",nil)];
    }
    return;
}

- (NSDate *)getNextDayByCustomer:(NSInteger )nextDay {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = nextDay;
    NSDate *currentDate = [NSDate date];
    NSDate* newDate = [calendar dateByAddingComponents: components toDate:currentDate options: 0];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:kDateOnlyWithHyphenFormat];
    NSString *dateCV =[formatter stringFromDate:newDate];
    return [DCUtility convertStringToDate:dateCV inFormat:kDateOnlyWithHyphenFormat];;
}

#pragma mark - DCTaskCellNew delegate
- (void)acceptTaskWF:(UITableViewCell *)cell {
    NSLog(@"Touch ACCEPT \n");
    NSMutableDictionary *updateInfoDict = [[NSMutableDictionary alloc] init];
    [updateInfoDict setValue:@"accept" forKey:@"action"];
    [updateInfoDict setValue:@"task" forKey:@"type"];
    [updateInfoDict setValue:nil forKey:@"reason"];
    DCTaskListWFTypeNewCell *cellN = (DCTaskListWFTypeNewCell*)cell;
    DCTaskDetailWFInfo *obj = cellN.info;
    [DCApis updateTaskProgressWithId:[obj.uID integerValue] withCmd:updateInfoDict complete:^(BOOL success, ServerObjectBase *response) {
        if (success) {
            isReload = YES;
            [self callAPI];
        } else {
            //TODO
            //Inform that failure request
//            [self sendRequestGetTaskDetail];
        }
    }];
}

- (void)rejectTaskWF:(UITableViewCell *)cell {
    NSLog(@"Touch REJECT \n");
    NSMutableDictionary *updateInfoDict = [[NSMutableDictionary alloc] init];
    [updateInfoDict setValue:@"reject" forKey:@"action"];
    [updateInfoDict setValue:@"task" forKey:@"type"];
    [updateInfoDict setValue:nil forKey:@"reason"];
    DCTaskListWFTypeNewCell *cellN = (DCTaskListWFTypeNewCell*)cell;
    DCTaskDetailWFInfo *obj = cellN.info;
    [DCApis updateTaskProgressWithId:[obj.uID integerValue] withCmd:updateInfoDict complete:^(BOOL success, ServerObjectBase *response) {
        if (success && response) {
            isReload = YES;
            [self callAPI];
        } else {
            //TODO
            //Inform that failure request
//            [self sendRequestGetTaskDetail];
        }
    }];
}
@end
