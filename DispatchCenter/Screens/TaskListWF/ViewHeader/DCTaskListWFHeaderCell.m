//
//  DCTaskListWFHeaderCell.m
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//
#import "DCTaskListWFHeaderCell.h"

#define TO_DAY      @"Today"
#define TOMORROW    @"Tomorrow"
#define NEXT_3_DAYS @"Next 3 Days"
#define AFTER_3_DAYS @"More than 3 Days"

@interface DCTaskListWFHeaderCell () {
    IBOutlet UILabel *titleLbl;
}

@end

@implementation DCTaskListWFHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) fillDataToCell:(NSString* )titleHeader {
    titleLbl.text = titleHeader;
}

@end
