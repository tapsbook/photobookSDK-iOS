//
//  TBSDKAlbumManager+Update.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 10/29/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@interface TBSDKAlbumManager (Update)

///---------------------------------------
/// @name Interact with a specific photo book: editing, renaming etc
///---------------------------------------

/** Async add images to a album. loading existing photos, or adding new photos. Notice TBAlbumManager tracks all existing images so that it won't add duplicate images to an album.
 *  @param images A array of TBImage
 *  @param sdkAlbum
 *  @param completionBlock Get called after finish
 */

- (void)addImages:(NSArray *)images toSDKAlbum:(TBSDKAlbum *)sdkAlbum completionBlock:(void (^)(BOOL success, NSUInteger photosAdded, NSError *error))compeletionBlock;

/** Rename the tile of a album
 *  @param sdkAlbum the reference to the album
 *  @param title New name of the album
 */
- (void)renameSDKAlbum:(TBSDKAlbum *)sdkAlbum title:(NSString *)title;

@end
