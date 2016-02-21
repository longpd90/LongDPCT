//
//  DCActiveTaskModel.h
//  DispatchCenter
//
//  Created by VietHQ on 10/13/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCActiveTaskModel : NSObject

@property( nonatomic, assign) BOOL mActive;
@property( nonatomic, assign) NSInteger mAmountTotal;
@property( nonatomic, assign) NSInteger mAmountTax;
@property( nonatomic, assign) NSInteger mUnTaxed;
@property( nonatomic, strong) NSString *mDueDate;
@property( nonatomic, assign) NSInteger mId;
@property( nonatomic, strong) NSString *mStrCode;
@property( nonatomic, strong) NSString *mStrName;
@property( nonatomic, assign) NSInteger mSummary;
@property( nonatomic, strong) NSString *mTask;
@property( nonatomic, strong) NSString *mTaskNo;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end
