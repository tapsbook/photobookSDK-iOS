//
//  TBSDKAlbumManager.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 14-3-26.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TapsbookSDK/TBSDKAlbum.h>

@protocol TBImageDataSource;
@protocol TBSDKAlbumManagerDelegate;

/**The shared TBSDKAlbumManager object provides methods for creating a new photo book, retrieving a list of all photo books for viewing and editing, or presenting the checkout views and submitting orders for manufacturing.

 **To create a new book**

 1. Call the sharedInstance method to retrieve the shared album manager object.

 2. Create and prepare an array of TBImage objects, each object representing a photo to be inserted into the book. The order of the photo in the array will be used to present the photos in the pages. See TBImages for details of preparation steps including importing images before page rendering.

 3. Use createSDKAlbumWithImages:identifier:title:tag:completionBlock: method to create the book


 Once the book is created, the TBSDKAlbumManager offers tools for customers to edit and order the book.

 1. Call openSDKAlbum:presentOnViewController:shouldPrintDirectly: to open the book for viewing and editing

 TBSDKAlbumManager intelligently creates a photo book by populating book pages to fit the selected images meeting the photo book manufacturing specification. The SDK will create a TBSDKAlbum object and decide number of TBImage to put on each page, then apply a randomized page layout template to place these TBImage on the page. The SDK embeds its own template data store containing hundreds of beautiful hand-crafted page layouts templates. Enterprise account developer has the option to customize these templates or add their own templates. You can use TBSDKConfiguratorProtocol to control the minimum and maximum photos per page. Most manufacturers require at least 20 pages in order to achieve a quality book binding, therefore it is required to have at least 20 images per book.
 
 TBSDKAlbumManager also creates book front and back cover using a set of TBImages following the photo book manufacturing spec. User can customize the cover images and layout using the page cover editor, and they can optionally add book title to the book. Most  photo book manufactures don't allow printing on the inside cover of a photo book except the premium layflat photo book. You will see the inside cover is left blank and not editable for the regular photo books.
 
 A TBSDKAlbumManager object can have a object adopting TBSDKAlbumManagerDelegate protocal. The delegate receive messages from a TBSDKAlbumManager, and their responses to these messages enable them to affect the operation of an album creation or to trigger certain actions to be performed in your app, such as refreshing an album list view after user has completed editing a photo book.
 
 TBSDKAlbumManager stores the  TBSDKAlbum object and its page meta data in a local data store. To reduce SDK local disk usage, it always renders the images when needed and delete them after the order has been submitted. It is recommended you clean the imported images in your app to reduce the disk usage.  When the TBSDKAlbumManager opens the book for viewing and editing, it uses lazy load and caching for the images to minimize the memory footprint while ensure an optimal user experience.
 
 **To check out a book using SDK workflow**
 
 There are two options for the checkout: using the Tapsbook eCommerce w/ Tapsbook checkout views or use your eCommerce platform w/ your own checkout views. 
 
 The diagram below shows the steps the SDK perform for the usual checkout after the product is created and ready for checkout.
 
 ![image](https://cloud.githubusercontent.com/assets/842068/12008562/dbd3d6de-ac11-11e5-8da3-4079a4b7d4e0.png)
 
 Specifically, TBSDKAlbumManager performs the following steps
 
  1. Load the full size TBImage and renders the high resolution book pages for print
 
  2. Upload the rendered high resolution images to AWS S3 Cloud Storage
 
  3. Present the built-in iOS native shopping cart view and checkout views to collect payment info. The product info and the payment info is then sent to Tapsbook server.
 
  At the backend, the Tapsbook server uses the 3rd party payment handler (Stripe or Paypal) to charge the customer and credit the proceeds to your account. Once completed, the tapsbook server will send the order to its manufacturing partner for production.
 
 The SDK renders the print ready high resolution page images according to the manufacturer printing standard (bleeding margins, spine width etc). During the rendering phase of each page, it loads the full size version of each image using an auto-released pool.  TBSDKAlbumManager will trigger its delegate method [TBSDKAlbumManagerDelegate albumManager:preloadXXLSizeImages:ofSDKAlbum: progressBlock:completionBlock] to ask your app to provide the full size images if they were not imported during the preparation phase.
 
 The rendered images will be uploaded to Cloud Storage and run MD5 check to ensure its integrity. You will need to provide your own AWS S3 storage account for storing the rendered book page images. These images will be retrieved by the photo book manufacturer at the manufacturing time.
 
 The Checkout workflow currently supports Stripe APIs for worldwide customer payment and Alipay APIs for China customer payment. The TBSDKAlbumManager does not store customer credit card number, and it only sends the data to tapsBook backend server for making the charge.  Once the charge is verified, the order will be submitted to manufacturers for production.
 
 **To check out a book using your own eCommerce **

 The diagram below shows the steps the SDK performs and the 3rd party checkout integration point. The red arrow highlights the steps you must implement.
 
 ![image](https://cloud.githubusercontent.com/assets/842068/12011734/d2a4f4ee-aca7-11e5-95b5-e9777acc8c69.png)

 Specifically, TBSDKAlbumManager performs the following steps
 
 1. Same as the SDK-checkout case, it loads the full size TBImage and renders the high resolution book pages for print and then uploads the pages to AWS S3. The order data is then sent to the Tapsbook server.
 
 2. Instead of showing SDK shopping cart view and checkout views to collect payment info, the SDK gives you a callback for you to present your own checkout views. The callback will includes an order number as the key to link to order data referred in step 1.
 
 Your app must implement the following:
 
 1. Implement your own checkout views, including address collection, shopping cart view and payment information views. 
 
 2. Once you collect the data, send to your server to process the payment and compelte the order on your eCommerce server. Once completed the order and get the payment, your server should communicate to Tapsbook server to "claim" the order identified by the order number. 
 
 3. Once claimed, the server will reply with the full book data in JSON or XML for you to send to your manufacturing process. You should only claim an order after it is paid, as it will be billed to your merchant account for billing purpose.
 
 To use this option, To use this option you must set YES to [TBSDKConfiguratorProtocol shouldSendJSONDictToHostingAppWhenCheckout] in your app's configuration, and then  implement the delegate [TBSDKAlbumManagerDelegate_Checkout_Enterprise albumManager:checkoutSDKAlbum:withInfoDict:viewControllerToPresentOn:] to present your checkout viewControllers.
 
 **To retrieve a list of existing books**
 
 You can optionally present a list view showing all the books users have created.
 
 Use allSDKAlbumsWithCompletionBlock: method to retrieve an array of TBSDKAlbum objects, alternatively, if you created these Albums with tags, you can use allSDKAlbumsOfTag:completionBlock: to only retrieve a subset of TBSDKAlbum that matching the tag.
 
 **To manage an ordered book**
 
 Once your app user submits a book order, it triggers an automated manufacturing workflow
 
  1. The tapsBook platform sends a branded confirmation email to your client confirming the order has been received.
 
  2. The manufacturer prints the photo book and ships it to your app user via a pre-selected shipping provider
 
  3. The tapsBook platform sends a branded shipping notice email to your client with the shipping information and tracking #
 
 These steps are performed by the tapsBook platform backend. You can track and manage the orders from your app via tapsBook platform's dashboard at http://dashboard.tapsbook.com
 
 */

