//
//  TBSDKUser.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 12/1/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 TBSDKUser represent an user at the SDK backend. SDK backend uses a user registry to associate 3rd party user  with the user's orders. The user registry uses the pair {app_name, app_user_id} to uniquely identify a user.
 
 In order to let the SDK tracks and manages the user order, you must call [TBSDKAlbumManager signinSDKUser:fromApp:completionBlock:] Once you signed in your app user, you can call [TBSDKAlbumManager orderListViewController] to show the orders made by the signed in app user.
 
 The following example demonstrates the typical preparation steps.
 
     if (![TBSDKAlbumManager sharedInstance].currentSDKUser){
         [[TBSDKAlbumManager sharedInstance] signinSDKUser:@"APP_USER_ID" fromApp:@"APP_ID" completionBlock:^(BOOL success, TBSDKUser *sdkUser, NSError *error) {
             if(success){
                NSLog(@"SDK user logged in. User name:%@", sdkUser.name);
             }
             else {
                NSLog(@"SDK user cannot log in. Error:%@", error.localizedDescription);
             }
        }];
     }
 
 You should always use the sign in method to get TBSDKUser instead of creating one by hand.
 */

@interface TBSDKUser : NSObject

///---------------------------------------
/// @name Properties
///---------------------------------------

/** After sign in is successful, this returns the name of the user*/
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *referralCode;
@property (assign, nonatomic) BOOL referralUsed;

+ (TBSDKUser *)currentUser;

@end
