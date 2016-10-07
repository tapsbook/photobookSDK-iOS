//
//  PhotoBookListViewController.m
//  Swip
//
//  Created by z on 16-09-06.
//  Copyright (c) 2016 Ziqi Wu. All rights reserved.
//

#import "PhotoBookListViewController.h"
#import "PhotoBookListCell.h"
#import "PhotoListViewController.h"
#import "TBPSSizeUtil.h"
#import "MBProgressHUD.h"

#import "UIImage+Save.h"
#import <TapsbookSDK/TapsbookSDK.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


@interface PhotoBookListViewController()<UITableViewDataSource, UITableViewDelegate,
TBSDKAlbumManagerDelegate, PhotoBookListCellDelegate>
@property (nonatomic, strong) NSMutableArray *albums;
@property (weak, nonatomic) IBOutlet UILabel *noBookLabel;

@property (strong, nonatomic) dispatch_queue_t cellImageLoadingQueue;

@property (strong, nonatomic) NSOperationQueue *imageCacheingQueue;

@property (strong, nonatomic) NSOperationQueue *imagePreloadingOperationQueue;

@property (strong, nonatomic) dispatch_queue_t diskIOQueue;

@property (strong, nonatomic) PHCachingImageManager * imageManager;

@end

@implementation PhotoBookListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imagePreloadingOperationQueue = [NSOperationQueue mainQueue];
    self.diskIOQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    self.title = NSLocalizedString(@"My Books", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:18]}];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
        
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"nav-back"]
                                             style:UIBarButtonItemStylePlain
                                             target:self action:@selector(goBack)];
    
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadPhotoBooks];
}

#pragma mark - PhotoListCellDelegate

- (void)didClickBuyAlbum:(TBSDKAlbum *)album {
    [[TBSDKAlbumManager sharedInstance] loadImagesOfSDKAlbum:album completionBlock:^(BOOL success, NSError *error) {
        
        if (success) {
            [self loadImagesAndOpenAlbum:album printDirectly:YES];
        }
        else {
            //handle error
        }
    }];
}

- (void)didClickAlbum:(TBSDKAlbum *)album {
    [[TBSDKAlbumManager sharedInstance] loadImagesOfSDKAlbum:album completionBlock:^(BOOL success, NSError *error) {
        
        if (success) {
            [self loadImagesAndOpenAlbum:album printDirectly:NO];
        }
        else {
            //handle error
        }
    }];
}

- (void)didClickDeleteAlbum:(TBSDKAlbum *)album {
    [self deleteSDKAlbum:album];
}


#pragma mark - Override
- (NSMutableArray *)albums
{
    if (!_albums) {
        _albums = [[NSMutableArray alloc] init];
    }
    return _albums;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.albums.count > 0) {
        self.noBookLabel.hidden = YES;
    }
    
    return [self.albums count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 358;
}

