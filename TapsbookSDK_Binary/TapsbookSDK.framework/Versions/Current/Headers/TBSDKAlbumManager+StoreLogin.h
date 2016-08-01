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

- (void)presentStoreLoginViewControllerOnViewController:(UIViewController *)viewController completionBlock:(void (^)(TBSDKLoginRegisterResult result, TBSDKUser *sdkUser, NSError *error))completionBlock;

- (void)logoutCurrentUser;

- (TBSDKUser *)currentSDKUser;

@end
