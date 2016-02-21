//
//  CustomeImagePicker.h
//  PostApp
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>



@protocol CustomeImagePickerDelegate <NSObject>

- (void)imageSelected:(NSArray*)arrayOfImages forIndexPath:(NSIndexPath*)indextPath;
@optional

-(void)imageSelectionCancelled;

@end

@interface CustomeImagePicker : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
}
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) PAImageSelectionType imageSelectionTye;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *cancelButton;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, weak) IBOutlet UINavigationItem *naviBarItem;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;
@property (nonatomic, assign) NSInteger maxPhotos;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *distanceFromButton;
@property (nonatomic, strong) NSMutableArray *highLightThese;
@property(nonatomic,weak) id<CustomeImagePickerDelegate> delegate;
@end
