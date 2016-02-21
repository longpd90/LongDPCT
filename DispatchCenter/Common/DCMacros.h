//
//  DCMacros.h
//
//
//  Created on 12/15/14.
//

#ifndef AM_Macros_h
#define AM_Macros_h



#define APP_DELEGATE [DCAppDelegate sharedInstance]
#define MAIN_NAVIGATION ([DCCustomNaviViewController mainNavigation])
#define USER_DEFAULT_STANDARD [NSUserDefaults standardUserDefaults]

// enum
typedef NS_ENUM(NSUInteger, PAImageSelectionType)  {
    PAImageSelectionTypeMultiple =1,
    PAImageSelectionTypeSingle =2
};

// social client
#define FACEBOOK_SCHEME_WF  @"fb1665715956980158"
#define FACEBOOK_SCHEME_FA  @"fb1504143056549269"

#define kGoogleClientIDFA     @"603320486175-hel095k7q3sshojos7hbaejd00p0lcdv.apps.googleusercontent.com"
#define kGoogleClientIDWF     @"13807393367-j3cmmvusn4i8h0ggfd2lnld3umpts1jb.apps.googleusercontent.com"

// color
#define PAUIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

// os
#define PAImage(imageName)     [UIImage imageNamed:imageName]
#define PAScreenSize           [UIScreen mainScreen].bounds.size

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// color
#define kDCGlobalYellowColorBase            [UIColor colorWithRed:254.0 / 255.0 green:191.0 / 255.0 blue:15.0 / 255.0 alpha:1]
#define kDCGlobalGrayColorBase            [UIColor colorWithRed:189.0 / 255.0 green:189.0 / 255.0 blue:189.0 / 255.0 alpha:1]

// Notification
#define kPushDidReceiveNotification             @"kPushDidReceiveNotification"

// Push Notification
#define NOTI_APS                            @"aps"
#define NOTI_ALERT                          @"alert"
#define NOTI_FILTER                          @"filter"
#define NOTI_PAGE                          @"page"
#define NOTI_DIALOGID                          @"dialog_id"
#define NOTI_USERID                          @"user_id"


// User default key
#define kDCFAShowPreviewKey               @"kDCFAShowPreviewKey"
#define kDCFAINAppSoundKey                 @"kDCFAINAppSoundKey"
#define kDCFAINAppVibrationKey                    @"kDCFAINAppVibrationKey"
#define kDCFAShareLocationKey                    @"kDCFAShareLocationKey"
#define kDCFAPhoneNumberSupportKey                    @"kDCFAPhoneNumberSupportKey"

#define kDCWFShowPreviewKey               @"kDCWFShowPreviewKey"
#define kDCWFINAppSoundKey                 @"kDCWFINAppSoundKey"
#define kDCWFINAppVibrationKey                    @"kDCWFINAppVibrationKey"
#define kDCWFShareLocationKey                    @"kDCWFShareLocationKey"
#define kDCWFOnlineStatusKey                    @"kDCWFOnlineStatusKey"
#define kDCWFPhoneNumberSupporKey                    @"kDCWFPhoneNumberSupporKey"
#define kDCWFChatRoomIDKey                    @"kDCWFChatRoomIDKey"
#define kDCWFChatRoomJIDKey                    @"kDCWFChatRoomJIDKey"
#define kDCAccessTokenKey                    @"kDCAccessTokenKey"
#define kDCPanCountryKey                    @"kDCPanCountryKey"
#define kDCDoNotShowAlertView                    @"kDCDoNotShowAlertView"


