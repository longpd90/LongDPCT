//
//  DCInvoiceForListInfo.h
//  DispatchCenter
//
//  Created by VietHQ on 11/3/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObjectBase.h"

// ---------------------------- DCInvoiceForListInfo ------------------------------- //
@interface DCInvoiceForListInfo : ServerObjectBase

@property( strong, nonatomic) NSArray *mInvoiceList;

@end


// --------------------------- DCInvoiceForListModel -------------------------------- //
@interface DCInvoiceForListModel : NSObject

@property( assign, nonatomic) NSUInteger mId; //
@property( strong, nonatomic) NSString *mStrTaskName; //
@property( strong, nonatomic) NSString *mStrSumary;
@property( strong, nonatomic) NSString *mInvoiceNo; //
@property( strong, nonatomic) NSString *mInvoiceDate; //
@property( strong, nonatomic) NSString *mStatusCode;
@property( strong, nonatomic) NSString *mStatusName;
@property( assign, nonatomic) NSInteger mAmountUnTaxed;
@property( assign, nonatomic) NSInteger mAmountTax; //
@property( assign, nonatomic) NSInteger mAmountTotal; //
@property( strong, nonatomic) NSString *mShortAddress;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end

// ---------------------------- DCTaskForInvoiceList ------------------------------- //
@interface DCTaskForInvoiceList : NSObject

@property( strong, nonatomic) NSString *mTaskNo;
@property( strong, nonatomic) NSString *mTask;
@property( assign, nonatomic) NSUInteger mId;

@end
