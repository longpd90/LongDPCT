//
//  DCMapViewController.m
//  DispatchCenter
//
//  Created by VietHQ on 10/24/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCMapViewController.h"
#import "DCApis.h"
#import "DCListCountryInfo.h"
#import "DCMyProfile.h"
#import "DCChatViewController.h"
#import "LocationController.h"


@interface DCMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mTitleView;
@property (weak, nonatomic) IBOutlet MKMapView *mMap;
@property (weak, nonatomic) IBOutlet UIView *mContainerInfoView;
@property (weak, nonatomic) IBOutlet UILabel *mLocationInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *mSetLoButton;
@property (strong, nonatomic) CLLocationManager *mLocationMng;

@property (strong, nonatomic) NSArray *mArrCountrySupport;
@property (strong, nonatomic) NSArray *mArrCountrySupportByCode;
@property (strong, nonatomic) DCMyProfile *mMyProfile;

@property (assign, nonatomic) BOOL mIsLocationEnable;
@property (assign, nonatomic) BOOL mIsFirstDisplay;

@end

@implementation DCMapViewController

#pragma mark - View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mIsLocationEnable = NO;
    
    
    
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"ic_edit"],[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]]
                      leftOrRight:NO target:self
                          actions:@[ [NSValue valueWithPointer:@selector(didEditProfileBtn:)],
                                     [NSValue valueWithPointer:@selector(didSelectChatBtn:)],
                                     [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];

    
    self.mTitleView.text = NSLocalizedString(@"str_select_your_location", nil);
    self.mTitleView.backgroundColor = [UIColor backgroundNavRegVC];
    
    ////////////// CONTAINER ADDRESS INFO (BOTTOM VIEW) //////////////
    self.mContainerInfoView.backgroundColor = [UIColor backgroundNavRegVC];
    
    self.mLocationInfoLabel.numberOfLines = 0;
    self.mLocationInfoLabel.text = @"";
    
    [self.mSetLoButton setTitle:NSLocalizedString(@"str_set_location", nil) forState:UIControlStateNormal];
    self.mSetLoButton.backgroundColor = [UIColor yellowButton];
    self.mSetLoButton.layer.cornerRadius = 2.0f;
    self.mSetLoButton.clipsToBounds = YES;
    
    
    ///////////// 1.LOCATION MNG /////////////////
    // need call location update before get current location
   
   
    self.mLocationMng.delegate = self;
    self.mLocationMng.distanceFilter = kCLLocationAccuracyHundredMeters;
    self.mLocationMng.desiredAccuracy = kCLLocationAccuracyBest;
     [self requestAlwaysAuthorization];
//    [self.mLocationMng startUpdatingLocation];

    
    ///////////////// 2.MAP //////////////////////
    self.mMap.delegate = self;
    self.mMap.showsUserLocation = YES; // see user location
    
    
    // show user location
    MKPointAnnotation *pUserLocation = [[MKPointAnnotation alloc] init];
    pUserLocation.coordinate = self.mMap.userLocation.coordinate;

    //hard code long/lat
//    pUserLocation.coordinate = CLLocationCoordinate2DMake(13.756333, 100.501777);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pUserLocation.coordinate, 800, 800);
    [self.mMap setRegion:[self.mMap regionThatFits:region] animated:YES];
    
    // add long ges to map view
    UILongPressGestureRecognizer *pLongGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addPinCallback:)];
    pLongGes.minimumPressDuration = 0.5f;
    [self.mMap addGestureRecognizer:pLongGes];
    
    
    /////////////// GET LIST COUNTRY SUPPORT //////////////
    __weak typeof (self) thiz = self;
    SHOW_LOADING;
    [DCApis getInfoCountryWithCountryName:nil complete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        if (success)
        {
            DCListCountryInfo *pListCountryModel = (DCListCountryInfo*)response;
            thiz.mArrCountrySupport = pListCountryModel.mListCountry;
            thiz.mArrCountrySupportByCode = pListCountryModel.mListCountryCode;
        }
        else
        {
            
        }
     }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
    [APP_DELEGATE showYellowLineBottomNav];
//    [self requestAlwaysAuthorization];
}

