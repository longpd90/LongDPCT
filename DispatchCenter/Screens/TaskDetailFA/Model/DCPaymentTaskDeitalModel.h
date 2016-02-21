//
//  DCPaymentTaskDeitalModel.h
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCPaymentTaskDeitalModel : NSObject

@property( nonatomic, assign) NSInteger mId;
@property( nonatomic, assign) BOOL mNeedPay;
@property( nonatomic, copy) NSString *mMethodName;
@property( nonatomic, copy) NSString *mMethodType;
@property( nonatomic, copy) NSString *mCardHolderName;
@property( nonatomic, copy) NSString *mCardNumber;
@property( nonatomic, assign) NSInteger mExpiryMonth;
@property( nonatomic, assign) NSInteger mExpiryYear;
@property( nonatomic, copy) NSString *mPayDate;
@property( nonatomic, strong) NSString *mPaidAmount;
@property( nonatomic, strong) NSString *mStatus;
@property( nonatomic, strong) NSString *mNextPayment;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end
