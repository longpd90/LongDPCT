//
//  UIFont+Utils.m
//  DispatchCenter
//
//  Created by VietHQ on 10/13/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "UIFont+Utils.h"

@implementation UIFont (Utils)

+(UIFont*)subTitleFont
{
    return [UIFont systemFontOfSize:12.5f];
}

+(UIFont*)subTitleBoldFont
{
    return [UIFont boldSystemFontOfSize:12.5f];
}

+(UIFont*)normalFont
{
    return [UIFont systemFontOfSize:14.0f];
}

+(UIFont*)normalBoldFont
{
    return [UIFont boldSystemFontOfSize:14.0f];
}

+(UIFont*)largeFont
{
    return [UIFont systemFontOfSize:14.0f];
}

+(UIFont*)largeBoldFont
{
    return [UIFont boldSystemFontOfSize:17.0f];
}


@end
