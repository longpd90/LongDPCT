//
//  otpViewControllerDelegate.h
//  my2c2pSDK
//
//  Created by 2c2p on 23/1/13.
//  Copyright (c) 2013 2c2p. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol otpViewControllerDelegate <NSObject>
@required
-(void)browserCloseWithURL:(NSString*)urlString RawData:(NSString*)raw AndViewController:(UIViewController*)viewController;
@end
