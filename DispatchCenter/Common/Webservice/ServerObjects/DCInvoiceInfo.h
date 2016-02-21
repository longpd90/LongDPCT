//
//  DCInvoiceInfo.h
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DCLineItem : NSObject
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSNumber *quanlity;
@end

@interface DCInvoicePaymentMethod : NSObject
//pay method via credit card
@property (nonatomic, strong) NSNumber *methodId;
@property (nonatomic, strong) NSString *methodName;
@property (nonatomic, strong) NSString *methodType;
@property (nonatomic, strong) NSString *cardHolderName;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSNumber *expiryMonth;
@property (nonatomic, strong) NSNumber *expireYear;

//credit config
@property (nonatomic, strong) NSString *configGateway;
@property (nonatomic, strong) NSString *configVers;
@property (nonatomic, strong) NSString *configMerchantId;
@property (nonatomic, strong) NSString *configSecretKey;
@property (nonatomic, strong) NSString *configPublicKey;
@property (nonatomic, strong) NSString *configPrivateKey;
@property (nonatomic, strong) NSString *configPrivateKeyPass;

//pay method via bank
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *branch;
@property (nonatomic, strong) NSString *accountNum;
@property (nonatomic, strong) NSString *urlLogo;

//pay method via cash
@end

@interface DCInvoicePaymentInfo : NSObject
@property (nonatomic, strong) NSNumber *paymentId;
@property (nonatomic, assign) BOOL needPay;
@property (nonatomic, strong) NSString *paymentDate;
@property (nonatomic, strong) NSNumber *paidAmount;
@property (nonatomic, strong) NSString *statusCode;
@property (nonatomic, strong) NSString *statusName;
@property (nonatomic, strong) DCInvoicePaymentMethod *method;
@property (nonatomic, strong) NSArray *paymentMethods; //this array need or not, are there more than 1 payment Method ?
@property (nonatomic, strong) NSArray *allowPaymentMethods;
@end

@interface DCInvoiceInfo : NSObject
@property (nonatomic, strong) NSNumber *invoiceId;
@property (nonatomic, strong) NSString *invoiceTaskName;
@property (nonatomic, strong) NSString *invoiceTaskSummary;
@property (nonatomic, strong) NSString *invoiceNum;
@property (nonatomic, strong) NSString *invoiceDate;
@property (nonatomic, strong) NSString *strStatusCode;
@property (nonatomic, strong) NSString *strStatusName;

@property (nonatomic, strong) NSNumber *amount_taxed;
@property (nonatomic, strong) NSNumber *amount_untaxed;
@property (nonatomic, strong) NSNumber *amount_total;

@property (nonatomic, strong) NSArray *lineItems;
@property (nonatomic, strong) NSNumber *nextPayments;

@property (nonatomic, strong) NSArray *payments;



@end
