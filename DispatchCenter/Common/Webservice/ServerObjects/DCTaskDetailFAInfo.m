//
//  DCTaskDetailFAInfo.m
//  DispatchCenter
//
//  Created by VietHQ on 10/14/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskDetailFAInfo.h"
#import "DCPaymentTaskDeitalModel.h"
#import "DCProgressHistoryModel.h"
#import "DCTeamTaskModel.h"
#import "DCReviewSectionModel.h"

@implementation DCTaskDetailFAInfo

-(void)parseResponse:(NSDictionary *)response
{
    NSDictionary *tmp = response;
    
    [self parseDataForSectionTaskDone:tmp];
    [self parseDataForSectionPayment:tmp];
    [self parseDataForSectionProgress:tmp];
    [self parseDataForSectionTeam:tmp];
    [self parseDataForSectionReview:tmp];
    
    // customer_qb_id
    self.mStrCustomer_qb_room_id = [tmp stringForKey:@"customer_qb_room_id"] ?  : @"";
    self.mStrCustomer_qb_room_jId = [tmp stringForKey:@"customer_qb_room_jid"] ? : @"";
    //DLogInfo(@" ~ customer %@", self.mStrCustomer_qb_room_id);
    
    // location task
    NSDictionary *pDictAddress = [tmp dictionaryForKey:@"address"];
    NSDictionary *pLoDict = [pDictAddress dictionaryForKey:@"geo_location"];
    CGFloat latitude = [pLoDict floatForKey:@"latitude"];
    CGFloat longitude = [pLoDict floatForKey:@"longitude"];
    
    self.mLocationTask = CLLocationCoordinate2DMake(latitude, longitude);
}

#pragma mark - Parse helper
-(NSString*)parseAddressStringFromDict:(NSDictionary*)dict
{
//    NSString *pAddress1 = [dict stringForKey:@"address1"];
//    NSString *pAddress2 = [dict stringForKey:@"address2"];
    NSDictionary *pProvince = [dict dictionaryForKey:@"province"] ;
    NSString *pStrProvince = [pProvince stringForKey:@"name"] ? : @"";
    NSDictionary *pDistrict = [dict dictionaryForKey:@"district"] ;
    NSString *pStrDistrict = [pDistrict stringForKey:@"name"] ? : @"";
    NSDictionary *pSubDistrict = [dict dictionaryForKey:@"subdistrict"] ;
    NSString *pStrSubDist = [pSubDistrict stringForKey:@"name"] ? : @"";
    NSString *pStrZip = [dict stringForKey:@"zip"] ? : @"";
    
    NSString *stringAddress = [NSString stringWithFormat:@"%@, %@, %@ %@",pStrSubDist,pStrDistrict,pStrProvince,pStrZip];
    if ([pStrZip isEqualToString:@""] &&
        [pStrSubDist isEqualToString:@""] &&
        [pStrDistrict isEqualToString:@""] &&
        [pStrProvince isEqualToString:@""]) {
        stringAddress = @"";
    } else {
        
    }
    
    
    
    
    return stringAddress;
}

-(NSString*)parseStatus:(NSDictionary*)dict
{
    self.mStrTaskName = [dict stringForKey:@"name"];
    return NSLocalizedString([dict stringForKey:@"name"],nil);
}

