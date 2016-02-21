//
//  DCApis.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/6/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCApis.h"
#import "WSNames.h"
#import "ServerObjectBase.h"
#import "DCLoginInfo.h"
#import "DCListCountryInfo.h"
#import "DCVertifyOtpInfo.h"
#import "DCUpdateProfileInfo.h"
#import "DCContactSupportInfo.h"
#import "DCActiveTaskInfo.h"
#import "DCTaskDetailFAInfo.h"
#import "DCTaskDetailWFInfo.h"
#import "DCTaskCountWF.h"
#import "DCTaskWF.h"
#import "DCMyProfile.h"
#import "DCStateInfo.h"
#import "DCDistrictsInfo.h"
#import "DCReviewSectionModel.h"
#import "DCMapInfo.h"
#import "DCPhoneModel.h"
#import "DCInvoiceForListInfo.h"
#import "DCSetting.h"
#import "DCInvoiceDetailFAInfo.h"
#import "DCBankBranchInfo.h"

@implementation DCApis
+ (void)loginByEmail:(NSString*)email password:(NSString*)password complete:(ServerResponseHandler)complete {
    NSDictionary *params = @{API_PR_NAME_EMAIL : (email ? : @""),
                             API_PR_NAME_PASSWORD : (password ? : @""),
                             API_PR_NEED_PROFILE : @(YES)};
    [[WSRequester new] sendPOSTRequestForAPI:API_METHOD_NAME_LOGIN parameters:params responseObjectClass:[DCLoginInfo class] responseHandler:complete withToken:NO];
}

+ (void)loginWithSocial:(NSDictionary *)socialParams complete:(ServerResponseHandler)complete {
    NSDictionary *params = @{API_PR_SOCIAL_CHANNEL : (socialParams ? : @""),
                             API_PR_NEED_PROFILE : @(YES)};
    
    [[WSRequester new] sendPOSTRequestForAPI:API_METHOD_NAME_LOGIN
                                  parameters:params
                         responseObjectClass:[DCLoginInfo class]
                             responseHandler:complete withToken:NO];
}


+ (void)getInfoCountryWithCountryName:(NSString*)name complete:(ServerResponseHandler)complete
{
    
    if (name)
    {
        NSString *pURL = [NSString stringWithFormat:@"%@?name=%@", API_METHOD_COUNTRY_LIST, name];
        [[WSRequester new] sendGETRequestWithURL:pURL responseObjectClass:[DCListCountryInfo class] responseHandler:complete withToken:NO];
    }
    else
    {
        [[WSRequester new] sendGETRequestWithURL:API_METHOD_COUNTRY_LIST responseObjectClass:[DCListCountryInfo class] responseHandler:complete withToken:NO];
    }
    
}

+ (void)signUpWithFirstName:(NSString*)firstName
                         lastName:(NSString*)lastName
                            email:(NSString*)email
                           mobile:(NSString*)mobileNumber
                           social:(NSDictionary *)socicalParams
                         complete:(ServerResponseHandler)complete
{
    NSDictionary *pParams = @{  API_PR_USER_FIRST_NAME : (firstName ? : @""),
                                API_PR_USER_LAST_NAME : (lastName ? : @""),
                                API_PR_USER_EMAIL: (email ? : @""),
                                API_PR_USER_MOBILE : (mobileNumber ? : @""),
                                (IS_FA_APP ? API_PR_USER_CUSTOMER : API_PR_USER_EMPLOYEE) : @"true"};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:pParams];
    if (socicalParams) {
        [params setObject:socicalParams forKey:API_PR_SOCIAL_CHANNEL];
    }
    
    [[WSRequester new] sendPOSTRequestForAPI: API_METHOD_SIGN_UP
                                  parameters: params
                         responseObjectClass: [DCLoginInfo class]
                             responseHandler: complete
                                   withToken: NO];
}


+ (void)getUserProfileComplete:(ServerResponseHandler)complete {    
    [[WSRequester new] sendGETRequestWithURL:API_METHOD_GET_PROFILE responseObjectClass:[DCMyProfile class] responseHandler:complete withToken:YES];
}

