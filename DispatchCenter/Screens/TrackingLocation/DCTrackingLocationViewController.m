//
//  DCTrackingLocation.m
//  DispatchCenter
//
//  Created by VietHQ on 10/29/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTrackingLocationViewController.h"
#import "DCTeamLeaderContactView.h"
#import "DCChatViewController.h"
#import "DCGeoDataManager.h"
#import "DCGeoStoreManager.h"
#import "LocationController.h"
#import "DCSetting.h"
#import "DCWFSettingViewController.h"
#import "DCFASettingViewController.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterIOS7Style.h"

#define ALERT_VIEW_DEVICE_LOCATION_SETTING  1
#define ALERT_VIEW_APP_LOCATION_SETTING     2

static NSTimeInterval kDeltaSchedule = 10.0f;
static CGFloat kVelocityDefault = 60.0f;

@interface DCTrackingLocationViewController ()<DCTeamLeaderContactViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mTitleViewLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mMapView;
@property (weak, nonatomic) IBOutlet DCTeamLeaderContactView *mLeaderStatusView;
@property (strong, nonatomic) MKPointAnnotation *mTaskAnnotation;
@property (strong, nonatomic) NSTimer *mScheduleTracking;

@property (assign, nonatomic) CLLocationCoordinate2D mTrackerLocation;
@property (strong, nonatomic) MKPointAnnotation *mPointTask;
@property (strong, nonatomic) MKPointAnnotation *mPointUser;
@property (assign, nonatomic) BOOL mFirstLoad;
@property (assign, nonatomic) BOOL mIsLocationEnable;
@property (strong, nonatomic) CLLocationManager *mLocationMng;

@property (strong, nonatomic) MKPolyline *mPolyline;
@property (strong, nonatomic) MKPolygonView* mPolygonView;
@property (assign, nonatomic) CGFloat mDuration;

@end

@implementation DCTrackingLocationViewController

#pragma mark - View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]] leftOrRight:NO target:self actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];

    
    self.mTitleViewLabel.backgroundColor = [UIColor backgroundNavRegVC];
    self.mTitleViewLabel.text = IS_FA_APP ? NSLocalizedString(@"str_tracking_fa", nil) : NSLocalizedString(@"str_tracking", nil);
    self.mLeaderStatusView.mDelegate = self;
    
    //////////////////// MAP VIEW SETTING ////////////////////
    self.mMapView.delegate = self;
    self.mMapView.mapType = MKMapTypeStandard;
    self.mMapView.showsUserLocation = YES; // see user location
    
    ///////////// 1.LOCATION MNG /////////////////
    // need call location update before get current location
    
    
    self.mLocationMng.delegate = self;
    self.mLocationMng.distanceFilter = kCLLocationAccuracyHundredMeters;
    self.mLocationMng.desiredAccuracy = kCLLocationAccuracyBest;
//    [self.mLocationMng requestWhenInUseAuthorization];
    
    
    
    // first load map
    if ( !CLLocationCoordinate2DIsValid(self.mTaskLo))
    {
        CLLocationCoordinate2D noLocation;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 800, 800);
        MKCoordinateRegion adjustedRegion = [self.mMapView regionThatFits:viewRegion];
        [self.mMapView setRegion:adjustedRegion animated:NO];
    }
    else
    {
        //DLogInfo(@"lat lo %f %f", self.mTaskLo.latitude, self.mTaskLo.longitude);
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.mTaskLo, 800, 800);
        MKCoordinateRegion adjustedRegion = [self.mMapView regionThatFits:viewRegion];
        [self.mMapView setRegion:adjustedRegion animated:NO];
        
        self.mPointTask = [[MKPointAnnotation alloc] init];
        self.mPointTask.coordinate = self.mTaskLo;
        [self.mMapView addAnnotation:self.mPointTask];
    }
    
    //////////////////// TEAM LEADER VIEW ///////////////////////
    CGFloat starValue = self.mAvgStar;
    if ( starValue - floorf(starValue) < 0.25f)
    {
        starValue = floorf(starValue);
    }
    else if( starValue -floorf(starValue) >= 0.25 && starValue - floorf(starValue) < 0.75)
    {
        starValue = floorf(starValue) + 0.5f;
    }
    else
    {
        starValue = floorf(starValue) + 1.0f;
    }
    if (IS_FA_APP) {
        [self.mLeaderStatusView setName:self.mTeamLeaderModel.mStrName];
        [self.mLeaderStatusView setAvaWithURL:self.mTeamLeaderModel.mStrImageURL];
    } else {
        [self.mLeaderStatusView setName:self.mTeamMember.teamMemberName];
        [self.mLeaderStatusView setAvaWithURL:self.mTeamMember.teamMemberImg];
    }
    
    [self.mLeaderStatusView setStar:starValue ? starValue : 0.0f];
    
    // status for fa if not disable location
    if (!self.mTeamLeaderModel.mShareLocation && IS_FA_APP)
    {
        NSString *pStatus = NSLocalizedString(@"str_coming_soon_fa", nil);
        [self.mLeaderStatusView setStatus:pStatus];
    }
    
    //TODO: status for wf
    if (!self.mTeam.enabledShareLocation && IS_WF_APP)
    {
        NSString *pStatus = NSLocalizedString(@"str_coming_soon_fa", nil);
        [self.mLeaderStatusView setStatus:pStatus];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
    
    
    
    /////////// TRACKING ///////////////
    if (!self.mScheduleTracking)
    {
        self.mScheduleTracking = [NSTimer scheduledTimerWithTimeInterval:kDeltaSchedule
                                                                  target:self
                                                                selector:@selector(updateLocation)
                                                                userInfo:nil
                                                                 repeats:YES];
        
        [self.mScheduleTracking fire];
    }

    
    
    /////////// ADD NOTIFY ////////////
//    if (IS_FA_APP) {
    
    if (IS_FA_APP && self.mTeamLeaderModel.mShareLocation) {
     
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackingLocationCallback:) name:DC_GEO_DATA_DID_UPDATE object:nil];
    }