#pragma mark - Private
- (void)reloadPhotoBooks
{
    [self.albums removeAllObjects];
    TBSDKAlbumManager *manager = [TBSDKAlbumManager sharedInstance];
    manager.delegate = self;
    [manager allSDKAlbumsWithCompletionBlock:^(BOOL success, NSArray *sdkAlbums, NSError *error) {
        if (success) {
            [self.albums removeAllObjects];
            NSEnumerator * enu = [sdkAlbums reverseObjectEnumerator];
            TBSDKAlbum *a;
            while ((a = [enu nextObject])) {
                if (a.numberOfPages > 0) {
                    [self.albums addObject:a];
                }
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)deleteSDKAlbum:(TBSDKAlbum *)album {
    [[TBSDKAlbumManager sharedInstance] removeSDKAlbum:album];
    
    NSInteger index = [self.albums indexOfObject:album];
    NSIndexPath *removedBook = [NSIndexPath indexPathForRow:index inSection:0];
    [self.albums removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[removedBook] withRowAnimation:UITableViewRowAnimationFade];
    
    if (self.albums.count == 0) {
        self.noBookLabel.hidden = NO;
    }
}

//reload images if needed because user may clean cache
- (void)loadImagesAndOpenAlbum:(TBSDKAlbum*)album printDirectly:(BOOL)shouldPrintDirectly {
    NSArray *tbImages = album.images;
    
    //convert tbImages to PHAssets
    NSMutableArray *selectedAssets = [NSMutableArray new];
    if (tbImages.count==0) {
        return;
    } else {
        for (TBImage * tbImage in tbImages) {
            PHAsset *asset;
            NSString *identifier = tbImage.identifier;

            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
            asset = result.firstObject;
            
            [selectedAssets addObject:asset];
        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading images";
    hud.dimBackground = YES;
    
    // Saving assetes to disk
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Cache image to disk
        NSString *cachePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"ImageCache"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:cachePath isDirectory:NULL]) {
            [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
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
                
            }//end of autorelease
        }//enf of for loop
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            //private API demo here for enterprise clients, consulting before use.
            NSDictionary * albumOption = @{
                                           kTBProductPreferredTheme:   @"200",  //200 is for square book
                                           kTBProductPreferredSKU:     @"1003", //sku=1003 is a layflat book
                                           kTBProductMaxPageCount:     @"24",   //set max=min will limit the page count
                                           kTBProductMinPageCount:     @"24",
                                           kTBPreferredUIDirection:    @"LTR"
                                           };
            album.productOptions = albumOption;
            [[TBSDKAlbumManager sharedInstance] openSDKAlbum:album presentOnViewController:self.navigationController shouldPrintDirectly:NO];
        });
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    PhotoBookListCell *cell = (PhotoBookListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [PhotoBookListCell createPhotoBookListCell];
    }
    cell.delegate = self;
    
    [cell configureCellWithAlbum:self.albums[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - TBSDK

//handle the + (add photo) function of the SDK
- (UIViewController *)photoSelectionViewControllerInstanceForAlbumManager:(TBSDKAlbumManager *)albumManager withSDKAlbum:(TBSDKAlbum *)sdkAlbum existingTBImages:(NSArray *)existingTBImages maxPhotoCount:(NSInteger)maxPhotoCount completionBlock:(void (^)(NSArray *))completionBlock
{
    PhotoListViewController *vc = [PhotoListViewController new];
    vc.mode = PhotoListViewControllerMode_AddPhoto;
    vc.sdkAlbum = sdkAlbum;
    vc.existingTBImages = existingTBImages;
    vc.tb_completionBlock = completionBlock;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    return nav;
}

- (void)albumManager:(TBSDKAlbumManager *)albumManager preloadXXLSizeImages:(NSArray *)tbImages ofSDKAlbum:(TBSDKAlbum *)sdkAlbum progressBlock:(void (^)(NSInteger, NSInteger, float))progressBlock completionBlock:(void (^)(NSInteger, NSInteger, NSError *))completionBlock
{    
    [self preloadImageWithEnumerator:[tbImages objectEnumerator] currentIdx:0 total:tbImages.count progressBlock:progressBlock completionBlock:completionBlock];
}

- (void)albumManager:(TBSDKAlbumManager *)albumManager didFinishEditingSDKAlbum:(TBSDKAlbum *)sdkAlbum{
    //do some album clean up, e.g. clean up image cache if needed
    NSLog(@"Book data has been saved to the DB, now it is safe to do more with the album object");
}

#pragma mark -

- (void)preloadImageWithEnumerator:(NSEnumerator *)enumerator currentIdx:(NSInteger)currentIdx total:(NSInteger)total progressBlock:(void (^)(NSInteger, NSInteger, float))progressBlock completionBlock:(void (^)(NSInteger, NSInteger, NSError *))completionBlock {
    TBImage *tbImage = [enumerator nextObject];
    
    if (tbImage) {
        NSURL *assetsURL = [NSURL URLWithString:tbImage.identifier];
        dispatch_queue_t diskIOQueue = self.diskIOQueue;
        
        
//        @weakify(self);
//        [self.assetsLibrary assetForURL:assetsURL resultBlock:^(ALAsset *asset) {
//            dispatch_async(diskIOQueue, ^{
//                @autoreleasepool {
//                    ALAssetRepresentation *rep = [asset defaultRepresentation];
//                    NSString *name = [rep photoId];
//                    
//                    CGImageRef imgRef = [rep fullResolutionImage];
//                    
//                    NSString *cachePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"ImageCache"];
//                    NSString *xxlPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_xxl", name]];
//                    
//                    UIImage *image = [UIImage imageWithCGImage:imgRef scale:1 orientation:(UIImageOrientation)rep.orientation];
//                    [image writeToFile:xxlPath withCompressQuality:1];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        @strongify(self);
//                        [tbImage setImagePath:xxlPath size:TBImageSize_xxl];
//                        
//                        progressBlock(currentIdx, total, 1);
//                        
//                        [self preloadImageWithEnumerator:enumerator currentIdx:currentIdx + 1 total:total progressBlock:progressBlock completionBlock:completionBlock];
//                    });
//                }
//            });
//        } failureBlock:^(NSError *error) {
//            completionBlock(currentIdx, total, error);
//        }];
    }
    else {
        completionBlock(currentIdx, total, nil);
    }
}

//datasource method that helps SDK to recognize an album is new or existing
- (BOOL)albumManager:(TBSDKAlbumManager *)albumManager checkout3_isSDKAlbumInCart:(TBSDKAlbum *)sdkAlbum {
    return NO;
}

//a callback after user click order for an album if the album is new,  the infoDict here only contains the cover page JSON
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkout3_addSDKAlbumToCart:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:viewController {
    [[TBSDKAlbumManager sharedInstance] dismissTBSDKViewControllersAnimated:YES completion:nil];
}

//a callback after user click order for an album if the album is already in the cart, just need to update it, the infoDict here only contains the cover page JSON
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkout3_updateSDKAlbumInCart:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:viewController {
    [[TBSDKAlbumManager sharedInstance] dismissTBSDKViewControllersAnimated:YES completion:nil];
}


@end
