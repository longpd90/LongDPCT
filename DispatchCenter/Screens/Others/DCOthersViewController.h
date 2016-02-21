//
//  DCOthersViewController.h
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 11/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OTHER_VIEW_HELP                         0
#define OTHER_VIEW_PRIVACY_POLICY               1
#define OTHER_VIEW_TERM_CONDITION               2
#define OTHER_VIEW_END_USER_LICENSE_AGREEMENT   3
#define OTHER_VIEW_CONTACT_US                   4

@interface DCOthersViewController : UIViewController

@property (nonatomic, assign) NSInteger otherViewType;
@end
