//
//  DCInvoiceDetailFAInfo.m
//  DispatchCenter
//
//  Created by VietHQ on 11/5/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceDetailFAInfo.h"

// ------------------------------------------------------- //
#pragma mark - Data model
@implementation DCTwoColumnCellHelper

@end


@implementation DCPaymentCellHelper

@end

// ------------------------------------------------------- //
#pragma mark - Response
#pragma mark - Parse Response
@implementation DCInvoiceDetailInfo

-(void)parseResponse:(NSDictionary *)response
{
    id tmp = response;
    if ( ![tmp isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    NSDictionary *pDrawData = (NSDictionary*)tmp;
    
    // status
    self.mStatus = [[DCInvoiceStatus alloc] initWithDict:[pDrawData dictionaryForKey:@"status"]];
    
    
    // line items
    NSArray *pLineDrawData = [pDrawData arrayForKey:@"line_item"];
    NSMutableArray<DCInvoiceLineItem*> *pLineArr = [[NSMutableArray alloc] initWithCapacity:pLineDrawData.count];
    for (NSDictionary *pLineDict in pLineDrawData)
    {
        DCInvoiceLineItem *pItem = [[DCInvoiceLineItem alloc] initWithDict:pLineDict];
        [pLineArr addObject:pItem];
    }
    
    self.mLineItemArr = [pLineArr copy];
    
    
    // amount untax
    self.mAmountUntaxed = [pDrawData floatForKey:@"amount_untaxed"];
    
    
    // next_payment
    self.mNextPayment = [pDrawData floatForKey:@"next_payment"];
    
    
    // invoice_date
    self.mInvoiceDate = [[pDrawData stringForKey:@"invoice_date"] dateMMDDYYVersionTwo];
    
    
    // payment
    NSArray *pPaymentDrawData = [pDrawData arrayForKey:@"payment"];
    NSMutableArray<DCInvoicePaymentItem*> *pPaymentArr = [[NSMutableArray alloc] initWithCapacity:pPaymentDrawData.count];
    for (NSDictionary *pDict in pPaymentDrawData)
        
    {
        NSArray *pAllowData = [pDict arrayForKey:@"allow_payment_method"];

        if (pAllowData) {
            DCInvoicePaymentItem *pItem = [[DCInvoicePaymentItem alloc] initWithDict:pDict];
           
            self.paymentEntity = pItem;
        }
            DCInvoicePaymentItem *pItem = [[DCInvoicePaymentItem alloc] initWithDict:pDict];
            [pPaymentArr addObject:pItem];
    }
    self.mPaymentArr = [pPaymentArr copy];


    
    // payment term
    self.mPaymentTerm = [[DCInvoicePaymentTerm alloc] initWithDict:[pDrawData dictionaryForKey:@"payment_term"]];
    
    
    // amount tax
    self.mAmountTax = [pDrawData floatForKey:@"amount_tax"];
    
    
    // invoice_no
    self.mInvoiceNo = [pDrawData stringForKey:@"invoice_no"];
    
    
    // id
    self.mId = [pDrawData integerForKey:@"id"];
    
    
    //amount_total
    self.mAmountTotal = [pDrawData floatForKey:@"amount_total"];
    
    
    //
    self.mInvoiceTask = [[DCInvoiceTask alloc] initWithDict:[pDrawData dictionaryForKey:@"task"]];
}

@end

#pragma mark - FA
#pragma mark - First section

@implementation DCInvoiceDetailFAInfo

-(void)parseResponse:(NSDictionary *)response
{
    [super parseResponse:response];
    
    [self createDataForFirstSection];
    [self createDataForSectionPaymentDetail];
}

-(void)createDataForFirstSection
{
    NSMutableArray *pSectionOneArr = [[NSMutableArray alloc] initWithCapacity:[self titleForFirstSection].count];
    for (NSInteger i = 0; i < [self titleForFirstSection].count; ++i)
    {
        DCTwoColumnCellHelper *pModel = [[DCTwoColumnCellHelper alloc] init];
        pModel.mTitle = [self titleForFirstSection][i];
        pModel.mContent = [self contentForFirstSection][i];
        
        [pSectionOneArr addObject:pModel];
    }
    
    self.mDataFirsSection = [pSectionOneArr copy];
}

-(DCTwoColumnCellHelper*)dataForItemInFirstSection:(NSInteger)row
{
    if (row >= self.mDataFirsSection.count)
    {
        return nil;
    }
    
    return self.mDataFirsSection[row];
}

-(NSArray*)titleForFirstSection
{
    NSMutableArray<NSString *> *pArrContainer = [[NSMutableArray alloc] initWithCapacity:100];
    
    /*
     * invoice date, invoice no, status
     */
    NSArray<NSString*> *pTopArr = @[ NSLocalizedString(@"str_invoice_detail_date", nil),
                                     NSLocalizedString(@"str_invoice_detail_no", nil),
                                     NSLocalizedString(@"str_invoice_detail_status", nil) ];
    [pArrContainer addObjectsFromArray:pTopArr];
    
    /*
     * show line items
     */
    NSMutableArray<NSString*> *pArrLineContainer = [[NSMutableArray alloc] initWithCapacity:10];
    if (self.mLineItemArr.count)
    {
        for (DCInvoiceLineItem *pItem in self.mLineItemArr)
        {
            [pArrLineContainer addObject:NSLocalizedString(pItem.mStrName,nil)];
        }
    }
    
    [pArrContainer addObjectsFromArray:pArrLineContainer];
    
    /*
     * total
     */
    [pArrContainer addObject: NSLocalizedString(@"str_invoice_total", nil)];
    
    
    DLogInfo(@"count %li", pArrContainer.count);
    
    return [pArrContainer copy];
}

-(NSArray*)contentForFirstSection
{
    NSMutableArray<NSString *> *pArrContainer = [[NSMutableArray alloc] initWithCapacity:100];
    
    /*
     * invoice date, invoice no, status
     */
    NSArray<NSString*> *pTopArr = @[self.mInvoiceDate ? self.mInvoiceDate : [NSString stringWithFormat:@""], self.mInvoiceNo ? self.mInvoiceNo : [NSString stringWithFormat:@""], self.mStatus.mStatusName];
    [pArrContainer addObjectsFromArray:pTopArr];
    
    /*
     * show line items
     */
    NSMutableArray *pLinesContainer = [[NSMutableArray alloc] initWithCapacity:10];
    if (self.mLineItemArr.count)
    {
        for (DCInvoiceLineItem *pItem in self.mLineItemArr)
        {
            [pLinesContainer addObject: [NSString stringWithFormat:@"%li", pItem.mQty]];
        }
    }
    
    [pArrContainer addObjectsFromArray:pLinesContainer];
    
    /*
     * total
     */
    [pArrContainer addObject:[NSString stringWithFormat:@"฿%.2f", self.mAmountTotal]];
    
    return [pArrContainer copy];
}


#pragma mark - Payment detail section
-(void)createDataForSectionPaymentDetail
{
    // 1,
    [self dataForPaymentTerm]; // first row
    [self dataForPaymentInfo]; // center
    [self dataForNextPayment]; // last row
    
    // 2,
    NSMutableArray *pArrContainer = [[NSMutableArray alloc] initWithCapacity:50];
    [pArrContainer addObject:self.mDataForPaymentTerm]; // add payment term first
    [pArrContainer addObjectsFromArray:self.mDataForPaymentCells]; // add payment info array second
    [pArrContainer addObject:self.mDataForNextPayment]; // add next payment last
    
    self.mDataPaymentDetailSection = [pArrContainer copy];
}

-(id)dataForItemInPaymentDetailSection:(NSInteger)row
{
    if (row > self.mDataPaymentDetailSection.count - 1)
    {
        return nil;
    }
    
    if (row == 0)
    {
        return self.mDataForPaymentTerm;
    }
    
    if (row == self.mDataPaymentDetailSection.count -1)
    {
        return self.mDataForNextPayment;
    }
    
    return (DCPaymentCellHelper*)self.mDataPaymentDetailSection[row];
}

-(void)dataForPaymentTerm
{
    DCTwoColumnCellHelper *pItem = [[DCTwoColumnCellHelper alloc] init];
    pItem.mTitle = NSLocalizedString(@"str_payment_term", nil);
    pItem.mContent = self.mPaymentTerm.mName;
    
    self.mDataForPaymentTerm = pItem;
}


-(void)dataForNextPayment
{
    DCTwoColumnCellHelper *pItem = [[DCTwoColumnCellHelper alloc] init];
    pItem.mTitle = NSLocalizedString(@"str_next_payment", nil);
    pItem.mContent = [NSString stringWithFormat:@"฿%.2f", self.mNextPayment];
    
    self.mDataForNextPayment = pItem;
}

-(void)dataForPaymentInfo
{
    NSMutableArray *pArrContainer = [[NSMutableArray alloc] initWithCapacity:self.mPaymentArr.count];
    
    for (DCInvoicePaymentItem *pItem in self.mPaymentArr)
    {
        DCPaymentCellHelper *pCellHelper = [[DCPaymentCellHelper alloc] init];
        pCellHelper.mPaymentMethod = pItem.mMethod.mName;
        pCellHelper.mPaymentDate = pItem.mPaymentDate;
        pCellHelper.mTotalAmount = [NSString stringWithFormat:@"$%.2f", pItem.mPaidAmount];
        pCellHelper.mStatus = [[pItem.mPaymentStatus.mStatusName lowercaseString] isEqualToString:@"posted"] ? NSLocalizedString(@"str_paid", nil) : NSLocalizedString(@"str_wait_for_payment", nil);
        pCellHelper.mArrPaymentAllowMethod = [pItem.mAllowMethodArr copy];
        
        [pArrContainer addObject:pCellHelper];
    }
    
    self.mDataForPaymentCells = [pArrContainer copy];
}


@end


#pragma mark - WF
#pragma mark - WF first section

@implementation DCInvoiceDetailWFInfo

-(void)parseResponse:(NSDictionary *)response
{
    [super parseResponse:response];
    
    [self createDataForWFFirstSection];
}

-(void)createDataForWFFirstSection
{
    NSMutableArray *pArrContainer = [[NSMutableArray alloc] initWithCapacity:[self titleForFirstWFFirstSection].count];
    
    for (NSInteger i = 0; i < [self titleForFirstWFFirstSection].count; ++i)
    {
        DCTwoColumnCellHelper *pItem = [[DCTwoColumnCellHelper alloc] init];
        pItem.mTitle = [self titleForFirstWFFirstSection][i];
        pItem.mContent = [self contentForWFFirstSection][i];
        [pArrContainer addObject:pItem];
    }
    
    self.mDataWFFirstSection = [pArrContainer copy];
}

-(NSArray*)titleForFirstWFFirstSection
{
    NSMutableArray *pArrTitle = [[NSMutableArray alloc] initWithCapacity:50];
    
    // row 0 : invoice no
    NSString *pInvoiceDateTitle = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"str_invoice_detail_date", nil), self.mInvoiceDate];
    [pArrTitle addObject:pInvoiceDateTitle];
    
    // row 1 : summary
    [pArrTitle addObject:self.mInvoiceTask.mSummary ? : @""];
    
    // row 2 : task#
    [pArrTitle addObject: NSLocalizedString(@"str_invoice_task_no", nil)];
    
    // row 3: Location
    [pArrTitle addObject:@"Location"];
    
    // row 4: total
    [pArrTitle addObject:NSLocalizedString(@"str_invoice_total", nil)];
    
    return [pArrTitle copy];
}

