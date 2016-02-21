//
//  DCInvoiceDetailWFViewController.h
//  DispatchCenter
//
//  Created by VietHQ on 11/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCInvoiceDetailWFViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *mInvoiceDetailTblView;
@property (assign, nonatomic) NSUInteger mInvoiceId;
@property (strong, nonatomic) NSString *mStrLocation;

@end
