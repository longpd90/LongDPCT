//
//  DCInvoiceDetailFAViewController.m
//  DispatchCenter
//
//  Created by VietHQ on 11/4/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceDetailFAViewController.h"
#import "DCApis.h"
#import "DCInvoiceDetailFAInfo.h"
#import "DCEntityCellDelegate.h"
#import "DCTwoColumnCellHelper+CellForEntity.h"
#import "DCTaskTwoColumnTxtCell.h"
#import "DCPaymentCellHelper+PaymentCellForEntity.h"
#import "DCPaymentTaskCell.h"
#import "DCChatViewController.h"
#import "DCTaskButtonCell.h"
#import "DCPaymentBankTranferTableViewCell.h"
#import "my2c2pSDK.h"
#import "my2c2pConfig.h"
#import "DCPaymentTileCell.h"
#import "DCPaymentTableViewCell.h"
#import "DCThanksToRegViewController.h"
#import "DCPaymentByCashCell.h"
#import "DCBankBranchInfo.h"

#define kDCNumberOfCell         4
#define noExpandCell -1

static CGFloat kMarginLeft = 8.0f;
static CGFloat kHeaderHeight = 30.0f;
static CGFloat kHeightButtonCell = 60.0f;

typedef NS_ENUM( NSInteger, DCInvoiceDetailFASectionType)
{
    DCInvoiceDetailFASectionTypeTop,
    DCInvoiceDetailFASectionTypePaymentDetail,
    DCInvoiceDetailFASectionTypePayment
};

typedef enum {
    DCPaymentModeNone = 0,
    DCPaymentModeCreditCard,
    DCPaymentModeBankTransfer,
    DCPaymentModeCash
}DCPaymentMode;

@interface DCInvoiceDetailFAViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *mInvoiceTableview;
@property (strong, nonatomic) DCInvoiceDetailFAInfo *mDetailManager;
@property (assign, nonatomic) CGFloat mPaymentTextContentMargin;
@property (assign, nonatomic) BOOL isShowPaymentView;

@property (strong, nonatomic) my2c2pSDK *my2c2p;

@property (nonatomic,strong) my2c2pSDK *paymentSDK;
@property (nonatomic,strong) paymentFormViewController *paymentForm;

@property (assign, nonatomic) DCPaymentMode paymentMode;
@property (strong, nonatomic) NSArray *paymentMethods;
@property (strong, nonatomic) NSMutableArray *bankList;

@property (assign, nonatomic) NSInteger currentExpandedCell;
@property (assign, nonatomic) NSInteger currentNumberCellPayment;
@property (strong, nonatomic) DCPaymentAllowMethod *cashPayment;
@property (strong, nonatomic) DCPaymentAllowMethod *creditPayment;
@property (assign, nonatomic) NSInteger bankIndex;
@end


@implementation DCInvoiceDetailFAViewController


#pragma mark - View life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentExpandedCell = noExpandCell;
    _currentNumberCellPayment = kDCNumberOfCell;
    _bankIndex = -1;
    self.paymentMethods = [NSArray arrayWithObjects:NSLocalizedString(@"Credit Card",nil),NSLocalizedString(@"Bank Transfer",nil), NSLocalizedString(@"Cash",nil), nil];
    // payment
    self.paymentSDK = [[my2c2pSDK alloc] initWithPrivateKey:APP_DELEGATE.mySettings.securityKey];
    
    ///////////////// TITLE //////////////////
    self.mTitleLabel.text = NSLocalizedString(@"str_invoice_detail", nil);
    self.mTitleLabel.backgroundColor = [UIColor backgroundNavRegVC];
    
    
    
    //////////////// NAVIGATION ///////////////////
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]]
                      leftOrRight:NO
                           target:self
                          actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
    
    
    
    ///////////////// TABLE VIEW /////////////////
    self.mInvoiceTableview.delegate = self;
    self.mInvoiceTableview.dataSource = self;
    self.mInvoiceTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mInvoiceTableview.hidden = YES; // hide before loading data
    
    
    //  _my2c2p = [[my2c2pSDK alloc] initWithPrivateKey:@""];
    
    //////////////// LOAD DATA /////////////////
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bankList removeAllObjects];
    _currentExpandedCell = noExpandCell;
    _currentNumberCellPayment = kDCNumberOfCell;
    _isShowPaymentView = NO;
    [self getListDetail];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
    
    //////////////////// NOTIFY //////////////////
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(marginLeftForTextContentInPaymenCell:)
                                                 name:DC_NOTI_OFFSET_PAYMENT_CELL_TXT_CONTENT
                                               object:nil];
}

