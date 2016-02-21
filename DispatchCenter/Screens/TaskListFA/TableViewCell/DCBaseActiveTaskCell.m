//
//  DCBaseActiveTaskCell.m
//  DispatchCenter
//
//  Created by VietHQ on 10/12/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCBaseActiveTaskCell.h"
#import "DCCalFrameActiveTask.h"

@interface DCBaseActiveTaskCell()

@property (weak, nonatomic) IBOutlet UIView *mBottomLineView;
@property (nonatomic, strong) DCCalFrameActiveTask *mCalFrameModel;

@end

@implementation DCBaseActiveTaskCell

- (void)awakeFromNib
{
    self.mTaskNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.mTaskNameLabel.numberOfLines = 1;
    
    self.mTimeLabel.textColor = [UIColor colorTextContent];
    self.mTimeLabel.font = [UIFont subTitleFont];
    
    self.mGroupType = DCBaseActiveTaskCellTypePending;
    self.mStatusLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMGroupType:(DCBaseActiveTaskCellType)mGroupType
{
    self->_mGroupType = mGroupType;
    
    BOOL isGroupNew = self->_mGroupType == DCBaseActiveTaskCellTypeNew;
    self.mTaskNameLabel.font = isGroupNew ? [UIFont normalBoldFont] : [UIFont normalFont];
    self.mTaskNameLabel.textColor = isGroupNew ? [UIColor blackColor] : [UIColor grayColor];
    self.mStatusLabel.textColor = isGroupNew ? [UIColor greenStatusColor] : [UIColor grayColor];
}

-(void)showBottomLine:(BOOL)value
{
    self.mBottomLineView.hidden = !value;
    self.mBottomLineView.center = CGPointMake(CGRectGetWidth(self.contentView.frame)*0.5f, self.mBottomLineView.center.y);
}

-(void)calculateFrameWithObject:(DCCalFrameActiveTask*)calModel
{
    CGRect frameTaskNameLbl = self.mTaskNameLabel.frame;
    frameTaskNameLbl.size.height = calModel.mHeightTaskName;
    self.mTaskNameLabel.frame = frameTaskNameLbl;
    
    CGRect frameTimeLbl = self.mTimeLabel.frame;
    frameTimeLbl.origin.y = calModel.mOriginYTimeLabel;
    self.mTimeLabel.frame = frameTimeLbl;
    
    CGRect frameBottomLine = self.mBottomLineView.frame;
    frameTimeLbl.origin.y = calModel.mOriginYLineBottomView;
    self.mBottomLineView.frame = frameBottomLine;
    
    self.mStatusLabel.center = CGPointMake(self.mStatusLabel.center.x, CGRectGetHeight(self.contentView.frame)*0.5f);
}

@end
