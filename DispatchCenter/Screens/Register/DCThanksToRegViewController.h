//
//  DCThanksToRegViewController.h
//  DispatchCenter
//
//  Created by VietHQ on 11/4/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DCThanksRegist = 0,
    DCThanksPayment
    
} DCThanksMode;

@interface DCThanksToRegViewController : UIViewController
@property (nonatomic, assign) DCThanksMode mode;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mStatutsLabel;
@property (weak, nonatomic) IBOutlet UIButton *mTaskListButton;
@end
