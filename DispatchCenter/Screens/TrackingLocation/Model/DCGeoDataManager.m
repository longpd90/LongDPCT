//
//  DCGeoDataManager.m
//  DispatchCenter
//
//  Created by VietHQ on 10/30/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCGeoDataManager.h"
#import "DCGeoStoreManager.h"

@interface DCGeoDataManager()

@property(nonatomic, assign) BOOL mIsFirstLoad;

@end

@implementation DCGeoDataManager

+ (instancetype)instance
{
    static DCGeoDataManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    
    return instance;
}

- (void)fetchLatestCheckInsWithUserId:(NSInteger)userId
{
    QBLGeoDataFilter* filter = [QBLGeoDataFilter new];
    filter.lastOnly = YES;
    filter.userID = userId;
    
    QBGeneralResponsePage *page = [QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:1];
    
    [QBRequest geoDataWithFilter:filter
                            page:page
                    successBlock:^(QBResponse *response, NSArray *objects, QBGeneralResponsePage *page) {
                        
                        [[DCGeoStoreManager instance] saveCheckins:objects];
                        
                    } errorBlock:^(QBResponse *response) {
                        
                        DLogError(@"Error = %@", response.error);
                        if (!self.mIsFirstLoad)
                        {
                            [UIAlertView alertViewtWithTitle:@""
                                                     message: NSLocalizedString(@"msg_cant_get_location",nil)
                                                    autoShow:YES
                                                    callback:NULL
                                           cancelButtonTitle:NSLocalizedString(@"str_ok", nil)
                                           otherButtonTitles:nil];
                            self.mIsFirstLoad = YES;
                        }
                     }];
}


@end