#pragma mark - APIs
- (void)getListDetail
{
    SHOW_LOADING;
    __weak typeof (self) thiz = self;
    [DCApis getInvoiceDetailWithId:self.mInvoiceId complete:^(BOOL success, ServerObjectBase *response){
        HIDE_LOADING;
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success)
            {
                strongSelf.mDetailManager = (DCInvoiceDetailFAInfo*)response;
                     DCInvoicePaymentItem  *paymentItem = self.mDetailManager.paymentEntity ;
                for (int i = 0; i < paymentItem.mAllowMethodArr.count; i ++) {
                    DCPaymentAllowMethod *pItem = [paymentItem.mAllowMethodArr objectAtIndex:i];
                    if ([pItem.mType isEqualToString:@"cash"]) {
                        _cashPayment = pItem;
                    }
                    if ([pItem.mType isEqualToString:@"credit_card"]) {
                        _creditPayment = pItem;
                    }
                    if ([pItem.mType isEqualToString:@"bank_transfer"]) {
                        if (!self.bankList) {
                            self.bankList = [NSMutableArray new];
                        }
                        [self.bankList addObject:pItem];
                    }
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.mInvoiceTableview.hidden = NO;
                    [strongSelf.mInvoiceTableview reloadData];
                });
            }
            else
            {
                //TODO: error
            }
        }
    }];
}

- (void)getListBanksTransfer
{
    __weak typeof (self) thiz = self;
    [DCApis getBanksWithcomplete:^(BOOL success, ServerObjectBase *response) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success){
                DCBankBranchInfo *pInvoiceContainer = (DCBankBranchInfo*)response;
                if (!strongSelf.bankList) {
                    strongSelf.bankList = [NSMutableArray new];
                }
                [strongSelf.bankList addObjectsFromArray:pInvoiceContainer.mBankList];
                
            } else {
                
            }
        }
    }];
}

- (void)postPaymetWithPayment:(DCPaymentAllowMethod *)paymentItem {
    __weak typeof (self) thiz = self;
    [DCApis paymentWithDueDate:self.mDetailManager.paymentEntity.mPaymentDate paymentMethodID:[NSString stringWithFormat:@"%lu", (unsigned long)paymentItem.mId ] amount:[NSString stringWithFormat:@"%f",self.mDetailManager.paymentEntity.mPaidAmount] invoiceID:[NSString stringWithFormat:@"%lu",(unsigned long)self.mInvoiceId] complete:^(BOOL success, ServerObjectBase *response) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            if (success){
                [self showThankYouPage];
            } else {
                
            }
        }

    }];
}

    // payment with 2c2p

