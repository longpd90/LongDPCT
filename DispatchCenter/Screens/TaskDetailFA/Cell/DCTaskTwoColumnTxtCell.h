//
//  DCTaskTwoColumnTxtCell.h
//  DispatchCenter
//
//  Created by VietHQ on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCEntityCellDelegate.h"

@interface DCTaskTwoColumnTxtCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mBorderUpView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mContentLabel;
@property (strong, nonatomic) NSIndexPath *mIdxPath;
@property (assign, nonatomic) CGFloat mTextContentMarginLeft;

-(void)showBorderUp:(BOOL)value;
+(CGFloat)defaultHeight;

@end

@interface DCTaskTwoColumnTxtCell(BindingData) <DCBindingDataForEntityDelegate>

@end
