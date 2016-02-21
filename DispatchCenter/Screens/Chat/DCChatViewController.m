//
//  PDLChatViewController.m
//  PDLChatDemo
//
//  Created by Phung Long on 10/13/15.
//  Copyright (c) 2015 Phung Long. All rights reserved.
//

#import "DCChatViewController.h"
#import "DCChatManager.h"
#import "UIImage+Utility.h"
#import "CustomeImagePicker.h"
#import <AVFoundation/AVFoundation.h>
#import "DCRefreshView.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterIOS7Style.h"
#define messagePazingSize 20

@interface DCChatViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,CustomeImagePickerDelegate,MWPhotoBrowserDelegate, UIActionSheetDelegate> {
    BOOL dontLeaveChat;
    BOOL isShowPhotoPreview;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (assign, nonatomic) int skip;
@property (assign, nonatomic) BOOL canLoadMore;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSDate *messageDateSent;
@property (nonatomic, strong) NSArray *fixedMessages;
@property (nonatomic, strong) DCRefreshView *loadMoreView;
@property (nonatomic, strong) NSString *occupantIDs;
@property (nonatomic, strong) MWPhotoBrowser *browser;

@end


@implementation DCChatViewController

#pragma mark - Class methods

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([DCChatViewController class])
                          bundle:[NSBundle bundleForClass:[DCChatViewController class]]];
}

+ (instancetype)messagesViewController
{
    return [[[self class] alloc] initWithNibName:NSStringFromClass([DCChatViewController class])
                                          bundle:[NSBundle bundleForClass:[DCChatViewController class]]];
}

- (IBAction)agreeToCallTouched:(id)sender {
    NSString *phoneNum = [NSString stringWithFormat:@"%@",self.phoneCall];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
}

- (IBAction)cancelCallTouched:(id)sender {
    [self.callingAlert removeFromSuperview];
}

