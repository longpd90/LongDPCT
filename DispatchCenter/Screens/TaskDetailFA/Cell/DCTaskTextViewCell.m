//
//  DCTaskTextViewCell.m
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskTextViewCell.h"

@interface DCTaskTextViewCell()<UITextViewDelegate>

@end

@implementation DCTaskTextViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.mCommentTextView.delegate = self;
    self.mCommentTextView.textColor = [UIColor grayColor];
    self.mCommentTextView.font = [UIFont normalFont];
    self.mCommentTextView.text = @"";
    
    self.mCommentTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.mCommentTextView.layer.borderWidth = 1.0f;
    self.mCommentTextView.layer.cornerRadius = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ( [self.mCommentTextView.text isEqualToString:NSLocalizedString(@"str_no_comment", nil)])
    {
        self.mCommentTextView.text = @"";
    }
    
    self.mCommentTextView.textColor = [UIColor blackColor];
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (!self.mCommentTextView.text.length)
    {
        self.mCommentTextView.text = @"";
    }
    
    if (self.updateReviewComment)
    {
        self.updateReviewComment(self.mCommentTextView.text);
    }
    
    self.mCommentTextView.textColor = [UIColor grayColor];
}

@end
