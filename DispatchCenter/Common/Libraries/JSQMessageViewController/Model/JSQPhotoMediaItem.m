//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQPhotoMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"

@interface JSQPhotoMediaItem ()

@property (strong, nonatomic) UIImageView *cachedImageView;

@end


@implementation JSQPhotoMediaItem

#pragma mark - Initialization

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
//        _image = [image copy];
        _cachedImageView = nil;
    }
    return self;
}

- (instancetype)initWithQBMessage:(QBChatMessage *)message
{
    self = [super init];
    if (self) {
        QBChatAttachment *att = (QBChatAttachment*)message.attachments[0];
        NSString *privateUrl = [QBCBlob privateUrlForID:[att.ID integerValue]];
        _imageURL = [NSURL URLWithString:privateUrl];
        _cachedImageView = nil;
    }
    return self;
}


- (void)dealloc
{
    _imageURL = nil;
    _cachedImageView = nil;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedImageView = nil;
}

#pragma mark - Setters

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = [imageURL copy];
    _cachedImageView = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedImageView = nil;
}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.imageURL == nil) {
        return nil;
    }
    
    if (self.cachedImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:_imageURL placeholderImage:[UIImage imageNamed:@"images-chat-placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error"
//                                                                message:@"send photo failed"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
            }
        }];
          self.cachedImageView = imageView;
    }
    
    return self.cachedImageView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject

- (NSUInteger)hash
{
    return super.hash ^ self.imageURL.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: image=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.imageURL, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [super encodeWithCoder:aCoder];
//    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
//}

#pragma mark - NSCopying

//- (instancetype)copyWithZone:(NSZone *)zone
//{
//    JSQPhotoMediaItem *copy = [[JSQPhotoMediaItem allocWithZone:zone] initWithImage:self.image];
//    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
//    return copy;
//}

@end
