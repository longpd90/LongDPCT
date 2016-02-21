//
//  DCPaymentCellHelper+PaymentCellForEntity.h
//  DispatchCenter
//
//  Created by VietHQ on 11/10/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceDetailFAInfo.h"
#import "DCEntityCellDelegate.h"

@interface DCPaymentCellHelper (PaymentCellForEntity) <DCCellForEntityDelegate>

- (id<DCBindingDataForEntityDelegate>) cellForEntityForTableView:(UITableView *)tableView
                                                       atIdxPath:(NSIndexPath *)idxPath
                                                    sectionCount:(NSUInteger)count;

@end
