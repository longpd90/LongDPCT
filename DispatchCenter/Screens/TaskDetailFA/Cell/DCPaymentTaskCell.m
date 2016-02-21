//
//  DCPaymentTaskCell.m
//  DispatchCenter
//
//  Created by VietHQ on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCPaymentTaskCell.h"
#import "DCInvoiceDetailFAInfo.h"

@interface DCPaymentTaskCell()


@end

@implementation DCPaymentTaskCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    self.mPaymentDateLabel.text = NSLocalizedString(@"Payment Date",nil);
    self.mPaymentMethodLabel.text = NSLocalizedString(@"Payment Method",nil);
    self.mTotalAmountLabel.text = NSLocalizedString(@"Total amount",nil);
    self.mStatusLabel.text = NSLocalizedString(@"Status",nil);
    
    self.mPaymentMethodContentLabel.text = @"";
    self.mPaymentDateContentLabel.text = @"";
    self.mPaymentTotalAmountContentLabel.text = @"";
    self.mStatusContentLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.mOriginXOfContentText =  CGRectGetMinX( self.mStatusContentLabel.frame);
    [[NSNotificationCenter defaultCenter] postNotificationName:DC_NOTI_OFFSET_PAYMENT_CELL_TXT_CONTENT
                                                        object:@(self.mOriginXOfContentText)];
}

-(void)showBorderUp:(BOOL)value
{
    self.mLineLabel.hidden = !value;
}

@end

@implementation DCPaymentTaskCell(CellForEntity)

- (void)bindingDataForEntity:(NSObject *)obj
{
    DCPaymentCellHelper *pItem = (DCPaymentCellHelper*)obj;
    
    self.mPaymentMethodContentLabel.text = NSLocalizedString(pItem.mPaymentMethod,nil);
    self.mPaymentDateContentLabel.text = [pItem.mPaymentDate dateMMDDYYVersionTwo];
    self.mPaymentTotalAmountContentLabel.text = pItem.mTotalAmount;
    if ([[pItem.mStatus lowercaseString] isEqualToString:@"unpaid"]) {
        pItem.mStatus = NSLocalizedString(@"Waiting for payment",nil);
    }
    self.mStatusContentLabel.text = pItem.mStatus;
}

@end
