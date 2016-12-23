//
//  DemoBaseViewController.m
//  TapsbookSDKDemo
//
//  Created by yoda on 12/23/16.
//  Copyright © 2016 tapsbook. All rights reserved.
//

#import "DemoBaseViewController.h"
#import "DemoCheckoutViewController.h"

#import "UIImage+Save.h"
#import "UIAlertView+BlocksKit.h"
#import "TZImageManager.h"
#import "MBProgressHUD.h"

#import <TapsbookSDK/TapsbookSDK.h>
#import "TBPSSizeUtil.h"

@interface DemoBaseViewController () <TBSDKAlbumManagerDelegate>

// checkout
@property (strong, nonatomic) NSMutableArray *albumsInCart;

@end

@implementation DemoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkoutMethod = CheckoutMethod_Default;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSMutableArray *)convertAssetsToTBImages:(NSArray *) assets {
    NSMutableArray * tbImages = [NSMutableArray arrayWithCapacity:assets.count];
    
    //download the selected images to cache, SDK req all images available on local file system
    for (id asset in assets){
        NSString *name = [[[asset localIdentifier] componentsSeparatedByString:@"/"] firstObject];
        TBImage *tbImage = [[TBImage alloc] initWithIdentifier:name];
        
        NSString *sPath = [self imageCachePathForAsset:name size:TBImageSize_s];
        NSString *lPath = [self imageCachePathForAsset:name size:TBImageSize_l];
        NSString *xlPath = [self imageCachePathForAsset:name size:TBImageSize_xxl];
        
        //save small size photos
        [[TZImageManager manager] getPhotoWithAsset:asset
                                         photoWidth:150
                                         completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                                             [photo writeToFile:sPath withCompressQuality:1];
                                         }];
        //save large size photos
        [[TZImageManager manager] getPhotoWithAsset:asset
                                         photoWidth:800
                                         completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                                             [photo writeToFile:lPath withCompressQuality:1];
                                         }];
        
        //save print size photos, in
        [[TZImageManager manager] getOriginalPhotoWithAsset:asset
                                                 completion:^(UIImage *photo, NSDictionary *info) {
                                                     [photo writeToFile:xlPath withCompressQuality:1];
                                                 }];
        
        [tbImage setImagePath:sPath size:TBImageSize_s];
        [tbImage setImagePath:lPath size:TBImageSize_l];
        [tbImage setImagePath:xlPath size:TBImageSize_xxl];
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

#pragma mark - Checkout Option 1
/*
 Use SDK's built-in checkout UI and our eCommerce server to handle payment
 To use this option, you must
 1. setup the 3rd party payment parameters in configurator & the tapsbook backend
*/


#pragma mark - Checkout Option 2
/*
 Use your customer checkout UI and your eCommerce server to handle payment
To use this option, you must
1. set kTBUseExternalCheckout to @YES,
2. implement a checkout (payment) view, like the DemoCheckoutViewController below
 and have your own payment process at your backend via a payment gateway
 (Stripe, Ping++, Alipay etc).
3. AFTER YOUR PAYMENT IS COMPLETE, send an order confirmation API from 
 your app or your backend to inform the tapsbook backend that you have 
 received the payment
*/

//It is now time to launch the checkout view
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkoutSDKAlbum:(TBSDKAlbum *)sdkAlbum withOrderNumber:(NSString *)orderNumber viewControllerToPresentOn:(UIViewController *)viewController {
    
    NSLog(@"preorder is compelte with an order number:%@", orderNumber);
    
    //show your checkout view now
    DemoCheckoutViewController *vc = [DemoCheckoutViewController new];
    [viewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Checkout Option 3
//Receive the product output data in JSON and process the data at your own
//server and manufacturing the product by yourself.
//this option assumes you have a backend engine that can render the final JPG and manufacturer yourself.

//Implement this callback to handle the event user click order button for an album if the album is decided to be a new, notice the infoDict here only contains the cover page JSON. The full product JSON is only available after you call checkout3_checkoutAlbumsWithIDs
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkout3_addSDKAlbumToCart:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:viewController {
    [self.albumsInCart addObject:@(sdkAlbum.ID)];
        
    [[TBSDKAlbumManager sharedInstance] dismissTBSDKViewControllersAnimated:YES completion:nil];
}

//Implement this callback to handle the event user click order button for an album if the album is already in the cart, just need to update it, the infoDict here only contains the cover page JSON
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkout3_updateSDKAlbumInCart:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:viewController {
    // Update your cart view
    
    [[TBSDKAlbumManager sharedInstance] dismissTBSDKViewControllersAnimated:YES completion:nil];
}

//datasource method that helps SDK to recognize an album is new or existing
- (BOOL)albumManager:(TBSDKAlbumManager *)albumManager checkout3_isSDKAlbumInCart:(TBSDKAlbum *)sdkAlbum {
    BOOL contains = [self.albumsInCart containsObject:@(sdkAlbum.ID)];
    return contains;
}

//event handler when user click the checkout to finalize the purchase
- (void)handleCheckoutButton:(id)sender {
    if (self.albumsInCart.count == 0) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[TBSDKAlbumManager sharedInstance] checkout3_checkoutAlbumsWithIDs:self.albumsInCart completionBlock:^(BOOL success, id result, NSError *error) {
        [hud hide:YES];
        if (success) {
            //now you can submit the final JSON to your production
            NSLog(@"do more with this JSON%@", result);
            
        }
        else {
            [UIAlertView bk_showAlertViewWithTitle:@"Error" message:error.localizedDescription cancelButtonTitle:@"OK" otherButtonTitles:nil handler:nil];
        }
    }];
}



@end
