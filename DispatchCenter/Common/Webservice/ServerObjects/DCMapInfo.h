//
//  DCMapInfo.h
//  DispatchCenter
//
//  Created by VietHQ on 11/2/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCListCountryInfo.h"

@interface DCMapInfo : ServerObjectBase

@property(strong, nonatomic) DCItemNameId *mState;
@property(strong, nonatomic) DCItemNameId *mDistrict;
@property(strong, nonatomic) DCItemNameId *mSubDistrict;

@end
