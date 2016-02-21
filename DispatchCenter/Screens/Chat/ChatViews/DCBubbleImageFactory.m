//
//  PDLBubbleImageFactory.m
//  PDLChatDemo
//
//  Created by Phung Long on 10/14/15.
//  Copyright (c) 2015 Phung Long. All rights reserved.
//

#import "DCBubbleImageFactory.h"
#import "UIImage+JSQMessages.h"
#import "UIColor+JSQMessages.h"

@interface DCBubbleImageFactory ()
@property (strong, nonatomic, readonly) UIImage *bubbleImage;
@property (assign, nonatomic, readonly) UIEdgeInsets capInsets;

- (UIEdgeInsets)jsq_centerPointEdgeInsetsForImageSize:(CGSize)bubbleImageSize;

- (UIImage *)jsq_stretchableImageFromImage:(UIImage *)image withCapInsets:(UIEdgeInsets)capInsets;

@end

@implementation DCBubbleImageFactory

#pragma mark - Initialization

- (instancetype)initWithBubbleImage:(UIImage *)bubbleImage capInsets:(UIEdgeInsets)capInsets
{
    NSParameterAssert(bubbleImage != nil);
        if (self) {
        _bubbleImage = bubbleImage;
        
        if (UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsetsZero)) {
            _capInsets = [self jsq_centerPointEdgeInsetsForImageSize:bubbleImage.size];
        }
        else {
            _capInsets = capInsets;
        }
    }
    return self;
}

- (instancetype)init
{
    return [self initWithBubbleImage:[UIImage jsq_bubbleCompactImage] capInsets:UIEdgeInsetsZero];
}

- (void)dealloc
{
    _bubbleImage = nil;
}

#pragma mark - Public

- (JSQMessagesBubbleImage *)outgoingMessages
{
    UIImage *normalBubble = [UIImage imageNamed:@"bubble_goouting"];
    UIImage *highlightedBubble = [UIImage imageNamed:@"bubble_goouting"];
    normalBubble = [self jsq_stretchableImageFromImage:normalBubble withCapInsets:self.capInsets];
    highlightedBubble = [self jsq_stretchableImageFromImage:highlightedBubble withCapInsets:self.capInsets];
    
    return [[JSQMessagesBubbleImage alloc] initWithMessageBubbleImage:normalBubble highlightedImage:highlightedBubble];
}

- (JSQMessagesBubbleImage *)incomingMessages
{
    UIImage *normalBubble = [UIImage imageNamed:@"bubble_incoming"];
    UIImage *highlightedBubble = [UIImage imageNamed:@"bubble_incoming"];
    normalBubble = [self jsq_stretchableImageFromImage:normalBubble withCapInsets:self.capInsets];
    highlightedBubble = [self jsq_stretchableImageFromImage:highlightedBubble withCapInsets:self.capInsets];
    
    return [[JSQMessagesBubbleImage alloc] initWithMessageBubbleImage:normalBubble highlightedImage:highlightedBubble];
}



- (UIImage *)jsq_stretchableImageFromImage:(UIImage *)image withCapInsets:(UIEdgeInsets)capInsets
{
    return [image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
}

- (UIEdgeInsets)jsq_centerPointEdgeInsetsForImageSize:(CGSize)bubbleImageSize
{
    // make image stretchable from center point
    CGPoint center = CGPointMake(bubbleImageSize.width / 2.0f, bubbleImageSize.height / 2.0f);
    return UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
}

@end
