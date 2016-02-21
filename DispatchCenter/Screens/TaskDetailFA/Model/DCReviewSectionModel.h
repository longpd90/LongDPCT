//
//  DCReviewSectionModel.h
//  DispatchCenter
//
//  Created by VietHQ on 10/27/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCStarModel : NSObject

@property( nonatomic, strong) NSString *mName;
@property( nonatomic, assign) CGFloat mStarValue;
@property( nonatomic, assign) NSInteger mId;

-(NSDictionary*)jsonData;

@end

@interface DCStarStatus : NSObject

@property( nonatomic, strong) NSString *mStrCode;
@property( nonatomic, strong) NSString *mStrName;

@end

@interface DCReviewSectionModel : ServerObjectBase

@property( nonatomic, assign) NSInteger mId;
@property( nonatomic, assign) NSInteger mTemplateId;

@property( nonatomic, assign) CGFloat mAvgStar;

@property( nonatomic, copy) NSString *mStrComment;
@property( nonatomic, strong) NSArray *mArrStarModel;

@property( nonatomic, strong) DCStarStatus *mStarStatus;

@property( nonatomic, strong) NSDictionary *mReviewUpdateDict;

-(instancetype)initWithDrawDictFromServer:(NSDictionary*)tmp;
-(NSDictionary*)jsonDataSendToServer;

@end


