//
//  DCEditTextCell.m
//  DispatchCenter
//
//  Created by VietHQ on 10/6/15.
//  Copyright (c) 2015 Helpser. All rights reserved.
//

#import "DCEditTextCell.h"

@interface DCEditTextCell ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *mContainer;
@property (weak, nonatomic) IBOutlet UIImageView *mThreeDotBlackImage;

@end

@implementation DCEditTextCell

#pragma mark - init view
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
    /* init value */
    self.mDelegate = nil;
    self.mStrPlaceHolder = @"";
    self.mIsEnableKeyBoard = YES;
    
    /* add container */
    self.mContainer = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    [self addSubview:self.mContainer];
    
    /* setting view */
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //
    self.mTxtField.textColor = [self placeHolderColor]; //default color
    self.mTxtField.delegate = self;
    
    //
    self.mThreeDotBlackImage.hidden = YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    /* set title center */
    CGPoint centerTitle = self.mTitle.center;
    centerTitle.y = CGRectGetHeight(self.mContainer.frame)*0.5f;
    self.mTitle.center = centerTitle;
    
    /* text feild center */
    CGPoint centerTxtFeild = self.mTxtField.center;
    centerTxtFeild.y = CGRectGetHeight(self.mContainer.frame)*0.5f;
    self.mTxtField.center = centerTxtFeild;
}

-(void)setWidthTitle:(CGFloat)size
{
    CGRect frameTitle = self.mTitle.frame;
    
    CGFloat detalX = size - CGRectGetWidth(frameTitle);
    frameTitle.size.width = size;
    self.mTitle.frame = frameTitle;
    
    CGRect frameTxtField = self.mTxtField.frame;
    frameTxtField.origin.x += detalX;
    frameTxtField.size.width -= detalX;
    
    self.mTxtField.frame = frameTxtField;
}

-(void)showThreeDot:(BOOL)value
{
    self.mThreeDotBlackImage.hidden = !value;
}


#pragma mark - place holder
-(void)setMStrPlaceHolder:(NSString *)mStrPlaceHolder
{
    self->_mStrPlaceHolder = mStrPlaceHolder;
    self.mTxtField.text = self->_mStrPlaceHolder;
}

-(UIColor*)placeHolderColor
{
    return [UIColor colorTextContent];
}

#pragma mark - str content
-(NSString*)mStrContent
{
    return [self.mTxtField.text isEqualToString:self.mStrPlaceHolder] ? @"" : self.mTxtField.text;
}

-(void)dismissKeyboard
{
    [self.mTxtField resignFirstResponder];
}

- (void)setTextContent:(NSString *)str
{
    self.mTxtField.text = str;
    if ([self.mTxtField.text isNotNullString])
    {
        self.mTxtField.textColor = [UIColor blackColor];
    }
}

-(void)setSecureText:(BOOL)value
{
    self.mTxtField.secureTextEntry = value;
}

#pragma mark - show keyboard
-(void)setKeyboardType:(UIKeyboardType)type
{
    self.mTxtField.keyboardType =type;
}

#pragma mark - textfield delegate

- (IBAction)textFieldDidChanged:(id)sender {
    if ([self.mTxtField.text isEqualToString:self.mStrPlaceHolder])
    {
        self.mTxtField.text = @"";
    }
    
    self.mTxtField.textColor = [UIColor blackColor];
    

}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.mTxtField.text isEqualToString:self.mStrPlaceHolder])
    {
        self.mTxtField.text = @"";
    }
    
    self.mTxtField.textColor = [UIColor blackColor];
    
    if ([self.mDelegate respondsToSelector:@selector(editTextCellbeginEditText:)])
    {
        [self.mDelegate editTextCellbeginEditText:self];
    }
    
    return self.mIsEnableKeyBoard;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!self.mTxtField.text.length)
    {
        self.mTxtField.text = self.mStrPlaceHolder;
        self.mTxtField.textColor = [self placeHolderColor]; //defaul color
    }
    else
    {
        self.mTxtField.textColor = [UIColor blackColor];
    }
}

//-(BOOL)             textField: (UITextField *)textField
//shouldChangeCharactersInRange: (NSRange)range
//            replacementString: (NSString *)string
//{
//    // text allow
//    NSString *pAcceptChars = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}";
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:pAcceptChars] invertedSet];
//    
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:NSSet] componentsJoinedByString:@""];
//    
//    return [string isEqualToString:filtered];
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.mTxtField resignFirstResponder];
    return YES;
}

@end