// user default value
#define kDCFAShowPreviewValue                     [USER_DEFAULT_STANDARD objectForKey:kDCFAShowPreviewKey]
#define kDCFAINAppSoundValue                  [USER_DEFAULT_STANDARD objectForKey:kDCFAINAppSoundKey]
#define kDCFAINAppVibrationValue                     [USER_DEFAULT_STANDARD objectForKey:kDCFAINAppVibrationKey]
#define kDCFAShareLocationValue                     [USER_DEFAULT_STANDARD objectForKey:kDCFAShareLocationKey]
#define kDCWFShowPreviewValue                     [USER_DEFAULT_STANDARD objectForKey:kDCWFShowPreviewKey]
#define kDCWFINAppSoundValue                     [USER_DEFAULT_STANDARD objectForKey:kDCWFINAppSoundKey]
#define kDCWFINAppVibrationValue               [USER_DEFAULT_STANDARD objectForKey:kDCWFINAppVibrationKey]
#define kDCWFShareLocationValue               [USER_DEFAULT_STANDARD objectForKey:kDCWFShareLocationKey]
#define kDCWFOnlineStatusValue               [USER_DEFAULT_STANDARD objectForKey:kDCWFOnlineStatusKey]
#define kDCWFPhoneNumberSupportValue               [USER_DEFAULT_STANDARD objectForKey:kDCWFPhoneNumberSupporKey]
#define kDCFAPhoneNumberSupportValue               [USER_DEFAULT_STANDARD objectForKey:kDCFAPhoneNumberSupportKey]
#define kDCWFChatRoomIDValue               [USER_DEFAULT_STANDARD objectForKey:kDCWFChatRoomIDKey]
#define kDCWFChatRoomJIDValue               [USER_DEFAULT_STANDARD objectForKey:kDCWFChatRoomJIDKey]
#define kDCAccessTokenValue                    [USER_DEFAULT_STANDARD objectForKey:kDCAccessTokenKey]
#define kDCPanCountryValue                    [USER_DEFAULT_STANDARD objectForKey:kDCPanCountryKey]


#define kDCOffStatusValue                   @"kDCOffStatusValue"
#define kDCOnStatusValue                    @"kDCOnStatusValue"


/** Get image by name*/
#define Image(x)  [UIImage imageNamed:x]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_3_5_INCH_SCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_4_INCH_SCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_4_7_INCH_SCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_5_5_INCH_SCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < DBL_EPSILON)
#define MAIN_SCREEN [[UIScreen mainScreen] bounds]
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_BEFORE_8   ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)
#define MESSAGE_NOT_EMPTY(message) (message.length > 0 ? 1 : 0)

#define SAFE_PERFORM_SELECTOR(target,selector) {if(target!=nil&&selector!=nil&&[target respondsToSelector:selector]){[target performSelector:selector];}}
#define SAFE_PERFORM_SELECTOR_WITH_OBJECT(target,selector,obj) {if(target!=nil&&selector!=nil&&[target respondsToSelector:selector]){[target performSelector:selector withObject:obj];}}
#define SAFE_PERFORM_SELECTOR_WITH_2OBJECT(target,selector,obj1,obj2) {if(target!=nil&&selector!=nil&&[target respondsToSelector:selector]){[target performSelector:selector withObject:obj1 withObject:obj2];}}

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGB(r, g, b)		[UIColor colorWithRed:(CGFloat)r/255.0 green:(CGFloat)g/255.0 blue:(CGFloat)b/255.0 alpha:1.0]

#define DEVICE_ID ([[[UIDevice currentDevice] identifierForVendor] UUIDString])
#define APP_DISPLAY_NAME ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])
#define APP_VERSION_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define APP_VERSION_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

#define ALLOW_HOUSEHOLD

#define AssertFileExists(path) NSAssert([[NSFileManager defaultManager] fileExistsAtPath:path], @"Cannot find the file: %@", path)
#define AssertNibExists(file_name_string) AssertFileExists([[NSBundle mainBundle] pathForResource:file_name_string ofType:@"nib"])

//#define DUMMY_RESPONSE
#define DUMMY_CONTENT_TYPE
#define DUMMY_NOTIFICATION_ID
#define DUMMY_USER_ID_OF_BUDGET_DETAIL
//#define HOPETAN_SKIP_NOT_NULL_ITEM_IF_NULL
#ifdef DEBUG
#define HOPETAN_SAVE_RECEIPT_IMAGE
#endif // DEBUG

#define NLS(text) NSLocalizedString(text, nil)

#define IS_FA_APP   [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApplicatonDCType"] isEqualToString:@"FA"]
#define IS_WF_APP   [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApplicatonDCType"] isEqualToString:@"WF"]

#define SHOW_LOADING_PROGRESS [LoadingViewHelper showLoadingWithText:NLS(@"Processing...")]
#define SHOW_LOADING          [LoadingViewHelper showLoadingWithText:NLS(@"Loading...")]
#define HIDE_LOADING     [LoadingViewHelper hideLoading]

#ifndef SAFE_RELEASE
#define	SAFE_RELEASE(ptr)	{if(ptr!=nil){if ([ptr respondsToSelector:@selector(setDelegate:)]) {[ptr performSelector:@selector(setDelegate:) withObject:nil];}[ptr release];ptr=nil;}}
#endif

#endif
