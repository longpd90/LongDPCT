//
//  DCGeoStoreManager.h
//  DispatchCenter
//
//  Created by VietHQ on 10/30/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>

@interface DCGeoStoreManager : NSObject

@property (nonatomic, readonly) NSArray *mCheckins;

+ (instancetype)instance;
- (void)saveCheckins:(NSArray *)checkins;

@end
