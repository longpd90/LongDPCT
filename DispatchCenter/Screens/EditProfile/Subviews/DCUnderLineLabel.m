//
//  DCUnderLineLabel.m
//  DispatchCenter
//
//  Created by VietHQ on 10/24/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCUnderLineLabel.h"

@interface DCUnderLineLabel()

@property( nonatomic, assign) BOOL isShowBottomLine;

@end

@implementation DCUnderLineLabel

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commitInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commitInit];
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

-(void)commitInit
{
    UITapGestureRecognizer *pTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventCallback:)];
    [self addGestureRecognizer:pTap];
    self.userInteractionEnabled = YES;
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    
    // under line
    if (self.isShowBottomLine)
    {
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        self.attributedText = [[NSAttributedString alloc] initWithString: self.text
                                                              attributes:underlineAttribute];
    }
}

-(void)tapEventCallback:(UITapGestureRecognizer*)tapGes
{
    if (self.tapCallback)
    {
        self.tapCallback();
    }
}

@end