- (void)paymentWithCreditCard
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 2 inSection: DCInvoiceDetailFASectionTypePayment];
    
    UITableViewCell *cell = [self.mInvoiceTableview cellForRowAtIndexPath:indexPath];
    
    for (UIView *view in  cell.contentView.subviews){
        
        if ([view isKindOfClass:[UITextField class]]){
            
            UITextField* txtField = (UITextField *)view;
            
            if (txtField.tag == 0) {
                NSLog(@"TextField.tag:%ld and Data %@", (long)txtField.tag, txtField.text);
                self.paymentSDK.cardholderName = txtField.text;
            }
            if (txtField.tag == 1) {
                NSLog(@"TextField.tag:%ld and Data %@", (long)txtField.tag, txtField.text);
                self.paymentSDK.pan = txtField.text;
            }
            if (txtField.tag == 2) {
                if (txtField.text.length == 0) {
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"secure code is requeried" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [errorAlert show];
                    return;
                }
                NSLog(@"TextField.tag:%ld and Data %@", (long)txtField.tag, txtField.text);
                self.paymentSDK.securityCode = txtField.text;
            }
            if (txtField.tag == 3) {
                NSLog(@"TextField.tag:%ld and Data %@", (long)txtField.tag, txtField.text);
                self.paymentSDK.cardExpireMonth = txtField.text.intValue;
                
            }
            if (txtField.tag == 4) {
                NSLog(@"TextField.tag:%ld and Data %@", (long)txtField.tag, txtField.text);
                self.paymentSDK.cardExpireYear = txtField.text.intValue;
            }
        }
    }
    
   
    //set mandatory fields
    self.paymentSDK.merchantID = APP_DELEGATE.mySettings.merchant_id;
    self.paymentSDK.currencyCode = APP_DELEGATE.mySettings.currency_code;
    self.paymentSDK.secretKey = APP_DELEGATE.mySettings.secrectKey;
    self.paymentSDK.panCountry = kDCPanCountryValue;
    self.paymentSDK.uniqueTransactionCode = self.mDetailManager.mInvoiceTask.mTaskNo;
    self.paymentSDK.desc = self.mDetailManager.mInvoiceTask.mTaskName;
    self.paymentSDK.amt = self.mDetailManager.paymentEntity.mPaidAmount;
    self.paymentSDK.displayPaymentPage = NO;
    self.paymentSDK.productionMode = NO;
    
    [self.paymentSDK requestWithTarget:self onResponse:^(NSDictionary *response)
     {
         NSLog(@"%@",response);
         NSString *message = @"";
         if([response[@"respCode"] isEqualToString:@"00"])
         {
             message = @"Payment Success";
             [self postPaymetWithPayment:_creditPayment];
         }
         else {
             UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(response[@"failReason"],nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil];
             [errorAlert show];
             message = response[@"failReason"];
         }
         
         NSLog(@"Payment status: %@",message);
         
     } onFail:^(NSError *error) {
         NSString *messageError = error.localizedDescription;
         UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:messageError delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil];
         [errorAlert show];
         
         if(error) {
             NSLog(@"%@",error);
         }
         else {
             NSLog(@"Cancel The Payment From OTP");
         }
     }];
}

#pragma mark - Action callback
-(void)marginLeftForTextContentInPaymenCell:(NSNotification*)sender
{
    CGFloat value = [[sender valueForKey:@"object"] floatValue];
    self.mPaymentTextContentMargin = value;
    [self.mInvoiceTableview reloadData];
    
    // only need at the first time
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DC_NOTI_OFFSET_PAYMENT_CELL_TXT_CONTENT object:nil];
}

-(void)didSelectChatBtn:(id)sender
{
    // Chat with HO
    if (IS_FA_APP) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        [MAIN_NAVIGATION pushViewController:[DCChatViewController makeMeWithRoomID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomID roomJID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil] animated:YES];
    }
    
}

-(void)didSelectMenuBtn:(id)sender
{
    [DCDropDownMenuViewController showMe];
}

