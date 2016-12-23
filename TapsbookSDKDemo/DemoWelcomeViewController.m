//
//  DemoWelcomeViewController.m
//  TapsbookSDKDemo
//
//  Created by yoda on 12/18/16.
//  Copyright © 2016 tapsbook. All rights reserved.
//

#import "DemoWelcomeViewController.h"
#import "TZImagePickerController.h"
#import "MBProgressHUD.h"
#import "PhotoBookListViewController.h"

#import "UIImage+Save.h"
#import "TBPSSizeUtil.h"
#import <TapsbookSDK/TapsbookSDK.h>
#import <TapsbookSDK/TBSDKAlbumManager+StoreLogin.h>
#import <TapsbookSDK/TBSDKAlbumManager+StoreOrderList.h>

@interface DemoWelcomeViewController () <TZImagePickerControllerDelegate, TBSDKAlbumManagerDelegate>

@property (strong, nonatomic) void (^tb_completionBlock)(NSArray *newImages);
@property (nonatomic, strong) NSArray * selectedImages;
@property (nonatomic, assign) ViewControllerMode mode;
@property (weak, nonatomic) IBOutlet UIButton *projectListButton;
@property (weak, nonatomic) IBOutlet UIButton *orderListButton;
@property (weak, nonatomic) IBOutlet UIButton *createProjectButton;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;

@end

@implementation DemoWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self translateButtons];
    
    self.checkoutButton.hidden = self.checkoutMethod != CheckoutMethod_AppCommerceAndProduction;
    
    // Sign in to SDK in order to retrieve order list
    [self signInSDKUser];
    [[TBSDKAlbumManager sharedInstance] setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Handle buttons
- (IBAction)handleNewOrder:(id)sender {
    self.mode = ViewControllerMode_CreateAlbum;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:20 delegate:self];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (IBAction)handleExistingProjects:(id)sender {
    PhotoBookListViewController *vc = [PhotoBookListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)handleHistoryOrders:(id)sender {
    UIViewController * vc = [[TBSDKAlbumManager sharedInstance] orderListViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    self.selectedImages = assets;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSMutableArray *tbImages = [self convertAssetsToTBImages:assets];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.mode == ViewControllerMode_CreateAlbum) {
            
            //the createSDKAlbumWithImages process include facial recognition, which  takes some time..
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = NSLocalizedString(@"loader-create", @"");
            
            //create a new product
            [[TBSDKAlbumManager sharedInstance] createSDKAlbumWithImages:tbImages
                                                              identifier:nil
                                                                   title:@"Album"
                                                                     tag:0
                                                                 options:[self getDefaultProductOptions]
                                                         completionBlock:^(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error) {
                
                [hud hide:YES];
                [[TBSDKAlbumManager sharedInstance] openSDKAlbum:sdkAlbum
                                         presentOnViewController:self.navigationController
                                             shouldPrintDirectly:NO];
                
            }];
            
        }
        else if (self.mode == ViewControllerMode_AddPhoto) {
            [hud hide:YES];
            self.tb_completionBlock(tbImages);
        }
    });
    
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
}

#pragma mark TBSDKAlbumManagerDelegate

- (UIViewController *)photoSelectionViewControllerInstanceForAlbumManager:(TBSDKAlbumManager *)albumManager withSDKAlbum:(TBSDKAlbum *)sdkAlbum existingTBImages:(NSArray *)existingTBImages maxPhotoCount:(NSInteger)maxPhotoCount allowMultiple:(BOOL)allowMultiple completionBlock:(void (^)(NSArray *newImages))completionBlock {

    self.mode = ViewControllerMode_AddPhoto;
    self.tb_completionBlock = completionBlock;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:20 delegate:self];
    imagePickerVc.autoDismiss = NO;
    imagePickerVc.allowPickingVideo = NO;
    return imagePickerVc;
}


- (void) signInSDKUser {
    
    //sign in to SDK if you want to use the order tracking feature
    if (![TBSDKAlbumManager sharedInstance].currentSDKUser){
        [[TBSDKAlbumManager sharedInstance] signinSDKUser:@"123456789" fromApp:@"wechat" completionBlock:^(BOOL success, TBSDKUser *sdkUser, NSError *error) {
            if(success){
                NSLog(@"SDK user logged in. User name:%@", sdkUser.name);
            }
            else {
                NSLog(@"SDK user cannot log in. Error:%@", error.localizedDescription);
            }
        }];
    }
}

- (void)translateButtons {
    [self.projectListButton setTitle:NSLocalizedString(@"welcome-existing", @"") forState:UIControlStateNormal];
    [self.orderListButton setTitle:NSLocalizedString(@"welcome-orders", @"") forState:UIControlStateNormal];
    [self.createProjectButton setTitle:NSLocalizedString(@"welcome-new", @"") forState:UIControlStateNormal];
    [self.checkoutButton setTitle:NSLocalizedString(@"welcome-checkout", @"") forState:UIControlStateNormal];
    self.headerTitle.text = NSLocalizedString(@"welcome-title", @"");
}

- (IBAction)handleCheckoutButton:(id)sender {
    [super handleCheckoutButton:sender];
}

@end