#pragma mark - Set layout
-(void)viewWillLayoutSubviews
{
//    __weak typeof (self) thiz = self;
//    [self.mTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(thiz.view);
//        make.top.equalTo(thiz.view).offset(0.0f);
//        make.height.equalTo( thiz.mIsLocationEnable ? @60 : @0);
//    }];
//    
//    [self.mContainerInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(thiz.view);
//        make.height.mas_greaterThanOrEqualTo(183.0f);
//    }];
    
//    [self.mMap mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(thiz.mTitleView.mas_bottom);
//        make.left.right.equalTo(thiz.view);
//        make.bottom.equalTo(thiz.mContainerInfoView.mas_top);
//    }];
}
#pragma mark - Location manager authorize
- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? NSLocalizedString(@"Location services are off",nil) : NSLocalizedString(@"Background location is not enabled",nil);
        NSString *message = NSLocalizedString(@"To use background location you must turn on 'Always' in the Location Services Settings",nil);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                                  otherButtonTitles:NSLocalizedString(@"Settings",nil), nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.mLocationMng requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

#pragma mark - Action callback
-(void)addPinCallback:(UILongPressGestureRecognizer*)longGes
{
    if (longGes.state != UIGestureRecognizerStateBegan)
        return;
    
    // remove all annotations before add new
    [self.mMap removeAnnotations:self.mMap.annotations];
    
    // add new
    CGPoint touchPoint = [longGes locationInView:self.mMap];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mMap convertPoint:touchPoint toCoordinateFromView:self.mMap];
    
    MKPointAnnotation *pPoint = [[MKPointAnnotation alloc] init];
    pPoint.coordinate = touchMapCoordinate;
    [self.mMap addAnnotation:pPoint];
    
    [self infoAddressFromCoordinate:touchMapCoordinate];
}

-(void)didEditProfileBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didSelectChatBtn:(id)sender
{
    if (IS_FA_APP) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        [MAIN_NAVIGATION pushViewController:[DCChatViewController makeMeWithRoomID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomID roomJID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil] animated:YES];
    }
}

-(void)didSelectMenuBtn:(id)sender
{
    //TODO: select menu
    [DCDropDownMenuViewController showMe];
}

- (IBAction)setLocationCallback:(id)sender
{
    /////////////// IF HAVE NO LOCATION INFO ////////////
    if ( !self.mLocationInfoLabel.text.length)
    {
        UIAlertView *pAlert = [UIAlertView alertViewtWithTitle:@""
                                                       message:NSLocalizedString(@"msg_pick_location", nil)
                                                      autoShow:NO
                                                      callback:NULL
                                             cancelButtonTitle:NSLocalizedString(@"str_ok", nil)
                                             otherButtonTitles:nil];
        [pAlert show];
        
        return;
    }
    
    
    /////////////// IF HAS LOCATION /////////////////////
    if ( ![self isCountrySupport:self.mMyProfile.mCountryCode] )
    {
        NSLog(@"my profile country code ==== %@ \n", self.mMyProfile.mCountryCode);
        
        UIAlertView *pAlert = [UIAlertView alertViewtWithTitle:@""
                                                       message:NSLocalizedString(@"msg_country_not_support", nil)
                                                      autoShow:NO
                                                      callback:NULL
                                             cancelButtonTitle:NSLocalizedString(@"str_ok", nil)
                                             otherButtonTitles:nil];
        [pAlert show];
        
        return;

    }
    
    /////////////// IF EVERYTHING OK ////////////////
    [[NSNotificationCenter defaultCenter] postNotificationName:DC_NOTI_LOCATION_UPDATE object:self.mMyProfile];
    DLogInfo(@"%@", self.mMyProfile.mStreetAddress);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Map helper
-(void)infoAddressFromCoordinate:(CLLocationCoordinate2D)coordinate
{
    CLLocation *pLo = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];

    CLGeocoder *pGeo = [[CLGeocoder alloc] init];
    
    __weak typeof (self) thiz = self;
    [pGeo reverseGeocodeLocation:pLo completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            CLPlacemark *pPlacemark = [placemarks firstObject];
            
            // display location in view
            NSString *pLocationAt = [[pPlacemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.mLocationInfoLabel.text = pLocationAt;
            });
            
            //////////// LOG INFO ///////////
            DLogInfo(@"addressDictionary %@", pPlacemark.addressDictionary);
            
            // address street and address 2
            //DLogInfo(@"address 2 %@", pPlacemark.thoroughfare);
            //DLogInfo(@"address street %@", pPlacemark.subThoroughfare);
            
            // district and province
            //DLogInfo(@"district %@", pPlacemark.subAdministrativeArea);
            //DLogInfo(@"province %@", pPlacemark.administrativeArea);
            
            
        
            if (! [strongSelf isCountrySupport:pPlacemark.ISOcountryCode])
            {
                if (self.mIsFirstDisplay)
                {
                    UIAlertView *pAlert = [UIAlertView alertViewtWithTitle: @""
                                                                   message: NSLocalizedString(@"msg_country_not_support", nil)
                                                                  autoShow: NO
                                                                  callback: NULL
                                                         cancelButtonTitle: NSLocalizedString(@"str_ok", nil)
                                                         otherButtonTitles: nil];
                    [pAlert show];

                }
                
                strongSelf.mIsFirstDisplay = YES;
            }
            
            //////////// SAVE INFO ////////////
            if (!strongSelf.mMyProfile)
            {
                strongSelf.mMyProfile = [[DCMyProfile alloc] init];
            }
            
            strongSelf.mMyProfile.mStreetAddress = pPlacemark.subThoroughfare;
            strongSelf.mMyProfile.mAddress2 = pPlacemark.thoroughfare;
            strongSelf.mMyProfile.mDistrict = pPlacemark.subAdministrativeArea;
            strongSelf.mMyProfile.mState = pPlacemark.administrativeArea;
            strongSelf.mMyProfile.mCountry = pPlacemark.country;
            strongSelf.mMyProfile.mZipCode = pPlacemark.postalCode;
            strongSelf.mMyProfile.mCountryCode = pPlacemark.ISOcountryCode;
        }
     }];
}

