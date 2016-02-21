//
//  DCUnderLineLabel.h
//  DispatchCenter
//
//  Created by VietHQ on 10/24/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCUnderLineLabel : UILabel

@property(copy, nonatomic) void(^tapCallback)();

@end
