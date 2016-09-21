//
//  PhotoListViewController.m
//  TapsbookSDKDemo
//
//  Created by Xinrong Guo on 14-6-27.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import "PhotoListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "PhotoCell.h"

#import <TapsbookSDK/TBSDKAlbumManager+StoreLogin.h>
#import <TapsbookSDK/TBSDKAlbumManager+StoreOrderList.h>
#import "MBProgressHUD.h"
#import "UIAlertView+BlocksKit.h"
#import "ALAssetRepresentation+Helper.h"
#import "UIImage+Save.h"
#import "extobjc.h"
#import "CheckoutViewController.h"
#import "TBPSSizeUtil.h"
#import "PhotoBookListViewController.h"

#define WZProductType_8x8softcover @"SOFT88"
#define WZProductType_8x8hardcover @"HARD88"
#define WZProductType_6x6softcover @"SOFT66"
#define WZProductType_8x8layflat @"LAYFLAT88"

@interface PhotoListViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, TBSDKAlbumManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@property (strong, nonatomic) NSMutableArray *assets;

@property (strong, nonatomic) dispatch_queue_t cellImageLoadingQueue;

@property (strong, nonatomic) NSOperationQueue *imageCacheingQueue;

@property (strong, nonatomic) NSOperationQueue *imagePreloadingOperationQueue;

@property (strong, nonatomic) dispatch_queue_t diskIOQueue;

@property (strong, nonatomic) PHCachingImageManager * imageManager;
@property (strong, nonatomic) UIBarButtonItem *createAlbumOrAddPhotoButton;

// SDK

@property (assign, nonatomic) BOOL shouldCreateCanvas;

// checkout 3
@property (strong, nonatomic) NSMutableArray *albumsInCart;
@property (strong, nonatomic) UIButton *checkoutButton;

@end

@implementation PhotoListViewController

static CGSize AssetGridThumbnailSize;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _mode = PhotoListViewControllerMode_CreateAlbum;
        
        _imageManager = [[PHCachingImageManager alloc] init];

        _cellImageLoadingQueue = dispatch_queue_create("cellImageLoadingQueue", NULL);
        
        _imageCacheingQueue = [[NSOperationQueue alloc] init];
        [self.imageCacheingQueue setMaxConcurrentOperationCount:3];
        
        _albumsInCart = [NSMutableArray array];
    }
    return self;
}

- (void)loadPhotos {
    if (!self.assets) {
        _assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }

    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
    
    [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        [self.assets addObject:asset];
        }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Select Photos";
    
    self.imagePreloadingOperationQueue = [NSOperationQueue mainQueue];
    self.diskIOQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    AssetGridThumbnailSize =  CGSizeMake(120, 120);

    if (self.mode == PhotoListViewControllerMode_CreateAlbum) {
        [[TBSDKAlbumManager sharedInstance] setDelegate:self];
    }
    
    [self loadPhotos];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:@"photoCell"];
    [self.collectionView setAllowsMultipleSelection:YES];
    
    
    NSString *buttonTitle = self.mode == PhotoListViewControllerMode_CreateAlbum ? @"Create" : @"Add";
    
    UIBarButtonItem *sdkLoginButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(handleShowSDKStoreLoginViewControllerButton:)];
    
    UIBarButtonItem *sdkOrderListButton = [[UIBarButtonItem alloc] initWithTitle:@"Orders" style:UIBarButtonItemStylePlain target:self action:@selector(handleShowSDKOrderListViewControllerButton:)];

    UIBarButtonItem *bookListButton = [[UIBarButtonItem alloc] initWithTitle:@"Books" style:UIBarButtonItemStylePlain target:self action:@selector(handleBookListViewControllerButton:)];

    self.createAlbumOrAddPhotoButton = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStylePlain target:self action:@selector(handleCreateAlbumOrAddPhotoButton:)];
    self.navigationItem.rightBarButtonItems = @[
                                                self.createAlbumOrAddPhotoButton,
                                                bookListButton,
//                                                sdkOrderListButton,
//                                                sdkLoginButton,
                                                ];
    
    UIButton *checkoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [checkoutButton setTitle:@"Cart(0)" forState:UIControlStateNormal];
    [checkoutButton addTarget:self action:@selector(handleCheckoutButton:) forControlEvents:UIControlEventTouchUpInside];
    [checkoutButton sizeToFit];
    self.checkoutButton = checkoutButton;
    UIBarButtonItem *checkoutButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkoutButton];
    self.navigationItem.leftBarButtonItem = checkoutButtonItem;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGSize collecionViewSize = self.view.bounds.size;
    CGSize itemSize = flowLayout.itemSize;
    NSInteger maxItemsCount = collecionViewSize.width / itemSize.width;
    CGFloat horizonSpace = floorf((collecionViewSize.width - maxItemsCount * itemSize.width) / (maxItemsCount + 1)) - 1;
    
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, horizonSpace, 5, horizonSpace)];
    [flowLayout setMinimumLineSpacing:horizonSpace];
    
    [flowLayout invalidateLayout];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"photoCell";
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    PHAsset * asset = self.assets[indexPath.row];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  
                                  // Only update the thumbnail if the cell tag hasn't changed. Otherwise, the cell has been re-used.
