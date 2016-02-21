//
//  NSString+Extra.m
//  DispatchCenter
//
//  Created by Phung Long on 11/11/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "NSString+Extra.h"

@implementation NSString (Extra)

- (NSArray *)separatedStringBySpaces {
    NSRange rng = [self rangeOfString:@" "];
    if (rng.length > 0) {
        NSString *firstName = [self substringToIndex:rng.location];
        NSString *lastName ;
        if (rng.location > 1) {
            lastName = [self substringFromIndex:rng.location + 1];
        }
        return [NSArray arrayWithObjects:firstName,lastName, nil];
    } else {
        return [NSArray arrayWithObject:self];
    }
    return nil;
}

- (NSArray *)separatedStringByShap{
    NSRange rng = [self rangeOfString:@"#"];
    NSString *firstName = [self substringToIndex:rng.location];
    NSString *lastName = [self substringFromIndex:rng.location + 1];
    return [NSArray arrayWithObjects:firstName,lastName, nil];
}

@end