#pragma mark - Tableview delegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self cellInSection:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isShowPaymentView) {
        return 3;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return !section ? : kHeaderHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect s = [UIScreen mainScreen].bounds;
    UIView *pHeader = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, CGRectGetWidth(s), kHeaderHeight)];
    pHeader.backgroundColor = [UIColor yellowButton];
    
    UILabel *pLbl = [[UILabel alloc] initWithFrame:CGRectMake( kMarginLeft, 0.0f, CGRectGetWidth(s) -kMarginLeft, kHeaderHeight)];
    pLbl.text = [self titleForHeaderInSection: section];
    pLbl.textColor = [UIColor whiteColor];
    pLbl.font = [UIFont normalBoldFont];
    [pHeader addSubview:pLbl];
    
    return pHeader;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == DCInvoiceDetailFASectionTypeTop)
    {
        CGSize s = [self sizeForCellAtIndexPath:indexPath];
        // status cell
        if (indexPath.row == self.mDetailManager.mDataFirsSection.count - 1)
        {
            return MAX(40.0f, s.height + 1.0f);
        }
        
        return MAX(kHeaderHeight, s.height + 1.0f);
    }
    
    if (indexPath.section == DCInvoiceDetailFASectionTypePaymentDetail)
    {
        // payment term, next payment
        if (indexPath.row == 0 ||
            indexPath.row == self.mDetailManager.mDataPaymentDetailSection.count -1)
        {
            CGSize s = [self sizeForCellAtIndexPath:indexPath];
            
            return !s.height ? : MAX(kHeaderHeight, s.height + 1.0f);
        }
        
        // payment cell
        if( indexPath.row < self.mDetailManager.mDataPaymentDetailSection.count)
        {
            
            CGSize s = [self sizeForCellAtIndexPath:indexPath];
            
            return MAX(120.0f, s.height +1.0f);
        }
        
        // pay button
        if ( [self isPayForThisInvoiceButton:indexPath])
        {
            return kHeightButtonCell;
        }
    }
    if (indexPath.section == DCInvoiceDetailFASectionTypePayment) {
        if (indexPath.row == _currentExpandedCell) {
            if (indexPath.row == 2) {
                return 210.0f;
            }
            if (indexPath.row == 3) {
                return 45.0f + 40 * _bankList.count;
            }
            if (indexPath.row == 4) {
                return 45.0f;
            }
        }
        if (indexPath.row > 0) {
            return 25.0f;
        }
    }
    
    return 40.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // btn cell
    if ([self isButtonCell: indexPath])
    {
        if ( [self isPayForThisInvoiceButton:indexPath])
        {
            DCTaskButtonCell *pCell = [self.mInvoiceTableview dequeueReusableCellWithIdentifier: NSStringFromClass([DCTaskButtonCell class])];
            
            if (!pCell)
            {
                pCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DCTaskButtonCell class]) owner:nil options:nil] firstObject];
            }
            if ([[self.mDetailManager.mStatus.mStatusName lowercaseString] isEqualToString:@"paid"] ) {
                [pCell.mButton setHidden:YES];
            } else {
                [pCell.mButton setHidden:NO];
                [pCell.mButton setTitle:NSLocalizedString(@"str_pay_for_this_invoice", nil) forState:UIControlStateNormal];
            }
            
            pCell.mButton.hidden = _isShowPaymentView;
            pCell.mIdxPath = indexPath;
            //TODO: event click button pay for this invoice
            [pCell setClickButtonCallback:^(NSIndexPath *idxPath) {
                _isShowPaymentView =! _isShowPaymentView;
                [self.mInvoiceTableview reloadData];
                [self tableViewScrollToBottom];
                DLogInfo(@"click pay button");
            }];
            pCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return pCell;
        }
    }
    
    //TODO: payment cell
    
    if (indexPath.section == DCInvoiceDetailFASectionTypePayment) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"paymentMethodIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            cell.textLabel.text = NSLocalizedString(@"Payment Method",nil);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if (indexPath.row == _currentExpandedCell) {
            if (indexPath.row == 2) {
                static NSString *CellIdentifier = @"DCPaymentTableViewCell";
                DCPaymentTableViewCell *pCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!pCell) {
                    pCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
                }
                [pCell setClickContinueMethod:^(NSIndexPath *idxPath) {
                    [self paymentWithCreditCard];
                }];
                return pCell;
            }
            if (indexPath.row == 3) {
                
                static NSString *CellIdentifier = @"DCPaymentBankTranferTableViewCell";
                DCPaymentBankTranferTableViewCell *pCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!pCell) {
                    pCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
                }
                pCell.banks = self.bankList;
                [pCell setClickPaymentMethod:^(NSIndexPath *idxPath) {
                    if (_bankIndex == -1) {
                        return ;
                    }
                    DCPaymentAllowMethod *payment = [self.bankList objectAtIndex:_bankIndex];
                    [self postPaymetWithPayment:payment];

                }];
                [pCell setClickSelectBank:^(NSInteger bankIndex) {
                    _bankIndex = bankIndex;
                }];
                return pCell;
            }
            if (indexPath.row == 4) {
                static NSString *CellIdentifier = @"DCPaymentByCashCell";
                DCPaymentByCashCell *pCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!pCell) {
                    pCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
                }
                [pCell setClickPaymentMethod:^(NSIndexPath *idxPath) {
                    [self postPaymetWithPayment:_cashPayment];
                }];
                return pCell;
            }

        } else {
            static NSString *CellIdentifier = @"DCPaymentTileCell";
            DCPaymentTileCell *pCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!pCell) {
                pCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] firstObject];
            }
            if (_currentExpandedCell != noExpandCell) {
                if (indexPath.row == _currentExpandedCell - 1) {
                    [pCell.checkButton setSelected:YES];
                } else {
                    [pCell.checkButton setSelected:NO];
                }
                if (indexPath.row > _currentExpandedCell) {
                    pCell.paymentModeLabel.text = [_paymentMethods objectAtIndex:indexPath.row -2];
                } else {
                    pCell.paymentModeLabel.text = [_paymentMethods objectAtIndex:indexPath.row -1];
                    
                }
                
            } else {
                [pCell.checkButton setSelected:NO];
                pCell.paymentModeLabel.text = [_paymentMethods objectAtIndex:indexPath.row -1];
            }
            
            
            [pCell setClickPaymentMethod:^(NSIndexPath * idxPath) {
                if (_currentExpandedCell == noExpandCell) {
                    _currentExpandedCell = indexPath.row + 1;
                    _currentNumberCellPayment ++;
                    
                } else {
                    if (indexPath.row == _currentExpandedCell - 1) {
                        _currentExpandedCell = noExpandCell;
                        _currentNumberCellPayment --;
                    } else {
                        if (indexPath.row > _currentExpandedCell) {
                            _currentExpandedCell = indexPath.row;
                        } else {
                            _currentExpandedCell = indexPath.row + 1;
                        }
                    }
                }
                [self.mInvoiceTableview reloadData];
                [self tableViewScrollToBottom];

            }];
            return pCell;
        }
        return nil;
    }
    
    
    // not btn cell
    return [self cellForRowAtIdxPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSString*)titleForHeaderInSection:(NSInteger)section
{
    NSArray *pArrTitle = @[ @"",
                            NSLocalizedString(@"str_payment_detail", nil),
                            NSLocalizedString(@"str_payment", nil)];
    
    return pArrTitle[section] ? : @"";
}

