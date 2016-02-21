//
//  DCGeoStoreManager.m
//  DispatchCenter
//
//  Created by VietHQ on 10/30/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCGeoStoreManager.h"

@interface DCGeoStoreManager()

@property (nonatomic, strong) NSArray *mCheckins;

@end


@implementation DCGeoStoreManager

+ (instancetype)instance
{
    static DCGeoStoreManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (void)saveCheckins:(NSArray *)checkins
{
    self.mCheckins = checkins;
    [[NSNotificationCenter defaultCenter] postNotificationName:DC_GEO_DATA_DID_UPDATE object:nil];
}

@end
