//
//  TBSDKAlbumManager+StoreOrderList.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 11/27/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@interface TBSDKAlbumManager (StoreOrderList)

- (void)presentOrderListViewControllerOnViewController:(UIViewController *)viewController;

- (UIViewController *)orderListViewController;

@end
