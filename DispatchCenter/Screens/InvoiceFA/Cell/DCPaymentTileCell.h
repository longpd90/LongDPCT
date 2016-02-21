//
//  DCPaymentTileCell.h
//  DispatchCenter
//
//  Created by Phung Long on 12/4/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPaymentTileCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *mIdxPath;
@property (weak, nonatomic) IBOutlet UILabel *paymentModeLabel;
@property (nonatomic, copy) void(^clickPaymentMethod)(NSIndexPath *idxPath);
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

- (IBAction)checkButtonClicked:(id)sender;

@end