-(NSArray*)contentForWFFirstSection
{
    NSMutableArray *pArrInfo = [[NSMutableArray alloc] initWithCapacity:50];
    
    // row 0: invoice no
    [pArrInfo addObject:[ NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"str_invoice_detail_no", nil), self.mInvoiceNo ? self.mInvoiceNo : @""]];
    
    // row 1: summary
    [pArrInfo addObject:@""]; // summary is title of cell, not have content
    
    // row 2: task#
    [pArrInfo addObject:self.mInvoiceTask.mTaskNo ? : @""];
    
    // row 3: location
    [pArrInfo addObject:@""]; // get location in invoice list
    
    // row 4: total
    [pArrInfo addObject: [NSString stringWithFormat:@"฿%.2f", self.mAmountTotal]];
    
    return [pArrInfo copy];
}

-(DCTwoColumnCellHelper*)dataWFForItemInFirstSection:(NSInteger)row
{
    if (row > self.mDataWFFirstSection.count - 1)
    {
        return nil;
    }
    
    return self.mDataWFFirstSection[row];
}

@end


#pragma mark - Parse response helper
#pragma mark - Parse data info
// ------------------------------------------------------- //
@implementation DCInvoiceStatus

-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        self.mStrCode = [dict stringForKey:@"code"];
        self.mStatusName = [dict stringForKey:@"name"];
    }
    
    return self;
}