//    } else { //WF_APP
    
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (IS_WF_APP) {
        [self requestAlwaysAuthorization];
    }
}

- (void)updateLocation
{
    if ( !self.mUserId || !CLLocationCoordinate2DIsValid(self.mTaskLo)) return;
    
    [[DCGeoDataManager instance] fetchLatestCheckInsWithUserId:self.mUserId];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    ////////// REMOVE NOTIFY ///////////////
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    ////////// STOP TRACKING //////////////
    [self.mScheduleTracking invalidate];
    self.mScheduleTracking = nil;
}

#pragma mark - Location manager authorize
- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    NSLog(@"DCSetting privacy === %d \n",APP_DELEGATE.mySettings.privacy);
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? NSLocalizedString(@"Location services are off",nil) : NSLocalizedString(@"Background location is not enabled",nil);
        NSString *message = NSLocalizedString(@"To use background location you must turn on 'Always' in the Location Services Settings",nil);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                                  otherButtonTitles:NSLocalizedString(@"Settings",nil), nil];
        alertView.tag = ALERT_VIEW_DEVICE_LOCATION_SETTING;
        [alertView show];
    } else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)  {
//        [self.mLocationMng stopUpdatingLocation];
        if (APP_DELEGATE.mySettings.privacy != YES) {
            [self checkAppSetting];
        } else if (APP_DELEGATE.mySettings.privacy == YES) {
            [self.mLocationMng startUpdatingLocation];
        }
        
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.mLocationMng requestAlwaysAuthorization];
    }
}

- (void)checkAppSetting {
//    APP_DELEGATE.mySettings.privacy = YES;
    if (APP_DELEGATE.mySettings.privacy == YES) {
        NSLog(@"STart UPDATING location ----- \n");
        self.mIsLocationEnable = YES;
         [self.mLocationMng startUpdatingLocation];
    } else {
        [self.mLocationMng stopUpdatingLocation];
        NSString *title;
        NSLocalizedString(@"Location setting are off",nil) ;
        NSString *message = NSLocalizedString(@"To use background location you must turn on Location Sharing Settings",nil);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                                  otherButtonTitles:NSLocalizedString(@"Settings",nil), nil];
        alertView.tag = ALERT_VIEW_APP_LOCATION_SETTING;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALERT_VIEW_DEVICE_LOCATION_SETTING: {
            if (buttonIndex == 1) {
                // Send the user to the Settings for this app
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }
            break;
        case ALERT_VIEW_APP_LOCATION_SETTING: {
            if (buttonIndex == 1) {
             
            if (IS_WF_APP) {
                [MAIN_NAVIGATION pushViewController:[[DCWFSettingViewController alloc] initWithNibName:@"DCWFSettingViewController" bundle:nil] animated:YES];
            } else {
                [MAIN_NAVIGATION pushViewController:[[DCFASettingViewController alloc] initWithNibName:@"DCFASettingViewController" bundle:nil] animated:YES];
            }
            } else {
                self.mIsLocationEnable = NO;
                [self.mLocationMng stopUpdatingLocation];
                [self resetAnnotationUserLocation];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)resetAnnotationUserLocation {
    MKPointAnnotation *pUserLocation = [[MKPointAnnotation alloc] init];
//    pUserLocation.coordinate = [locations firstObject].coordinate;
    
    //hard code long/lat
    pUserLocation.coordinate = self.mPointTask.coordinate;
    [self.mMapView removeOverlays:self.mMapView.overlays];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pUserLocation.coordinate, 800, 800);
    [self.mMapView setRegion:[self.mMapView regionThatFits:region] animated:YES];
}

#pragma mark - location manager delegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ( status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        self.mIsLocationEnable = YES;
       
        
        [self checkAppSetting];
        
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
    if (IS_FA_APP) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mPointTask.coordinate, 800, 800);
        [self.mMapView setRegion:[self.mMapView regionThatFits:region] animated:YES];
    } else if (IS_WF_APP){
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mPointTask.coordinate, 800, 800);
        [self.mMapView setRegion:[self.mMapView regionThatFits:region] animated:YES];
        self.mPointUser.coordinate = pUserLocation.coordinate;
    }
    
    if (!CLLocationCoordinate2DIsValid(self.mTaskLo)) {
        [self resetAnnotationUserLocation];
    }
}