/*
 * is not button cell
 */
- (UITableViewCell *)cellForRowAtIdxPath:(NSIndexPath*)idxPath
{
    id<DCCellForEntityDelegate> entity = [self entityForCellAtIdxPath:idxPath];
    NSUInteger sectionCount = [self cellInSection:idxPath.section];
    
    // set originY text content of two column cell is Equal with text content in payment cell
    if ( self.mPaymentTextContentMargin &&
        idxPath.section == DCInvoiceDetailFASectionTypePaymentDetail)
    {
        if ([entity isKindOfClass:[DCTwoColumnCellHelper class]])
        {
            DCTwoColumnCellHelper *pTwoColumnHelper = (DCTwoColumnCellHelper*)entity;
            pTwoColumnHelper.mTextContentMargin = self.mPaymentTextContentMargin;
        }
    }
    
    id<DCBindingDataForEntityDelegate> cell = [entity cellForEntityForTableView:self.mInvoiceTableview
                                                                      atIdxPath:idxPath
                                                                   sectionCount:sectionCount];
    
    //DLogInfo(@"%@", [cell class]); // all class of tableview cell are used in this table view
    [cell bindingDataForEntity:entity]; // category of cell
    UITableViewCell *pCell = (UITableViewCell*)cell;
    pCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return pCell;
}

#pragma mark - Tableview helper

