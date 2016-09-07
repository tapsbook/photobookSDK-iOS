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

/** Get all books in an array of TBSDKAlbum. You can use this method to return all existing TBSDKAlbums object in a list. The list of books is ordered by the creation date. Once you retrieved the TBSDKAlbum, you can use it to retrieve metadata of the album, such as the album title,  cover image etc.
 *  @param completionBlock Async returns the result of the query. Once you retrieved the TBSDKAlbum objects, you can use it to retrieve metadata of the album, such as the album title,  cover image etc.
 */
- (void)allSDKAlbumsWithCompletionBlock:(void (^)(BOOL success, NSArray *sdkAlbums, NSError *error))completionBlock;

/** Get all TBSDKAlbum that is filtered by a tag, useful if you want to categorize your books.
 *  @param tag The integer ID of the tag that was used when you call createSDKAlbumWithImages:identifier:title:tag:completionBlock: 
 *  @param completionBlock Async returns the result of the albums that matching the tag query. Once you retrieved the TBSDKAlbum objects, you can use it to retrieve metadata of the album, such as the album title,  cover image etc.
 */
- (void)allSDKAlbumsOfTag:(NSInteger)tag completionBlock:(void (^)(BOOL success, NSArray *sdkAlbums, NSError *error))completionBlock;

///---------------------------------------
/// @name Retrieve a specific photo book
///---------------------------------------

/** Get the album of a specific identifier
 *  @param identifier the identifier string was used when you create the Album
 *  @param completionBlock. Async returns the result of the albums that matching the identifier query. Once you retrieved the TBSDKAlbum objects, you can use it to retrieve metadata of the album, such as the album title,  cover image etc.
 */
- (void)sdkAlbumOfIdentifier:(NSString *)identifier completionBlock:(void (^)(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error))completionBlock;

/** [Async] If you saves the TBSDKAlbum's ID after you called createSDKAlbum method, you can get the album by that specific ID. This is the async version. There is another sync version if you prefer that way.
 *  @param ID The TBSDKAlbum ID returned by the createSDKAlbum method.
 *  @param completionBlock
 */
- (void)sdkAlbumOfID:(long long)ID completionBlock:(void (^)(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error))completionBlock;

/** [Sync] Get the album object of a specific ID
 *  @param ID The TBSDKAlbum ID returned by the createSDKAlbum method.
 */

- (TBSDKAlbum *)sdkAlbumOfID:(long long)ID;



@end
