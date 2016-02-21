//
//  DCEntityCellDelegate.h
//  DispatchCenter
//
//  Created by VietHQ on 11/6/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCBindingDataForEntityDelegate;

@protocol DCCellForEntityDelegate <NSObject>

@required
- (id<DCBindingDataForEntityDelegate>) cellForEntityForTableView:(UITableView *)tableView
                                                       atIdxPath:(NSIndexPath*)idxPath
                                                    sectionCount:(NSUInteger)count;
@end

@protocol DCBindingDataForEntityDelegate <NSObject>

@required
-(void)bindingDataForEntity:(NSObject*)obj;

@end