#pragma mark - Layout
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    __weak typeof (self) thiz = self;
    [self.mTitleViewLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.left.right.equalTo(thiz.view);
            make.top.equalTo(thiz.view).offset(0.0f);
            make.height.equalTo(@60);
        }
    }];
    
    [self.mLeaderStatusView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof(thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.bottom.equalTo(thiz.view.mas_bottom);
            make.left.right.equalTo(thiz.view);
            make.height.equalTo(@120);
        }
    }];
    
    [self.mMapView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof(thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.top.equalTo(strongSelf.mTitleViewLabel.mas_bottom);
            make.left.right.equalTo(strongSelf.view);
            make.bottom.equalTo(strongSelf.mLeaderStatusView.mas_top);
        }
    }];
}

#pragma mark - Notify callback
-(void)trackingLocationCallback:(NSNotification*)sender
{
    QBLGeoData *pData = [[[DCGeoStoreManager instance] mCheckins] firstObject];
    //DLogInfo(@" ====> geo %f %f", pData.latitude, pData.longitude);
    
    if (!self.mPointUser)
    {
        self.mPointUser = [[MKPointAnnotation alloc] init];
    }
    else
    {
        [self.mMapView removeAnnotation:self.mPointUser];
    }
    
    self.mPointUser.coordinate = CLLocationCoordinate2DMake(pData.latitude, pData.longitude);
    [self.mMapView addAnnotation:self.mPointUser];
    
    if (
        [self.mMapView respondsToSelector:@selector(showAnnotations:animated:)] /* IOS 7 */)
    {
        self.mFirstLoad = YES;
        
        __weak typeof (self) thiz = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (thiz) strongSelf = thiz;
            if (strongSelf)
            {
                // if show full the way should go on map, open this comment
                //[strongSelf.mMapView showAnnotations:strongSelf.mMapView.annotations animated:YES];
                [strongSelf drawDirection];
            }
        });
        
    }
}

- (void)trackingLocationWF {
//    QBLGeoData *pData = [[[DCGeoStoreManager instance] mCheckins] firstObject];
//    //DLogInfo(@" ====> geo %f %f", pData.latitude, pData.longitude);
//    
//    if (!self.mPointUser)
//    {
//        self.mPointUser = [[MKPointAnnotation alloc] init];
//    }
//    else
//    {
//        [self.mMapView removeAnnotation:self.mPointUser];
//    }
    
//    self.mPointUser.coordinate = CLLocationCoordinate2DMake(pData.latitude, pData.longitude);
    [self.mMapView addAnnotation:self.mPointUser];
    
    if (
        [self.mMapView respondsToSelector:@selector(showAnnotations:animated:)] /* IOS 7 */)
    {
        self.mFirstLoad = YES;
        
        __weak typeof (self) thiz = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (thiz) strongSelf = thiz;
            if (strongSelf)
            {
                // if show full the way should go on map, open this comment
                //[strongSelf.mMapView showAnnotations:strongSelf.mMapView.annotations animated:YES];
                [strongSelf drawDirection];
            }
        });
        
    }
}


#pragma mark - Action callback
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
    [DCDropDownMenuViewController showMe];
}


