//
//  DCTaskTextViewCell.h
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCTaskTextViewCell : UITableViewCell

@property (copy, nonatomic) void (^updateReviewComment)(NSString* str);
@property (weak, nonatomic) IBOutlet UITextView *mCommentTextView;

@end
