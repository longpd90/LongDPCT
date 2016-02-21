//
//  DCSuggestionsView.h
//  DispatchCenter
//
//  Created by VietHQ on 10/22/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DCSuggestionsView;

@protocol DCSuggestionsViewDelegate<NSObject>

-(void)suggestionsView:(DCSuggestionsView*)view didSelectWord:(NSString*)key;

@end


@interface DCSuggestionsView : UIView

@property(nonatomic, copy) NSArray *mArrData;
@property(nonatomic, copy) NSString *mKeySearch;
@property(nonatomic, assign) CGFloat mMaxHeight;
@property(nonatomic, weak) id<DCSuggestionsViewDelegate> mDelegate;

@end