@end



// ------------------------------------------------------- //
@implementation DCInvoiceLineItem

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        self.mPriceUnit = [dict integerForKey:@"price_unit"];
        self.mStrName = [dict stringForKey:@"name"];
        self.mQty = [dict integerForKey:@"qty"];
    }
    
    return self;
}

@end



// ------------------------------------------------------- //
@implementation DCInvoicePaymentItem

-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        // status
        self.mPaymentStatus = [[DCPaymentStatus alloc] initWithDict:[dict dictionaryForKey:@"status"]];
        
        // payment allow
        NSArray *pAllowData = [dict arrayForKey:@"allow_payment_method"];
        NSMutableArray<DCPaymentAllowMethod*> *pAllowArr = [[NSMutableArray alloc] initWithCapacity:pAllowData.count];
        for (NSDictionary *pDict in pAllowData)
        {
            DCPaymentAllowMethod *pItem = [[DCPaymentAllowMethod alloc] initWithDict:pDict];
            [pAllowArr addObject:pItem];
        }
        
        self.mAllowMethodArr = [pAllowArr copy];
        
        // id
        self.mPaymentId = [dict integerForKey:@"id"];
        
        // account
        self.account_no = [dict stringForKey:@"account_no"];
        // paid amount
        self.mPaidAmount = [dict floatForKey:@"paid_amount"];
        
        // need pay
        self.mIsNeedPay = [dict boolForKey:@"need_pay"];
        
        // payment method
        NSDictionary *pDictMethod = [dict dictionaryForKey:@"payment_method"];
        self.mMethod = [[DCPaymentMethod alloc] init];
        self.mMethod.mName = [pDictMethod stringForKey:@"name"];
        self.mMethod.mType = [pDictMethod stringForKey:@"type"];
        
        // payment date
        self.mPaymentDate = [dict stringForKey:@"payment_date"];
    }
    
    return self;
}

