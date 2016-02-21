//
//  DCDistrictsInfo.h
//  DispatchCenter
//
//  Created by VietHQ on 10/23/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObjectBase.h"

@interface DCSubDistrictsInfo : ServerObjectBase

@property (strong, nonatomic) NSArray *mSubDistricstList;

@end

@interface DCDistrictsInfo : ServerObjectBase

@property (strong, nonatomic) NSArray *mDistrictsList;

@end
