//
//  DCInvoiceTwoColumnCell.h
//  DispatchCenter
//
//  Created by VietHQ on 11/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCEntityCellDelegate.h"

@interface DCInvoiceTwoColumnCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mContentLabel;
@property (weak, nonatomic) IBOutlet UIView *mLineBottomView;

@end


@interface DCInvoiceTwoColumnCell(CellForInvoice)<DCBindingDataForEntityDelegate>

@end