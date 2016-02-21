//
//  DCTableProgressCell.h
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTaskDetailWFInfo.h"
@interface DCTableProgressCell : UITableViewCell {
    NSMutableArray *progressContents;
    __weak IBOutlet UILabel *lblContent;
}
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
- (IBAction)toggleSelectProgressContent:(id)sender;
- (void)setProgressInforWithIndex: (NSInteger)index withTitleContent:(DCTaskDetailWFInfo*)info;
@end