//                                  if (cell.tag == currentTag) {
                                      cell.imageView.image = result;
//                                  }
                                  
                              }];

    
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self refreshNavButton];
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self refreshNavButton];
}

- (void)refreshNavButton {
    NSArray *selectedIndexes = [self.collectionView indexPathsForSelectedItems];
    
    if (selectedIndexes.count>0) {
        self.title =[NSString stringWithFormat:@"%zd Selected", selectedIndexes.count];
    }
    else {
        self.title =[NSString stringWithFormat:@"Select Photos", selectedIndexes.count];
        [self.createAlbumOrAddPhotoButton setEnabled:NO];
    }
}

#pragma mark - Album
- (void)handleBookListViewControllerButton:(id)sender {
    PhotoBookListViewController *vc = [PhotoBookListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleShowSDKStoreLoginViewControllerButton:(id)sender {
    [[TBSDKAlbumManager sharedInstance] presentStoreLoginViewControllerOnViewController:self completionBlock:nil];
}

- (void)handleShowSDKOrderListViewControllerButton:(id)sender {
    [[TBSDKAlbumManager sharedInstance] presentOrderListViewControllerOnViewController:self];
}

- (void)handleCreateAlbumOrAddPhotoButton:(id)sender {
    [self createProductWithType:TBProductType_Photobook ];
    return;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Create A Product"
                                                                   message:@"Select the product type to build"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* bookAction = [UIAlertAction actionWithTitle:@"Photo Book" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self createProductWithType:TBProductType_Photobook ];
                                                          }];

    UIAlertAction* canvasAction = [UIAlertAction actionWithTitle:@"Canvas" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self createProductWithType:TBProductType_Canvas ];
                                                          }];
    
    [alert addAction:bookAction];
    [alert addAction:canvasAction];
    
    [self presentViewController:alert animated:YES completion:nil];}

