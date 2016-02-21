//
//  DCContactSupportVC.h
//  DispatchCenter
//
//  Created by VietHQ on 10/10/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum contactSupportViewType {
    kViewTypeContactSupport,
    kViewTypeContactUs
} viewType;

@interface DCContactSupportVC : UIViewController

@property(nonatomic, strong) NSString *mPhoneNumber;
@property(nonatomic, strong) NSString *mStrCountryName;
@property(nonatomic, assign) NSUInteger mIdCountry;
@property(nonatomic, assign) NSUInteger viewType;

@end
