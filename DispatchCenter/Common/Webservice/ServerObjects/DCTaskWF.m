//
//  DCTaskWF.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskWF.h"

@implementation DCTaskWF

- (id) init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void) parseResponse:(NSDictionary *)response {
    if (response && [response isKindOfClass:[NSArray class]]) {
        if (self.result.count > 0)
            [self.result removeAllObjects];
        self.result = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in response) {
            DCTaskWFDetail *dcTaskFW = [DCTaskWFDetail new];
            id idStatus = [dic objectForKey:@"status"];
            if (idStatus && [idStatus isKindOfClass:[NSDictionary class]]) {
                dcTaskFW.code = [idStatus objectForKey:@"code"];
                dcTaskFW.name = [idStatus objectForKey:@"name"];
                dcTaskFW.typeTask = [self gettypeWithCode:dcTaskFW.code];
            }
            id idTaskLocation = [dic objectForKey:@"short_address"];
            if (idTaskLocation && [idTaskLocation isKindOfClass:[NSString class]]) {
                dcTaskFW.locationName = idTaskLocation;
            }
            id idTask = [dic objectForKey:@"task"];
            if (idTask && [idTask isKindOfClass:[NSString class]])
                dcTaskFW.task = idTask;
            id idAmount_untaxed = [dic objectForKey:@"amount_untaxed"];
            if (idAmount_untaxed && [idAmount_untaxed isKindOfClass:[NSNumber class]])
                dcTaskFW.amount_untaxed = idAmount_untaxed;
            id idTaskNo = [dic objectForKey:@"task_no"];
            if (idTaskNo && [idTaskNo isKindOfClass:[NSString class]])
                dcTaskFW.task_no = idTaskNo;
            id idAmountTotal = [dic objectForKey:@"amount_total"];
            if (idAmountTotal && [idAmountTotal isKindOfClass:[NSNumber class]])
                dcTaskFW.amount_total = idAmountTotal;
            id idActive = [dic objectForKey:@"active"];
            if (idActive && [idActive isKindOfClass:[NSNumber class]])
                dcTaskFW.active = [idActive boolValue];
            id idUid = [dic objectForKey:@"id"];
            if (idUid && [idUid isKindOfClass:[NSNumber class]])
                dcTaskFW.uID = idUid;
            id idAmountTax = [dic objectForKey:@"amount_tax"];
            if (idAmountTax && [idAmountTax isKindOfClass:[NSNumber class]])
                dcTaskFW.amount_tax = idAmountTax;
            id idSummary = [dic objectForKey:@"summary"];
            if (idSummary && [idSummary isKindOfClass:[NSString class]])
                dcTaskFW.summary = idSummary;
            id idDueDate = [dic objectForKey:@"due_date"];
            if (idDueDate && [idDueDate isKindOfClass:[NSString class]]) {
                dcTaskFW.due_date = idDueDate;
            }
            
            [self.result addObject:dcTaskFW];
        }
    }
}

/*
 *  new - order_confirmed
 *  pending - waiting_ho_confirm
 *  in-progress
 *      +finding_you_an_operator  (WF:start task)
 *      +operator_on_the_way (WF: At location, stop)
 *      +operator_working_on_task (WF:completed, stop)
 *  completed - task_completed-*
 */



- (TaskListType )gettypeWithCode:(NSString *)code {
    if ([code isEqualToString:@"order_confirmed"]
        || [code isEqualToString:@"new"])
        return TaskListTypeNewTaslList;
    else if ([code isEqualToString:@"waiting_ho_confirm"])
        return TaskListTypePendingTaskList;
    else if ([code isEqualToString:@"finding_you_an_operator"]
             || [code isEqualToString:@"operator_on_the_way"]
             || [code isEqualToString:@"operator_working_task"]
             || [code isEqualToString:@"stop_task"]
             || [code isEqualToString:@"awaiting_for_customer_approval"])
        return TaskListTypeInProgressTaskList;
    else if ([code isEqualToString:@"task_complete"] )
        return TaskListTypeCompletedTaskList;
    else if ([code isEqualToString:@"cancelled"])
        return TaskListTypeCancelTask;
    else if ([code isEqualToString:@"rejected"])
        return TaskListTypeRejectedTask;
    else
        return TaskListTypeAllTaskList;
}

@end


@implementation DCTaskWFDetail



@end