- (void)createProductWithType:(TBProductType) productType {
    NSArray *selectedIndexes = [self.collectionView indexPathsForSelectedItems];
    
    if (selectedIndexes.count > 0) {
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
        
        for (NSIndexPath *indexPath in selectedIndexes) {
            [indexSet addIndex:indexPath.row];
        }
        
        NSArray *selectedAssets = [self.assets objectsAtIndexes:indexSet];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Saving assetes to disk
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // Cache image to disk
            NSString *cachePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"ImageCache"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if (![fileManager fileExistsAtPath:cachePath isDirectory:NULL]) {
                [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            NSMutableArray *tbImages = [NSMutableArray arrayWithCapacity:selectedAssets.count];
            
            NSInteger counter = 0;
            
            for (PHAsset *asset in selectedAssets) {
                @autoreleasepool {
                    
                    NSString *name = [[[asset localIdentifier] componentsSeparatedByString:@"/"] firstObject];
                    
                    // Size
                    CGSize boundingSize_s = [TBPSSizeUtil sizeFromPSImageSize:(TBPSImageSize)TBImageSize_s];
                    CGSize boundingSize_l = [TBPSSizeUtil sizeFromPSImageSize:(TBPSImageSize)TBImageSize_l];
                    CGSize convertedSize_s = boundingSize_s;
                    CGSize convertedSize_l = boundingSize_l;
                    if (asset.pixelWidth * asset.pixelHeight > 0) {
                        CGSize photoSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
                        convertedSize_s = [TBPSSizeUtil convertSize:photoSize toSize:boundingSize_s contentMode:UIViewContentModeScaleAspectFill];
                        convertedSize_l = [TBPSSizeUtil convertSize:photoSize toSize:boundingSize_l contentMode:UIViewContentModeScaleAspectFill];
                    }
                    else {
                        NSAssert(NO, @"asset should have a size");
                    }
                    
                    NSString *sPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_s", name]];
                    NSString *lPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_l", name]];
                    
                    NSLog(@"downloading file for:%@", name);
                    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
                    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
                    requestOptions.networkAccessAllowed = YES;
                    requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
                    
                    if (![fileManager fileExistsAtPath:sPath]) {
                        
                        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                   targetSize:convertedSize_s
                                                                  contentMode:PHImageContentModeAspectFill
                                                                      options:requestOptions
                                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                    [result writeToFile:sPath withCompressQuality:1];
                                                                }];
                        
                    }
                    
                    if (![fileManager fileExistsAtPath:lPath]) {
                        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                   targetSize:convertedSize_l
                                                                  contentMode:PHImageContentModeAspectFill
                                                                      options:requestOptions
                                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                    [result writeToFile:lPath withCompressQuality:1];
                                                                }];
                    }
                    
                    TBImage *tbImage = [[TBImage alloc] initWithIdentifier:name];
                    
                    [tbImage setImagePath:sPath size:TBImageSize_s];
                    [tbImage setImagePath:lPath size:TBImageSize_l];
                    [tbImage setDesc:@(counter++).description];
                    [tbImage setImageCSURLString:@"http://awesome.web/where/is/my/photo_full.jpg" size:TBImageSize_xxl];
                    [tbImage setImageCSURLString:@"http://awesome.web/where/is/my/photo_regular.jpg" size:TBImageSize_l];
                    [tbImages addObject:tbImage];
                }//end of autorelease
            }//enf of for loop
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.mode == PhotoListViewControllerMode_CreateAlbum) {
                    //private API demo here for enterprise clients, consulting before use.
                    //note that SKU and Theme must share the common std_ratio_type, otherwise you will get error "No availble product"
                    NSDictionary * albumOptionBase = @{
                                                       kTBProductMaxPageCount:     @"20",   //set max=min will limit the page count
                                                       kTBProductMinPageCount:     @"20",
                                                       kTBPreferredUIDirection:    @"RTL",   //set this RTL or LTR
                                                       @"preferSpread":            @(YES)
                                                       };
                    NSDictionary * albumBookType8x8 =@{
                                                       kTBProductPreferredTheme:   @"200",  //200 is for square book
                                                       kTBProductPreferredSKU:     @"1003", //1003 is a layflat square book
                                                       };
                    NSDictionary * albumBookType11x85 =@{
                                                       kTBProductPreferredTheme:   @"201",  //201 is for 11x8.5 page
                                                       kTBProductPreferredSKU:     @"998",  //998 is corresponding book
                                                       };
                    NSDictionary * albumBookType85x11 =@{
                                                       kTBProductPreferredTheme:   @"202",  //202 is for 8.5x11 page
                                                       kTBProductPreferredSKU:     @"999",  //998 is corresponding book book
                                                       };

                    NSMutableDictionary *  albumOption = [albumOptionBase mutableCopy];
                    [albumOption addEntriesFromDictionary:albumBookType11x85];
                    
                    //the createSDKAlbumWithImages process include facial recognition, which might take sometime..
                    hud.mode = MBProgressHUDModeIndeterminate;
                    hud.labelText = @"recognizing faces...";

                    [[TBSDKAlbumManager sharedInstance] createSDKAlbumWithImages:tbImages identifier:nil title:@"Album" tag:0 options:albumOption completionBlock:^(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error) {

                        [hud hide:YES];

                        [[TBSDKAlbumManager sharedInstance] openSDKAlbum:sdkAlbum presentOnViewController:self.navigationController shouldPrintDirectly:NO];
                        
                    }];
                    
//                self.shouldCreateCanvas = YES
//                    [[TBSDKAlbumManager sharedInstance] createSDKAlbumWithProductType:self.shouldCreateCanvas ? TBProductType_Canvas : TBProductType_Photobook images:tbImages identifier:nil title:@"Album" tag:0 completionBlock:^(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error) {
//                        [[TBSDKAlbumManager sharedInstance] openSDKAlbum:sdkAlbum presentOnViewController:self.navigationController shouldPrintDirectly:NO];
//                    }];
//
//                    self.shouldCreateCanvas = !self.shouldCreateCanvas;

                    
//                    [[TBSDKAlbumManager sharedInstance] sdkAlbumOfID:52 completionBlock:^(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error) {
//                        [[TBSDKAlbumManager sharedInstance] addImages:tbImages toSDKAlbum:sdkAlbum completionBlock:^(BOOL success, NSUInteger photosAdded, NSError *error) {
//                            [[TBSDKAlbumManager sharedInstance] openSDKAlbum:sdkAlbum presentOnViewController:self.navigationController shouldPrintDirectly:NO];
//                        }];
//                    }];
                }
                else if (self.mode == PhotoListViewControllerMode_AddPhoto) {
                    self.tb_completionBlock(tbImages);
                }
            });
        });
    }
}

