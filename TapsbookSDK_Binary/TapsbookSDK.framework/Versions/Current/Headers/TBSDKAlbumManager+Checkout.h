//
//  TBSDKAlbumManager+Checkout.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 3/18/15.
//  Copyright (c) 2015 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@interface TBSDKAlbumManager (Checkout)

//Get the count of items in Cart
- (NSInteger)numberOfCartItems;

//Show Cart View
//Let use see cart items and checkout directly without go through page editing, print preview, etc.
//@param viewController  Cart ViewController will be presented on this
- (void)showCartOnViewController:(UIViewController *)viewController;

//In your appDelegate's `- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation` method,
//call [[TBSDKAlbumManager sharedInstance] processOrderWithPaymentResult:url]; to get wether SDK can process the URL
- (BOOL)processOrderWithPaymentResult:(NSURL *)resultUrl;

- (void)completeCheckoutWithSuccess:(BOOL)success;

- (void)fetchRecommandedPromotionWithCompletionBlock:(void (^)(BOOL sucess, NSDictionary *promotion, NSError *error))completionBlock;

- (void)fetchProductListWithCompletionBlock:(void (^)(BOOL success, NSArray *products, NSError *error))completionBlock;

/** Checkout all items in the cart
 
 You should call this method when user is ready to checkout all items in the cart. The SDK will render the JSON and thumbnail for all book pages of each book item in the cart. Prior to this call, you must implement the protocal method defined in TBSDKAlbumManagerDelegate_Checkout_Enterprise that tracks items in the cart. A book item is typically added to the cart when user click the order button of the SDK editor screen.
 
 Notice this method will take a few seconds to complete because each page rendering takes time, and the time increases as the number of book pages increase. This method also invokes a non-blocking call-home method that connects to Tapsbook server for usage analytics reporting. This reporting is essential for the normal order workflow.
 
@param albumsIDs  Cart items that need to be checked out
@param completionBlock An async block that returns the a dictonary containing the data for you to manufacture the product. The dictionary includes a string in "album_JSON" and an array of page image thumbnails in "album_page_thumbnails".
 
 */
- (void)checkout3_checkoutAlbumsWithIDs:(NSArray *)albumIDs
                        completionBlock:(void (^)(BOOL success, id result, NSError *error))completionBlock;


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
/// @name Checkout with your own Shopping Cart
///---------------------------------------

/**
 * Callback when it is ready to present your own checkout and eCommerce views
 * @param orderNumber returns you the orderNumber where you need to refer to when you are ready to confirm the order
 */
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkoutSDKAlbum:(TBSDKAlbum *)sdkAlbum withOrderNumber:(NSString *)orderNumber viewControllerToPresentOn:(UIViewController *)viewController;

//deprecated
- (void)albumManager:(TBSDKAlbumManager *)albumManager
 didCheckoutSDKAlbum:(TBSDKAlbum *)sdkAlbum
    withCheckoutInfo:(NSDictionary *)checkoutInfo;

//deprecated
- (void)albumManager:(TBSDKAlbumManager *)albumManager
loadPrintInfosForSDKAlbum:(TBSDKAlbum *)sdkAlbum
        standardSize:(CGSize)size completionBlock:(void (^)(NSArray *printInfos))completionBlock;


///---------------------------------------
/// @name Checkout with your own Shopping Cart and Print Workflow, Simple Option
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
///  @name Checkout with your own Shopping Cart and Print Workflow, Advanced Option
///  
///---------------------------------------
/** A data source method that SDK needs your app to tell whether a given TBSDKAlbum is a new item or an existing item, which will trigger different callbacks below.
 *  @param albumManager a instance of the album manager
 *  @param sdkAlbum an album that SDK need you to decide it is new or existing
 */
- (BOOL)albumManager:(TBSDKAlbumManager *)albumManager checkout3_isSDKAlbumInCart:(TBSDKAlbum *)sdkAlbum;

/** A callback after user clicked the "order" button for a new book on the SDK book editor screen.
 *  At this point, user adds a TBSDKAlbum to the shopping cart so you can safely update your book list view
 *  @param albumManager a instance of the album manager
 *  @param infoDict the JSON object of **the cover page only**, the full page JSON is only avaiable after you called checkout3_checkoutAlbumsWithIDs:completionBlock:
 *  @param completionBlock An async callback the includes the JSON for each book pages.
 */
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkout3_addSDKAlbumToCart:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:viewController;

/** A callback after user clicked the "order" button for an existing book on the SDK book Editor screen.
 *  At this point, user has completed an update to a TBSDKAlbum that you can safely update the book list view.
 *  @param albumManager a instance of the album manager
 *  @param infoDict the JSON object of **the cover page only**, the full page JSON is only avaiable after you called checkout3_checkoutAlbumsWithIDs:completionBlock:
 *  @param completionBlock An async callback the includes the JSON for each book pages.
 */
- (void)albumManager:(TBSDKAlbumManager *)albumManager checkout3_updateSDKAlbumInCart:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:viewController;


//- (void)albumManager:(TBSDKAlbumManager *)albumManager checkout3_deleteSDKAlbumInCart:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict  viewControllerToPresentOn:viewController;

@end
