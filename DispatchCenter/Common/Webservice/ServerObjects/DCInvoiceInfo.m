//
//  DCInvoiceInfo.m
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceInfo.h"

@implementation DCInvoicePaymentInfo
@end
@implementation DCInvoicePaymentMethod
@end
@implementation DCLineItem
@end

@implementation DCInvoiceInfo
- (void)parseResponse: (NSDictionary*)response {
//    NSDictionary *tmp = response;
    
    id idInvoiceId = [response objectForKey:@"id"];
    self.invoiceId = idInvoiceId;
    
    id idInvoiceTask = [response objectForKey:@"task"];
    
    if (idInvoiceTask && [idInvoiceTask isKindOfClass:[NSDictionary class]]) {
        self.invoiceTaskName = [idInvoiceTask stringForKey:@"task"];
        self.invoiceTaskSummary = [idInvoiceTask stringForKey:@"summary"];
    }
    
    //invoice num
    self.invoiceNum = [response stringForKey:@"invoice_no"];
    
    self.invoiceDate = [response stringForKey:@"invoice_date"];

    id idInvoiceStatus = [response objectForKey:@"status"];
    
    if (idInvoiceStatus && [idInvoiceStatus isKindOfClass:[NSDictionary class]]) {
        self.strStatusCode = [idInvoiceStatus stringForKey:@"code"];
        self.strStatusName = [idInvoiceStatus stringForKey:@"name"];
    }
    
    self.amount_taxed = [response objectForKey:@"amount_tax"];
    self.amount_untaxed = [response objectForKey:@"amount_untaxed"];
    self.amount_total = [response objectForKey:@"amount_total"];
    
    //line items
    id idLineItems = [response objectForKey:@"line_item"];
    if (idLineItems && [idLineItems isKindOfClass:[NSArray class]]) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [idLineItems count]; i++) {
            DCLineItem *item =  [[DCLineItem alloc] init];
            item.itemName = [[idLineItems objectAtIndex:i] stringForKey:@"name"];
            item.quanlity = [[idLineItems objectAtIndex:i] objectForKey:@"qty"];
            [tmpArray addObject:item];
        }
        self.lineItems = [tmpArray copy];
    }
    
    self.nextPayments = [response objectForKey:@"next_payment"];
    
    //payment list
    id idPaymentList = [response objectForKey:@"payment"];
    
    if (idPaymentList && [idPaymentList isKindOfClass:[NSArray class]]) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [idPaymentList count]; i++) {
            DCInvoicePaymentInfo *paymentInfo = [[DCInvoicePaymentInfo alloc] init];
            id idPaymentDict = [idPaymentList objectAtIndex:i];
            if (idPaymentDict && [idPaymentDict isKindOfClass:[NSDictionary class]]) {
                paymentInfo.paymentId = [idPaymentDict objectForKey:@"id"];
                paymentInfo.needPay = [[idPaymentDict stringForKey:@"need_pay"] isEqualToString:@"true"] ? YES : NO ;
                paymentInfo.paymentDate = [idPaymentDict stringForKey:@"payment_date"];
                paymentInfo.paidAmount = [idPaymentDict objectForKey:@"paid_amount"];
                paymentInfo.statusCode = [[idPaymentDict objectForKey:@"status"] stringForKey:@"code"];
                paymentInfo.statusName = [[idPaymentDict objectForKey:@"status"] stringForKey:@"name"];
                
                //payment method
                id idPaymentMethods = [idPaymentDict objectForKey:@"payment_method"];
                if (idPaymentMethods && [idPaymentMethods isKindOfClass:[NSDictionary class]]) {
                    DCInvoicePaymentMethod *paymentMethod = [[DCInvoicePaymentMethod alloc] init];
                    paymentMethod.methodName = [idPaymentMethods stringForKey:@"name"];
                    paymentMethod.methodType = [idPaymentMethods stringForKey:@"type"];
                    paymentMethod.cardHolderName = [idPaymentMethods stringForKey:@"card_holder_name"] ? [idPaymentMethods stringForKey:@"card_holder_name"] : @"";
                    paymentMethod.cardNumber = [idPaymentMethods stringForKey:@"card_number"] ? [idPaymentMethods stringForKey:@"card_number"] : @"";
                    paymentMethod.expiryMonth = [idPaymentMethods objectForKey:@"expiry_month"] ? [idPaymentMethods objectForKey:@"expiry_month"] : @"";
                    paymentMethod.expireYear = [idPaymentMethods objectForKey:@"expiry_year"] ? [idPaymentMethods objectForKey:@"expiry_year"] : @"";
                    paymentMethod.bankName = [idPaymentMethods stringForKey:@"bank"] ? [idPaymentMethods stringForKey:@"bank"] : @"";
                    paymentMethod.bankCode = [idPaymentMethods stringForKey:@"code"] ? [idPaymentMethods stringForKey:@"code"] : @"";
                    paymentMethod.branch = [idPaymentMethods stringForKey:@"branch"] ? [idPaymentMethods stringForKey:@"branch"] : @"";
                    paymentMethod.accountNum = [idPaymentMethods stringForKey:@"account_no"] ? [idPaymentMethods stringForKey:@"account_no"] : @"";
                    paymentMethod.urlLogo = [idPaymentMethods stringForKey:@"url_logo"] ? [idPaymentMethods stringForKey:@"url_logo"] : @"";
                    
                    paymentInfo.method = paymentMethod;
                }
                
                //allow payment methods
                id idAllowMethods = [idPaymentDict objectForKey:@"allow_payment_method"];
                if (idAllowMethods && [idAllowMethods isKindOfClass:[NSArray class]]) {
                    NSMutableArray *tmpArrayAllowMethods = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [idAllowMethods count]; i++) {
                        DCInvoicePaymentMethod *allowMethod = [[DCInvoicePaymentMethod alloc] init];
                        
                        id idAllowMethodItem = [idAllowMethods objectAtIndex:i];
                        if (idAllowMethodItem && [idAllowMethodItem isKindOfClass:[NSDictionary class]]) {
                            allowMethod.methodName = [idAllowMethodItem stringForKey:@"name"];
                            allowMethod.methodType = [idAllowMethodItem stringForKey:@"type"];
                            allowMethod.methodId = [idAllowMethodItem objectForKey:@"id"];
                            allowMethod.cardHolderName = [idAllowMethodItem stringForKey:@"card_holder_name"] ? [idPaymentMethods stringForKey:@"card_holder_name"] : @"";
                            allowMethod.cardNumber = [idAllowMethodItem stringForKey:@"card_number"] ? [idPaymentMethods stringForKey:@"card_number"] : @"";
                            allowMethod.expiryMonth = [idAllowMethodItem objectForKey:@"expiry_month"] ? [idPaymentMethods objectForKey:@"expiry_month"] : @"";
                            allowMethod.expireYear = [idAllowMethodItem objectForKey:@"expiry_year"] ? [idPaymentMethods objectForKey:@"expiry_year"] : @"";
                            allowMethod.bankName = [idAllowMethodItem stringForKey:@"bank"] ? [idPaymentMethods stringForKey:@"bank"] : @"";
                            allowMethod.bankCode = [idAllowMethodItem stringForKey:@"code"] ? [idPaymentMethods stringForKey:@"code"] : @"";
                            allowMethod.branch = [idAllowMethodItem stringForKey:@"branch"] ? [idPaymentMethods stringForKey:@"branch"] : @"";
                            allowMethod.accountNum = [idAllowMethodItem stringForKey:@"account_no"] ? [idPaymentMethods stringForKey:@"account_no"] : @"";
                            allowMethod.urlLogo = [idAllowMethodItem stringForKey:@"url_logo"] ? [idPaymentMethods stringForKey:@"url_logo"] : @"";
                            
                            //config of credit card method if not nil
                            allowMethod.configGateway = [idAllowMethodItem objectForKey:@"config"] ? [[idAllowMethodItem objectForKey:@"config"] stringForKey:@"payment_gateway_provider"] : @"";
                             allowMethod.configVers = [idAllowMethodItem objectForKey:@"config"] ? [[idAllowMethodItem objectForKey:@"config"] stringForKey:@"version"] : @"";
                             allowMethod.configMerchantId = [idAllowMethodItem objectForKey:@"config"] ? [[idAllowMethodItem objectForKey:@"config"] stringForKey:@"merchant_id"] : @"";
                             allowMethod.configSecretKey = [idAllowMethodItem objectForKey:@"config"] ? [[idAllowMethodItem objectForKey:@"config"] stringForKey:@"secret_key"] : @"";
                             allowMethod.configPublicKey = [idAllowMethodItem objectForKey:@"config"] ? [[idAllowMethodItem objectForKey:@"config"] stringForKey:@"public_key"] : @"";
                             allowMethod.configPrivateKey = [idAllowMethodItem objectForKey:@"config"] ? [[idAllowMethodItem objectForKey:@"config"] stringForKey:@"private_key"] : @"";
                             allowMethod.configPrivateKeyPass = [idAllowMethodItem objectForKey:@"config"] ? [[idAllowMethodItem objectForKey:@"config"] stringForKey:@"private_key_pass"] : @"";
                        }
                        [tmpArrayAllowMethods addObject:allowMethod];
                        
                    }
                    paymentInfo.allowPaymentMethods = [tmpArrayAllowMethods copy];
                }
            
            }
           //array of payments
            [tmpArray addObject:paymentInfo];
        }
        self.payments = [tmpArray copy];
    }
    
}


@end