#pragma mark - Parse data task done
-(void)parseDataForSectionTaskDone:(NSDictionary*)tmp
{
    /*
     * parse data for create array data
     */
    self.mStrSummary = [tmp stringForKey:@"summary"] ? : @"";
    self.mStrCreateDate = [[tmp stringForKey:@"created_date"] dateMMDDYY] ? : @"";
    self.mStrTask = [tmp stringForKey:@"task_no"] ? : @"";
    self.mStrTotalAmount = [tmp stringForKey:@"amount_total"] ? [NSString stringWithFormat:@"฿%@",[tmp stringForKey:@"amount_total"]]: @"฿0";
    self.mStrDueDate = [[tmp stringForKey:@"due_date"] dateMMDDYY] ? : @"";
    self.mStrContactName = [tmp stringForKey:@"contact_name"] ? : @"";
    self.mTaskId = [tmp objectForKey:@"id"];
    // address info
    NSDictionary *pDictAddress = [tmp dictionaryForKey:@"address"];
    self.mStrLocation = [self parseAddressStringFromDict:pDictAddress] ? : @"";
    DLogInfo(@"address %@", self.mStrLocation);
    // contact mobile
    self.mStrContactMobile = [NSString stringWithFormat:@"%@", [tmp stringForKey:@"mobile"]] ? : @"";
    
    // status info
    NSDictionary *pDictStatus = [tmp dictionaryForKey:@"status"];
    self.mStrStatus = [self parseStatus:pDictStatus] ? : @"";
    
    /*
     * create for section task done
     */
    [self createDataForSectionTaskDone];

}

-(void)createDataForSectionTaskDone
{
    self.mArrSecTaskDone = @[   self.mStrSummary,
                                self.mStrCreateDate,
                                self.mStrTask,
                                self.mStrTotalAmount,
                                self.mStrDueDate,
                                self.mStrContactName,
                                self.mStrContactMobile,
                                self.mStrLocation,
                                self.mStrStatus ];
}

#pragma mark - parse data payment
-(void)parseDataForSectionPayment:(NSDictionary*)tmp
{
    // data for row payment term
    self.mStrPaymentTerm = @"";
    
    // payment list
    NSDictionary *pContainerPayments = [[tmp arrayForKey:@"invoices"] firstObject];
    NSString *nextPayment = [pContainerPayments stringForKey:@"next_payment"];
    nextPayment = nextPayment ?  [NSString stringWithFormat:@"฿%@",nextPayment] : @"" ;
    NSArray *pPayments = [pContainerPayments arrayForKey:@"payment"];
    NSMutableArray *pArrListPayment = [[NSMutableArray alloc] initWithCapacity:pPayments.count];
    for ( NSDictionary *pDictData in pPayments)
    {
        DCPaymentTaskDeitalModel *pPaymentModel = [[DCPaymentTaskDeitalModel alloc] initWithDict:pDictData];
        [pArrListPayment addObject:pPaymentModel];
    }
    
    self.mPaymentList = [pArrListPayment copy];
    
    // data for row next payment
    self.mStrNextPayment = nextPayment;
    
    //data for invoice status
    self.invoiceID = [pContainerPayments integerForKey:@"id"];
    self.mStrInvoiceStatus = [[pContainerPayments objectForKey:@"status"] stringForKey:@"name"];
}

#pragma mark - parse data progress
-(void)parseDataForSectionProgress:(NSDictionary*)tmp
{
    NSArray *pArrData = [tmp arrayForKey:@"progress_history"];
    //DLogInfo(@" ~ progress %@", pArrData);
    NSMutableArray *pArrProgress = [[NSMutableArray alloc] initWithCapacity:pArrData.count];
    for (NSDictionary *pDict in pArrData)
    {
        DCProgressHistoryModel *pModel = [[DCProgressHistoryModel alloc] initWithDict:pDict];
        //DLogInfo(@" ~ check %i", [pModel isCheck]);
        [pArrProgress addObject:pModel];
    }
    
    self.mProgressList = [pArrProgress copy];
    //DLogInfo(@" ~ count progress list %li", self.mProgressList.count);
}

#pragma mark - parse data team
-(void)parseDataForSectionTeam:(NSDictionary*)tmp
{
    self.mTeamModel = [[DCTeamTaskModel alloc] initWithDict:tmp];
    self.mStrPhoneNumber = [tmp stringForKey:@"phone"];
    //DLogInfo(@"Phone %@", self.mStrPhoneNumber);
}

#pragma mark - parse data for section review
-(void)parseDataForSectionReview:(NSDictionary*)tmp
{
    self.mReviewModel = [[DCReviewSectionModel alloc] initWithDrawDictFromServer:tmp];
}

@end
