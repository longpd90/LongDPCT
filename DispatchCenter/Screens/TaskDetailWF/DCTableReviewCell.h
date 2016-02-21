//
//  DCTableReviewCell.h
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTaskDetailWFInfo.h"

@interface DCTableReviewCell : UITableViewCell {
    
    IBOutletCollection(UIImageView) NSArray *vwRateStars;
}
@property (weak, nonatomic) IBOutlet UILabel *textReviewContent;
- (void)setReviewInfoWithIndex : (NSInteger)index withTaskInfor:(DCTaskDetailWFInfo*)infor;
@end
