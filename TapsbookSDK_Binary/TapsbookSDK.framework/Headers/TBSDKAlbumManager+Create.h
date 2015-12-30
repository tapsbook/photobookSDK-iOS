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

/** Create a photo book with a set of images
 *  @param images A array of TBImage, can be nil if you want to add images later. @see addImages:toSDKAlbum:completionBlock:
 *  @param (optional) identifier a unique string, lenth <= 20. This provides a way to identify a album for later retrieval: you can query the album you want using this identifier.
 *  @param (optional) title the title of the album
 *  @param (optional) tag, similar to identifier
 *  @param completionBlock, callback after creation is done. This is a good time to present the product editor UI.
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
