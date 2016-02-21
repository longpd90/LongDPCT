//
//  UIColor+HexColor.m
//  DispatchCenter
//
//  Created by VietHQ on 10/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+(UIColor*)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

// reg vc
+(UIColor*)backgroundNavRegVC
{
    return [UIColor colorWithRed:0.110f green:0.110f blue:0.110f alpha:1.00f];
}

+(UIColor*)navBarBorderRegVC
{
    return [UIColor colorFromHexString:@"#BA9642"];
}

+(UIColor*)yellowButton
{
    return [UIColor colorFromHexString:@"#FFCC3F"];
}

+(UIColor*)lightYellowButton
{
    return [UIColor colorFromHexString:@"#FFF5D6"];
}

+(UIColor*)colorTextContent
{
    return [UIColor colorFromHexString:@"#BDBDBD"];
}

+(UIColor*)bgSMSCode
{
    return [UIColor colorFromHexString:@"#F3E3B3"];
}

// color group
+(UIColor*)greenStatusColor
{
    return [UIColor colorFromHexString:@"#29AF38"];
}

// twitter
+(UIColor*)twitterColor
{
    return [UIColor colorFromHexString:@"#55ACEE"];
}

@end
