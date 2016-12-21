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

/**
 * Returns the currently signed-in SDK user
 *
 * To sign in a user, call signinSDKUser:fromApp:completionBlock: first. If you have not signed-in the user, this method will return nil.
 */
- (TBSDKUser *)currentSDKUser;

/**
 * Use this method to sign in your-app-user
 *
 * SDK backend has a user registry that is used to associate user orders with the user. You must call this method before the initiating the order creation if you want to let the SDK track this order later.
 *
 * Once you signed in your app user, you can call orderListViewController to show the orders made by the signed in app user.
 *
 * This is an invitation-only feature, you must use contact us to pre-approve your appName first before using this feature.
 *
 *  @param userid The userid in your app, it must be unique.
 *  @param appName The appName of your app, it must be unique.
 *  @param completionBlock The callback after signin is complete. You can use this to find out whether the signin was successful.
 */
- (void) signinSDKUser:(NSString *) userid fromApp:(NSString*)appName completionBlock:(void (^)(BOOL success, TBSDKUser *sdkUser, NSError *error))completionBlock;

@end
