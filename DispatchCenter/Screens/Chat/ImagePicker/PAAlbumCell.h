//
//  PAAlbumCell.h
//  PostApp
//
//  Created by NghiaNH on 10/8/15.
//
//

#import <UIKit/UIKit.h>

@interface PAAlbumCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *firstImageView;
@property (nonatomic, weak) IBOutlet UILabel *albumTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *albumNumberOfAssetsLabel;
@end
