//
//  DCCountryPicker.h
//  DispatchCenter
//
//  Created by VietHQ on 10/7/15.
//  Copyright (c) 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCCountryPicker : UIView

@property(nonatomic, copy) NSString *mStrSelectCountry;
@property (nonatomic, strong) NSArray *mArrDataCountry;
@property (nonatomic, strong, readonly) NSArray *mCountryWithIdList;
@property(nonatomic, copy) void (^selectCountryEvent)(NSString *strCountrySelect, NSString *strMapCode);

-(void)getListCountryFromServer;
-(void)getListCountryInSys;

@end
