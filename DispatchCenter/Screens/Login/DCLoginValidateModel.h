//
//  DCLoginValidateModel.h
//  DispatchCenter
//
//  Created by VietHQ on 10/12/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCLoginValidateModel : NSObject

@property(nonatomic, strong) NSString *mStrEmail;
@property(nonatomic, strong) NSString *mStrPassword;

-(instancetype)initWithEmail:(NSString*)email andPassword:(NSString*)password;
-(NSString*)stringValidate;

@end
