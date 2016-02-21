//
//  DCEditTextCell.h
//  DispatchCenter
//
//  Created by VietHQ on 10/6/15.
//  Copyright (c) 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DCEditTextCell;
@protocol DCEditTextCellDelegate<NSObject>

-(void)editTextCellbeginEditText:(DCEditTextCell*)cell;
-(void)editTextCellEndEditText:(DCEditTextCell *)cell;

@end

@interface DCEditTextCell : UIView

@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (strong, nonatomic) NSString *mStrPlaceHolder;
@property (nonatomic, weak) id<DCEditTextCellDelegate> mDelegate;
@property (nonatomic, copy, readonly) NSString *mStrContent;
@property (nonatomic, assign) BOOL mIsEnableKeyBoard;
@property (weak, nonatomic) IBOutlet UITextField *mTxtField;

-(void)setKeyboardType:(UIKeyboardType)type;
-(void)setTextContent:(NSString*)str;
-(void)setWidthTitle:(CGFloat)size;
-(void)setSecureText:(BOOL)value;
-(void)showThreeDot:(BOOL)value;

@end
