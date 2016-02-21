//
//  DCPaymentBankTranferTableViewCell.h
//  DispatchCenter
//
//  Created by Phung Long on 12/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPaymentBankTranferTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *banks;
@property (nonatomic, copy) void(^clickPaymentMethod)(NSIndexPath *idxPath);
@property (nonatomic, copy) void(^clickSelectBank)(NSInteger bankIndex);

@property (nonatomic, assign) float originY;
@property (nonatomic, strong) UIButton *buttonSelected;
@property (nonatomic, strong) NSIndexPath *mIdxPath;

- (IBAction)paymentByBankTranfer:(id)sender;

@end