//Once you are ready to print from these source data, typically after you have cleared the payment from your customer, you can retrieve the JSON data via the order API as such
//
//{
//    "order_type" : "claim_only",
//    "album_key" : "THE_ALBUM_KEY",
//    “api_key":"YOUR_API_KEY ",
//    "external_order_id":"YOUR ORDER ID",
//    "currency": "CNY",
//    "total_price": "1.00",
//    "customer": {
//        "address": {
//            "phone": "",
//            "address1": "",
//            "lastname": "",
//            "firstname": "",
//            "email": "",
//            "state_id": "99",
//            "country_id": "48",
//        }
//    },
//    "action": "create",
//    "controller": "api/v1/preorder"
//}


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
/// @name Interact with an existing book: edit, printing etc
///---------------------------------------

/** Open a album, let the user edit album pages, print the album
 *  @param sdkAlbum
 *  @param presentOnViewController viewControllers of TapsbookSDK will be presented on this viewController
 *  @param shouldPrintDirectly  NO: Go to page edit; YES: Print directly
 */

- (BOOL)openSDKAlbum:(TBSDKAlbum *)sdkAlbum presentOnViewController:(UIViewController *)viewController shouldPrintDirectly:(BOOL)shouldPrintDirectly;

/** Go to the viewController that edit page.
 */

- (void)popToPageViewControllerAnimated:(BOOL)animated;

/** Dissmiss TapsbookSDKViews, this will also save the album data
 *  Do not directly use `dismissViewControllerAnimated:completion:` on your viewController, otherwise the album data may not be saved properly
 */

- (void)dismissTBSDKViewControllersAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**
 * get Cache Size
 */
- (NSUInteger)getCacheSize;

/**
 *  clear cache on disk
 */

- (void)clearCache;



/** TapsbookSDK calls dataSource to get images
 *
 *  All TBImage's `dataSource` will be assigned `imageDataSource`
 *
 *  @see TBImage
 */

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

/**
 * Callback when user request to add more photos from your app managed photo library
 * You must implement this method if you want to allow your app user to add photos
 * while they are still inside the book pages. Fail to do so will force user to leave
 * the book to add photos from outside the book.
 */
- (UIViewController *)photoSelectionViewControllerInstanceForAlbumManager:(TBSDKAlbumManager *)albumManager withSDKAlbum:(TBSDKAlbum *)sdkAlbum existingTBImages:(NSArray *)existingTBImages completionBlock:(void (^)(NSArray *newImages))completionBlock;

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
