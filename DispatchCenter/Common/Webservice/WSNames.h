//
//  WSNames.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/6/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#ifndef WSNames_h
#define WSNames_h

#define API_METHOD_NAME_LOGIN                   @"session"
#define API_METHOD_GET_PROFILE                  @"users/"

#define API_PR_NAME_EMAIL                       @"email"
#define API_PR_NAME_PASSWORD                    @"password"
#define API_PR_NAME_TOKEN                       @"token"
#define API_PR_NEED_PROFILE                     @"need_profile"
#define API_PR_NEED_USER                        @"user"

#define API_METHOD_COUNTRY_LIST                 @"countries"

#define API_PR_COUNTRY_NAME                     @"name"

#define API_METHOD_SIGN_UP                      @"users"

#define API_PR_USER_FIRST_NAME                  @"first_name"
#define API_PR_USER_LAST_NAME                   @"last_name"
#define API_PR_USER_MOBILE                      @"mobile"
#define API_PR_USER_CUSTOMER                    @"customer"
#define API_PR_USER_EMPLOYEE                    @"employee"
#define API_PR_USER_EMAIL                       @"email"
#define API_PR_USER_QB                          @"user_qb"
#define API_PR_USER_QB_LOGIN                    @"login"
#define API_PR_USER_QB_ROOM_ID                  @"room_id"
#define API_PR_USER_QB_ROOM_JID                 @"room_jid"
#define API_PR_SOCIAL_CHANNEL                   @"social_channel"
#define API_PR_SOCIAL_MODE                      @"code"
#define API_PR_SOCIAL_TOKEN                     @"access_token"
#define API_PR_SOCIAL_TOKEN_SECRECT             @"access_token_secret"

#define API_PR_FACEBOOK_TOKEN_KEY                @"API_PR_FACEBOOK_TOKEN_KEY"
#define API_PR_GOOGLE_TOKEN_KEY                  @"API_PR_GOOGLE_TOKEN_KEY"
#define API_PR_TWITER_TOKEN_KEY                  @"API_PR_TWITER_TOKEN_KEY"
#define API_PR_TWITER_TOKEN_SECRECT_KEY          @"API_PR_TWITER_TOKEN_SECRECT_KEY"

#define API_PR_FACEBOOK_TOKEN_VALUE             [USER_DEFAULT_STANDARD objectForKey:API_PR_FACEBOOK_TOKEN_KEY]
#define API_PR_GOOGLE_TOKEN_VALUE               [USER_DEFAULT_STANDARD objectForKey:API_PR_GOOGLE_TOKEN_KEY]
#define API_PR_TWITER_TOKEN_VALUE               [USER_DEFAULT_STANDARD objectForKey:API_PR_TWITER_TOKEN_KEY]
#define API_PR_TWITER_TOKEN_SECRECT_VALUE       [USER_DEFAULT_STANDARD objectForKey:API_PR_TWITER_TOKEN_SECRECT_KEY]

#define API_METHOD_VERTIFY_OTP                  @"users/verify"
#define API_METHOD_PAYMENT                      @"payments"

#define API_PR_VERTIFY_OTP                      @"otp"

#define API_PR_INVOICE_ID                       @"invoice_id"
#define API_PR_INVOICE_AMOUNT                   @"amount"
#define API_PR_PAYMENT_METHOD                   @"payment_method_id"
#define API_PR_DUE_DATE                         @"due_date"

#define API_METHOD_RESEND_OTP                   @"resend_otp"

#define API_METHOD_UPDATE_PROFILE               @"users"

#define API_PR_UPD_PROFILE_FIST_NAME            @"first_name"
#define API_PR_UPD_PROFILE_LAST_NAME            @"last_name"
#define API_PR_UPD_PROFILE_PASS                 @"password"
#define API_PR_UPD_PROFILE_ADDRESS              @"address"
#define API_PR_UPD_PROFILE_PHONE                @"phone"
#define API_PR_UPD_PROFILE_MOBILE               @"mobile"
#define API_PR_UPD_PROFILE_EMAIL                @"email"
#define API_PR_UPD_PROFILE_IMG                  @"image"

#define API_METHOD_CONTACT_SUPPORT              @"contact"

#define API_PR_CONTACT_MSG                      @"message"

#define API_METHOD_TASK_COUNT                   @"tasks/count"

#define API_METHOD_TASK                         @"tasks"

#define API_PR_TASK_GROUP                       @"group"

#define API_PR_TASK_DETAIL                      @"id"
#define API_PR_URL_IMAGE                        @"url_image"

#define API_METHOD_STATE                        @"provinces"

#define API_METHOD_DISTRICTS                    @"districts"

#define API_METHOD_SUB_DISTRICTS                @"subdistricts"

#define API_METHOD_REVIEW                       @"tasks/review"


#define API_METHOD_ADDRESS                      @"address"

#define API_METHOD_INVOICES                     @"invoices"

#define API_METHOD_SETTINGS                     @"users/settings"

#define API_METHOD_BANKS                        @"banks"

#endif /* WSNames_h */
