//
//  DCValidateEditProfileModel.h
//  DispatchCenter
//
//  Created by VietHQ on 10/21/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCValidateEditProfileModel : NSObject

-(instancetype)initWithFirstName:(NSString*)firstName
                        lastName:(NSString*)lastName
                    mobileNumber:(NSString*)numb
                         country:(NSString*)country;

-(NSString*)stringValidate;

@end
