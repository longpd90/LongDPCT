//
//  DCPaymentTaskCell.h
//  DispatchCenter
//
//  Created by VietHQ on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCEntityCellDelegate.h"

@interface DCPaymentTaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mPaymentMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPaymentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTotalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *mPaymentMethodContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPaymentDateContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPaymentTotalAmountContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *mStatusContentLabel;

@property (weak, nonatomic) IBOutlet UIView *mLineLabel;
@property (assign, nonatomic) CGFloat mOriginXOfContentText;

-(void)showBorderUp:(BOOL)value;

@end

@interface DCPaymentTaskCell(CellForEntity)<DCBindingDataForEntityDelegate>

@end
