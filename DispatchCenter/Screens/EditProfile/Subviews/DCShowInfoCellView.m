//
//  DCShowInfoCellView.m
//  DispatchCenter
//
//  Created by VietHQ on 10/20/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCShowInfoCellView.h"

@interface DCShowInfoCellView ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *mContainerView;
@property (weak, nonatomic) IBOutlet UITextField *mTxtField;
@property (weak, nonatomic) IBOutlet UILabel *mPlaceHolderLabel;

@end

@implementation DCShowInfoCellView

#pragma mark - Init
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

-(void)commonInit
{
    self.mDelegate = nil;
    self.mId = 0;
    self.mIsEnableKeyBoard = YES;
    
    self.mContainerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    [self addSubview:self.mContainerView];
    
    self.mTxtField.borderStyle = UITextBorderStyleNone;
    self.mTxtField.delegate = self;
    
    [self.mTxtField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    self.mPlaceHolderLabel.textColor = [UIColor grayColor];
    self.mPlaceHolderLabel.text = @"";
    self.mPlaceHolderLabel.font = [UIFont normalFont];
    
    [self editTxt:NO];
    [self setUpConstraints];
}

-(void)drawRect:(CGRect)rect
{
    CALayer *pLayer = [CALayer layer];
    pLayer.frame = CGRectMake(0.0f, CGRectGetHeight(self.mContainerView.frame)-1.0f, CGRectGetWidth(self.mContainerView.frame), 1.0f);
    
    pLayer.backgroundColor = [UIColor grayColor].CGColor;
    
    [self.mContainerView.layer addSublayer:pLayer];
}

#pragma mark - Layout
-(void)setUpConstraints
{
    __weak typeof(self) thiz = self;
    
    [self.mContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(thiz);
    }];
    
    
    [self.mTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.left.equalTo(strongSelf.mContainerView.mas_left).offset(8.0f);
            make.right.equalTo(strongSelf.mContainerView.mas_right).offset(-8.0f);
            make.top.equalTo(strongSelf.mContainerView.mas_top).offset(0.0f);
            make.bottom.equalTo(strongSelf.mContainerView.mas_bottom).offset(-1.0f);
        }
    }];
    
    [self.mPlaceHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.left.equalTo(strongSelf.mTxtField.mas_left).offset(1.0f);
            make.centerY.equalTo(strongSelf.mTxtField.mas_centerY);
            make.width.offset(150.f);
        }
    }];
}

#pragma mark - Public method
-(void)editTxt:(BOOL)value
{
    self.mTxtField.enabled = value;
    self.mTxtField.textColor = self.mTxtField.enabled ? [UIColor blackColor] : [UIColor grayColor];
}

-(void)setText:(NSString*)str
{
    self.mTxtField.text = str;
    self.mPlaceHolderLabel.hidden = [self.mTxtField hasText];
}

-(NSString*)mText
{
    return self.mTxtField.text;
}

-(BOOL)mCanEdit
{
    return self.mTxtField.enabled;
}

-(void)setPlaceHolder:(NSString*)str
{
    self.mPlaceHolderLabel.text = str;
}

-(void)showPlaceHolder:(BOOL)value
{
    self.mPlaceHolderLabel.hidden = !value;
}

-(void)setKeyboardType:(UIKeyboardType)type
{
    self.mTxtField.keyboardType =type;
}

-(void)openKeyBoard
{
    self.mIsEnableKeyBoard = YES;
    [self.mTxtField becomeFirstResponder];
}

#pragma mark - Private method
-(void)textFieldDidChange:(UITextField*)txtField
{
    //DLogInfo(@"txt %@",txtField.text);
    if ([self.mDelegate respondsToSelector:@selector(showInfoCellDidChange:)])
    {
        [self.mDelegate showInfoCellDidChange:self];
    }
}

#pragma mark - txtfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.mPlaceHolderLabel.hidden = YES;
    
    if ([self.mDelegate respondsToSelector:@selector(showInfoCellViewBeginEdit:)])
    {
        [self.mDelegate showInfoCellViewBeginEdit:self];
    }
    
    return self.mIsEnableKeyBoard;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.mPlaceHolderLabel.hidden = [textField hasText];
    
    if ([self.mDelegate respondsToSelector:@selector(showInfoCellViewEndEdit:)])
    {
        [self.mDelegate showInfoCellViewEndEdit:self];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.mTxtField resignFirstResponder];
    return YES;
}


@end
