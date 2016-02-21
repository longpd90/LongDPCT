//
//  DCInvoiceDetailHeaderCell.h
//  DispatchCenter
//
//  Created by VietHQ on 11/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCEntityCellDelegate.h"

@interface DCInvoiceDetailHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mInvoiceDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mInvoiceNoLabel;
@property (weak, nonatomic) IBOutlet UIView *mLineBottomView;

@end

@interface DCInvoiceDetailHeaderCell(CellForInvoice) <DCBindingDataForEntityDelegate>

@end