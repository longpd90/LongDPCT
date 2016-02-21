//
//  DCTaskListMasterCell.m
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskListMasterCell.h"
#import "DCTaskWF.h"
#import "DCTaskCountWF.h"

@interface DCTaskListMasterCell () {
    
    IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *bageLbl;
}

@end

@implementation DCTaskListMasterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) fillDataToCell:(DCtaskGroupWF *)object {
    if (!object)
        return;
    if (object.name.length  > 0)
        titleLbl.text = NSLocalizedString(object.name,nil);
    if (object.total)
        bageLbl.text = [object.total stringValue];
}
@end
