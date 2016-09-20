//
//  TBImage.h
//  AtomBook
//
//  Created by Xinrong Guo on 13-10-9.
//
//

#import "TBContent.h"
#import "TBPriority.h"
#import <UIKit/UIKit.h>

/// Size of the image
typedef NS_ENUM(NSInteger, TBImageSize) {
    /// The thumbnail size
    TBImageSize_s = 0,
    /// The size for display
    TBImageSize_l = 2,
    /// The the size for printing
    TBImageSize_xxl = 4,
};

/// Donloading status of a image
typedef NS_ENUM(NSInteger, TBImageStatus) {
    /// Image not available, only when there is a error when downloading the image, use TBImageStatus_Downloading when image is not downloaded and can be downloaded
    TBImageStatus_Unavailable,
    /// Image is being downloaded or will be downloaed right now, this is the default status
    TBImageStatus_Downloading,
    /// Image is availble
    TBImageStatus_Available,
};

/**A TBImage object represent an image that appears on photo book page. A TBImage object only contains the metadata for the photo it represents. It also provides convenience method to quickly get specific sizes of an image and optionally handles mult-threaded importing.
 
 To Create a TBImage

 1. Call the initWithIdentifier: method to retrieve the shared album manager object.

 2. Call setImagePath:size: to tell SDK the local file path of the thumbnail, display and full size version of the image.
 
 **TBSDKAlbumManager can only access images local to your app**. Once you created and prepared your array of TBImages, you need to import and create the different sized image file of each TBImage so that the TBSDKAlbumManager can locate these files when they are needed. TBSDKAlbumManager will only lazy load the image content from the specified location when the image is about to be shown on the UI. Doing this minimizes the memory usage of the final app.
 
 The following example demonstrates the typical preparation steps.

    NSMutableArray *tbImages = [NSMutableArray arrayWithCapacity:self.selectedPhoto.count];
 
    for (Photo *photo in self.selectedPhoto) {
       TBImage *tbImage = [[TBImage alloc] initWithIdentifier:photo.identifier];
 
       [tbImage setImagePath:sPath size:TBImageSize_s];
       [tbImage setImagePath:lPath size:TBImageSize_l];
 
       [tbImages addObject:tbImage];
    }
 
    //importing images
    UIImage *image = [UIImage imageWithCGImage:imgRef scale:1 orientation: orientation];
    [image writeToFile:path withCompressQuality:1];
 */


@protocol TBImageDataSource;

@interface TBImage : TBContent

///---------------------------------------
/// @name Properties
///---------------------------------------

/** TapsbookSDK calls dataSource to get images */

@property (weak, readonly, nonatomic) id<TBImageDataSource> dataSource;

/** A unique string that distinguish different images */

@property (readonly, nonatomic) NSString *identifier;

/** (Optional) The title of a image, maybe a name */

@property (strong, nonatomic) NSString *title;

/** (Optional) The description of a image */

@property (strong, nonatomic) NSString *desc;

/** The size in pixel of a TBImageSize_xxl size image. 
 *  TapsbookSDK use this value to know whether a image can be printed clearly. 
 *  Assign a CGSize if you don't have the size.
 */

@property (assign, nonatomic) CGSize xxlSizeInPixel; // core

/** NO(default, recommanded): Image is stored as a file on disk, and your app gives the path to that file, 
 *  TapsbookSDK will load the image from the path.
 *
 *  YES: Image not strored as a file on disk, 
 *  TapsbookSDK will tell dataSource load the image. @see imageOfTBImage:size:
 *
 */

@property (readonly, nonatomic) BOOL isImageLoadingHandledByDataSource DEPRECATED_ATTRIBUTE;

///---------------------------------------
/// @name Create a New TBImage
///---------------------------------------

/** Initialize method
 *  @param identifier A unique string that distinguish different images, Should not be nil
 */

- (id)initWithIdentifier:(NSString *)identifier;

/** If isImageLoadingHandledByDataSource == NO, you should set the image path before you call gotImageWithSize:, 
 *  TapsbookSDK will load image form the path.
 *  @param path The path of a image, should be a local path, a remote path won't work
 *  @param size TBImageSize
 */

///---------------------------------------
/// @name Handle different sizes
///---------------------------------------

- (void)setImagePath:(NSString *)path size:(TBImageSize)size;

/** Set the image cloud storage URL as a reference, this URL will be printed in the output JSON.
 *  TapsbookSDK will load image form the path.
 *  @param path The path of a image, should be a local path, a remote path won't work
 *  @param size TBImageSize
 */
