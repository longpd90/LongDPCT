//
//  GBRefreshView.m
//  Ganbare
//
//  Created by Phung Long on 10/1/15.
//  Copyright (c) 2015 Phung Long. All rights reserved.
//

#import "DCRefreshView.h"

@interface DCRefreshView ()

@property (strong,nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong,nonatomic) UIView *bgView;

@end

@implementation DCRefreshView

-(id)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        if (!_indicatorView) {
            _bgView = [[UIView alloc]initWithFrame:CGRectZero];
            _bgView.backgroundColor = [UIColor grayColor];
            _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectZero];
            [self createIndicatorImage];
            
            [self setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_bgView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_indicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:_bgView];
            [_bgView addSubview:_indicatorView];
            NSDictionary *views = @{@"bgView":_bgView,@"indicator":_indicatorView};
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bgView]|" options:0 metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bgView]|" options:0 metrics:nil views:views]];
            [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
            [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
            [_indicatorView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
            [_indicatorView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
            [self clipsToBounds];
            [self setTranslatesAutoresizingMaskIntoConstraints:YES];
            self.backgroundColor = [UIColor whiteColor];
            [self layoutIfNeeded];
        }
    }
    return self;
}

- (void)createIndicatorImage {
    [_indicatorView startAnimating];
}

- (void)containingScrollViewDidEndDragging:(UIScrollView *)containingScrollView
{
    CGFloat minOffsetToTriggerRefresh = 50.0f;
    if (containingScrollView.contentOffset.y <= -minOffsetToTriggerRefresh) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
