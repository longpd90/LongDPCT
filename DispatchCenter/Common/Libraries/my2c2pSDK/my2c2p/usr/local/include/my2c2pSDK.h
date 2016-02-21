//
//  my2c2pSDK.h
//  my2c2pSDK
//
//  Version : 2.1.8
//  Update At 31/03/2015
//  Created by 2c2p on 23/1/13.
//  Copyright (c) 2013 2c2p. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "paymentFormViewController.h"

#define iOS2c2pLogNoti @"iOS2c2pLogNotification"

typedef void (^APIResponse)(NSDictionary* response);
typedef void (^APIViewControllerAppear)(UINavigationController* otpVC);
typedef void (^APIResponseError)(NSError* error);

@protocol my2c2pSDKDelegate <NSObject>

@optional
- (void)my2c2pSDKWillOpenOTPPage;
- (void)my2c2pSDKDidOpenOTPPage;
- (void)my2c2pSDKWillCloseOTPPageWithCancel:(BOOL)cancel;
- (void)my2c2pSDKDidCloseOTPPageWithCancel:(BOOL)cancel;

@end
@interface my2c2pSDK : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate,UITextFieldDelegate>

@property (nonatomic,assign) id<my2c2pSDKDelegate> delegate;
@property (nonatomic,strong) NSString* merchantID;
@property (nonatomic,strong) NSString* uniqueTransactionCode;
@property (nonatomic,strong) NSString* desc;
@property (nonatomic,assign) double amt;
@property (nonatomic,strong) NSString* currencyCode;

@property (nonatomic,strong) NSString* payCategoryID;
@property (nonatomic,strong) NSString* userDefined1;
@property (nonatomic,strong) NSString* userDefined2;
@property (nonatomic,strong) NSString* userDefined3;
@property (nonatomic,strong) NSString* userDefined4;
@property (nonatomic,strong) NSString* userDefined5;
@property (nonatomic,assign) BOOL enableStoreCard;

@property (nonatomic,strong) NSString* cardholderName;
@property (nonatomic,strong) NSString* cardholderEmail;
@property (nonatomic,strong) NSString* storeCardUniqueID;

//for 3ds
@property (nonatomic,strong) NSString *request3DS;

//For non payment UI
@property (nonatomic,strong) NSString* pan;
@property (nonatomic) int cardExpireMonth;
@property (nonatomic) int cardExpireYear;
@property (nonatomic) NSString* securityCode;
@property (nonatomic,strong) NSString* panCountry;
@property (nonatomic,strong) NSString* panBank;
///////////////
@property (nonatomic) BOOL productionMode;
//for v8
@property (nonatomic) BOOL displayPaymentPage;

//for v8
@property (nonatomic, assign) double apiVersion;
@property (nonatomic, assign) BOOL ippTransaction;
@property (nonatomic, assign) int installmentPeriod;
@property (nonatomic, strong) NSString *interestType;
@property (nonatomic, assign) BOOL recurring;
@property (nonatomic, assign) BOOL storeCard;
@property (nonatomic, strong) NSString *invoicePrefix;
@property (nonatomic, assign) double recurringAmount;
@property (nonatomic, assign) BOOL allowAccumulate;
@property (nonatomic, assign) double maxAccumulateAmt;
@property (nonatomic, assign) int recurringInterval;
@property (nonatomic, assign) int recurringCount;
@property (nonatomic, strong) NSString *chargeNextDate;
@property (nonatomic, strong) NSString *promotion;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, strong) NSString *hashKey;
///////////////

- (id) initWithPrivateKey:(NSString*)privateKey;

- (void) requestWithTarget:(id)targetViewController onResponse:(APIResponse)completion onFail:(APIResponseError)error;

- (void) requestWithTarget:(id)targetViewController AndPaymentForm:(paymentFormViewController*)paymentForm onResponse:(APIResponse)completion onFail:(APIResponseError)error;

@end
