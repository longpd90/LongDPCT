//
//  DCTaskWF.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "ServerObjectBase.h"

typedef enum : NSUInteger {
    TaskListTypeAllTaskList,
    TaskListTypeNewTaslList,
    TaskListTypePendingTaskList,
    TaskListTypeInProgressTaskList,
    TaskListTypeCompletedTaskList,
    TaskListTypeCancelTask,
    TaskListTypeRejectedTask
} TaskListType;

@class DCTaskWFDetail;

@interface DCTaskWF : ServerObjectBase

@property (nonatomic, strong) NSMutableArray *result;
@property (nonatomic, strong) NSString *titleTaskListMaster;








@end

@interface DCTaskWFDetail : ServerObjectBase

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *due_date;
@property (nonatomic, strong) NSString *task;
@property (nonatomic, strong) NSNumber *amount_untaxed;
@property (nonatomic, strong) NSString *task_no;
@property (nonatomic, strong) NSNumber *amount_total;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) NSNumber *uID;
@property (nonatomic, strong) NSNumber *amount_tax;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, assign) TaskListType typeTask;
@property (nonatomic, assign) CGFloat height;

@end