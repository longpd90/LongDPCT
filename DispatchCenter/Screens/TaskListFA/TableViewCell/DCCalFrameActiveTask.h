//
//  DCCalFrameActiveTask.h
//  DispatchCenter
//
//  Created by VietHQ on 10/13/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCCalFrameActiveTask : NSObject

@property( nonatomic, assign, readonly) CGFloat mOriginYTimeLabel;
@property( nonatomic, assign, readonly) CGFloat mOriginYLineBottomView;
@property( nonatomic, assign, readonly) CGFloat mHeightTaskName;
@property( nonatomic, assign, readonly) CGFloat mCellHeight;

-(instancetype)initWithTaskNameWithtext:(NSString*)strTaskName andFont:(UIFont*)font;
+(CGFloat)minCellHeight;

@end