- (void)setImageCSURLString:(NSString *)urlString size:(TBImageSize)size;

/** Get the path of a image
 *  @param size TBImageSize
 */

- (NSString *)imagePathWithSize:(TBImageSize)size;

/** Call this method to tell TapsbookSDK the image has been downloaded successfuly and available
 *  @param size TBImageSize
 */

- (void)gotImageWithSize:(TBImageSize)size;

/** Call this method to tell TapsbookSDK you failed downloading the image
 *  @param size TBImageSize
 *  @param errorDescription Localized description for the reason, can be nil
 */

- (void)failedGettingImageWithSize:(TBImageSize)size errorDescription:(NSString *)errorDescription;

/** the error is generated by hosting app by calling `failedGettingImageWithSize:errorDescription:`
 */

- (NSString *)errorDescriptionWithSize:(TBImageSize)size;

/** Used as the `referenceName` in `TBTaskManager`
 */

- (NSString *)referenceName;

@end

/**TBImageDataSource is an optional feature if you app wants to delay the image importing to the last second before the image is accessed. It is however recommended that you import the images before entering TBSDKAlbumManager, as it is much simpler doing this way.
 
 TBImageDataSource provides delegate that will be called when a specified size of a TBImage is not available, you can then implement these delegate methods to download image and notify the SDK when download is completed.
 
 If you would like to use NSOperationQueue to run multi-threaded download, TBImageDataSource can help you prioritize the image download and cancel download jobs in case the TBImage is no longer needed.
 
 */
@protocol TBImageDataSource <NSObject>

@optional

///---------------------------------------
/// @name Importing images
///---------------------------------------

/** TapsbookSDK call this method when the image is not available, when reveiving this, 
 *  you should download the image and call gotImageWithSize: when done
 *  @param tbImage
 *  @param size
 *  @param priority
 *  @param ignoreCache When ignoreCache is YES, it means user want to re-download the image, you should ignore your image cache and re-download
 */

- (void)tbimageRequestImage:(TBImage *)tbImage size:(TBImageSize)size priority:(TBPriority)priority ignoreCache:(BOOL)ignoreCache;

/** TapsbookSDK call this method when a previous request of a image is no longer necessary, 
 *  you can cancel image download operation and focous on the necessary ones.
 *  @param tbImage
 *  @param size
 */

///---------------------------------------
/// @name Manage priority of job in the queue
///---------------------------------------

- (void)tbimageCancelImageRequest:(TBImage *)tbImage size:(TBImageSize)size;

/** TapsbookSDK call this method when a the priority of a image request has changed.
 *  You can adjust the priority of your own image download operations to make the image requests with high priority complete as soon as possible
 *  @param tbImage
 *  @param size
 *  @param oldPriority the previous priority
 *  @param newPriority the new priority
 */

- (void)tbimage:(TBImage *)tbImage size:(TBImageSize)size priorityOfRequestChangeFrom:(TBPriority)oldPriority to:(TBPriority)newPriority;

///---------------------------------------
/// @name Check status of different sized images
///---------------------------------------

/** TapsbookSDK call this method every time before it loads a image to memory using a existing path, 
 *  if you return YES, the exising path will be ignored and a new request will be fired
 *  This mehod may be called on both main 
 *  @param tbImage
 *  @param path
 *  @param size
 */
- (BOOL)tbImage:(TBImage *)tbImage isPathInvalid:(NSString *)path ofSize:(TBImageSize)size;

///////// Must implement methods below when isImageLoadingHandledByDataSource = YES;

/** If isImageLoadingHandledByDataSource == NO, TapsbookSDK call this method to get the status of a image, you should provide the status correctly,
 *  otherwise the preloading of images will not work correctly
 *  @param tbImage
 *  @param size
 *  @param ignoreCache When ignoreCache is YES, it means user want to re-download image, you should ignore your image cache,
 *         and return TBImageStatus_Downloading
 *  @return The status of a image. @see TBImageStatus
 */

- (TBImageStatus)statusOfTBImage:(TBImage *)tbImage size:(TBImageSize)size ignoreCache:(BOOL)ignoreCache DEPRECATED_ATTRIBUTE;

/** If isImageLoadingHandledByDataSource == NO, TapsbookSDK call this method to get the UIImage instance of a image
 *  @param tbImage
 *  @param size
 *  @return The UIImage instance of the image, nil if the image is not available
 */

- (UIImage *)imageOfTBImage:(TBImage *)tbImage size:(TBImageSize)size DEPRECATED_ATTRIBUTE;

@end