+ (void)vertifyOtp:(NSString*)otp complete:(ServerResponseHandler)complete
{
    NSDictionary *pParams = @{ API_PR_VERTIFY_OTP : (otp ? : @"")};
    //DLogInfo(@"%@", pParams);
    
    [[WSRequester new] sendPOSTRequestForAPI: API_METHOD_VERTIFY_OTP
                                  parameters: pParams
                         responseObjectClass: [DCVertifyOtpInfo class]
                             responseHandler: complete
                                   withToken: YES];
}

+ (void)paymentWithDueDate:(NSString*)date
           paymentMethodID:(NSString *)methodID
                    amount:(NSString *)amout
                 invoiceID:(NSString *)invoiceID
                  complete:(ServerResponseHandler)complete
{
    NSDictionary *pParams = @{ API_PR_INVOICE_ID : (invoiceID ? : @""),
                               API_PR_INVOICE_AMOUNT : (amout ? : @""),
                               API_PR_PAYMENT_METHOD : (methodID ? : @""),
                               API_PR_DUE_DATE : (date ? : @"")};
    
    [[WSRequester new] sendPOSTRequestForAPI: API_METHOD_PAYMENT
                                  parameters: pParams
                         responseObjectClass: [DCVertifyOtpInfo class]
                             responseHandler: complete
                                   withToken: YES];
}

+ (void)resendOptWithComplete:(ServerResponseHandler)complete
{
    [[WSRequester new] sendPOSTRequestForAPI: API_METHOD_RESEND_OTP
                                  parameters: nil
                         responseObjectClass: [DCVertifyOtpInfo class]
                             responseHandler: complete
                                   withToken: YES];
}

+ (void)updateProfileWithCmd:(NSDictionary*)cmd complete:(ServerResponseHandler)complete
{
    //DLogInfo(@"%@", cmd);
    [[WSRequester new] sendPUTRequestForAPI: API_METHOD_UPDATE_PROFILE
                                 parameters: cmd
                        responseObjectClass: [DCUpdateProfileInfo class]
                            responseHandler: complete
                                  withToken: YES];
}

+ (void)sendProblemToContactSupport:(NSString*)strProblem
                        phoneNumber:(NSString*)strPhoneNumber
                           complete:(ServerResponseHandler)complete
{
    NSMutableDictionary *pDataToSend = [[NSMutableDictionary alloc] initWithCapacity:50];
    
    if (APP_DELEGATE.mMyProfile.mStatus == DCMyProfileStatusVerify)
    {
        DCMyProfile *pProfile = APP_DELEGATE.mMyProfile;
        pDataToSend[@"name"] = [NSString stringWithFormat:@"%@ %@", pProfile.mFirstName, pProfile.mLastName] ? : @"";
        pDataToSend[@"email"] = pProfile.mEmail ? : @"";
        pDataToSend[@"mobile"] = strPhoneNumber;
        
        NSDictionary *pDictCountryCode = DICT_COUNTRY_CODE();
        NSString *pCodeCountry = pDictCountryCode[pProfile.mCountry] ? : @"";

        pDataToSend[@"country"] = @{@"id": pProfile.mIdCountry ? @(pProfile.mIdCountry) : @0,
                                    @"code" : pCodeCountry,
                                    @"name" : pProfile.mCountry};
        
        pDataToSend[API_PR_CONTACT_MSG] = strProblem ? : @"";

    }
    else
    {
        pDataToSend[@"name"] = @"";
        pDataToSend[@"email"] = @"";
        pDataToSend[@"mobile"] = strPhoneNumber;
        
        NSUserDefaults *pDefaul = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *pDictCountryCode = DICT_COUNTRY_CODE();
        NSString *pCodeCountry = pDictCountryCode[[pDefaul valueForKey:USER_KEY_COUNTRY_NAME]] ? : @"";
        DLogInfo(@" ~ name %@", pDictCountryCode[[pDefaul valueForKey:USER_KEY_COUNTRY_NAME]]);
        
        pDataToSend[@"country"] = @{@"id": [pDefaul valueForKey:USER_KEY_ID_COUNTRY] ? : @1,
                                    @"code" : pCodeCountry ? : @"TH" ,
                                    @"name" : [pDefaul valueForKey:USER_KEY_COUNTRY_NAME] ? : @"Thailand"};
        
        pDataToSend[API_PR_CONTACT_MSG] = strProblem ? : @"";
    }
    
    NSDictionary *pParams = [pDataToSend copy];
    DLogInfo(@"dict to send %@", pParams);
    
    [[WSRequester new] sendPOSTRequestForAPI: API_METHOD_CONTACT_SUPPORT
                                  parameters: pParams
                         responseObjectClass: [DCContactSupportInfo class]
                             responseHandler: complete
                                   withToken: NO];
}

