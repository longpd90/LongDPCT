//
//  LocationController.m
//  andGApp
//
//  Created by Tran Bao Thai on 8/6/13.
//  Copyright (c) 2013 Bui Manh Hung. All rights reserved.
//

#import "LocationController.h"
#import "DCChatManager.h"

#define DISTANCE_FILTER             50.0f
static CGFloat const kInvalidDistance = 30000.0f;

@implementation LocationController

static LocationController *locationController;

BOOL isFistUpdateLocation;

+ (LocationController *)shareLocationController{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        locationController = [[LocationController alloc] init];
        
        locationController.currentLocation = [[[CLLocation alloc] initWithLatitude:0.0
                                                                         longitude:0.0] autorelease]; // Add autorelease by ThaiTB
        
        [locationController.locationManager startUpdatingLocation];
        
        isFistUpdateLocation = YES;
    });    
    
    return locationController;
}

+ (void)stopUpdate{
    if (locationController && locationController.locationManager) {
        [locationController.locationManager stopUpdatingLocation];
    } else {
        // do nothing
    }
}

+ (void)startUpdate{
    if (locationController && locationController.locationManager) {
        [locationController.locationManager startUpdatingLocation];
    } else {
        // do nothing
    }
}

// return distance(km) from current to target location
+ (double)calculateDistanceFromMeToLatitude:(double)latitude toLongtitude:(double)longtitude{
    if (![LocationController shareLocationController].currentLocation) {
        return kInvalidDistance;
    } else {
        CLLocation *targetLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longtitude] autorelease];
        CLLocationDistance meters = [targetLocation distanceFromLocation:[LocationController shareLocationController].currentLocation];
        
        return meters/1000.0;
    }
}

+ (BOOL)isLocationServicesEnabled{
    if ([CLLocationManager locationServicesEnabled]) {
        return !([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted);
    } else {
        return NO;
    }
}

- (void)dealloc{
    SAFE_RELEASE(_locationManager)
    SAFE_RELEASE(locationController);
    SAFE_RELEASE(_currentLocation);
    
    [super dealloc];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = DISTANCE_FILTER;
        [_locationManager setDelegate:self];
        
        if(IS_OS_8_OR_LATER) {
            if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
                [_locationManager requestWhenInUseAuthorization];
            }
        }
    }
    
    return _locationManager;
}

- (void)updateMylocation
{
    // Do nothing
}

- (BOOL)hasLocation{
    return [LocationController isLocationServicesEnabled] && !isFistUpdateLocation;
}

- (void)updateMyLocationHandler:(id)value{
    // Do nothing
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    CLLocationDistance distance = [newLocation distanceFromLocation:self.currentLocation];
    
    BOOL isFirstLoad = FALSE;
    if (!isFirstLoad)
    {
        [self sendLocationWithLatitude:newLocation.coordinate.latitude
                          andLongitude:newLocation.coordinate.longitude];
        isFirstLoad = YES;
    }
    
    if (distance > DISTANCE_FILTER) {
        self.currentLocation = newLocation;
        
        [self sendLocationWithLatitude: self.currentLocation.coordinate.latitude
                          andLongitude: self.currentLocation.coordinate.longitude];
        
        if (isFistUpdateLocation) {
            isFistUpdateLocation = NO;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    DLogError(@"LocationManager did fail");
}

- (void)sendLocationWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    QBLGeoData *geodata = [QBLGeoData geoData];
    geodata.latitude = latitude;
    geodata.longitude = longitude;
    geodata.status = @"I'm comming";
    
    if ([[QBSession currentSession] currentUser] != nil) {
        
        [QBRequest createGeoData:geodata
                    successBlock:^(QBResponse *response, QBLGeoData *geoData) {
                        // parse data
                        NSError *error = nil;
                        id responseData = [NSJSONSerialization JSONObjectWithData:response.data options:kNilOptions error:&error];
                        DLogInfo(@" ===> data %@", responseData);
                    } errorBlock:^(QBResponse *response) {
                        // Handle error
                        DLogError(@" ===> data %@", response);
                    }];
    }

}

@end
