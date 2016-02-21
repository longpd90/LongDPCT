//
//  DCTeamLeaderContactView.m
//  DispatchCenter
//
//  Created by VietHQ on 10/29/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTeamLeaderContactView.h"

@interface DCTeamLeaderContactView ()

@property (strong, nonatomic) IBOutlet UIView *mContainerView;
@property (weak, nonatomic) IBOutlet UIButton *mChatButton;
@property (weak, nonatomic) IBOutlet UIButton *mPhoneButton;


@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mAvaImageView;
@property (weak, nonatomic) IBOutlet UILabel *mStarLabel;


@end

@implementation DCTeamLeaderContactView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self commitInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commitInit];
    }
    
    return self;
}

-(void)commitInit
{
    self.mContainerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    self.mContainerView.backgroundColor = [UIColor backgroundNavRegVC];
    [self addSubview:self.mContainerView];
    
    self.mChatButton.backgroundColor = [UIColor yellowButton];    
    self.mPhoneButton.backgroundColor = [UIColor colorFromHexString:@"#86CC85"];
    
    self.mNameLabel.text = @"";
    self.mStatusLabel.text = @"";
    self.mStarLabel.text = @"";
    self.mAvaImageView.backgroundColor = [UIColor grayColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    __weak typeof (self) thiz = self;
    [self.mContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(thiz);
    }];
}

-(void)setName:(NSString*)name
{
    self.mNameLabel.text = name;
}

-(void)setStatus:(NSString*)status
{
    self.mStatusLabel.text = status;
}

-(void)setStar:(CGFloat)star
{
    DLogInfo(@"star %f", star);
    self.mStarLabel.text = [NSString stringWithFormat:@"%.1f", star];
}

-(void)setAvaWithURL:(NSString*)url
{
    [self.mAvaImageView sd_setImageWithURL: [NSURL URLWithString:url]];
}

#pragma mark - Action callback
- (IBAction)clickChatBtn:(id)sender
{
    if ( [self.mDelegate respondsToSelector:@selector(teamLeaderContactViewDidChat:)])
    {
        [self.mDelegate teamLeaderContactViewDidChat:self];
    }
}


- (IBAction)clickCallBtn:(id)sender
{
    if ( [self.mDelegate respondsToSelector:@selector(teamLeaderContactViewDidCall:)])
    {
        [self.mDelegate teamLeaderContactViewDidCall:self];
    }
}


@end