+ (void)getTaskWithGroupWithComplete:(ServerResponseHandler)complete
{
    [[WSRequester new] sendGETRequestWithURL: API_METHOD_TASK
                         responseObjectClass: [DCActiveTaskInfo class]
                             responseHandler: complete
                                   withToken: YES];
}

+ (void)getTaskDetailWithId:(NSInteger)idTask complete:(ServerResponseHandler)complete
{
    NSString *pUrl = [NSString stringWithFormat:@"%@/%li", API_METHOD_TASK, (long)idTask];
    [[WSRequester new] sendGETRequestWithURL: pUrl
                                  parameters: nil
                         responseObjectClass: (IS_WF_APP ? [DCTaskDetailWFInfo class] : [DCTaskDetailFAInfo class])
                             responseHandler: complete
                                   withToken: YES];
}


+ (void) getTaskCountComplete:(ServerResponseHandler)complete {
    [[WSRequester new] sendGETRequestWithURL:API_METHOD_TASK_COUNT
                         responseObjectClass:[DCTaskCountWF class]
                             responseHandler:complete withToken:YES];
}

+ (void)getTaskGroupFWWithCode:(NSString *)code
                      complete:(ServerResponseHandler)complete {
    if ([code isEqualToString:@"in_progerss"])
        code = @"in_progress";
    NSString *strUrl = [NSString stringWithFormat:@"%@/?group=%@",API_METHOD_TASK,code];
    [[WSRequester new] sendGETRequestWithURL:strUrl
                         responseObjectClass:[DCTaskWF class]
                             responseHandler:complete withToken:YES];
}

+ (void)getStateWithCode:(NSString*)code complete:(ServerResponseHandler)complete
{
    NSString *pUrl = API_METHOD_STATE;
    if (code)
    {
        pUrl = [NSString stringWithFormat:@"%@/?name=%@", API_METHOD_STATE, code];
    }
    
    [[WSRequester new] sendGETRequestWithURL: pUrl
                                  parameters: nil
                         responseObjectClass: [DCStateInfo class]
                             responseHandler: complete
                                   withToken: YES];
}

+ (void)getDistrictWithStateId:(NSInteger)idState complete:(ServerResponseHandler)complete
{
    NSString *pUrl = API_METHOD_DISTRICTS;
    if (idState)
    {
        pUrl = [NSString stringWithFormat:@"%@?province_id=%li", API_METHOD_DISTRICTS, (long)idState];
    }
    
    [[WSRequester new] sendGETRequestWithURL:pUrl
                         responseObjectClass:[DCDistrictsInfo class]
                             responseHandler:complete
                                   withToken:YES];
}

+ (void)getDistrictWithName:(NSString*)name complete:(ServerResponseHandler)complete
{
    NSString *pUrl = API_METHOD_DISTRICTS;
    if (name)
    {
        pUrl = [NSString stringWithFormat:@"%@?name=%@", API_METHOD_DISTRICTS, name];
    }
    
    [[WSRequester new] sendGETRequestWithURL:pUrl
                         responseObjectClass:[DCDistrictsInfo class]
                             responseHandler:complete
                                   withToken:YES];

}

+ (void)getSubDistrictWithName:(NSString*)name complete:(ServerResponseHandler)complete
{
    NSString *pUrl = API_METHOD_SUB_DISTRICTS;
    if (name)
    {
        pUrl = [NSString stringWithFormat:@"%@?name=%@", API_METHOD_SUB_DISTRICTS, name];
    }
    
    [[WSRequester new] sendGETRequestWithURL:pUrl
                         responseObjectClass:[DCSubDistrictsInfo class]
                             responseHandler:complete
                                   withToken:YES];
}

