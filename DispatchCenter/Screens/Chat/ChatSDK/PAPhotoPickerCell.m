//
//  PAPhotoPickerCell.m
//  PostApp
//

#import "PAPhotoPickerCell.h"



@interface PAPhotoPickerCell ()

@property(nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property(nonatomic, weak) IBOutlet UILabel *selectIndex;

@end
@implementation PAPhotoPickerCell

- (UIImageView *)getImageView;
{
    return self.photoImageView;
}

- (void)showTickWithIndex:(NSUInteger)idx
{
    self.layer.borderColor = [PAUIColorFromRGB(0x147EFB) CGColor];
    self.layer.borderWidth = 4.0;
    [self setAlpha:1.0];
    [self setUserInteractionEnabled:YES];
    
    [self.selectIndex setHidden:NO];
    self.selectIndex.text = [NSString stringWithFormat:@"%ld", (unsigned long)idx];
}
- (void)hideTick
{
    [self.selectIndex setHidden:YES];
    self.layer.borderColor = nil;
    self.layer.borderWidth = 0.0;
    [self setAlpha:1.0];
    [self setUserInteractionEnabled:YES];
    
    self.selectIndex.hidden = YES;
    self.selectIndex.text = @"";
}

- (void)disableTick {
    self.layer.borderColor = nil;
    self.layer.borderWidth = 0.0;
    [self setAlpha:0.5];
    [self setUserInteractionEnabled:NO];
    
    self.selectIndex.hidden = YES;
    self.selectIndex.text = @"";
}

- (void)setAsset:(ALAsset *)asset
{
    // 2
    _asset = asset;
    UIImage *thumbnail = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
    self.photoImageView.image = thumbnail;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (void)setImage:(UIImage *)image
{
    [self.photoImageView setImage:image];
}

- (void)performSelectionAnimations {
    
}

@end
