//
//  UIColor+HexColor.h
//  DispatchCenter
//
//  Created by VietHQ on 10/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+(UIColor*)colorFromHexString:(NSString *)hexString;

// reg VC
+(UIColor*)backgroundNavRegVC;
+(UIColor*)navBarBorderRegVC;
+(UIColor*)yellowButton;
+(UIColor*)lightYellowButton;
+(UIColor*)colorTextContent;

// alert SMS code
+(UIColor*)bgSMSCode;

// color group new
+(UIColor*)greenStatusColor;

+(UIColor*)twitterColor;

@end
