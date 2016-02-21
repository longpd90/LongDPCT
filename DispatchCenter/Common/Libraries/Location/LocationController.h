//
//  LocationController.h
//  andGApp
//
//  Created by Tran Bao Thai on 8/6/13.
//  Copyright (c) 2013 Bui Manh Hung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Quickblox/Quickblox.h>

@interface LocationController : NSObject<CLLocationManagerDelegate>{
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;

+ (LocationController *)shareLocationController;

+ (void)stopUpdate;
+ (void)startUpdate;

// return distance(km) from current to target location
+ (double)calculateDistanceFromMeToLatitude:(double)latitude toLongtitude:(double)longtitude;
+ (BOOL)isLocationServicesEnabled;

- (void)updateMylocation;
- (BOOL)hasLocation;
@end