-(BOOL)isCountrySupport:(NSString*)countryName
{
    for (DCItemNameId *pName in self.mArrCountrySupportByCode)
    {
        
        if ([[pName.mISOName lowercaseString] isEqualToString:[countryName lowercaseString]])
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - map view delegate
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation:(id<MKAnnotation>) annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }

    MKAnnotationView *pin = (MKAnnotationView *) [self.mMap dequeueReusableAnnotationViewWithIdentifier: @"VoteSpotPin"];
    if (pin == nil)
    {
        pin = [[MKAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"TestPin"];
    }
    else
    {
        pin.annotation = annotation;
    }
    
    [pin setImage:[UIImage imageNamed:@"ic_location"]];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mMap.showsUserLocation = NO;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mMap setRegion:[self.mMap regionThatFits:region] animated:YES];
    
    // remove all annotation
    [self.mMap removeAnnotations:self.mMap.annotations];
    
    // Add an annotation
    MKPointAnnotation *pPoint = [[MKPointAnnotation alloc] init];
    pPoint.coordinate = userLocation.coordinate;
    [self.mMap addAnnotation:pPoint];
    
     [self infoAddressFromCoordinate:pPoint.coordinate];
}

#pragma mark - location manager delegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ( status == kCLAuthorizationStatusAuthorizedAlways ||
         status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        self.mIsLocationEnable = YES;
        [self.mLocationMng startUpdatingLocation];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
    else if( status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied)
    {
        self.mIsLocationEnable = NO;
        [self.mLocationMng stopUpdatingLocation];
        self.mLocationMng = nil;
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
    else
    {
        self.mIsLocationEnable = YES;
        [self.mLocationMng requestAlwaysAuthorization];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //DLogInfo(@"didFailWithError: %@", error);
//    static BOOL isFistTimeShow = NO;
//    if (!isFistTimeShow)
//    {
        UIAlertView *pErrorAlert = [UIAlertView alertViewtWithTitle: @""
                                                            message: NSLocalizedString(@"Failed to get your location",nil)
                                                           autoShow: NO
                                                           callback: NULL
                                                  cancelButtonTitle: NSLocalizedString(@"str_ok", )
                                                  otherButtonTitles: nil];
        [pErrorAlert show];
//        isFistTimeShow = YES;
//    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    DLogInfo(@"didUpdateToLocation: %@", [locations firstObject]);
    
    // show user location
    MKPointAnnotation *pUserLocation = [[MKPointAnnotation alloc] init];
    pUserLocation.coordinate = [locations firstObject].coordinate;
    
    //hard code long/lat
//    pUserLocation.coordinate = CLLocationCoordinate2DMake(13.756333, 100.501777);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pUserLocation.coordinate, 800, 800);
    [self.mMap setRegion:[self.mMap regionThatFits:region] animated:YES];
}

-(void)dealloc
{
    [self.mLocationMng stopUpdatingLocation];
    self.mLocationMng = nil;
}

@end
