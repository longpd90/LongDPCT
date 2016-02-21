//
//  DCTaskDetailFAInfo.h
//  DispatchCenter
//
//  Created by VietHQ on 10/14/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ServerObjectBase.h"

@class DCPaymentTaskDeitalModel;
@class DCProgressHistoryModel;
@class DCTeamTaskModel;
@class DCReviewSectionModel;

@interface DCTaskDetailFAInfo : ServerObjectBase

@property( nonatomic, copy) NSString *mStrSummary;
@property( nonatomic, copy) NSString *mStrAddress;
@property( nonatomic, copy) NSString *mStrCreateDate;
@property( nonatomic, copy) NSString *mStrTask;
@property( nonatomic, copy) NSString *mStrTotalAmount;
@property( nonatomic, copy) NSString *mStrDueDate;
@property( nonatomic, copy) NSString *mStrContactName;
@property( nonatomic, copy) NSString *mStrContactMobile;
@property( nonatomic, copy) NSString *mStrLocation;
@property( nonatomic, copy) NSString *mStrStatus;
@property( nonatomic, copy) NSString *mStrTaskName;
@property( nonatomic, copy) NSNumber *mTaskId;
@property( nonatomic, copy) NSString *mStrInvoiceStatus;
@property( nonatomic, assign) NSInteger invoiceID;


//customer_qb_room_id
@property( nonatomic, copy) NSString *mStrCustomer_qb_room_id;
@property( nonatomic, copy) NSString *mStrCustomer_qb_room_jId;


// location task
@property (nonatomic, assign) CLLocationCoordinate2D mLocationTask;


// data for section task done
@property( nonatomic, strong) NSArray *mArrSecTaskDone;



// data for section payment
@property( nonatomic, copy) NSString *mStrPaymentTerm; // for payment term cell
@property( nonatomic, strong) NSArray *mPaymentList;
@property( nonatomic, copy) NSString *mStrNextPayment; // for next payment cell



// data for section progress
@property( nonatomic, strong) NSArray *mProgressList; // progress list



// data for section team
@property( nonatomic, strong) DCTeamTaskModel *mTeamModel;
@property( nonatomic, strong) NSString *mStrPhoneNumber;



// data for section review
@property( nonatomic, strong) DCReviewSectionModel *mReviewModel;

@end
