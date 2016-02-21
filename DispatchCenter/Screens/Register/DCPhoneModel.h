//
//  DCPhoneModel.h
//  DispatchCenter
//
//  Created by VietHQ on 10/8/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#ifndef __PHONE_HELPER__
#define __PHONE_HELPER__
#import <Foundation/Foundation.h>

NSDictionary *CALLING_CODE_MAP();
NSArray *ARRAY_DATA_COUNTRY();
NSArray *ARRAY_DATA_COUNTRY_WITH_CODE();
NSDictionary *DICT_COUNTRY_CODE(); // ect: VI, TH, ...
NSString *COUNTRY_NAME_WITH_CODE_MAP(NSString *country);
NSString *CODE_MAP_FOR_COUNTRY(NSString *country);
NSString *PHONE_NUMBER_FORMAT_IN_EDIT_PROFILE(NSString* str, NSString *country);

#endif