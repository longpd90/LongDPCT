//
//  DCTaskCountWF.m
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskCountWF.h"

@implementation DCTaskCountWF


- (void) parseResponse:(NSDictionary *)response {
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        id idTotal = [response objectForKey:@"total"];
        if (idTotal && [idTotal isKindOfClass:[NSNumber class]])
            self.total = (NSNumber *)idTotal;
        id idtotal_by_group = [response objectForKey:@"total_by_group"];
        if (idtotal_by_group && [idtotal_by_group isKindOfClass:[NSArray class]]) {
            self.total_by_group = (NSArray *)idtotal_by_group;
            if (self.result.count > 0)
                [self.result removeAllObjects];
            self.result = [[NSMutableArray alloc] init];
            DCtaskGroupWF *dcGRHas = [DCtaskGroupWF new];
            dcGRHas.name = @"All Task";
            dcGRHas.total = self.total;
            dcGRHas.code = @"";
            [self.result addObject:dcGRHas];
            for (id dic in self.total_by_group) {
                if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                    DCtaskGroupWF *dcGR = [DCtaskGroupWF new];
                    dcGR.total = [dic objectForKey:@"total"];
                    id groupDC = [dic objectForKey:@"group"];
                    if (groupDC && [groupDC isKindOfClass:[NSDictionary class]]) {
                        dcGR.name = [groupDC objectForKey:@"name"];
                        dcGR.code = [groupDC objectForKey:@"code"];
                    }
                    [self.result addObject:dcGR];
                }
            }
            
        }
    }
    
}

@end

@implementation DCtaskGroupWF



@end
