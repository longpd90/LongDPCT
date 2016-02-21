//
//  DCShowInfoCellView.h
//  DispatchCenter
//
//  Created by VietHQ on 10/20/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCShowInfoCellView;

@protocol  DCShowInfoCellViewDelegate<NSObject>

-(void)showInfoCellViewBeginEdit:(DCShowInfoCellView*)view;
-(void)showInfoCellViewEndEdit:(DCShowInfoCellView*)view;
-(void)showInfoCellDidChange:(DCShowInfoCellView*)view;

@end

@interface DCShowInfoCellView : UIView

@property (nonatomic, assign, readonly) BOOL mCanEdit;
@property (nonatomic, weak) id<DCShowInfoCellViewDelegate> mDelegate;
@property (nonatomic, strong, readonly) NSString *mText;
@property (nonatomic, assign) NSUInteger mId;
@property (nonatomic, assign) BOOL mIsEnableKeyBoard;

-(void)editTxt:(BOOL)value;
-(void)setText:(NSString*)str;
-(void)setPlaceHolder:(NSString*)str;
-(void)showPlaceHolder:(BOOL)value;
-(void)setKeyboardType:(UIKeyboardType)type;
-(void)openKeyBoard;

@end
