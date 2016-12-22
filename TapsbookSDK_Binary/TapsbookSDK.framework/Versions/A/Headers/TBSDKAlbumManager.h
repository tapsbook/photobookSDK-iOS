//
//  TBSDKAlbumManager.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 14-3-26.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TapsbookSDK/TBSDKAlbum.h>
#import <UIKit/UIKit.h>

@protocol TBImageDataSource;
@protocol TBSDKAlbumManagerDelegate;

/**The shared TBSDKAlbumManager object provides methods for creating a new photo gifting order, retrieving a list of all photo books for viewing and editing, or presenting the checkout views and submitting orders for manufacturing.

 **To create a new order**

 1. Create and prepare an array of TBImage objects, each object representing a photo to be inserted into the book. The order of the photo in the array will be used to present the photos in the pages. See TBImages for details of preparation steps including importing images before page rendering.

 2. Use createSDKAlbumWithImages:identifier:title:tag:completionBlock: method to create the book

 3. Call openSDKAlbum:presentOnViewController:shouldPrintDirectly: to open the book for viewing and editing

 **To check out an order using SDK workflow**
 
 The Tapsbook SDK provides very flexible checkout integration options. There are three options for you to add the checkout UX to your app:
 
 1. Using SDK built-in checkout views and the Tapsbook eCommerce
 
 1. Using your checkout views and the Tapsbook eCommerce
 
 1. Using your checkout views and your eCommerce
 
The detail discussion of each option can be found here: Checkout guide [English](https://github.com/tapsbook/photobookSDK-iOS/blob/master/Doc/developer-guide-checkout.md) and [Chinese](https://github.com/tapsbook/photobookSDK-iOS/blob/master/Doc/developer-guide-checkout-cn.md)
 
 **The order manufacturing process**
 
 Once your app user checks out and submits an order, tapsBook platform backend will manage an automated manufacturing workflow
 
 1. The tapsBook platform notifies the user confirming the order has been received.
 
 2. The manufacturer prints the photo book and ships it to your app user via a pre-selected shipping provider
 
 3. The tapsBook platform notifies the user with the shipping information and tracking #
 
 **To retrieve a list of existing books**
 
 You can optionally render a list view showing all the books users have created. From here user can continue to edit a previously created book, or reorder a book.
 
 Use allSDKAlbumsWithCompletionBlock: method to retrieve an array of TBSDKAlbum objects, alternatively, if you created these Albums with tags, you can use allSDKAlbumsOfTag:completionBlock: to only retrieve a subset of TBSDKAlbum that matching the tag.
 
 **To view a list of submitted orders**
 
 The SDK provides ready-to use UI showing all the books orders users have submitted. From here user can view the order status.
 
 Notice SDK backend tracks users order via TBSDKUser. To allow SDK tracks your user oders including view order status later, you must first sign in your current app user to SDK by calling signinSDKUser:fromApp:completionBlock:. After this, you can use orderListViewController to list the order  made by the signed in app user.
 
 **The Tapsbook data model explained **
 
 Behind the scene, TBSDKAlbumManager intelligently creates a photo book by populating book pages to fit the selected images meeting the photo book manufacturing specification. The SDK will create a TBSDKAlbum object and apply a page layout template to place these TBImage on the page. The SDK embeds its own template data store containing hundreds of beautiful hand-crafted page layouts templates. Enterprise account developer has the option to customize these templates or add their own templates.
 
 A TBSDKAlbumManager object can have a object adopting TBSDKAlbumManagerDelegate protocal. The delegate receive messages from a TBSDKAlbumManager, and their responses to these messages enable them to affect the operation of an album creation or to trigger certain actions to be performed in your app, such as refreshing an album list view after user has completed editing a photo book.
 
 TBSDKAlbumManager stores the  TBSDKAlbum object and its page meta data in a local data store. To reduce SDK local disk usage, it always renders the images when needed and delete them after the order has been submitted. It is recommended you clean the imported images in your app to reduce the disk usage.  When the TBSDKAlbumManager opens the book for viewing and editing, it uses lazy load and caching for the images to minimize the memory footprint while ensure an optimal user experience.
 
 */


@interface TBSDKAlbumManager : NSObject

/** Delegate of TBSDKAlbumManager. Use TBSDKAlbumManagerDelegate to get the callback 
 * when user has triggered certain events. For example, you need to handle the callback
 * of importing full size photos when user wants to order a photo book.
 *
 */

@property (weak, nonatomic) id<TBSDKAlbumManagerDelegate> delegate;


///---------------------------------------
/// @name Getting the shared album manager object.
///---------------------------------------

/** Getting the shared album manager object.
 */
+ (instancetype)sharedInstance;

///---------------------------------------
/// @name Presenting the book editor
///---------------------------------------

/** Async retrieve all image metedata (TBImage) of a album from the datastore. By default, allSDKAlbumsWithCompletionBlock: will return TBSDKAlbum with empty images property, you must use this method to populate the image metadata prior to the call of OpenSDKAlbum
 *  @param sdkAlbum
 *  @param completionBlock Get called after finish
 */

- (void)loadImagesOfSDKAlbum:(TBSDKAlbum *)sdkAlbum completionBlock:(void (^)(BOOL success, NSError *error))completionBlock;

/** Present the album pages in a User Interface and let the user edit album pages, print the album.
 *  @param sdkAlbum. The TBSDKAlbum object must be created via the Creation method first.
 *  @param presentOnViewController viewControllers of TapsbookSDK will be presented on this viewController
 *  @param shouldPrintDirectly  NO: Go to page edit; YES: Go to checkout page directly (only useful if you use SDK checkout views)
 */

