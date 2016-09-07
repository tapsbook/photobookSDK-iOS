//
//  TBSDKAlbumManager+Delete.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 10/29/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@interface TBSDKAlbumManager (Delete)

///---------------------------------------
/// @name Delete a specific photo book
///---------------------------------------

/** Remove a album
 *  @param sdkAlbum
 */

- (void)removeSDKAlbum:(TBSDKAlbum *)sdkAlbum;

@end
