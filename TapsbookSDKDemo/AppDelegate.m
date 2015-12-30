//
//  AppDelegate.m
//  TapsbookSDKDemo
//
//  Created by Xinrong Guo on 14-6-27.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoListViewController.h"
#import <TapsbookSDK/TapsbookSDK.h>
#import <AliSDK/AlipaySDK.framework/Headers/AlipaySDK.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "WXApi.h"
#import <TapsbookSDK/TBWeChatManager.h>
#import <TapsbookSDK/TBFacebookManager.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@", NSHomeDirectory());
    
    [[TBWeChatManager sharedInstance] setupWithApplication:application options:launchOptions];
    [[TBFacebookManager sharedInstance] setupWithApplication:application options:launchOptions];
    
    [Fabric with:@[[Crashlytics class]]];
    
//    [TBSDKConfiguration initializeWithConfiguratorClassName:@"SDKConfigurator"];
    [TBSDKConfiguration initializeWithConfiguratorClassName:@"SDKConfiguratorCustomCheckout"];
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // iOS 8 Notifications
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
     
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    PhotoListViewController *photoListVC = [[PhotoListViewController alloc] initWithNibName:@"PhotoListViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoListVC];
    
    self.window.rootViewController = navController;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [self application:application handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url {
    BOOL result = NO;
    
    result |= [[TBSDKAlbumManager sharedInstance] processOrderWithPaymentResult:url];
    result |= [[TBWeChatManager sharedInstance] application:application openURL:url sourceApplication:nil annotation:nil];
    result |= [[TBFacebookManager sharedInstance] application:application openURL:url sourceApplication:nil annotation:nil];
    
    return result;
}
@end