-(id<DCCellForEntityDelegate>)entityForCellAtIdxPath:(NSIndexPath*)idxPath
{
    if (idxPath.section == DCInvoiceDetailFASectionTypeTop)
    {
        id<DCCellForEntityDelegate> entity = (DCTwoColumnCellHelper*)[self.mDetailManager dataForItemInFirstSection:idxPath.row];
        return entity;
    }
    
    if (idxPath.section == DCInvoiceDetailFASectionTypePaymentDetail)
    {
        if (idxPath.row == self.mDetailManager.mDataPaymentDetailSection.count)
        {
            return nil; // button pay for this invoice
        }
        
        id<DCCellForEntityDelegate> entity = [self.mDetailManager dataForItemInPaymentDetailSection:idxPath.row];
        return entity;
    }
    
    return nil;
}

- (NSInteger)cellInSection:(NSInteger)section
{
    if (section == DCInvoiceDetailFASectionTypeTop)
    {
        return self.mDetailManager.mDataFirsSection.count;
    }
    
    if (section == DCInvoiceDetailFASectionTypePaymentDetail)
    {
        NSLog(@"number of payment detail rows === %ld \n", (long)[self.mDetailManager.mDataPaymentDetailSection count]);
        NSLog(@"payment detail section === %@ \n", [self.mDetailManager.mDataPaymentDetailSection description]);
        if ([[self.mDetailManager.mStatus.mStatusName lowercaseString] isEqualToString:@"paid"]) {
            return self.mDetailManager.mDataPaymentDetailSection.count;
        } else {
            if (_isShowPaymentView) {
                return self.mDetailManager.mDataPaymentDetailSection.count;
            } else {
                return self.mDetailManager.mDataPaymentDetailSection.count +1;
            }
        }
    }
   
    if (section == DCInvoiceDetailFASectionTypePayment)
    {
        return _currentNumberCellPayment;
    }
    
    return 0;
}



-(CGSize)sizeForCellAtIndexPath:(NSIndexPath*)idxPath
{
    ////////////// BUTTON CELL /////////////////
    if ([self isButtonCell:idxPath])
    {
        return CGSizeMake(0.0f, kHeightButtonCell);
    }
    
    ///////////// ANOTHER CELL TYPE //////////////
    id<DCCellForEntityDelegate> entity = [self entityForCellAtIdxPath:idxPath];
    NSUInteger sectionCount = [self cellInSection:idxPath.section];
    
    id<DCBindingDataForEntityDelegate> cell = [entity cellForEntityForTableView:self.mInvoiceTableview
                                                                      atIdxPath:idxPath
                                                                   sectionCount:sectionCount];
    
    [cell bindingDataForEntity:entity];
    UITableViewCell *pCell = (UITableViewCell*)cell;
    CGSize size = [pCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    
    // status: paid, hide cell next payment
    if ( [cell isKindOfClass:[DCTaskTwoColumnTxtCell class]] &&
        [[self.mDetailManager.mStatus.mStatusName lowercaseString] isEqualToString:@"paid"])
    {
        DCTaskTwoColumnTxtCell *pCell = (DCTaskTwoColumnTxtCell*)cell;
        if ( [pCell.mTitleLabel.text isEqualToString:NSLocalizedString(@"str_next_payment", nil)])
        {
            size.height = 0.0f;
        }
    }
    
    return size;
}


-(BOOL)isPayForThisInvoiceButton:(NSIndexPath*)idxPath
{
    return idxPath.section == DCInvoiceDetailFASectionTypePaymentDetail &&
    idxPath.row == self.mDetailManager.mDataPaymentDetailSection.count;
}


-(BOOL)isButtonCell:(NSIndexPath*)idxPath
{
    if ( [self isPayForThisInvoiceButton:idxPath])
    {
        return YES;
    }
    
    return NO;
}

- (void)tableViewScrollToBottom {
    if (self.mInvoiceTableview.contentSize.height > self.mInvoiceTableview.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.mInvoiceTableview.contentSize.height - self.mInvoiceTableview.frame.size.height);
        [self.self.mInvoiceTableview setContentOffset:offset animated:YES];
    }
}

- (void)showThankYouPage {
    DCThanksToRegViewController *pVC = [[DCThanksToRegViewController alloc] initWithNibName:nil bundle:nil];
    pVC.mode = DCThanksPayment;
    [MAIN_NAVIGATION pushViewController:pVC animated:YES];
}
#pragma mark - Deinit
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
