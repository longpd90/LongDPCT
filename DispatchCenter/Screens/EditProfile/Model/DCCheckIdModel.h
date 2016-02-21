//
//  DCProvincesModel.h
//  DispatchCenter
//
//  Created by VietHQ on 10/23/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DCListCountryInfo;

@interface DCCheckIdModel : NSObject

-(instancetype)initWithNameAndIdList:(NSArray*)arr;
-(NSInteger)idForName:(NSString*)name;

@end