#pragma mark - TBSDKAlbumManagerDelegate

- (UIViewController *)photoSelectionViewControllerInstanceForAlbumManager:(TBSDKAlbumManager *)albumManager withSDKAlbum:(TBSDKAlbum *)sdkAlbum existingTBImages:(NSArray *)existingTBImages completionBlock:(void (^)(NSArray *newImages))completionBlock {
    PhotoListViewController *vc = [PhotoListViewController new];
    vc.mode = PhotoListViewControllerMode_AddPhoto;
    vc.sdkAlbum = sdkAlbum;
    vc.existingTBImages = existingTBImages;
    vc.tb_completionBlock = completionBlock;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    return nav;
}

- (void)albumManager:(TBSDKAlbumManager *)albumManager preloadXXLSizeImages:(NSArray *)tbImages ofSDKAlbum:(TBSDKAlbum *)sdkAlbum progressBlock:(void (^)(NSInteger, NSInteger, float))progressBlock completionBlock:(void (^)(NSInteger, NSInteger, NSError *))completionBlock {
    
    [self preloadImageWithEnumerator:[tbImages objectEnumerator] currentIdx:0 total:tbImages.count progressBlock:progressBlock completionBlock:completionBlock];
}

- (void)albumManager:(TBSDKAlbumManager *)albumManager cancelPreloadingXXLSizeImages:(NSArray *)tbImages ofSDKAlbum:(TBSDKAlbum *)sdkAlbum {
    
}

#pragma mark - 

- (void)preloadImageWithEnumerator:(NSEnumerator *)enumerator currentIdx:(NSInteger)currentIdx total:(NSInteger)total progressBlock:(void (^)(NSInteger, NSInteger, float))progressBlock completionBlock:(void (^)(NSInteger, NSInteger, NSError *))completionBlock {
    TBImage *tbImage = [enumerator nextObject];
    
    if (tbImage) {
        NSURL *assetsURL = [NSURL URLWithString:tbImage.identifier];
        dispatch_queue_t diskIOQueue = self.diskIOQueue;
        
        
        @weakify(self);
        [self.assetsLibrary assetForURL:assetsURL resultBlock:^(ALAsset *asset) {
            dispatch_async(diskIOQueue, ^{
                @autoreleasepool {
                    ALAssetRepresentation *rep = [asset defaultRepresentation];
                    NSString *name = [rep photoId];
                    
                    CGImageRef imgRef = [rep fullResolutionImage];
                    
                    NSString *cachePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"ImageCache"];
                    NSString *xxlPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_xxl", name]];
                    
                    UIImage *image = [UIImage imageWithCGImage:imgRef scale:1 orientation:(UIImageOrientation)rep.orientation];
                    [image writeToFile:xxlPath withCompressQuality:1];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        @strongify(self);
                        [tbImage setImagePath:xxlPath size:TBImageSize_xxl];
                        
                        progressBlock(currentIdx, total, 1);
                        
                        [self preloadImageWithEnumerator:enumerator currentIdx:currentIdx + 1 total:total progressBlock:progressBlock completionBlock:completionBlock];
                    });
                }
            });
        } failureBlock:^(NSError *error) {
            completionBlock(currentIdx, total, error);
        }];
    }
    else {
        completionBlock(currentIdx, total, nil);
    }
}

#pragma mark - Checkout 3


//a callback after user click order for an album if the album is new,  the infoDict here only contains the cover page JSON
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkout3_addSDKAlbumToCart:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:viewController {
    [self.albumsInCart addObject:@(sdkAlbum.ID)];
    
    [self.checkoutButton setTitle:[NSString stringWithFormat:@"Checkout(%zd)", self.albumsInCart.count] forState:UIControlStateNormal];
    
    [[TBSDKAlbumManager sharedInstance] dismissTBSDKViewControllersAnimated:YES completion:nil];
}

//a callback after user click order for an album if the album is already in the cart, just need to update it, the infoDict here only contains the cover page JSON
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
