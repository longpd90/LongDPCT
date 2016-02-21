//
//  DCTwoColumnCellHelper+CellForEntity.h
//  DispatchCenter
//
//  Created by VietHQ on 11/6/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceDetailFAInfo.h"
#import "DCEntityCellDelegate.h"
#import <objc/runtime.h>

@interface DCTwoColumnCellHelper (CellForEntity) <DCCellForEntityDelegate>

- (id<DCBindingDataForEntityDelegate>) cellForEntityForTableView:(UITableView *)tableView
                                                       atIdxPath:(NSIndexPath *)idxPath
                                                    sectionCount:(NSUInteger)count;

@property( assign, nonatomic) CGFloat mTextContentMargin;

@end
