//
//  DCTaskListWFTypePendingAndCompletedCell.m
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskListWFTypePendingAndCompletedCell.h"
#import "DCTaskWF.h"
#import "DCUtility.h"

@interface DCTaskListWFTypePendingAndCompletedCell () {
    
    IBOutlet UILabel *locationLbl;
    IBOutlet UILabel *workNameLbl;
    IBOutlet UILabel *dateWorkLbl;
    IBOutlet UILabel *statusCompleteLbl;
}

@end

@implementation DCTaskListWFTypePendingAndCompletedCell

- (void)awakeFromNib {
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) fillDataToCell:(DCTaskWFDetail *)obj {
    if (obj.task.length > 0)
        workNameLbl.text = obj.task;
    locationLbl.text = obj.locationName;
    NSString *strJobDate = NSLocalizedString(@"Job Date:",nil);
    if (obj.due_date.length > 0) {
        NSString *strdate = [DCUtility autoConvertDateString:obj.due_date toStringWithFormat:kDateShowCell];
        strJobDate = [strJobDate stringByAppendingString:strdate];
        dateWorkLbl.text = strJobDate;
    }
//    if (obj.typeTask == TaskListTypeCompletedTaskList)
//        statusCompleteLbl.text = @"Completed";
//    else if (obj.typeTask == TaskListTypeCancelTask)
//        statusCompleteLbl.text = @"Cancelled";
//    else if (obj.typeTask == TaskListTypePendingTaskList)
//        statusCompleteLbl.text = @"";
//    else if (obj.typeTask == TaskListTypeRejectedTask)
//        statusCompleteLbl.text = @"Rejected";
    if ([self.taskGroup.code isEqualToString:@"pending"] ) {
        statusCompleteLbl.text = @"";
    } else {
        statusCompleteLbl.text = NSLocalizedString(obj.name,nil);
    }
}

@end