+ (DCChatViewController*)makeMeWithRoomID:(NSString*)roomID roomJID:(NSString*)roomJID phoneNum:(NSString *)phoneNum{
    DCChatViewController *chatVC = [self messagesViewController];
    chatVC.roomID = roomID;
    chatVC.roomJID = roomJID;
    chatVC.phoneCall = phoneNum;
    return chatVC;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _canLoadMore = YES;
    self.skip = 0;
    
    if (_chatMode == DCChatModeNormal) {
        self.inputToolbar.contentView.leftBarButtonItem = nil;
        [MAIN_NAVIGATION addMultiBtns:@[[UIImage imageNamed:@"btn_chat_attach"], [UIImage imageNamed:@"btn_call"], [UIImage imageNamed:@"btn_3dot_menu"]] leftOrRight:NO target:self actions:@[[NSValue valueWithPointer:@selector(didSelectAttachBtn:)], [NSValue valueWithPointer:@selector(didSelectCallBtn:)], [NSValue valueWithPointer:@selector(didSelectMenuBtn:)]]];
        self.inputToolbar.contentView.textView.placeHolder = [NSBundle jsq_localizedStringForKey:@"I need..."];
        
    } else {
        self.inputToolbar.contentView.textView.placeHolder = [NSBundle jsq_localizedStringForKey:@"Start a conversation..."];
    }
    
    self.title = @"";
    self.toolbarHeightConstraint.constant = 50.0f;
    
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    self.inputToolbar.contentView.textView.layer.cornerRadius = 4.0;
    
    self.messagesData = [[DCMessagesModelData alloc] init];
    
    self.showLoadEarlierMessagesHeader = NO;
    
    [self creatLoadMoreView];
    
    /**
     *  Register custom menu actions for cells.
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    [UIMenuController sharedMenuController].menuItems = @[ [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Custom Action",nil)
                                                                                      action:@selector(customAction:)] ];
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
    
//    __weak typeof(self) weakSelf = self;
//    
//    [self checkCurrentUserWithCompletion:^(NSError *authError) {
//        
//        if (!authError) {
//            [weakSelf registerForRemoteNotifications];
//        } else {
//            NSLog(@"authen error !");
//        }
//        
//    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.currentChatDialog == nil) {
        [self setupChat];
    }
    if (!isShowPhotoPreview) {
        if (self.automaticallyScrollsToMostRecentMessage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scrollToBottomAnimated:NO];
                [self.collectionView.collectionViewLayout invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
            });
        }

    }
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back",nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    [super viewWillDisappear:animated];
    if (dontLeaveChat == NO) {
        if (self.currentChatDialog != nil) {
            [DCChat leaveDialog:self.currentChatDialog];
            self.currentChatDialog = nil;
        }
    }
}

- (void)dealloc {
    [DCChat setDidGetMessage:nil];
    self.currentChatDialog = nil;
}


#pragma mark - push message notification

- (void)registerForRemoteNotifications
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
}

- (void)checkCurrentUserWithCompletion:(void(^)(NSError *authError))completion
{
    if ([[QBSession currentSession] currentUser] != nil) {
        
        if (completion) completion(nil);
        
    } else {
        
        [QBRequest logInWithUserLogin:@"demo_api" password:@"pass123!" successBlock:^(QBResponse *response, QBUUser *user) {
            
            if (completion) completion(nil);
            
        } errorBlock:^(QBResponse *response) {
            
            if (completion) completion(response.error.error);
        }];
    }
}

- (void)sendPushWithMessage:(NSString *)message
{
    if([message length] == 0) {
        
        NSLog(@"empty message");
    } else {
        
        [QBRequest sendPushWithText:message toUsers:_occupantIDs successBlock:^(QBResponse *response, NSArray *events) {
            
        } errorBlock:^(QBError *error) {
        }];
    }
    
    
}

- (void)sendPushWithParams:(NSString *)message {
    // Send push to users with ids 292,300,1295
    QBMEvent *event = [QBMEvent event];
    event.notificationType = QBMNotificationTypePush;
    event.usersIDs = _occupantIDs;
    event.type = QBMEventTypeOneShot;
    
    // standart parameters
    // read more about parameters formation http://quickblox.com/developers/Messages#Use_custom_parameters
    //
    NSMutableDictionary  *dictPush = [NSMutableDictionary  dictionary];
    [dictPush setObject:message forKey:@"message"];
    // custom params
    
    NSError *error = nil;
    NSData *sendData = [NSJSONSerialization dataWithJSONObject:dictPush options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];
    //
    event.message = jsonString;
    [QBRequest createEvent:event successBlock:^(QBResponse * _Nonnull response, NSArray<QBMEvent *> * _Nullable events) {
        
        NSLog(@"creat envent success");
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        NSLog(@"creat envent error");
        
    }];
}

#pragma mark - Private methods

- (void)setTaskDetailFA:(DCTaskDetailWFInfo *)taskDetailFA {
    _taskDetailFA = taskDetailFA;
}

- (void)didSelectAttachBtn:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose photo",nil) message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Camera",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoFromCameraOrLibrary:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Camera Roll",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoFromCameraOrLibrary:NO];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"str_photo_cancel",nil) style:UIAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didSelectCallBtn:(id)sender {
    if (APP_DELEGATE.mySettings.phoneNumber == nil) {
        [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Phone number is empty", nil) callback:^(UIAlertView *al, NSInteger idx) {
            
        } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
    
//        [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterIOS7Style new];
//        [JCNotificationCenter
//         enqueueNotificationWithTitle:nil
//         message:NSLocalizedString(@"Phone number is empty", nil)
//         tapHandler:^{
//             
//         }];
    } else {
        __weak typeof (self) thiz = self;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"str_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:NSLocalizedString(@"str_callcenter", nil)], nil];
        [actionSheet showInView:thiz.view];
    }

    
}

- (void)didSelectMenuBtn:(id)sender {
    [DCDropDownMenuViewController showMe];
}

- (void)loadMoreMessage {
    if (self.currentChatDialog) {
        [LoadingViewHelper showLoading];
        if (self.chatMode == DCChatModeWF) {
            [DCChat loadChatHistoryInDialogID:self.currentChatDialog.ID skip:self.skip take:messagePazingSize startDate:[self.taskDetailFA.operatorStartDate dateFromFomratStringMMDDYY] endDate:[self.taskDetailFA.operatorEndDate dateFromFomratStringMMDDYY] responseHandler:^(BOOL success, NSArray *result) {
                [LoadingViewHelper hideLoading];
                [_loadMoreView endRefreshing];
                if (result.count < messagePazingSize || result == nil) {
                    _canLoadMore = NO;
                    self.showLoadEarlierMessagesHeader = NO;
                } else {
                    self.showLoadEarlierMessagesHeader = YES;
                }
                [self.messagesData loadMoreMessages:result];
                [self refreshView];
                if (self.skip == 0) {
                    [self scrollToBottomAnimated:YES];
                } else {
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:result.count inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                }
            }];
        } else {
            [DCChat loadChatHistoryInDialogID:self.currentChatDialog.ID skip:self.skip take:messagePazingSize  responseHandler:^(BOOL success, NSArray *result) {
                [LoadingViewHelper hideLoading];
                [_loadMoreView endRefreshing];
                if (result.count < messagePazingSize || result == nil) {
                    _canLoadMore = NO;
                    self.showLoadEarlierMessagesHeader = NO;
                } else {
                    self.showLoadEarlierMessagesHeader = YES;
                    
                }
                [self.messagesData loadMoreMessages:result];
                [self refreshView];
                if (self.skip == 0) {
                    [self scrollToBottomAnimated:YES];
                } else {
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(self.messagesData.messages.count - self.skip) inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                }
            }];
        }
    }
}

- (void)refreshView {
    NSDate *dateTemp;
    if (self.messagesData.messages.count <= 0) {
        [self.collectionView.collectionViewLayout invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
        [self.collectionView reloadData];
        return;
    }
    for (NSInteger i = 0;i < self.messagesData.messages.count; i ++) {
        JSQMessage *message = [self.messagesData.messages objectAtIndex:i];
        
        if (!dateTemp ) {
            message.isFirstInDay = YES;
        } else if ([self compareDay:message.date withDate:dateTemp] ) {
            message.isFirstInDay = YES;
        } else {
            message.isFirstInDay = NO;
        }
        dateTemp = message.date;
    }
    [self.collectionView.collectionViewLayout invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
    [self.collectionView reloadData];
    
}

- (void) creatLoadMoreView {
    CGFloat customRefreshControlHeight = 50.0f;
    CGFloat customRefreshControlWidth = CGRectGetWidth(self.collectionView.frame);
    _loadMoreView = [[DCRefreshView alloc]initWithFrame:CGRectMake(0.0, -customRefreshControlHeight, customRefreshControlWidth, customRefreshControlHeight)];
    [_loadMoreView addTarget:self action:@selector(reloadView:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:_loadMoreView];
}

- (void)reloadView:(id)sender {
    if ([_loadMoreView isRefreshing]) {
        if (_canLoadMore) {
            self.skip = (int)self.messagesData.messages.count;
            [self loadMoreMessage];
        } else {
            [_loadMoreView endRefreshing];
        }
    }
}

- (void)setupChat {

    if (self.roomID.length > 0 && self.roomJID.length > 0) {
        [LoadingViewHelper showLoading];
        [DCChat joinDialogWithID:self.roomID roomJID:self.roomJID currentUserID:[QBSession currentSession].currentUser.ID responseHandler:^(BOOL success, QBChatDialog *dialog) {
            if (success) {
                self.skip = 0;
                _messageDateSent = nil;
                [self.messagesData.messages removeAllObjects];
                [self refreshView];
                self.currentChatDialog = dialog;
                [self loadMoreMessage];
            } else {
                [LoadingViewHelper hideLoading];
            }
            if (!APP_DELEGATE.mMyProfile) {
                [APP_DELEGATE loadProfileIfNeed];
            }
        }];
        
    } else {
        DLogError(@"%@", @"Please input rooomID and roomJID");
    }
    
    [DCChat setDidGetMessage:^(QBChatMessage *message) {
        [self didGetMessage:message];
    }];
}

- (void)selectPhotoFromCameraOrLibrary:(BOOL)cameraOrLibrary {
    dontLeaveChat = YES;
    if (cameraOrLibrary) {
        [self showCamera];
    } else {
        [self showLibrary];
    }
}

- (void) showCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized ) {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        // do your logic
    } else if(authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera access",nil) message:NSLocalizedString(@"This app does not have access to your photos or videos\n You can enable access in Privacy Settings",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alertView show];
        // denied
    } else if(authStatus == AVAuthorizationStatusRestricted){
        // restricted, normally won't happen
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera roll access",nil) message:NSLocalizedString(@"The client is not authorized to access the hardware for the media type",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alertView show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController *picker = [UIImagePickerController new];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.delegate = self;
                    [self presentViewController:picker animated:YES completion:nil];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera access",nil) message:NSLocalizedString(@"This app does not have access to your photos or videos\n You can enable access in Privacy Settings",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        }];
    }
}

- (void)showLibrary {
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if(authStatus == AVAuthorizationStatusAuthorized ) {
        CustomeImagePicker *customImagePicker =[[CustomeImagePicker alloc] initWithNibName:NSLocalizedString(@"CustomeImagePicker",nil) bundle:nil];
        customImagePicker.delegate = self;
        [self presentViewController:customImagePicker animated:YES completion:nil];
        
    } else if(authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera roll access",nil) message:NSLocalizedString(@"This app does not have access to your photos or videos\n You can enable access in Privacy Settings",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alertView show];
        // denied
    } else if(authStatus == AVAuthorizationStatusRestricted){
        // restricted, normally won't happen
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera roll access",nil) message:NSLocalizedString(@"The client is not authorized to access the hardware for the media type",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alertView show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus authorizationStatus)
         {
             if (authorizationStatus == PHAuthorizationStatusAuthorized)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     CustomeImagePicker *customImagePicker =[[CustomeImagePicker alloc] initWithNibName:@"CustomeImagePicker" bundle:nil];
                     customImagePicker.delegate = self;
                     [self presentViewController:customImagePicker animated:YES completion:nil];
                 });
             } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera roll access",nil) message:NSLocalizedString(@"This app does not have access to your photos or videos\n You can enable access in Privacy Settings",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
                     [alertView show];
                 });
                 
             }
         }];
    }
    
}

#pragma mark - photoview delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - custom Image picker delegate

- (void)imageSelected:(NSArray*)arrayOfImages forIndexPath:(NSIndexPath*)indextPath{
    dontLeaveChat = NO;
    for (int i = 0; i < arrayOfImages.count; i ++) {
        NSString *imagePath = [arrayOfImages objectAtIndex:i];
        if (imagePath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([imagePath hasPrefix:@"assets-library://"]) {
                    [self getImage:imagePath];
                }
            });
        }
    }
}

- (void)getImage:(NSString *)url {
    NSURL* aURL = [NSURL URLWithString:url];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:aURL resultBlock:^(ALAsset *asset){
        UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:1 orientation:UIImageOrientationUp];
        
        if (copyOfOriginalImage) {
            [LoadingViewHelper showLoading];
            copyOfOriginalImage = [copyOfOriginalImage fixOrientation];
            copyOfOriginalImage = [copyOfOriginalImage correctImagetoMaxSize:1024];
            [DCChat sendMessage:@"" toDialog:self.currentChatDialog withAttachedImage:copyOfOriginalImage responseHandler:^(BOOL success) {
                if (!success) {
                    [UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Can't you send a message, You are not connected to chat",nil) callback:^(UIAlertView *al, NSInteger idx) {
                        
                    } cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
                    
                    
                    
                }
                //                if (success) {
                //                    [self sendPushWithMessage:@"friend send to you photos"];
                //                }
                //
                [LoadingViewHelper hideLoading];
                
            }];
        }
    }
            failureBlock:^(NSError *error) {
            }];
}

- (void)showPhotoView:(JSQMessage *)msg {
    dontLeaveChat = YES;
    isShowPhotoPreview = YES;
    // Create array of MWPhoto objects
    self.photos = [NSMutableArray array];
    JSQPhotoMediaItem *mediaItem = (JSQPhotoMediaItem *) msg.media;
    NSURL *imageURL = [mediaItem imageURL];
    // Add photos
    [_photos addObject:[MWPhoto photoWithURL:imageURL]];
    
    
    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    if (!_browser) {
        _browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    }
    
    // Set options
    _browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    _browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    _browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    _browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    _browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    _browser.enableGrid = NO; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    _browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    _browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    _browser.customImageSelectedIconName = @"ImageSelected.png";
    _browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [_browser.view addGestureRecognizer:singleFingerTap];
    // Optionally set the current visible photo before displaying
    //    [browser setCurrentPhotoIndex:1];
    [self presentViewController:_browser animated:YES completion:^{
        
    }];
//    [self.navigationController pushViewController:browser animated:YES];
    
    // Manipulate
    [_browser showNextPhotoAnimated:YES];
    [_browser showPreviousPhotoAnimated:YES];
    [_browser reloadData];
    //    [browser setCurrentPhotoIndex:10];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    dontLeaveChat = NO;
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    img = [img fixOrientation];
    img = [img correctImagetoMaxSize:1024];
    
    [LoadingViewHelper showLoading];
    [DCChat sendMessage:@"" toDialog:self.currentChatDialog withAttachedImage:img responseHandler:^(BOOL success) {
        [LoadingViewHelper hideLoading];
        if (!success) {
            [UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Can't you send a message, You are not connected to chat",nil) callback:^(UIAlertView *al, NSInteger idx) {
                
            } cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
            
            
            
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    dontLeaveChat = NO;
}

#pragma mark - DCChat blocks
- (void)didGetMessage:(QBChatMessage*)msg {
    if (msg) {
        if (self.chatMode == DCChatModeWF &&
            self.taskDetailFA &&
            [msg.dateSent compare:[self.taskDetailFA.operatorEndDate dateFromFomratStringMMDDYY]] == NSOrderedDescending ){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:NSLocalizedString(@"%@ finished, you can't send message",nil),self.taskDetailFA.name]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
            [alertView show];
            
        } else {
            if (msg.isPhotoMsg) {
                [self.messagesData addPhotoMediaMessage:msg isLoadMore:NO];
            } else {
                [self.messagesData addMessagesToChat:msg];
            }
        }
        
        [self finishSendingMessageAnimated:YES];
        
    }
}


- (void)finishSendingMessageAnimated:(BOOL)animated {
    
    UITextView *textView = self.inputToolbar.contentView.textView;
    textView.text = nil;
    [textView.undoManager removeAllActions];
    
    [self.inputToolbar toggleSendButtonEnabled];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:textView];
    
    [self.collectionView.collectionViewLayout invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
    [self refreshView];
    
    if (self.automaticallyScrollsToMostRecentMessage) {
        [self scrollToBottomAnimated:animated];
    }
}

#pragma mark - Actions
- (NSComparisonResult)compareDay:(NSDate *)date1 withDate:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentDateComponents = [calendar components:
                                               NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                          fromDate:date1];
    NSDateComponents *compareDateComponents = [calendar components:
                                               NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                          fromDate:date2];
    return [[calendar dateFromComponents:currentDateComponents] compare:
            [calendar dateFromComponents:compareDateComponents]];
}


#pragma mark - JSQMessagesViewController method overrides

- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self didSelectAttachBtn:sender];
}

- (void)didPressSendButtonWithMessageText:(NSString *)text
{
    [DCChat sendMessage:text inGroup:self.currentChatDialog failure:^(NSError *error) {
        [self finishSendingMessageAnimated:YES];
        if (error) {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:NSLocalizedString(@"Can't you send a message, You are not connected to chat",nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                              otherButtonTitles:nil]
             show];
        } else {
            NSLog(@"send success ");
        }
    }];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messagesData.messages.count > 0) {
        return [self.messagesData.messages objectAtIndex:indexPath.item];
    }
    return nil;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [self.messagesData.messages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    if (self.messagesData.messages.count > 0) {
        JSQMessage *message = [self.messagesData.messages objectAtIndex:indexPath.item];
        
        if ([message myMessage]) {
            return self.messagesData.outgoingBubbleImageData;
        }
        
        return self.messagesData.incomingBubbleImageData;
    }
    return nil;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messagesData.messages.count > 0) {
        JSQMessage *message = [self.messagesData.messages objectAtIndex:indexPath.item];
        if ( message.isFirstInDay ) {
            return [[JSQMessagesTimestampFormatter sharedFormatter] attributedGroupMessageDate:message.date];
        }
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messagesData.messages.count > 0) {
        JSQMessage *message = [self.messagesData.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messagesData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *msg = [self.messagesData.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
            
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
            
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    [cell.cellBottomLabel setTextAlignment:NSTextAlignmentRight];
    
    
    return cell;
}


#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Custom Action",nil)
                                message:nil
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK",nil)
                      otherButtonTitles:nil]
     show];
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath

{
    if (self.messagesData.messages.count > 0) {
        JSQMessage *message = [self.messagesData.messages objectAtIndex:indexPath.item];
        if ( message.isFirstInDay ) {
            return 40.0f;
        }
    }
    
    return 20.0f;
}



- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 10.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    if (_canLoadMore) {
        self.skip = (int)self.messagesData.messages.count;
        [self loadMoreMessage];
    }
    
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    JSQMessage *msg = [self.messagesData.messages objectAtIndex:indexPath.item];
    if (msg.isMediaMessage) {
        [self showPhotoView:msg];
    }
    
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods


- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.messagesData.messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}


#pragma mark - UIActionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSString *pPhoneNumber = [@"telprompt://" stringByAppendingString:APP_DELEGATE.mySettings.phoneNumber == nil ? @"" : APP_DELEGATE.mySettings.phoneNumber];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pPhoneNumber]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pPhoneNumber]];
        } else {
            [[UIAlertView alertViewtWithTitle:nil message:NSLocalizedString(@"Can not call this phone number", nil) callback:^(UIAlertView *al, NSInteger idx) {
                
            } cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
        }
        
    }
}

#pragma mark -
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [_browser dismissViewControllerAnimated:YES completion:^{
        isShowPhotoPreview = NO;
    }];
    //Do stuff here...
}

@end
