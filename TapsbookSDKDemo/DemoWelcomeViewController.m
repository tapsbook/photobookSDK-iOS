//
//  DemoWelcomeViewController.m
//  TapsbookSDKDemo
//
//  Created by yoda on 12/18/16.
//  Copyright © 2016 tapsbook. All rights reserved.
//

#import "DemoWelcomeViewController.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "MBProgressHUD.h"
#import "PhotoBookListViewController.h"

#import "UIImage+Save.h"
#import "TBPSSizeUtil.h"
#import <TapsbookSDK/TapsbookSDK.h>
#import <TapsbookSDK/TBSDKAlbumManager+StoreLogin.h>
#import <TapsbookSDK/TBSDKAlbumManager+StoreOrderList.h>

typedef NS_ENUM(NSInteger, ViewControllerMode) {
    ViewControllerMode_CreateAlbum,
    ViewControllerMode_AddPhoto,
};

@interface DemoWelcomeViewController () <TZImagePickerControllerDelegate, TBSDKAlbumManagerDelegate>

@property (strong, nonatomic) void (^tb_completionBlock)(NSArray *newImages);
@property (nonatomic, strong) NSArray * selectedImages;
@property (nonatomic, assign) ViewControllerMode mode;

@end

@implementation DemoWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
            hud.labelText = @"recognizing faces...";
            
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

#pragma mark TBSDKAlbumManager

- (UIViewController *)photoSelectionViewControllerInstanceForAlbumManager:(TBSDKAlbumManager *)albumManager withSDKAlbum:(TBSDKAlbum *)sdkAlbum existingTBImages:(NSArray *)existingTBImages maxPhotoCount:(NSInteger)maxPhotoCount allowMultiple:(BOOL)allowMultiple completionBlock:(void (^)(NSArray *newImages))completionBlock {

    self.mode = ViewControllerMode_AddPhoto;
    self.tb_completionBlock = completionBlock;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:20 delegate:self];
    imagePickerVc.autoDismiss = NO;
    imagePickerVc.allowPickingVideo = NO;
    return imagePickerVc;
}

- (NSMutableDictionary *)getDefaultProductOptions {
    NSDictionary * albumOptionBase = @{
                                       kTBProductMaxPageCount:     @"20",   //set max=min will limit the page count
                                       kTBProductMinPageCount:     @"20",
                                       kTBBookHasInsideCover:      @"NO",
                                       kTBProductMaxPhotoCount:    @"40",
                                       kTBProductMinPhotoCount:    @"20",
                                       kTBPreferredUIDirection:    @"LTR",   //set this RTL or LTR
                                       kTBPreferredPageTypeSpread: @(YES)
                                       };
    NSDictionary * albumBookType8x8 =@{
                                       kTBProductPreferredTheme:   @"200",  //200 is for square book
                                       kTBProductPreferredSKU:     @"1003", //1003 is a layflat square book
                                       };
    
    NSMutableDictionary *  albumOption = [albumOptionBase mutableCopy];
    [albumOption addEntriesFromDictionary:albumBookType8x8];
    return albumOption;
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

- (NSMutableArray *)convertAssetsToTBImages:(NSArray *) assets {
    NSMutableArray * tbImages = [NSMutableArray arrayWithCapacity:assets.count];
    
    //download the selected images to cache, SDK req all images available on local file system
    for (id asset in self.selectedImages){
        NSString *name = [[[asset localIdentifier] componentsSeparatedByString:@"/"] firstObject];
        TBImage *tbImage = [[TBImage alloc] initWithIdentifier:name];
        
        NSString *sPath = [self imageCachePathForAsset:name size:TBImageSize_s];
        NSString *lPath = [self imageCachePathForAsset:name size:TBImageSize_l];
        
        //save small size photos
        [[TZImageManager manager] getPhotoWithAsset:asset
                                         photoWidth:150
                                         completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                                             [photo writeToFile:sPath withCompressQuality:1];
                                         }];
        //save small size photos
        [[TZImageManager manager] getPhotoWithAsset:asset
                                         photoWidth:800
                                         completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                                             [photo writeToFile:lPath withCompressQuality:1];
                                         }];

        [tbImage setImagePath:sPath size:TBImageSize_s];
        [tbImage setImagePath:lPath size:TBImageSize_l];
        [tbImage setDesc:name];
        [tbImage setImageCSURLString:@"http://awesome.web/where/is/my/photo_full.jpg" size:TBImageSize_xxl];
        [tbImage setImageCSURLString:@"http://awesome.web/where/is/my/photo_regular.jpg" size:TBImageSize_l];
        [tbImages addObject:tbImage];
    }
    
    return tbImages;
}

- (NSString *) imageCachePathForAsset:(NSString*) name size:(TBImageSize) size {
    NSString *cachePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"ImageCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:cachePath isDirectory:NULL]) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%zd", name, size]];
    return filePath;
}

@end
