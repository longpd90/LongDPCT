//
//  DCTaskListWFViewController.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTaskListWFTypeNewCell.h"

@class DCTaskWF;
@class DCtaskGroupWF;
@interface DCTaskListWFViewController : UIViewController <DCTaskListWFTypeNewProtocol>

@property (nonatomic, strong) DCtaskGroupWF *object;

@end
