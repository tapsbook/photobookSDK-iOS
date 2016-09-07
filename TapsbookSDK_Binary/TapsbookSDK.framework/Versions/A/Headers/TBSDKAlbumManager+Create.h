//
//  TBSDKAlbumManager+Create.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 10/29/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@class TBAlbum;

@interface TBSDKAlbumManager (Create)

///---------------------------------------
/// @name Create a new book with an array of TBImage
///---------------------------------------

/** Create a photo book with a set of images. This methods returns very quickly because it merely creates the top level Album object with links to the images, the images autofilling process is deferred in a second lazy load step, which will be executed when you call openSDKAlbum:presentOnViewController:shouldPrintDirectly:
 *  @param images A array of TBImage, can be nil if you want to add images later. @see addImages:toSDKAlbum:completionBlock:
 *  @param identifier (optional) a unique string, lenth <= 20. Useful to identify a unique album for later retrieval: you can later query the album you want using this identifier.
 *  @param title (optional) the title of the album
 *  @param tag (optional) an integer of tag, useful to identify a group of albums fitting in a category, you can later query the album you want using this tag.
 *  @param productionOptions (optional) a dictionary that that allows advanced SDK client to customize the book creation. Contacting the SDK sales team for these options.
 *  @param completionBlock callback after creation is done. The callback includes a pointer to the Album object. It is now a good time to call  openSDKAlbum:presentOnViewController:shouldPrintDirectly: to start the image autofilling and present the book editor UI. 
 */

- (void)createSDKAlbumWithImages:(NSArray *)images
                      identifier:(NSString *)identifier
                           title:(NSString *)title
                             tag:(NSInteger)tag
                 completionBlock:(void (^)(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error))completionBlock;


- (void)createSDKAlbumWithImages:(NSArray *)images
                      identifier:(NSString *)identifier
                           title:(NSString *)title
                             tag:(NSInteger)tag
                         options:(NSDictionary *)productOptions
                 completionBlock:(void (^)(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error))completionBlock;

/** Create a TBSDK product other than photo book type
 *  @param productType Product type. @see TBProductType
 *  @param images A array of TBImage, can be nil if you want to add images later. @see addImages:toSDKAlbum:completionBlock:
 *  @param (optional) identifier a unique string, lenth <= 20. This provides a way to identify a album for later retrieval: you can query the album you want using this identifier.
 *  @param (optional) title the title of the album
 *  @param (optional) tag, similar to identifier
 *  @param completionBlock, callback after creation is done. This is a good time to present the product editor UI.
 */
- (void)createSDKAlbumWithProductType:(TBProductType)productType
                               images:(NSArray *)images
                           identifier:(NSString *)identifier
                                title:(NSString *)title
                                  tag:(NSInteger)tag
                      completionBlock:(void (^)(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error))completionBlock;

@end
