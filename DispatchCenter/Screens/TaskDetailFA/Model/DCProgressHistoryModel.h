//
//  DCProgressHistoryModel.h
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCProgressHistoryModel : NSObject


@property( nonatomic, copy) NSString *mStrCode;
@property( nonatomic, copy) NSString *mStrName;
@property( nonatomic, copy) NSString *mStrStatusCode;
@property( nonatomic, copy) NSString *mStrStatusName;

-(instancetype)initWithDict:(NSDictionary*)dict;
-(BOOL)isCheck;

@end
