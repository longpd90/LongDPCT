//
//  DCTaskListWFTypeInProgressCell.m
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskListWFTypeInProgressCell.h"
#import "DCTaskWF.h"
#import "DCUtility.h"

//@implementation DCtaskGroupWF
//@end
@interface DCTaskListWFTypeInProgressCell () {
    
    IBOutlet UILabel *locationLbl;
    IBOutlet UILabel *workNameLbl;
    IBOutlet UILabel *dateWorkLbl;
    IBOutlet UILabel *nameOtherLbl;
    __weak IBOutlet UILabel *statusLabel;
}

@end

@implementation DCTaskListWFTypeInProgressCell

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
    if (obj.summary) {
        nameOtherLbl.text = obj.summary;
        if (obj.summary.length > 0) {
            
        } else {
            CGFloat x = dateWorkLbl.frame.size.height + dateWorkLbl.frame.origin.y;
            obj.height = x;
        }
            
    }
    if ([self.taskGroup.code isEqualToString:@"in_progress"] ) {
        statusLabel.text = @"";
    } else {
        statusLabel.text = NSLocalizedString(obj.name,nil);
    }
    
  
    
    
    
    
}

@end
