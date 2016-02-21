//
//  DCHelpTableViewCell.h
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 11/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCHelpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblQuestionContent;
@property (weak, nonatomic) IBOutlet UILabel *lblAnswerContent;

@end
