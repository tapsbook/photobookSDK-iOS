//
//  TBSDKAlbumManager+Read.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 10/29/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@interface TBSDKAlbumManager (Read)

///---------------------------------------
/// @name Retrieve a list of existing photo books
///---------------------------------------
/** Get all TBSDKAlbum of a tag
 *  @param tag
 *  @param completionBlock
 */

- (void)allSDKAlbumsOfTag:(NSInteger)tag completionBlock:(void (^)(BOOL success, NSArray *sdkAlbums, NSError *error))completionBlock;

/** Get all TBSDKAlbum, you can use this method to return all existing books.
 *  @param completionBlock
 */

- (void)allSDKAlbumsWithCompletionBlock:(void (^)(BOOL, NSArray *, NSError *))completionBlock;

///---------------------------------------
/// @name Retrieve a specific photo book
///---------------------------------------

/** Get the album of a specific identifier
 *  @param identifier
 *  @param completionBlock
 */

- (void)sdkAlbumOfIdentifier:(NSString *)identifier completionBlock:(void (^)(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error))completionBlock;

/** [Async] Get the album of a specific ID
 *  @param ID
 *  @param completionBlock
 */

- (void)sdkAlbumOfID:(long long)ID completionBlock:(void (^)(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error))completionBlock;

/** [Sync] Get the album of a specific ID
 *  @param ID
 */

- (TBSDKAlbum *)sdkAlbumOfID:(long long)ID;

/** Async retrieve all image metedata (TBImage) of a album from the datastore. By default, allSDKAlbumsWithCompletionBlock: will return TBSDKAlbum with empty images property, you must use this method to populate the image metadata prior to access images property.
 *  @param sdkAlbum
 *  @param completionBlock Get called after finish
 */

- (void)loadImagesOfSDKAlbum:(TBSDKAlbum *)sdkAlbum completionBlock:(void (^)(BOOL success, NSError *error))completionBlock;

@end
