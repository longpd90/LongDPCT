//
//  DCPaymentCellHelper+PaymentCellForEntity.m
//  DispatchCenter
//
//  Created by VietHQ on 11/10/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCPaymentCellHelper+PaymentCellForEntity.h"
#import "DCPaymentTaskCell.h"

@implementation DCPaymentCellHelper (PaymentCellForEntity)

- (id<DCBindingDataForEntityDelegate>) cellForEntityForTableView:(UITableView *)tableView
                                                       atIdxPath:(NSIndexPath *)idxPath
                                                    sectionCount:(NSUInteger)count
{
    id<DCBindingDataForEntityDelegate> cell = [tableView dequeueReusableCellWithIdentifier:@"DCPaymentTaskCell"];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DCPaymentTaskCell class]) owner:nil options:nil] firstObject];
        //DLogInfo(@"class %@", [cell class]);
    }
    
    return cell;
}

@end
