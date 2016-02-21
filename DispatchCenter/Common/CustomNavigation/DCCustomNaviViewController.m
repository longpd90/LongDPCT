//
//  DCCustomNaviViewController.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCCustomNaviViewController.h"

@interface DCCustomNaviViewController ()<UINavigationControllerDelegate>

@end

@implementation DCCustomNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor backgroundNavRegVC]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Private methods
- (NSArray *)reversedArray:(NSArray*)inputArr {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[inputArr count]];
    NSEnumerator *enumerator = [inputArr reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

- (UIBarButtonItem*)barButtonWithImage:(UIImage*)img target:(id)target action:(SEL)action{
    CGFloat w = img.size.width;
    
    if (IS_OS_7_OR_LATER == NO) { // For ios 6
        w += 20;
    }
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, img.size.height)];

    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (UIBarButtonItem*)barButtonWithImage:(UIImage*)img title:(NSString*)title target:(id)target action:(SEL)action{
    CGFloat w = img.size.width + 70;
    
    if (IS_OS_7_OR_LATER == NO) { // For ios 6
        w += 20;
    }
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, img.size.height)];
    
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 60)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark - Override methods

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count == 1) {
        if (self.topViewController.navigationItem.rightBarButtonItems.count > 1) {
            [self addLeftBtnWithImg:[UIImage imageNamed:@"ic_navi_logo"] target:nil action:nil];
        } else {
            viewController.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_navi_logo"]];
        }
    } else {
        viewController.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_navi_logo"]];
    }
}
#pragma mark - Public methods
+ (DCCustomNaviViewController*)mainNavigation {
    if ([APP_DELEGATE.window.rootViewController isKindOfClass:[DCCustomNaviViewController class]]) {
        return (DCCustomNaviViewController*)APP_DELEGATE.window.rootViewController;
    }
    
    return nil;
}

- (void)addLeftBtnWithImg:(UIImage*)img target:(id)target action:(SEL)action {
    UIBarButtonItem *barBtn = [self barButtonWithImage:img target:target action:action];
    self.topViewController.navigationItem.leftBarButtonItem = barBtn;
}

- (void)addLeftBtnWithImg:(UIImage*)img title:(NSString*)title target:(id)target action:(SEL)action {
 UIBarButtonItem *barBtn = [self barButtonWithImage:img title:NSLocalizedString(@"Back",nil) target:target action:action];
 
   
    self.topViewController.navigationItem.leftBarButtonItem = barBtn;
}

- (void)addRightBtnWithImg:(UIImage*)img target:(id)target action:(SEL)action {
    UIBarButtonItem *barBtn = [self barButtonWithImage:img target:target action:action];
    self.topViewController.navigationItem.rightBarButtonItem = barBtn;
}

- (NSArray*)addMultiBtns:(NSArray*)btnContent leftOrRight:(BOOL)leftOrRight target:(id)target actions:(NSArray*)actions {
    if (btnContent.count > 0 && actions.count > 0 && btnContent.count == actions.count) {
        NSMutableArray *btnArr = [NSMutableArray new];
        for (int i = btnContent.count - 1; i >= 0; i--) {
            id cont = btnContent[i];
            
            SEL act = [actions[i] isKindOfClass:[NSValue class]] ? (SEL)[actions[i] pointerValue] : nil;
            
            if ([cont isKindOfClass:[UIImage class]]) {
                UIBarButtonItem *barBtn = [self barButtonWithImage:cont target:target action:act];
                
                [btnArr addObject:barBtn];
            } else if ([cont isKindOfClass:[NSString class]]) {
                UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:cont style:UIBarButtonItemStylePlain target:target action:act];
                
                [btnArr addObject:barBtn];
            }
        }
        
        if (leftOrRight == YES) {
            [self.topViewController.navigationItem setLeftBarButtonItems:btnArr];
        } else {
            [self.topViewController.navigationItem setRightBarButtonItems:btnArr];
        }
        
        return [self reversedArray:btnArr];
    } else {
        return nil;
    }
    
}
@end
