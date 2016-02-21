//
//  DCCalFrameActiveTask.m
//  DispatchCenter
//
//  Created by VietHQ on 10/13/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCCalFrameActiveTask.h"

/*
 * if change size any view in DCBaseActiveTaskCell, need changing all const value too.
 */
static CGFloat const kPaddingTopTaskNameLabel = 12.0f;
static CGFloat const kPaddingTopTimeLabel = 4.0f;
static CGFloat const kPaddingTopLineBottomView = 6.0f;
static CGFloat const kHeightTimeLabel = 16.0f;
static CGFloat const kHeightLineBottomView = 1.0f;
static CGFloat const kPaddingBottomView = 1.0f;
static CGFloat const kMinOriginYTimeLabel = 36.0f;
static CGFloat const kMinOriginYBottomLineView = 58.0f;
static CGFloat const kMinCellHeight = 60.0f;
static CGFloat const kMinTaskNameHeight = 18.0f;
static CGFloat const kPercentWidthTaskNameWithScreen = 193.0f / 320.0f;

@interface DCCalFrameActiveTask()

@property (nonatomic, assign) CGFloat mLabelWidth;
@property (nonatomic, strong) UIFont *mFont;
@property (nonatomic, strong) NSString *mStrTaskName;
@property( nonatomic, assign) CGFloat mHeightTaskName;

@property( nonatomic, assign) CGFloat mOriginYTimeLabel;
@property( nonatomic, assign) CGFloat mOriginYLineBottomView;
@property( nonatomic, assign) CGFloat mCellHeight;


@end

@implementation DCCalFrameActiveTask

-(instancetype)initWithTaskNameWithtext:(NSString*)strTaskName
                                andFont:(UIFont*)font;
{
    self = [super init];
    
    if (self)
    {
        CGRect s = [UIScreen mainScreen].bounds;
        self.mLabelWidth = kPercentWidthTaskNameWithScreen * CGRectGetWidth(s);
        self.mFont = font;
        self.mStrTaskName = strTaskName;
        
        [self calculateHeightCell];
        
    }
    
    return self;
}

-(void)calculateHeightCell
{
    CGRect recTaskName = [self.mStrTaskName rectForStringWithWidth:self.mLabelWidth andFont:self.mFont];
    self.mHeightTaskName = MAX( kMinTaskNameHeight, CGRectGetHeight(recTaskName));
    
    CGFloat calOriginYTimeLabel = kPaddingTopTaskNameLabel + self.mHeightTaskName + kPaddingTopTimeLabel;
    self.mOriginYTimeLabel = MAX( kMinOriginYTimeLabel, calOriginYTimeLabel);
    
    CGFloat calOriginYLineBottom = self.mOriginYTimeLabel + kHeightTimeLabel + kPaddingTopLineBottomView;
    self.mOriginYLineBottomView = MAX( kMinOriginYBottomLineView, calOriginYLineBottom);
    
    CGFloat calOriginCellH = self.mOriginYLineBottomView + kHeightLineBottomView + kPaddingBottomView;
    self.mCellHeight = MAX( kMinCellHeight , calOriginCellH);
}

+(CGFloat)minCellHeight
{
    return kMinCellHeight;
}

@end
