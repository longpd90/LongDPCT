//
//  PAPhotoPickerCell.h
//  PostApp
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PAPhotoPickerCell : UICollectionViewCell
@property(nonatomic, strong) ALAsset *asset;

- (void)setAsset:(ALAsset *)asset;
- (void)setImage:(UIImage *)image;
- (UIImageView*)getImageView;
- (void)performSelectionAnimations;
- (void)hideTick;
- (void)showTickWithIndex:(NSUInteger)idx;
- (void)disableTick;
@end
