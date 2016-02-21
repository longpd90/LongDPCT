//
//  DCTaskDetailWFInfo.h
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObjectBase.h"
#import "DCTaskWF.h"
#import <CoreLocation/CoreLocation.h>
#import "DCInvoiceInfo.h"
//


@class DCTaskDetailCategory;


//for category infor
@interface DCTaskDetailCategory : NSObject
@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSString *categoryName;
@end


//for address infor
@interface DCDistrict : NSObject
@property (nonatomic, strong) NSNumber *districtId;
@property (nonatomic, strong) NSString *districtName;
@end


@interface DCProvince : NSObject
@property (nonatomic, strong) NSNumber *provinceId;
@property (nonatomic, strong) NSString *provinceName;
@end

@interface  DCSubdistrict : NSObject
@property (nonatomic, strong) NSNumber *subdistrictId;
@property (nonatomic, strong) NSString *subdistrictName;
@end

@interface DCAddressInfor : NSObject
@property (nonatomic, strong) NSString *address1;
@property (nonatomic, strong) NSString *address2;
@property (nonatomic, strong) DCDistrict *district;
@property (nonatomic, strong) DCProvince *province;
@property (nonatomic, strong) DCSubdistrict *subdistrict;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, assign) CLLocationCoordinate2D geoLocation;

@end

// for job infor
@interface DCPaymentTerm : NSObject
@property (nonatomic, strong) NSNumber *paymentTermId;
@property (nonatomic, strong) NSString *paymentName;
@property (nonatomic, strong) NSString *paymentDescription;

@end

@interface DCJobInfor : NSObject
@property (nonatomic, strong) NSString *job_no;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) DCPaymentTerm *paymentTerm;
@end

// for team info

@interface DCTeamMember : NSObject
@property (nonatomic, strong) NSString *teamMemberName;
@property (nonatomic, strong) NSString *teamMemberImg;
@end

@interface DCTaskTeam : NSObject
@property (nonatomic, strong) NSNumber *teamId;
@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, strong) NSString *contactImage;
@property (nonatomic, strong) NSString *contactMobile;
@property (nonatomic, assign) BOOL enabledShareLocation;
@property (nonatomic, strong) NSString *idUserQB;
@property (nonatomic, strong) NSArray *teamMembers;
@end

// for progress history info
@interface DCProgressStatus : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@end

@interface DCProgressInfo : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) DCProgressStatus *status;
@end

//for review info
@interface DCReviewDetail : NSObject
@property (nonatomic, strong) NSNumber *detailId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *score;
@end


@interface DCTaskReview : NSObject
@property (nonatomic, strong) NSNumber *reviewId;
@property (nonatomic, strong) NSNumber *templateId;
@property (nonatomic, strong) NSNumber *avgScore;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSArray *details;
@end



@interface DCTaskDetailWFInfo : ServerObjectBase

@property (nonatomic, strong) NSNumber *uID;
@property (nonatomic, strong) NSString *task;
@property (nonatomic, assign) NSString *summaryText;
@property (nonatomic, strong) NSString *due_date;
@property (nonatomic, strong) NSString *created_date;
@property (nonatomic, strong) NSString *task_no;
@property (nonatomic, strong) NSString *amount_untaxed;
@property (nonatomic, strong) NSString *amount_tax;
@property (nonatomic, strong) NSString *amount_total;
@property (nonatomic, strong) NSNumber *customerId;
@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, strong) DCAddressInfor *taskAddress;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *mobileNum;
@property (nonatomic, strong) NSString *operatorEndDate;
@property (nonatomic, strong) NSString *operatorStartDate;

//customer_qb_room_id
@property( nonatomic, copy) NSString *mStrCustomer_qb_room_id;
@property( nonatomic, copy) NSString *mStrCustomer_qb_room_jId;

//for task detail status
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) DCJobInfor *jobInfo;
@property (nonatomic, strong) NSArray *progressHistory;

//allow_actions
@property (nonatomic, strong) NSArray *customer;
@property (nonatomic, strong) NSArray *workforce;

//team
@property (nonatomic, strong) DCTaskTeam *team;

//Invoices
@property (nonatomic, strong) NSArray *invoices;



//review
@property (nonatomic, strong) DCTaskReview *review;

@property (nonatomic, assign) BOOL active;


@property (nonatomic, assign) TaskListType typeTask;

@end