#pragma mark - draw direction
-(void)drawDirection
{
    ///////////////// set source and destination ////////////////
    // source setting, location of Work force
    
    MKPlacemark *pSource = [[MKPlacemark alloc]initWithCoordinate:self.mPointUser.coordinate addressDictionary:nil];
//    MKPlacemark *pSource = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(13.8795287, 100.4833978) addressDictionary:nil]; ///บริษัท+บาริสต้า+(ประเทศไทย)+จำกัด   hard code for tracking testing location
    MKMapItem *pSrcMapItem = [[MKMapItem alloc]initWithPlacemark:pSource];
    pSrcMapItem.name = @"Help";
    
    // Add an annotation
    MKPointAnnotation *pPoint = [[MKPointAnnotation alloc] init];
    pPoint.coordinate = self.mPointUser.coordinate;
    [self.mMapView addAnnotation:pPoint];
    
  
    //focus view
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pSource.coordinate, 100000, 100000);
//        [self.mMapView setRegion:[self.mMapView regionThatFits:region] animated:YES];
    
        // remove all annotation
        [self.mMapView removeAnnotations:self.mMapView.annotations];
    
        // Add an annotation
        MKPointAnnotation *pPoint1 = [[MKPointAnnotation alloc] init];
        pPoint1.coordinate = pSource.coordinate;
        [self.mMapView addAnnotation:pPoint1];
    
//        [self infoAddressFromCoordinate:pPoint.coordinate];
    
    
    // destination setting , location of TASK
    MKPlacemark *pDestination = [[MKPlacemark alloc]initWithCoordinate:self.mPointTask.coordinate addressDictionary:nil];
    
  //  MKPlacemark *pDestination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(13.9645485, 100.2746148) addressDictionary:nil];
    
    MKMapItem *pDistMapItem = [[MKMapItem alloc]initWithPlacemark:pDestination];
    
    MKPointAnnotation *pPointDes = [[MKPointAnnotation alloc] init];
    pPointDes.coordinate = pDestination.coordinate;
    [self.mMapView addAnnotation:pPointDes];
    
    //Region to show
//    MKCoordinateRegion region2 = MKCoordinateRegionMakeWithDistance(pDestination.coordinate, 20000, 20000);
//    [self.mMapView setRegion:[self.mMapView regionThatFits:region2] animated:YES];
    
    ///////////////// create request from source and destination, set transport type ////////////////
    MKDirectionsRequest *pRequest = [[MKDirectionsRequest alloc]init];
    [pRequest setSource:pSrcMapItem];
    [pRequest setDestination:pDistMapItem];
    [pRequest setTransportType:MKDirectionsTransportTypeAutomobile];
    
    
    
    ///////////////// create direction //////////////////////
    MKDirections *pDirection = [[MKDirections alloc] initWithRequest:pRequest];
    
    __weak typeof (self) thiz = self;
    [pDirection calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"error requesting direction error %@ \n",[error description]);
             NSLog(@"pSource === long %f lat %f  \n",pSource.coordinate.longitude, pSource.coordinate.latitude);;
             NSLog(@"pDestination === long %f lat %f  \n",pDestination.coordinate.longitude, pDestination.coordinate.latitude);;
             
         } else {
         __strong typeof (thiz) strongSelf = thiz;
         if(strongSelf)
         {
             // remove all overlays before add new
             [self.mMapView removeOverlays:self.mMapView.overlays];
             
             // add new
             NSArray *pArrRoutes = [response routes];
             CGFloat s = 0.0f;
             for (MKRoute *pRout in pArrRoutes)
             {
                 [self.mMapView addOverlay:[pRout polyline] level:MKOverlayLevelAboveRoads];
                 s += pRout.distance;
             }
             
             
             strongSelf.mDuration = s*60.0f / (kVelocityDefault*1000.0f);
             
             if ( strongSelf.mTeamLeaderModel.mShareLocation)
             {
                 NSString *pStatus =  IS_FA_APP ?   [NSString stringWithFormat:NSLocalizedString(@"str_will_arrive_in_minute_fa", nil), (NSUInteger)strongSelf.mDuration] :
                 [NSString stringWithFormat:NSLocalizedString(@"str_will_arrive_in_minute", nil), (NSUInteger)strongSelf.mDuration];
                 [strongSelf.mLeaderStatusView setStatus: pStatus];
             }
             
             if ( IS_WF_APP) {
                 NSString *pStatus =  IS_WF_APP ?   [NSString stringWithFormat:NSLocalizedString(@"str_will_arrive_in_minute_fa", nil), (NSUInteger)strongSelf.mDuration] :
                 [NSString stringWithFormat:NSLocalizedString(@"str_will_arrive_in_minute", nil), (NSUInteger)strongSelf.mDuration];
                 [strongSelf.mLeaderStatusView setStatus: pStatus];
             }
         }
         }
     }];
}

