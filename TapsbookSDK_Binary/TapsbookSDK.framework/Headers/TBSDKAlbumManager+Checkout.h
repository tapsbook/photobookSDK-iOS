//
//  TBSDKAlbumManager+Checkout.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 3/18/15.
//  Copyright (c) 2015 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@interface TBSDKAlbumManager (Checkout)

/** Get the count of items in Cart
 *
 */

- (NSInteger)numberOfCartItems;

/** Show Cart View
 *  Let use see cart items and checkout directly without go through page editing, print preview, etc.
 *  @param viewController  Cart ViewController will be presented on this
 */

- (void)showCartOnViewController:(UIViewController *)viewController;

/** In your appDelegate's `- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation` method,
 *  call [[TBSDKAlbumManager sharedInstance] processOrderWithPaymentResult:url]; to get wether SDK can process the URL
 */
- (BOOL)processOrderWithPaymentResult:(NSURL *)resultUrl;


/**
 *
 */

- (void)completeCheckoutWithSuccess:(BOOL)success;

//
- (void)fetchRecommandedPromotionWithCompletionBlock:(void (^)(BOOL sucess, NSDictionary *promotion, NSError *error))completionBlock;

- (void)fetchProductListWithCompletionBlock:(void (^)(BOOL success, NSArray *products, NSError *error))completionBlock;

///---------------------------------------
/// Checkout flow, type 3
///---------------------------------------
- (void)checkout3_checkoutAlbumsWithIDs:(NSArray *)albumIDs completionBlock:(void (^)(BOOL success, id result, NSError *error))completionBlock;

@end

@protocol TBSDKAlbumManagerDelegate_Checkout <TBSDKAlbumManagerDelegate>

///---------------------------------------
/// @name User just finished ordering a book
///---------------------------------------

/**
 * Callback when user order a sdkAlbum successfully
 */

- (void)albumManager:(TBSDKAlbumManager *)albumManager didCompleteOrderWithOrderInfo:(NSDictionary *)orderInfo;

@end

@protocol TBSDKAlbumManagerDelegate_Checkout_Enterprise <TBSDKAlbumManagerDelegate_Checkout>

///---------------------------------------
/// @name Use your own custom checkout workflow
///---------------------------------------

/**
 * Callback when it is ready to present your own checkout and eCommerce views
 * Do NOT use this unless you are an enterprise SDK customer
 * @param checkoutInfo returns you the required data for you to submit your order
 */
- (void)albumManager:(TBSDKAlbumManager *)albumManager
 didCheckoutSDKAlbum:(TBSDKAlbum *)sdkAlbum
    withCheckoutInfo:(NSDictionary *)checkoutInfo;

/**
 * Callback when you want to present your own checkout and eCommerce views
 * Do NOT use this unless you are an enterprise SDK customer
 */
- (void)albumManager:(TBSDKAlbumManager *)albumManager
loadPrintInfosForSDKAlbum:(TBSDKAlbum *)sdkAlbum
        standardSize:(CGSize)size completionBlock:(void (^)(NSArray *printInfos))completionBlock;


///---------------------------------------
/// @name Use your own custom print and checkout workflow
///---------------------------------------

/**
 * Callback when user click print button. Implement this method if you want to use your own print and checkout workflow
 *
 * Before use this option, you must set YES to TBSDKConfigurator kTBSendAlbumJSONDictToHostingApp in your app's configuration.
 *
 * By design, the SDK will render the page into print-ready images, the rendering
 * will be bypassed if you implement this method.  You will need to have a backend processing
 * server that loads the book page data, then use the downloaded full resolution images to create
 * the print ready image output.
 *
 * Here you should initiate and present your own checkout view. At this point, the book page
 * data has been uploaded to the Tapsbook cloud, and infoDict includes an "album_key" 
 * to retrieve the book page data with the order API. You must save this "album_key"
 * to your order checkout workflow, otherwise you won't be able to get the page data later when you print.
 *
 *
 */

- (void)albumManager:(TBSDKAlbumManager *)albumManager printAndCheckoutSDKAlbum:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:(UIViewController *)viewController;
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkoutSDKAlbum:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:(UIViewController *)viewController;


///---------------------------------------
/// Checkout flow, type 3
///---------------------------------------
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkout3_addSDKAlbumToCart:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:viewController;
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkout3_updateSDKAlbumInCart:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:viewController;
//- (void)albumManager:(TBSDKAlbumManager *)albumManager checkout3_deleteSDKAlbumInCart:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict  viewControllerToPresentOn:viewController;
- (BOOL)albumManager:(TBSDKAlbumManager *)albumManager checkout3_isSDKAlbumInCart:(TBSDKAlbum *)sdkAlbum;

@end