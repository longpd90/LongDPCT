//
//  CustomeImagePicker.m
//  PostApp
//


#import "CustomeImagePicker.h"
#import "PAPhotoPickerCell.h"
#import "PAImageDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PAAlbumsListViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "UIAlertView+Utils.h"

#define PA_IMAGE_PICKER_MAX_PHOTOS      5
@interface CustomeImagePicker ()<UIImagePickerControllerDelegate,UIPopoverPresentationControllerDelegate,PAAlbumsListViewDelegate,WYPopoverControllerDelegate> {
    WYPopoverController* albumsPopoverController;
}

@property(nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) NSString *imageUrlForViewDetail;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) ALAssetsGroup *selectedGroup;

@end

@implementation CustomeImagePicker

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBarItem.title = @"";
    // Do any additional setup after loading the view.

    self.maxPhotos = PA_IMAGE_PICKER_MAX_PHOTOS;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PAPhotoPickerCell" bundle:nil] forCellWithReuseIdentifier:@"PAPhotoPickerCell"];


    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    if(IS_IPHONE_6 || IS_IPHONE_6P)
        [flowLayout setItemSize:CGSizeMake(120, 120)];
    else
        [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self getAllGroup];

}

- (void)customNavigationBarTitle:(NSString *)albumTitle {
    
    UIButton *titleLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont boldSystemFontOfSize:16.0f];
    UIFont *font2 = [UIFont boldSystemFontOfSize:10.0f];
    UIColor *titleColor = [UIColor whiteColor];
    NSDictionary *dict1 = @{NSFontAttributeName:font1,
                            NSParagraphStyleAttributeName:style,
                            NSForegroundColorAttributeName : titleColor};
    NSDictionary *dict2 = @{NSFontAttributeName:font2,
                            NSParagraphStyleAttributeName:style,
                            NSForegroundColorAttributeName : titleColor};
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@\n",albumTitle ] attributes:dict1]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString: NSLocalizedString(@"Tap here to change ▾",nil) attributes:dict2]];
    [titleLabelButton setAttributedTitle:attString forState:UIControlStateNormal];
    [[titleLabelButton titleLabel] setNumberOfLines:0];
    [[titleLabelButton titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
    titleLabelButton.frame = CGRectMake(0, 0, 200, 44);
    [titleLabelButton addTarget:self action:@selector(didTapTitleView:) forControlEvents:UIControlEventTouchUpInside];
    [titleLabelButton sizeToFit];
    [self.naviBarItem setTitleView:titleLabelButton];
}

- (IBAction)didTapTitleView:(UIButton*) sender
{
    PAAlbumsListViewController *albumListViewController = [[PAAlbumsListViewController alloc] initWithNibName:@"PAAlbumsListViewController" bundle:nil];
    albumListViewController.delegate = self;
    albumListViewController.delegate = self;
    albumListViewController.groups = self.groups;
    albumListViewController.selectedGroup = self.selectedGroup;
    CGSize popoverContentSize = CGSizeMake(PAScreenSize.width - 20, MIN(self.groups.count * 60, PAScreenSize.height - 200));
    albumListViewController.preferredContentSize = popoverContentSize;
    albumsPopoverController = [[WYPopoverController alloc] initWithContentViewController:albumListViewController];
    albumsPopoverController.delegate = self;
    [albumsPopoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];

}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

#pragma mark - collection view data source

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PAPhotoPickerCell";
    
    PAPhotoPickerCell *cell = (PAPhotoPickerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
 
    NSString *imageUrl = @"";
    if ([self.assets[self.assets.count - indexPath.row -1] isKindOfClass:[ALAsset class]]) {
        ALAsset *asset = self.assets[self.assets.count - indexPath.row -1];
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        imageUrl = [[rep url] absoluteString];
        cell.asset = asset;
    } else {
        imageUrl = self.assets[indexPath.row];
        cell.asset = [ALAsset new];
        [[cell getImageView] setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:PAImage(@"noimage.png")];
    }    
    cell.backgroundColor = [UIColor whiteColor];
    if([self.highLightThese containsObject:imageUrl])
    {
        [cell showTickWithIndex:[self.highLightThese indexOfObject:imageUrl]+1];
    }
    else
    {
        if([self.highLightThese count] >= self.maxPhotos)
        {
            [cell disableTick];
        }
        else
        {
            [cell hideTick];
        }
    }
    return cell;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = collectionView.frame.size.width - 10;
    return CGSizeMake(screenWidth/3, screenWidth/3);
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = self.assets[self.assets.count - indexPath.row -1];
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    NSString *assetURL = [[rep url] absoluteString];
    
    if([self.highLightThese containsObject:assetURL])
    {
        [self.highLightThese removeObject:assetURL];
        [collectionView reloadData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *imageUrl = @"";
    if ([self.assets[self.assets.count - indexPath.row -1] isKindOfClass:[ALAsset class]]) {
        ALAsset *asset = self.assets[self.assets.count - indexPath.row -1];
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        imageUrl = [[rep url] absoluteString];
    } else {
        imageUrl = self.assets[indexPath.row];
    }
    
    if(![self.highLightThese containsObject:imageUrl] && ([self.highLightThese count] < self.maxPhotos))
    {
        [self.highLightThese addObject:imageUrl];
    }
    else
    {
        [self.highLightThese removeObject:imageUrl];
    }
    if([self.highLightThese count]>=1)
        [self.doneButton setEnabled:YES];
    else
        [self.doneButton setEnabled:NO];
    [collectionView reloadData];
}

#pragma mark - action

-(IBAction)donePressed:(id)sender
{
    if([self.highLightThese count] == 0)
    {
        NSLog(@"Please Select One");
    }
    else
    {
        NSMutableArray *allImagesIPicked = [[NSMutableArray alloc] init];
        for(NSString *ip in self.highLightThese)
        {
            [allImagesIPicked addObject:ip];
        } // end of for loop
        [self dismissViewControllerAnimated:NO completion:^{
            if ([self.delegate respondsToSelector:@selector(imageSelected:forIndexPath:)]) {
                [self.delegate imageSelected:allImagesIPicked forIndexPath:self.selectedItemIndexPath];
            }
        }];
        
    }
}

-(IBAction)cancelPressed:(id)sender
{
    //  self.selectedImage = Nil;
    [self dismissViewControllerAnimated:NO completion:^{
        if ([self.delegate respondsToSelector:@selector(imageSelectionCancelled)]) {
            [self.delegate imageSelectionCancelled];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.highLightThese == Nil)
        self.highLightThese = [[NSMutableArray alloc] init];
    
}


+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    ALAssetsLibrary *library = [CustomeImagePicker defaultAssetsLibrary];
    
    // Save snapshot to photosAlbum
    [library writeImageToSavedPhotosAlbum:((UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]).CGImage
                                 metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              [picker dismissViewControllerAnimated:YES completion:^{
                                  
                                  // add saved photo to display data
                                  __block NSMutableArray *tmpAssets = [self.assets mutableCopy];
                                  [library assetForURL:assetURL resultBlock:^(ALAsset *asset){
                                      NSInteger index = -1;
                                      if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                          index = 1;
                                      } else {
                                          index = 0;
                                      }
                                      if (index >= 0) {
                                          [tmpAssets insertObject:asset atIndex:index];
                                          // HighLight it
                                          [self.highLightThese addObject:[assetURL absoluteString]];
                                          
                                          self.assets = tmpAssets;
                                          //Reload data
                                          [self.collectionView performBatchUpdates:^{
                                              [self.doneButton setEnabled:YES];
                                              [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
                                          } completion:^(BOOL finished) {
                                              [self.collectionView reloadData];
                                          }];
                                      }
                                  }  failureBlock:^(NSError *error) {
                                      //Do nothing
                                  }];
                              }];
                          }];
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}

- (void) getAllGroup {
    ALAssetsLibrary *library = [CustomeImagePicker defaultAssetsLibrary];
    if (self.groups == nil) {
        _groups = [[NSMutableArray alloc] init];
    } else {
        [self.groups removeAllObjects];
    }
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        
        if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos)
        {
            if (self.selectedGroup == nil) {
                self.selectedGroup = group;
            }
        }
        if ([group numberOfAssets] > 0) {
            [self.groups addObject:group];
        } else {
            [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }

        [self reloadCollectionDataSource];
    };
    
    // enumerate only photos
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [library enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
    

}

- (void)reloadCollectionDataSource {
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    // Donot highligt list local image
    NSPredicate *evenNumbers = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *urlStr = (NSString *)evaluatedObject;
        return [urlStr hasPrefix:@"assets-library://"] == NO;
    }];
    
    [self.highLightThese filterUsingPredicate:evenNumbers];
    if([self.highLightThese count] > 0) {
        [self.doneButton setEnabled:YES];
        for (NSString *url in self.highLightThese) {
            if ([url hasPrefix:@"assets-library://"] == NO) {
                [tmpAssets addObject:url];
            }
        }
        
    }
    else {
        [self.doneButton setEnabled:NO];
        
    }
    [self customNavigationBarTitle:[self.selectedGroup valueForProperty:ALAssetsGroupPropertyName]];
    [self.selectedGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
     {
         if(result)
         {
             [tmpAssets addObject:result];
         }
     }];
    
    self.assets = tmpAssets;
    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
        [self.collectionView reloadData];
    });
}

- (void)didSelectedGroup:(ALAssetsGroup *)group {
    [albumsPopoverController dismissPopoverAnimated:YES];
    self.selectedGroup = group;
    [self reloadCollectionDataSource];
}

#pragma mark - WYPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)aPopoverController
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)aPopoverController
{
    if (aPopoverController == albumsPopoverController) {
    }
}

@end
