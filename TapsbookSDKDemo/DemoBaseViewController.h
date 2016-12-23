//
//  DemoBaseViewController.h
//  TapsbookSDKDemo
//
//  Created by yoda on 12/23/16.
//  Copyright © 2016 tapsbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapsbookSDK/TapsbookSDK.h>

typedef NS_ENUM(NSInteger, ViewControllerMode) {
    ViewControllerMode_CreateAlbum,
    ViewControllerMode_AddPhoto,
};

typedef NS_ENUM(NSInteger, CheckoutMethod) {
    CheckoutMethod_Default,
    CheckoutMethod_AppCommerce,
    CheckoutMethod_AppCommerceAndProduction,
};


@interface DemoBaseViewController : UIViewController

@property (assign, nonatomic) CheckoutMethod checkoutMethod;

- (NSMutableArray *)convertAssetsToTBImages:(NSArray *) assets;

- (NSMutableDictionary *)getDefaultProductOptions;

- (void)handleCheckoutButton:(id)sender;

@end
