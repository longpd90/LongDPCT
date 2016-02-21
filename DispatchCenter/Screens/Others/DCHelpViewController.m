//
//  DCHelpViewController.m
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 11/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCHelpViewController.h"
#import "DCHelpTableViewCell.h"
#import "DCChatViewController.h"

@interface DCHelpViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation DCHelpViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    MAIN_NAVIGATION.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_menu"], [UIImage imageNamed:@"btn_3dot_menu"]] leftOrRight:NO target:self actions:@[[NSValue valueWithPointer:@selector(didSelectChatBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)didSelectChatBtn:(id)sender {
    if (IS_FA_APP) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        [MAIN_NAVIGATION pushViewController:[DCChatViewController makeMeWithRoomID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomID roomJID:APP_DELEGATE.loginInfo.userInfo.qbUserInfo.roomJID phoneNum:nil] animated:YES];
    }
}

- (void)didSelectMenuBtn:(id)sender {
    [DCDropDownMenuViewController showMe];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITable view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 114.f;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    DCHelpTableViewCell *cell = (DCHelpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DCHelpTableViewCell" owner:nil options:nil];
        cell = [nibs firstObject];
    }
    cell.lblQuestionContent.text = @"Q: Lorem ipsum bangda akdlla kdkka kela ama gkak gask asdk gkasdlk gakdk dgkkieke gkasklsg agasdg dkkdkd kalang bobo ina mo bobo ";
    cell.lblAnswerContent.text = @"A:Lorem Ipsum is simply dummy text of the printing and typesetting";
    
    
    return cell;
    
}

@end
