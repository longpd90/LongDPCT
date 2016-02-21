//
//  DCValidateRegisterModel.h
//  DispatchCenter
//
//  Created by VietHQ on 10/8/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCValidateRegisterModel : NSObject

@property( nonatomic, copy) NSString *mStrFirstName;
@property( nonatomic, copy) NSString *mStrLastName;
@property( nonatomic, copy) NSString *mStrPhone;
@property( nonatomic, copy) NSString *mStrEmail;
@property( nonatomic, copy) NSString *mStrCountry;

-(NSString*)alertString;
-(void)setFirstName: (NSString*)firstName
           lastName: (NSString*)lastName
              email: (NSString*)email
              phone: (NSString*)phone
         andCountry: (NSString*)country;

@end
