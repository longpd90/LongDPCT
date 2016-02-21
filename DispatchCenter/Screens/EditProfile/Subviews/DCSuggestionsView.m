//
//  DCSuggestionsView.m
//  DispatchCenter
//
//  Created by VietHQ on 10/22/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCSuggestionsView.h"

static NSString *const kIdentifierSuggestion = @"kIdentifierSuggestion";
static CGFloat const kCellHeight = 28.0f;

@interface DCSuggestionsView ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *mContainerView;
@property (weak, nonatomic) IBOutlet UITableView *mSuggestionsTableView;
@property (strong, nonatomic) NSMutableArray *mSuggestList;

@end

@implementation DCSuggestionsView

#pragma mark - init
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

#pragma mark - setup view
-(void)commonInit
{
    self.mArrData = nil;
    self.mDelegate = nil;
    self.mSuggestList = [[NSMutableArray alloc] initWithCapacity:30];
    
    self.mContainerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    
    [self addSubview:self.mContainerView];
    
    [self.mSuggestionsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kIdentifierSuggestion];
    self.mSuggestionsTableView.delegate = self;
    self.mSuggestionsTableView.dataSource = self;
    
    [self setupConstraints];
}

-(void)setupConstraints
{
    __weak typeof (self) thiz = self;
    
    [self.mSuggestionsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(thiz.mContainerView);
    }];

    
    [self.mContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(thiz);
    }];
}

-(void)drawRect:(CGRect)rect
{
    self.layer.borderWidth = 1.0f;
    self.layer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2.0f;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.size.height = MIN(self.mMaxHeight,kCellHeight * self.mSuggestList.count);
    self.frame = frame;
}

#pragma mark - public method
-(void)setMArrData:(NSArray *)mArrData
{
    self->_mArrData = [mArrData copy];
    
    self.mKeySearch = @"";
    [self.mSuggestionsTableView reloadData];
}

-(void)setMKeySearch:(NSString *)mKeySearch
{
    self->_mKeySearch = mKeySearch;
    
    // remove all prev search string before update search list
    [self.mSuggestList removeAllObjects];
    
    //DLogInfo(@"%@", self.mArrData);
    
    if (!self->_mKeySearch.length)
    {
        [self.mSuggestList addObjectsFromArray:self.mArrData];
    }
    else
    {
        // add string to search list
        for (NSString *pStr in self.mArrData)
        {
            NSRange r = [[pStr lowercaseString] rangeOfString:[self->_mKeySearch lowercaseString]];
            if (r.location == NSNotFound)
            {
                //
            }
            else
            {
                [self.mSuggestList addObject:pStr];
            }
        }
    }
    
    // show search list
    [self.mSuggestionsTableView reloadData];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self setNeedsDisplay];
}

#pragma mark - Tableview delegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mSuggestList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *pCell = [self.mSuggestionsTableView dequeueReusableCellWithIdentifier:kIdentifierSuggestion];
    
    pCell.textLabel.text = self.mSuggestList[indexPath.row];
    pCell.textLabel.font = [UIFont normalFont];
    
    return pCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.mDelegate respondsToSelector:@selector(suggestionsView:didSelectWord:)])
    {
        [self.mDelegate suggestionsView:self didSelectWord:self.mSuggestList[indexPath.row]];
    }
}

@end
