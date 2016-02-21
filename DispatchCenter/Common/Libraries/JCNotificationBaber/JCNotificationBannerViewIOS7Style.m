#import "JCNotificationBannerViewIOS7Style.h"

@implementation JCNotificationBannerViewIOS7Style

- (id) initWithNotification:(JCNotificationBanner*)notification {
  self = [super initWithNotification:notification];
  if (self) {
    self.titleLabel.textColor = [UIColor whiteColor];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.messageLabel setFont:[UIFont boldSystemFontOfSize:16]];
    self.backgroundColor = RGB(91, 182, 189);
//  self.backgroundColor = [UIColor colorWithRed:0.341 green:0.757 blue:0.784 alpha:1.000];
    /*self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOpacity = 0.8;*/
  }
  return self;
}

/** Overriden to do no custom drawing */
- (void) drawRect:(CGRect)rect {
}

@end
