//
//  DCBankBranchModel.h
//  DispatchCenter
//
//  Created by Phung Long on 12/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>


// ---------------------------- DCInvoiceForListInfo ------------------------------- //
@interface DCBankBranchInfo : ServerObjectBase

@property( strong, nonatomic) NSArray *mBankList;

@end


// --------------------------- DCInvoiceForListModel -------------------------------- //
@interface DCBankBranchModel : NSObject

@property( strong, nonatomic) NSString *bankCode;
@property( strong, nonatomic) NSString *bankName;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end






