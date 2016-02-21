//
//  PAAlbumsListViewController.h
//  PostApp
//
//  Created by NghiaNH on 10/8/15.
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol PAAlbumsListViewDelegate <NSObject>

- (void)didSelectedGroup:(ALAssetsGroup *)group;

@end
@interface PAAlbumsListViewController : UITableViewController
@property (nonatomic, strong) id<PAAlbumsListViewDelegate>delegate;
@property (nonatomic, strong) ALAssetsGroup *selectedGroup;
@property (nonatomic, strong) NSMutableArray *groups;
@end
