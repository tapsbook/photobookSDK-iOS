//
//  TBSDKAlbumManager+StoreOrderList.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 11/27/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@interface TBSDKAlbumManager (StoreOrderList)

///---------------------------------------
/// @name Present built-in UI for showing orders for a signed-in SDK user
///---------------------------------------

/**
 * Use this method to present a view on a given ViewController to list all orders submitted by the current signed-in SDK user. From the list, user can view the order status and the detail for each order.
 *
 * Before calling this method, you must first sign in your current app user to SDK by calling signinSDKUser:fromApp:completionBlock: Without doing so will cause the viewcontroller not able to find any matching orders.
 * 
 *  @param viewController The VC you want to present the order list.
 */

- (void)presentOrderListViewControllerOnViewController:(UIViewController *)viewController;

/**
 * Use this method to get the instance of an helper viewController that lists all orders submitted by the current signed-in SDK user. From the list, user can view the order status and the detail for each order.
 *
 * Before calling this method, you must first sign in your current app user to SDK by calling signinSDKUser:fromApp:completionBlock: Without doing so will cause the viewcontroller not able to find any matching orders. 
 */
- (UIViewController *)orderListViewController;

@end
