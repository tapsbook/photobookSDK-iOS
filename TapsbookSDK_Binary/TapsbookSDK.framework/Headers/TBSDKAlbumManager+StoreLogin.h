//
//  TBSDKAlbumManager+StoreLogin.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 11/27/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>
#import "TBSDKUser.h"

typedef NS_ENUM(NSInteger, TBSDKLoginRegisterResult) {
    TBSDKLoginRegisterResult_Success,
    TBSDKLoginRegisterResult_Failed,
    TBSDKLoginRegisterResult_Canceled,
};

@interface TBSDKAlbumManager (StoreLogin)

///---------------------------------------
/// @name Link your app user to SDK user
///---------------------------------------

- (void)presentStoreLoginViewControllerOnViewController:(UIViewController *)viewController completionBlock:(void (^)(TBSDKLoginRegisterResult result, TBSDKUser *sdkUser, NSError *error))completionBlock;

- (void)logoutCurrentUser;

- (TBSDKUser *)currentSDKUser;

/**
 * SDK backend has a user registry that is used to associate user orders with the user. You must perform this signin process if you wish to retrieve order status later.
 *  @param userid The userid in your app, it must be unique.
 *  @param appName The appName of your app, it must be unique, use your app bundle id will be a good start.
 *  @param completionBlock The callback after signin is complete. You can use this to find out whether the signin was successful.
 */
- (void) signinSDKUser:(NSString *) userid fromApp:(NSString*)appName completionBlock:(void (^)(BOOL success, TBSDKUser *sdkUser, NSError *error))completionBlock;

@end
