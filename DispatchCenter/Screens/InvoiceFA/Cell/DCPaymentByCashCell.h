//
//  DCPaymentByCashCell.h
//  DispatchCenter
//
//  Created by Phung Long on 12/4/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPaymentByCashCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *mIdxPath;
@property (nonatomic, copy) void(^clickPaymentMethod)(NSIndexPath *idxPath);

- (IBAction)paymentByCash:(id)sender;

@end
