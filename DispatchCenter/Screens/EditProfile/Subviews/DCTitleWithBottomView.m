//
//  DCTitleWithBottomView.m
//  DispatchCenter
//
//  Created by VietHQ on 10/20/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTitleWithBottomView.h"

@implementation DCTitleWithBottomView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commintInit];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commintInit];
    }
    
    return self;
}

-(void)commintInit
{
    self.userInteractionEnabled = NO;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CALayer *pBottom = [CALayer layer];
    pBottom.frame = CGRectMake(0.0f, CGRectGetHeight(self.frame)-1.0f,CGRectGetWidth(self.frame), 2.0f);
    pBottom.backgroundColor = [UIColor yellowButton].CGColor;
    [self.layer addSublayer:pBottom];
}


@end
