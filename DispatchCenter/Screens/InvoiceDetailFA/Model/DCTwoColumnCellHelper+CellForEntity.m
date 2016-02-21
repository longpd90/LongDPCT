//
//  DCTwoColumnCellHelper+CellForEntity.m
//  DispatchCenter
//
//  Created by VietHQ on 11/6/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTwoColumnCellHelper+CellForEntity.h"
#import "DCTaskTwoColumnTxtCell.h"

typedef NS_ENUM(NSInteger, DCTwoColumnCellHelperSectionType)
{
    DCTwoColumnCellHelperSectionTypeTop,
    DCTwoColumnCellHelperSectionTypePaymentDetail
};

static NSUInteger const kStatusIdxRow = 2;
static void * kTextContentMarginKey = &kTextContentMarginKey;

@implementation DCTwoColumnCellHelper (CellForEntity)

- (id<DCBindingDataForEntityDelegate>) cellForEntityForTableView:(UITableView *)tableView
                                                       atIdxPath:(NSIndexPath *)idxPath
                                                    sectionCount:(NSUInteger)count
{
    id<DCBindingDataForEntityDelegate> cell = [tableView dequeueReusableCellWithIdentifier:@"DCTwoColumnCellHelper"];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DCTaskTwoColumnTxtCell" owner:nil options:nil] firstObject];
    }
    
    DCTaskTwoColumnTxtCell *pCell = (DCTaskTwoColumnTxtCell*)cell;
    pCell.mIdxPath = idxPath;
    
    if (idxPath.section == DCTwoColumnCellHelperSectionTypeTop)
    {
        if ( pCell.mIdxPath.row != 3 && pCell.mIdxPath.row != count - 1)
        {
            pCell.mBorderUpView.hidden = YES;
        }
        
        pCell.mContentLabel.textAlignment = NSTextAlignmentRight;
        
        if ( pCell.mIdxPath.row == kStatusIdxRow)
        {
            pCell.mContentLabel.font = [UIFont normalBoldFont];
        }
    }
    else if(idxPath.section == DCTwoColumnCellHelperSectionTypePaymentDetail)
    {
        if ( pCell.mIdxPath.row != 1 && pCell.mIdxPath.row != count - 2)
        {
            pCell.mBorderUpView.hidden = YES;
        }
        
        pCell.mTextContentMarginLeft = self.mTextContentMargin;
    }
    
    pCell.clipsToBounds = YES;
    
    return cell;
}

- (CGFloat)mTextContentMargin
{
    return [objc_getAssociatedObject(self, kTextContentMarginKey) floatValue];
}

- (void)setMTextContentMargin:(CGFloat)mTextContentMargin
{
    objc_setAssociatedObject(self, kTextContentMarginKey, @(mTextContentMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