- (BOOL)openSDKAlbum:(TBSDKAlbum *)sdkAlbum presentOnViewController:(UIViewController *)viewController shouldPrintDirectly:(BOOL)shouldPrintDirectly;

/** Go to the viewController that edit page.
 */

- (void)popToPageViewControllerAnimated:(BOOL)animated;

/** Dissmiss TapsbookSDKViews, this will also save the album data
 *  Do not directly use `dismissViewControllerAnimated:completion:` on your viewController, otherwise the album data may not be saved properly
 */

- (void)dismissTBSDKViewControllersAnimated:(BOOL)animated completion:(void (^)(void))completion;

@property (weak, nonatomic) id<TBImageDataSource> imageDataSource;

/** NO(default, recommanded): Image is stored as a file on disk, and your app gives the path to that file,
 *  TapsbookSDK will load the image from the path.
 *
 *  YES: Image not strored as a file on disk,
 *  TapsbookSDK will tell dataSource load the image.
 *
 *  @see TBImage
 *
 *  All TBImage's `isImageLoadingHandledByDataSource` will be assigned `isImageLoadingHandledByImageDataSource`
 */

@property (assign, nonatomic) BOOL isImageLoadingHandledByImageDataSource DEPRECATED_ATTRIBUTE;

///---------------------------------------
/// @name Utility method
///---------------------------------------

/**
 * SDK uses a local cache to store the rendered page images.  Use this method to get the disk space used by the Cache
 */
- (NSUInteger)getCacheSize;

/**
 *  clear cache on disk if you want to save the space.
 */

- (void)clearCache;

/**
 * Generate a zip file contains all logs to the Tapsbook SDK developers
 */

- (void)generateReportZipWithPrefix:(NSString*) prefix completeBlock:(void (^)(id result))completeBlock errorBlock:(void (^)(NSError *error))errorBlock;

/** TapsbookSDK calls dataSource to get images
 *
 *  All TBImage's `dataSource` will be assigned `imageDataSource`
 *
 *  @see TBImage
 */



@end

/**TBSDKAlbumManagerDelegate provides callbacks that are triggered at times when certain user action may require the hosting app to perform certain actions or update the hosting app UI. 
 
 There are three key events at which point SDK needs the hosting app intervention.
 
 1. when user wants to add photos to an existing product,
 2. when user finish editing the product and need the full resolution images to build the final print output
 3. when user finish editing and click the save button, or if user finish the final checkout flow and is ready to return to the hosting app. [only useful when the SDK checkout flow is used]
 */
@protocol TBSDKAlbumManagerDelegate <NSObject>

@optional

///---------------------------------------
/// @name Need a photo picker to add more photos
///---------------------------------------

- (UIViewController *) photoSelectionViewControllerInstanceForAlbumManager:(TBSDKAlbumManager *)albumManager
                                                              withSDKAlbum:(TBSDKAlbum *)sdkAlbum
                                                          existingTBImages:(NSArray *)existingTBImages
                                                           completionBlock:(void (^)(NSArray *newImages))completionBlock;

/**
 * The delegate method to show your photo picker UI. This method is triggered when
 * user request to add more photos from editor UI.
 * You must implement this method if you want to allow your app user to add photos
 * while they are still inside the book pages.
 * @param sdkAlbum A reference to the current album user is editing
 * @param existingTBImages An array reference to the selected photos prior to the current session
 * @param maxPhotoCount The max photos user can select for the current book, including the previously selected ones
 * @param allowMultiple Whether user wants to select a single photo or multiple photos.
 * @param completionBlock What to do next after user finished selecting photos
 */
- (UIViewController *)photoSelectionViewControllerInstanceForAlbumManager:(TBSDKAlbumManager *)albumManager
                                                             withSDKAlbum:(TBSDKAlbum *)sdkAlbum
                                                         existingTBImages:(NSArray *)existingTBImages
                                                            maxPhotoCount:(NSInteger) maxPhotoCount
                                                            allowMultiple:(BOOL)allowMultiple
                                                          completionBlock:(void (^)(NSArray *newImages))completionBlock;

///---------------------------------------
/// @name Need full size images for print
///---------------------------------------

/**
 * Callback when the full size images is needed to render the print output
 * You must implement this method to retrieve the full size image and 
 * udpate the image's property when done. Fail to do so will cause your 
 * app unable to render the high res page output and your customer will not
 * be able to checkout the album
 */
- (void)albumManager:(TBSDKAlbumManager *)albumManager
preloadXXLSizeImages:(NSArray *)tbImages
          ofSDKAlbum:(TBSDKAlbum *)sdkAlbum
       progressBlock:(void (^)(NSInteger currentIdx, NSInteger total, float currentProgress))progressBlock
     completionBlock:(void (^)(NSInteger successCount, NSInteger total, NSError *error))completionBlock;

/**
 Callback when the full size images is no longer needed.
 */
- (void)albumManager:(TBSDKAlbumManager *)albumManager
cancelPreloadingXXLSizeImages:(NSArray *)tbImages
          ofSDKAlbum:(TBSDKAlbum *)sdkAlbum;

///---------------------------------------
/// @name User just finished editing a book
///---------------------------------------

/**
 * Callback when user finish editing a sdkAlbum, and press the back button to leave SDK's view and get back to your views.
 * In case you have your a collection view of Book list, this method is a great place for you to refresh the tableView/collectionView cell because some properties of the sdkAlbum might have changed after user's editing.
 */
- (void)albumManager:(TBSDKAlbumManager *)albumManager didFinishEditingSDKAlbum:(TBSDKAlbum *)sdkAlbum;

@end