#pragma mark - TeamLeader view delegate
-(void)teamLeaderContactViewDidCall:(DCTeamLeaderContactView *)teamLeaderView
{
    if (IS_FA_APP) {
        if (self.mTeamLeaderModel.mStrPhoneNumb == nil) {
            [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Phone number is empty", nil) callback:^(UIAlertView *al, NSInteger idx) {
                
            } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
            
        } else {
            __weak typeof (self) thiz = self;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"str_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:NSLocalizedString(@"str_call", nil),self.mTeamLeaderModel.mStrPhoneNumb == nil ? @"" : self.mTeamLeaderModel.mStrPhoneNumb], nil];
            [actionSheet showInView:thiz.view];
        }
    } else {
        if (self.memberPhoneNumber == nil) {
            [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Phone number is empty", nil) callback:^(UIAlertView *al, NSInteger idx) {
                
            } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
            
        } else {

            __weak typeof (self) thiz = self;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"str_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:NSLocalizedString(@"str_call", nil),self.memberPhoneNumber == nil ? @"" : self.memberPhoneNumber],nil];
            [actionSheet showInView:thiz.view];
        }
    }
}

-(void)teamLeaderContactViewDidChat:(DCTeamLeaderContactView *)teamLeaderView
{
    DCChatViewController *chatViewController = [DCChatViewController makeMeWithRoomID:self.mQBInfo.roomID roomJID:self.mQBInfo.roomJID phoneNum:nil];
    chatViewController.chatMode = DCChatModeFA;
    [MAIN_NAVIGATION pushViewController:chatViewController animated:YES];
}

#pragma mark - mapview delegate

#pragma mark - map view delegate
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation:(id<MKAnnotation>) annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    
    MKAnnotationView *pin = (MKAnnotationView *) [self.mMapView dequeueReusableAnnotationViewWithIdentifier: @"VoteSpotPin"];
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
    self.mMapView.showsUserLocation = NO;
    
//    if (IS_FA_APP) { //focus on task location, now focus on user (WF) location
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mPointTask.coordinate, 800, 800);
        [self.mMapView setRegion:[self.mMapView regionThatFits:region] animated:YES];
//    }
    // remove all annotation
    [self.mMapView removeAnnotations:self.mMapView.annotations];
    
    // Add an annotation
    MKPointAnnotation *pPoint = [[MKPointAnnotation alloc] init];
    pPoint.coordinate = self.mPointTask.coordinate;
    [self.mMapView addAnnotation:pPoint];
    if (!CLLocationCoordinate2DIsValid(self.mTaskLo)) {
        [self resetAnnotationUserLocation];
    }
    if (IS_WF_APP) {
        NSLog(@"Call this location  WF_APP \n");
        // Add an annotation
        MKPointAnnotation *pPointUser = [[MKPointAnnotation alloc] init];
        pPointUser.coordinate = userLocation.coordinate;
        [self.mMapView addAnnotation:pPointUser];
        self.mPointUser = pPointUser;
        
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mPointTask.coordinate, 800, 800);
        [self.mMapView setRegion:[self.mMapView regionThatFits:region] animated:YES];
        //    }
        // remove all annotation
        [self.mMapView removeAnnotations:self.mMapView.annotations];
        
        MKPointAnnotation *pPointTask = [[MKPointAnnotation alloc] init];
        pPointTask.coordinate = self.mPointTask.coordinate;
        [self.mMapView addAnnotation:pPointTask];

        
//        if (self.mIsLocationEnable) {
            NSLog(@"track location WF \n");
            [self trackingLocationWF];
//        }
        
        
    }
//    [self infoAddressFromCoordinate:pPoint.coordinate];
}




- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    lineView.strokeColor = [UIColor greenColor];
    lineView.lineWidth = 2.0f;
    return lineView;
}

#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (IS_FA_APP) {
        if (buttonIndex == 0) {
            NSString *pPhoneNumber = [@"telprompt://" stringByAppendingString:self.mTeamLeaderModel.mStrPhoneNumb == nil ? @"" : self.mTeamLeaderModel.mStrPhoneNumb];
            
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pPhoneNumber]]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pPhoneNumber]];
                
            } else {
                
                [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Can not call this phone number", nil) callback:^(UIAlertView *al, NSInteger idx) {
                    
                } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
                
            }
        }
    } else {
        if (buttonIndex == 0) {
            NSString *pPhoneNumber = [@"telprompt://" stringByAppendingString:self.memberPhoneNumber == nil ? @"" : self.memberPhoneNumber];
            
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pPhoneNumber]]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pPhoneNumber]];
                
            } else {
                
                [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Can not call this phone number", nil) callback:^(UIAlertView *al, NSInteger idx) {
                    
                } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
                
            }
        }
    }
    

    
}
@end