@end



// ------------------------------------------------------- //
@implementation DCPaymentMethod

@end



// ------------------------------------------------------- //
@implementation DCInvoicePaymentTerm

-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        self.mName = [dict stringForKey:@"name"];
        self.mId = [dict integerForKey:@"id"];
        self.mDescription = [dict stringForKey:@"description"];
    }
    
    return self;
}

@end



// ------------------------------------------------------- //
@implementation DCPaymentStatus

-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        self.mStatusName = [dict stringForKey:@"code"];
        self.mStatusName = [dict stringForKey:@"name"];
    }
    
    return self;
}

@end



// ------------------------------------------------------- //
@implementation DCPaymentAllowMethod

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        //"allow_payment_method": [
        
        self.mType = [dict stringForKey:@"type"];
        self.mId = [dict integerForKey:@"id"];
        self.mName = [dict stringForKey:@"name"];

        self.mConfig = [[DCPaymentConfig alloc] initWithDict:[dict dictionaryForKey:@"config"]];
        self.mBank = [[DCPaymentBank alloc] initWithDict:[dict dictionaryForKey:@"bank"]];
    }
    
    return self;
}

@end



// ------------------------------------------------------- //
@implementation DCPaymentBank

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        self.mAccountNo = [dict stringForKey:@"account_no"];
    }
    
    return self;
}

@end



// ------------------------------------------------------- //
@implementation DCPaymentConfig

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

@end



// ------------------------------------------------------- //
@implementation DCInvoiceTask

-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        self.mTaskId = [dict integerForKey:@"id"];
        self.mSummary = [dict stringForKey:@"summary"];
        DLogInfo(@"%@", self.mSummary);
        
        self.mTaskName = [dict stringForKey:@"task"];
        self.mTaskNo = [dict stringForKey:@"task_no"];
    }
    
    return self;
}

@end
