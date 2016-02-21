//
//  DCListCountryInfo.h
//  DispatchCenter
//
//  Created by VietHQ on 10/8/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObjectBase.h"

@interface DCItemNameId : NSObject

@property(nonatomic, assign) NSInteger mId;
@property(nonatomic, strong) NSString *mName;
@property(nonatomic, strong) NSString *mISOName;

@end

@interface DCListCountryInfo : ServerObjectBase

@property(nonatomic, strong) NSArray *mListCountry; // only name
@property(nonatomic, strong) NSArray *mListCountryWithId;
@property(nonatomic, strong) NSArray *mListCountryCode; //only code

@end
