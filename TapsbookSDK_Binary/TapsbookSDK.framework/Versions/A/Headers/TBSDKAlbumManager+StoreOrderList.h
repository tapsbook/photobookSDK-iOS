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
 * Present a view to show all orders submitted by a given user. User can view the order status and the detail for each order.
 * 
 *  @param viewController The VC you want to present the order list.
 */

- (void)presentOrderListViewControllerOnViewController:(UIViewController *)viewController;

- (UIViewController *)orderListViewController;

@end
