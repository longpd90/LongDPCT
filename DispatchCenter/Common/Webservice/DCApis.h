//
//  DCApis.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/6/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequester.h"
@interface DCApis : NSObject
+ (void)loginByEmail:(NSString*)email password:(NSString*)password complete:(ServerResponseHandler)complete;
+ (void)loginWithSocial:(NSDictionary *)socialParams complete:(ServerResponseHandler)complete ;
+ (void)getInfoCountryWithCountryName:(NSString*)name complete:(ServerResponseHandler)complete;

+ (void)signUpWithFirstName:(NSString*)firstName
                   lastName:(NSString*)lastName
                      email:(NSString*)email
                     mobile:(NSString*)mobileNumber
                     social:(NSDictionary *)socicalParams
                   complete:(ServerResponseHandler)complete;

+ (void)paymentWithDueDate:(NSString*)date
           paymentMethodID:(NSString *)methodID
                    amount:(NSString *)amout
                 invoiceID:(NSString *)invoiceID
                  complete:(ServerResponseHandler)complete;

+ (void)getUserProfileComplete:(ServerResponseHandler)complete;
+ (void)vertifyOtp:(NSString*)otp complete:(ServerResponseHandler)complete;
+ (void)resendOptWithComplete:(ServerResponseHandler)complete;
+ (void)updateProfileWithCmd:(NSDictionary*)cmd complete:(ServerResponseHandler)complete;
+ (void)sendProblemToContactSupport:(NSString*)strProblem
                        phoneNumber:(NSString*)strPhoneNumber
                           complete:(ServerResponseHandler)complete;
+ (void)getTaskWithGroupWithComplete:(ServerResponseHandler)complete;
+ (void)getTaskDetailWithId:(NSInteger)idTask complete:(ServerResponseHandler)complete;
+ (void)getTaskCountComplete:(ServerResponseHandler)complete;
+ (void)getTaskGroupFWWithCode:(NSString *)code complete:(ServerResponseHandler)complete;

+ (void)getStateWithCode:(NSString*)code complete:(ServerResponseHandler)complete;

+ (void)getDistrictWithStateId:(NSInteger)idState complete:(ServerResponseHandler)complete;
+ (void)getDistrictWithName:(NSString*)name complete:(ServerResponseHandler)complete;

+ (void)getSubDistrictWithName:(NSString*)name complete:(ServerResponseHandler)complete;
+ (void)getSubDistrictWithDistrictId:(NSInteger)idDistrict complete:(ServerResponseHandler)complete;
+ (void)updateTaskReviewFAWithCmd:(NSDictionary*)params andIdTask:(NSInteger)idTask complete:(ServerResponseHandler)complete;

+ (void)updateTaskProgressWithId:(NSInteger)idTask withCmd:(NSDictionary*)cmd complete:(ServerResponseHandler)complete;

+ (void)getMapInfoWithZipId:(NSString*)zip andCountryCode:(NSString*)countryCode complete:(ServerResponseHandler)complete;

+ (void)getInvoiceListWithComplete:(ServerResponseHandler)complete;
+ (void)getInvoiceDetailWithId:(NSUInteger)idInvoice complete:(ServerResponseHandler)complete;


+ (void)getSettingStatuscomplete:(ServerResponseHandler)complete;

+ (void)updateSettingStatus:(NSDictionary *)settingStatus complete:(ServerResponseHandler)complete;

+ (void)getBanksWithcomplete:(ServerResponseHandler)complete;
@end
