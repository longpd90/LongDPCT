//
//  DCPopupSupportPhoneView.m
//  DispatchCenter
//
//  Created by VietHQ on 10/10/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCPopupSupportPhoneView.h"

@interface DCPopupSupportPhoneView ()

@property (strong, nonatomic) IBOutlet UIView *mContainer;
@property (weak, nonatomic) IBOutlet UILabel *mSupportLabel;

@end

@implementation DCPopupSupportPhoneView

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commitInit];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commitInit];
    }
    
    return self;
}

-(void)commitInit
{
    // add container
    self.mContainer = [[[NSBundle mainBundle] loadNibNamed:(NSStringFromClass([self class])) owner:self options:nil] firstObject];
    self.mContainer.backgroundColor = [UIColor colorFromHexString:@"#EEEEEE"];
    [self addSubview: self.mContainer];
    
    self.mSupportLabel.text = NSLocalizedString(@"str_contact_support", nil);
}

#pragma mark - layout
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.mContainer.frame = self.bounds;
    self.mSupportLabel.center = CGPointMake( self.mSupportLabel.center.x, CGRectGetHeight(self.bounds)*0.5f);
}

@end
