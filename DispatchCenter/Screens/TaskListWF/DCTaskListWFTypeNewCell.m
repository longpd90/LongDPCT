//
//  DCTaskListWFTypeNewCell.m
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskListWFTypeNewCell.h"
#import "DCTaskWF.h"
#import "DCUtility.h"

@interface DCTaskListWFTypeNewCell () {
    
    IBOutlet UILabel *locationLbl;
    IBOutlet UILabel *workNameLbl;
    IBOutlet UILabel *dateWorkLbl;
    __weak IBOutlet UILabel *statusCompleteLbl;
    IBOutlet UIButton *btnReject;
    IBOutlet UIButton *btnAccept;
    
}

@end

@implementation DCTaskListWFTypeNewCell

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
    if ([self.taskGroup.code isEqualToString:@"new"] ) {
        statusCompleteLbl.text = @"";
    } else {
        statusCompleteLbl.text = NSLocalizedString(obj.name,nil);
    }
}

- (IBAction) rejectClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(rejectTaskWF:)])
        [self.delegate rejectTaskWF:self];
        
}

- (IBAction) acceptClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(acceptTaskWF:)])
        [self.delegate acceptTaskWF:self];
}
@end
