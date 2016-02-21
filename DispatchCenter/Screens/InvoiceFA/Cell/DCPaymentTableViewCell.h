//
//  DCPaymentTableViewCell.h
//  DispatchCenter
//
//  Created by Phung Long on 12/2/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPaymentTableViewCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *mIdxPath;
@property (nonatomic, copy) void(^clickContinueMethod)(NSIndexPath *idxPath);
@property (weak, nonatomic) IBOutlet UITextField *cardHolderNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *securityCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;


- (IBAction)continueButtonClicked:(id)sender;

@end
