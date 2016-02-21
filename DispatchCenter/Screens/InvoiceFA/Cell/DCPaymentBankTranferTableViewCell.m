//
//  DCPaymentBankTranferTableViewCell.m
//  DispatchCenter
//
//  Created by Phung Long on 12/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCPaymentBankTranferTableViewCell.h"
#import "DCInvoiceDetailFAInfo.h"

@implementation DCPaymentBankTranferTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)paymentByBankTranfer:(id)sender {
    if (self.clickPaymentMethod)
    {
        self.clickPaymentMethod(self.mIdxPath);
    }
}

- (void)setBanks:(NSArray *)banks {
    _banks = banks;
    for (int i = 0; i < banks.count; i ++) {
        DCPaymentAllowMethod *bankModel = (DCPaymentAllowMethod *)[banks objectAtIndex:i];
        _originY = i *40;
        [self addBankViewWithBankModel:bankModel withIndex:i];
    }
}

- (void)addBankViewWithBankModel:(DCPaymentAllowMethod *)bankModel withIndex:(NSInteger)index {
    UIView * bankView = [[UIView alloc] initWithFrame:CGRectMake(0, _originY, self.bounds.size.width, 40)];
    bankView.backgroundColor = [UIColor clearColor];
    [self addSubview:bankView];

    UILabel *bankCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.bounds.size.width, 20)];
    bankCodeLabel.text = bankModel.mBank.mAccountNo;
    [bankCodeLabel setFont:[UIFont systemFontOfSize:12]];
    [bankView addSubview:bankCodeLabel];
    
    UILabel *bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.bounds.size.width, 20)];
    bankNameLabel.text = bankModel.mName;
    [bankNameLabel setFont:[UIFont systemFontOfSize:12]];
    [bankView addSubview:bankNameLabel];
    
    UIButton *buttonCheck = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 13, 13)];
    [buttonCheck setBackgroundImage:[UIImage imageNamed:@"ic_checkbox"] forState:UIControlStateNormal];
    [buttonCheck setBackgroundImage:[UIImage imageNamed:@"ic_checkbox_ac"] forState:UIControlStateSelected];
    [buttonCheck addTarget:self action:@selector(selectBank:) forControlEvents:UIControlEventTouchUpInside];
    buttonCheck.tag = index;
    [bankView addSubview:buttonCheck];
}

- (IBAction)selectBank:(UIButton *)sender {
    if (sender != _buttonSelected) {
        _buttonSelected.selected = NO;
    }
    sender.selected =! sender.selected;
    _buttonSelected = sender;
    if (_buttonSelected.selected == YES) {
        if (self.clickPaymentMethod)
        {
            self.clickSelectBank(_buttonSelected.tag);
        }
    } else {
        if (self.clickPaymentMethod)
        {
            self.clickSelectBank(-1);
        }
    }

}
@end
