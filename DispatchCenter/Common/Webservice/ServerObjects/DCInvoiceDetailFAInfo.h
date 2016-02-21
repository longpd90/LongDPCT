//
//  DCInvoiceDetailFAInfo.h
//  DispatchCenter
//
//  Created by VietHQ on 11/5/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCEntityCellDelegate.h"

@class DCInvoiceStatus;
@class DCInvoiceLineItem;
@class DCPaymentBank;
@class DCInvoicePaymentItem;
@class DCPaymentStatus;
@class DCPaymentConfig;
@class DCPaymentAllowMethod;
@class DCInvoicePaymentTerm;
@class DCInvoiceTask;
@class DCPaymentMethod;

// ------------------ DCTwoColumn Helper  -------------------- //
@interface DCTwoColumnCellHelper : NSObject

@property( strong, nonatomic) NSString *mTitle;
@property( strong, nonatomic) NSString *mContent;

@end

@interface DCPaymentCellHelper : NSObject

@property( strong, nonatomic) NSString *mPaymentMethod;
@property( strong, nonatomic) NSString *mPaymentDate;
@property( strong, nonatomic) NSString *mTotalAmount;
@property( strong, nonatomic) NSString *mStatus;
@property( strong, nonatomic) NSArray<DCPaymentAllowMethod*> *mArrPaymentAllowMethod;

@end

// ------------------ DCInvoiceDetailFAInfo -------------------- //
@interface DCInvoiceDetailInfo : ServerObjectBase

@property( strong, nonatomic) DCInvoiceStatus *mStatus;
@property( strong, nonatomic) NSArray<DCInvoiceLineItem*> *mLineItemArr;
@property( assign, nonatomic) CGFloat mAmountUntaxed;
@property( assign, nonatomic) CGFloat mNextPayment;
@property( copy, nonatomic) NSString *mInvoiceDate;
@property( strong, nonatomic) DCInvoicePaymentItem *paymentEntity;
@property( assign, nonatomic) CGFloat mAmountTax;
@property( strong, nonatomic) NSString *mInvoiceNo;
@property( assign, nonatomic) NSUInteger mId;
@property( assign, nonatomic) CGFloat mAmountTotal;
@property( strong, nonatomic) DCInvoicePaymentTerm *mPaymentTerm;
@property( strong, nonatomic) DCInvoiceTask *mInvoiceTask;
@property( strong, nonatomic) NSArray<DCInvoicePaymentItem*> *mPaymentArr;

@end


@interface DCInvoiceDetailFAInfo : DCInvoiceDetailInfo

/*
 * IS _ FA
 */
// section properties
@property( strong, nonatomic) NSArray *mDataFirsSection;
@property( strong, nonatomic) NSArray *mDataPaymentDetailSection;
@property( strong, nonatomic) DCTwoColumnCellHelper *mDataForPaymentTerm;
@property( strong, nonatomic) DCTwoColumnCellHelper *mDataForNextPayment;
@property( strong, nonatomic) NSArray<DCPaymentCellHelper*> *mDataForPaymentCells;

// Data for section
-(DCTwoColumnCellHelper*)dataForItemInFirstSection:(NSInteger)row;
-(id)dataForItemInPaymentDetailSection:(NSInteger)row;

@end

@interface DCInvoiceDetailWFInfo : DCInvoiceDetailInfo

/*
 * IS _ WF
 */
@property( strong, nonatomic) NSArray *mDataWFFirstSection;

// data for section
-(DCTwoColumnCellHelper*)dataWFForItemInFirstSection:(NSInteger)row;

@end

// ------------------ DCInvoiceStatus -------------------- //
@interface DCInvoiceStatus : NSObject

@property( strong, nonatomic) NSString *mStatusName;
@property( strong, nonatomic) NSString *mStrCode;
-(instancetype)initWithDict:(NSDictionary*)dict;

@end


// ------------------ DCInvoiceLineItem -------------------- //
@interface DCInvoiceLineItem : NSObject

@property( assign, nonatomic) NSUInteger mPriceUnit;
@property( strong, nonatomic) NSString *mStrName;
@property( assign, nonatomic) NSUInteger mQty;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end


//////////////////////// PAYMENT /////////////////////////
// ------------------ DCInvoicePaymentItem -------------------- //
@interface DCInvoicePaymentItem : NSObject

@property( strong, nonatomic) DCPaymentStatus *mPaymentStatus;
@property( strong, nonatomic) NSArray<DCPaymentAllowMethod*> *mAllowMethodArr;
@property( assign, nonatomic) NSUInteger mPaymentId;
@property( assign, nonatomic) CGFloat mPaidAmount;
@property( assign, nonatomic) BOOL mIsNeedPay;
@property( strong, nonatomic) NSString *mPaymentDate;
@property( strong, nonatomic) NSString *account_no;

@property( strong, nonatomic) DCPaymentMethod *mMethod;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end



@interface DCPaymentMethod : NSObject

@property( strong, nonatomic) NSString *mType;
@property( strong, nonatomic) NSString *mName;

@end

// ------------------ DCPaymentTerm -------------------- //
@interface DCInvoicePaymentTerm : NSObject

@property( strong, nonatomic) NSString *mDescription;
@property( assign, nonatomic) NSUInteger mId;
@property( strong, nonatomic) NSString *mName;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end



// ------------------ DCPaymentStatus -------------------- //
@interface DCPaymentStatus : NSObject

@property( strong, nonatomic) NSString *mStatusCode;
@property( strong, nonatomic) NSString *mStatusName;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end



// ------------------ DCPaymentAllowMethod -------------------- //
@interface DCPaymentAllowMethod : NSObject

@property( strong, nonatomic) NSString *mType;
@property( assign, nonatomic) NSUInteger mId;
@property( strong, nonatomic) NSString *mName;
@property( strong, nonatomic) DCPaymentBank *mBank;
@property( strong, nonatomic) DCPaymentConfig *mConfig;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end



// ------------------ DCPaymentBank -------------------- //
@interface DCPaymentBank : NSObject

@property( strong, nonatomic) NSString *mUrlLogo;
@property( strong, nonatomic) NSString *mCode;
@property( strong, nonatomic) NSString *mName;
@property( strong, nonatomic) NSString *mAccountNo;
@property( strong, nonatomic) NSString *mBranch;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end



// ------------------ DCPaymentConfig -------------------- //
@interface DCPaymentConfig : NSObject

@property( strong, nonatomic) NSString *mPublicKey;
@property( strong, nonatomic) NSString *mPrivateKey;
@property( strong, nonatomic) NSString *mPaymentGateWay;
@property( strong, nonatomic) NSString *mVersion;
@property( strong, nonatomic) NSString *mPrivateKeyPass;
@property( strong, nonatomic) NSString *mSecretKey;
@property( strong, nonatomic) NSString *mMerchantId;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end



// ------------------ DCInvoiceTask -------------------- //
@interface DCInvoiceTask : NSObject

@property( assign, nonatomic) NSUInteger mTaskId;
@property( strong, nonatomic) NSString *mSummary;
@property( strong, nonatomic) NSString *mTaskName;
@property( strong, nonatomic) NSString *mTaskNo;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end
