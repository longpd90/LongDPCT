//
//  PAImageDetailViewController.m
//  PostApp
//


#import "PAImageDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PAImageDetailViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imgDetail;

@end

@implementation PAImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToImagePickerDidTouched:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)loadImage {
    if (self.imageUrl.length > 0) {
        if ([self.imageUrl hasPrefix:@"assets-library://"]) {
            NSURL* aURL = [NSURL URLWithString:self.imageUrl];
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:aURL resultBlock:^(ALAsset *asset){
                UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:0.5 orientation:UIImageOrientationUp];
                if (copyOfOriginalImage == nil) {
                    self.imgDetail.image = [UIImage imageNamed:@"noimage.png"];
                } else {
                    self.imgDetail.image = copyOfOriginalImage;
                }
            }  failureBlock:^(NSError *error) {
                self.imgDetail.image = [UIImage imageNamed:@"noimage.png"];
            }];
        } else {
            NSURL *imageUrl = [NSURL URLWithString:self.imageUrl];
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            indicatorView.center = self.imgDetail.center;
            [self.view addSubview:indicatorView];
            [indicatorView startAnimating];
            [self.imgDetail setImageWithURLRequest:[NSURLRequest requestWithURL:imageUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                self.imgDetail.image = image;
                if (indicatorView) {
                    [indicatorView stopAnimating];
                    [indicatorView removeFromSuperview];
                }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                if (indicatorView) {
                    [indicatorView stopAnimating];
                    [indicatorView removeFromSuperview];
                }
                self.imgDetail.image = [UIImage imageNamed:@"noimage.png"];
            }];
        }
    } else {
        self.imgDetail.image = [UIImage imageNamed:@"noimage.png"];
    }
    [self.imgDetail  setContentMode:UIViewContentModeScaleAspectFit];
    [self.imgDetail setClipsToBounds:YES];
}

@end
