//
//  DCTaskFAReviewCell.h
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCTaskFAReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *mStar1Button;
@property (weak, nonatomic) IBOutlet UIButton *mStar2Button;
@property (weak, nonatomic) IBOutlet UIButton *mStar3Button;
@property (weak, nonatomic) IBOutlet UIButton *mStar4Button;
@property (weak, nonatomic) IBOutlet UIButton *mStar5Button;
@property (weak, nonatomic) IBOutlet UIView *mContainerStarView;
@property (weak, nonatomic) IBOutlet UIView *mMaskStarView;
@property (assign, nonatomic, readonly) CGFloat mStarValue;
@property (copy, nonatomic) void (^updateStar)(CGFloat value, NSIndexPath *idxPath);
@property (strong, nonatomic) NSIndexPath *mIdxPath;

-(void)settingStar:(CGFloat)value;
-(void)enableEditStarByTouch:(BOOL)value;

@end
