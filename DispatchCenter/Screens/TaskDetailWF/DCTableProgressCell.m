//
//  DCTableProgressCell.m
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTableProgressCell.h"
#define INDEX_CELL_TASK_CONFIRM     0
#define INDEX_CELL_FIND_OPERATOR    1
#define INDEX_CELL_ON_THE_WAY       2
#define INDEX_CELL_AT_LOCATION      3
#define INDEX_CELL_WORKING_TASK     4
#define INDEX_CELL_COMPLETED_TASK   5
#define INDEX_CELL_AWAITED_APPROVED 6
#define INDEX_CELL_TASK_COMPLETED   7


@implementation DCTableProgressCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toggleSelectProgressContent:(id)sender {
    self.btnCheck.selected = !self.btnCheck.selected;
}

- (void)setProgressInforWithIndex:(NSInteger)index withTitleContent:(DCTaskDetailWFInfo *)info {
    NSArray *progressArray = [NSArray arrayWithArray:info.progressHistory];
    DCProgressInfo *progInfo = (DCProgressInfo*)[progressArray objectAtIndex:index];
    lblContent.text = NSLocalizedString(progInfo.name,nil);

    
    //Set Button
    if ([progInfo.status.code isEqualToString:@"completed"]   ||
        [progInfo.status.code isEqualToString:@"in_progress"]) {
        self.btnCheck.selected = YES;
    } else {
        self.btnCheck.selected = NO;
    }
//    lblContent.text = content;
    
    [self.btnCheck setUserInteractionEnabled:YES];
}
@end
