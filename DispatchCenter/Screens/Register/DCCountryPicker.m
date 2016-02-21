//
//  DCCountryPicker.m
//  DispatchCenter
//
//  Created by VietHQ on 10/7/15.
//  Copyright (c) 2015 Helpser. All rights reserved.
//

#import "DCCountryPicker.h"
#import "UIColor+HexColor.h"
#import "DCPhoneModel.h"
#import "DCApis.h"
#import "DCListCountryInfo.h"

@interface DCCountryPicker ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *mContainer;
@property (weak, nonatomic) IBOutlet UIPickerView *mCountryPicker;
@property (weak, nonatomic) IBOutlet UIButton *mSelectButton;
@property (weak, nonatomic) IBOutlet UIView *mContainerPickerView;
@property (strong, nonatomic) NSArray *mCountryWithIdList;

@end

@implementation DCCountryPicker

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

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mContainer = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    self.mContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self addSubview:self.mContainer];
    
    // country picker setting
    self.mCountryPicker.delegate = self;
    self.mCountryPicker.dataSource = self;
    
    // select btn
    self.mSelectButton.backgroundColor = [UIColor yellowButton];
    [self.mSelectButton setTitle:NSLocalizedString(@"Select",nil) forState:UIControlStateNormal];
    
    
    // add tap ges
    UITapGestureRecognizer *pTapClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePickerCallback)];
    [self.mContainer addGestureRecognizer:pTapClose];
}

#pragma mark - layout
-(void)layoutSubviews
{
    CGRect s = [UIScreen mainScreen].bounds;
    self.mContainer.frame = s;
    CGPoint center = CGPointMake(
                                 CGRectGetWidth(self.mContainerPickerView.frame)*0.5f,
                                 CGRectGetHeight(self.mContainerPickerView.frame)*0.5f - 30.0f
                                 );
    self.mCountryPicker.center = center;
    
    self.mSelectButton.center = CGPointMake( center.x, CGRectGetMaxY(self.mCountryPicker.frame) + 30.0f);
}

#pragma mark - get list country
-(void)getListCountryFromServer
{
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis getInfoCountryWithCountryName:nil complete:^(BOOL success, ServerObjectBase *response) {
        HIDE_LOADING;
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                DCListCountryInfo *pCountryModel = (DCListCountryInfo*)response;
                //DLogInfo(@"list country: %@", pCountryModel.mListCountry);
                strongSelf.mArrDataCountry = pCountryModel.mListCountry; // country name only
                strongSelf.mCountryWithIdList = nil;
                strongSelf.mCountryWithIdList = pCountryModel.mListCountryWithId; // country name with id
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.mCountryPicker reloadComponent:0];
                    [strongSelf autoSelectRowInPicker];
                });
            }
            else
            {
                //TODO: error..
            }
        }
    }];
}

-(void)getListCountryInSys
{
    // create country array
    self.mArrDataCountry = ARRAY_DATA_COUNTRY();
}

#pragma mark - set selected country
-(void)setMStrSelectCountry:(NSString *)mStrSelectCountry
{
    self->_mStrSelectCountry = mStrSelectCountry;
    [self autoSelectRowInPicker];
}

#pragma mark - auto select row in picker
-(void)autoSelectRowInPicker
{
    if (self.mStrSelectCountry)
    {
        for (NSInteger i = 0; i < self.mArrDataCountry.count; ++i)
        {
            NSString *pCountryWithCodeMap = COUNTRY_NAME_WITH_CODE_MAP(self.mArrDataCountry[i]);
            if ([pCountryWithCodeMap isEqualToString:self.mStrSelectCountry ])
            {
                [self.mCountryPicker selectRow:i inComponent:0 animated:NO];
                break;
            }
        }
    }
}

#pragma mark - picker delegate & datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.mArrDataCountry.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pStrCountryWithMapCode = COUNTRY_NAME_WITH_CODE_MAP(self.mArrDataCountry[row]);
    return pStrCountryWithMapCode;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //DLogInfo(@"select row %li", (long)row);
}

#pragma mark - callback
- (IBAction)clickSelectCallback:(id)sender
{
    [self removeFromSuperview];
    
    NSInteger idx = [self.mCountryPicker selectedRowInComponent:0];
    NSString *pStrSelectCountry = self.mArrDataCountry[idx];
    if (self.selectCountryEvent)
    {
        // get code country, etc: VI, TH, ....
        NSDictionary *pDictCodeCountry = DICT_COUNTRY_CODE();
        NSString *pCodeCountry = pDictCodeCountry[pStrSelectCountry];
        
        // get code map, etc: +66, +67, ....
        NSDictionary *pDictCodeMap = CALLING_CODE_MAP();
        NSString *pCodeMap = pDictCodeMap[pCodeCountry];
        
        self.selectCountryEvent([pStrSelectCountry copy], pCodeMap);
    }
}

-(void)closePickerCallback
{
    [self removeFromSuperview];
    
}


@end