+ (void)getSubDistrictWithDistrictId:(NSInteger)idDistrict complete:(ServerResponseHandler)complete
{
    NSString *pUrl = API_METHOD_SUB_DISTRICTS;
    if (idDistrict)
    {
        pUrl = [NSString stringWithFormat:@"%@?district_id=%li", API_METHOD_SUB_DISTRICTS, (long)idDistrict];
    }
    
    [[WSRequester new] sendGETRequestWithURL:pUrl
                         responseObjectClass:[DCSubDistrictsInfo class]
                             responseHandler:complete
                                   withToken:YES];

}

+ (void)updateTaskReviewFAWithCmd:(NSDictionary*)params andIdTask:(NSInteger)idTask complete:(ServerResponseHandler)complete
{
    if (!idTask)
    {
        return;
    }
    
    NSString *pUrl = [NSString stringWithFormat:@"%@/%li", API_METHOD_REVIEW, (long)idTask];
    
    [[WSRequester new] sendPUTRequestForAPI:pUrl
                                 parameters:params
                        responseObjectClass:[DCReviewSectionModel class]
                            responseHandler:complete
                                  withToken:YES];
}


+ (void)updateTaskProgressWithId:(NSInteger)idTask withCmd:(NSDictionary *)cmd complete:(ServerResponseHandler)complete {
    NSString *pUrl = [NSString stringWithFormat:@"%@/%li", API_METHOD_TASK, (long)idTask];
    
    [[WSRequester new] sendPUTRequestWithURL:pUrl
                                  parameters:cmd
                        responseObjectClass: (IS_WF_APP ? [DCTaskDetailWFInfo class] : [DCTaskDetailFAInfo class])
                             responseHandler:complete withToken:YES];
    
}


+ (void)getMapInfoWithZipId:(NSString*)zip
             andCountryCode:(NSString*)countryCode
                   complete:(ServerResponseHandler)complete
{
    // country_code=TH&zip=10330
    NSString *pUrl = [NSString stringWithFormat:@"%@?country_code=%@&zip=%@",API_METHOD_ADDRESS, countryCode, zip];
    
    [[WSRequester new] sendGETRequestWithURL:pUrl
                         responseObjectClass:[DCMapInfo class]
                             responseHandler:complete
                                   withToken:YES];
}

+ (void)getInvoiceListWithComplete:(ServerResponseHandler)complete
{
    
    NSString *pUrl = API_METHOD_INVOICES;
    
    [[WSRequester new] sendGETRequestWithURL: pUrl
                         responseObjectClass: [DCInvoiceForListInfo class]
                             responseHandler: complete
                                   withToken: YES];
}

+ (void)getInvoiceDetailWithId:(NSUInteger)idInvoice complete:(ServerResponseHandler)complete
{
    if (!idInvoice)
    {
        return;
    }
    
    NSString *pUrl = API_METHOD_INVOICES;
    if (idInvoice)
    {
        // invoices/:id
        pUrl = [NSString stringWithFormat:@"%@/%li", API_METHOD_INVOICES, (long)idInvoice];
    }
    
    [[WSRequester new] sendGETRequestWithURL: pUrl
                         responseObjectClass: IS_FA_APP ? [DCInvoiceDetailFAInfo class] : [DCInvoiceDetailWFInfo class]
                             responseHandler: complete
                                   withToken: YES];
    
}

+ (void)getBanksWithcomplete:(ServerResponseHandler)complete
{
    NSString *pUrl = API_METHOD_BANKS;
    [[WSRequester new] sendGETRequestWithURL: pUrl
                         responseObjectClass:  [DCBankBranchInfo class]
                             responseHandler: complete
                                   withToken: YES];
    
}

+ (void)getSettingStatuscomplete:(ServerResponseHandler)complete
{
    /*
     * id = 0, load all invoices, id #0 load invoice detail by id
     */
    
    NSString *pUrl = API_METHOD_SETTINGS;
    
    [[WSRequester new] sendGETRequestWithURL:pUrl
                         responseObjectClass:[DCSetting class]
                             responseHandler:complete
                                   withToken:YES];
}

+ (void)updateSettingStatus:(NSDictionary *)settingStatus complete:(ServerResponseHandler)complete
{
    [[WSRequester new] sendPUTRequestForAPI: API_METHOD_SETTINGS
                                 parameters: settingStatus
                        responseObjectClass: [DCSetting class]
                            responseHandler: complete
                                  withToken: YES];
}

@end
