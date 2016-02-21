//
//  DCProgressHistoryModel.m
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCProgressHistoryModel.h"

@implementation DCProgressHistoryModel

-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        self.mStrCode = [dict stringForKey:@"code"];
        self.mStrName = [dict stringForKey:@"name"];
        
        NSDictionary *pStatusDict = [dict dictionaryForKey:@"status"];
        self.mStrStatusCode = [pStatusDict stringForKey:@"code"];
        self.mStrStatusName = NSLocalizedString([pStatusDict stringForKey:@"name"],nil);
        DLogInfo(@" ~ progress check %@", self.mStrStatusName);
    }
    
    return self;
}

-(BOOL)isCheck
{
    
    return [[self.mStrStatusCode lowercaseString] isEqualToString:@"completed"] || [[self.mStrStatusCode lowercaseString] isEqualToString:@"in_progress"];
}

@end
