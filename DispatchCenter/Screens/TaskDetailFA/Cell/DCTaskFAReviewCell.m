//
//  DCTaskFAReviewCell.m
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskFAReviewCell.h"

static NSUInteger const kStarNumb = 5;

@interface DCTaskFAReviewCell()

@property(assign, nonatomic) BOOL mIsEnableTouch;
@property(assign, nonatomic) CGFloat mStarValue;

@end


@implementation DCTaskFAReviewCell

- (void)awakeFromNib
{
    self.mIsEnableTouch = NO;
    
    
    for (NSInteger i = 1; i <= kStarNumb; ++i)
    {
        [self buttonByValue:i].enabled = NO;
    }
    
    
    UITapGestureRecognizer *pTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setStarCallback:)];
    UIPanGestureRecognizer *pPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(setStarCallback:)];
    
    [self.mContainerStarView addGestureRecognizer:pTap];
    [self.mContainerStarView addGestureRecognizer:pPan];
    self.mContainerStarView.clipsToBounds = YES;
    
    
    // start frame
    self.mMaskStarView.clipsToBounds = YES;
    CGRect frame = self.mMaskStarView.frame;
    frame.size.width = 0.0f;
    self.mMaskStarView.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - callback
-(void)setStarCallback:(UIGestureRecognizer*)ges
{
    if (!self.mIsEnableTouch)
    {
        return;
    }
    
    CGPoint lo = [ges locationInView:self.mContainerStarView];
    CGFloat wUnit = CGRectGetWidth(self.mContainerStarView.frame) / 10.0f;
    CGFloat star = lo.x / wUnit;
    star = floorf( star + 0.5f) *0.5f;
    
    [self updateFrameMaskWithStar:MAX(star, 0.5f)];
}

- (UIButton*)buttonByValue:(NSInteger)value
{
    NSString *pStrStar = [NSString stringWithFormat:@"mStar%liButton",(long)value];
    if ([self respondsToSelector:NSSelectorFromString(pStrStar)])
    {
        return [self valueForKey:pStrStar];
    }
    
    return nil;
}

-(void)settingStar:(CGFloat)value
{
    if (value < 0 || value > 5) return;
    
    if (value - floorf(value) < 0.25f)
    {
        value = floorf(value);
    }
    else if( value - floorf(value) >= 0.25 &&
            value - floorf(value) < 0.75)
    {
        value = floorf(value) + 0.5f;
    }
    else
    {
        value = floorf(value) + 1.0f;
    }
    //DLogInfo(@" ====> value %li", (long)value);
    [self updateFrameMaskWithStar:value];
}

-(void)updateFrameMaskWithStar:(CGFloat)value
{
    if (value < 0 || value > 5) return;
    
    // update frame
    CGFloat wUnit = CGRectGetWidth(self.mContainerStarView.frame) / 10.0f;
    
    CGFloat widthMask = value * 2 * wUnit; // unit = 0.5, need * 2
    CGRect frame = self.mMaskStarView.frame;
    frame.size.width = widthMask;
    self.mMaskStarView.frame = frame;
    
    // update star value
    self.mStarValue = value;
    //DLogInfo(@" ====> value %li", (long)value);
    
    if (self.updateStar)
    {
        self.updateStar(self.mStarValue, self.mIdxPath);
    }
}

-(void)enableEditStarByTouch:(BOOL)value
{
    self.mIsEnableTouch = value;
}

@end
