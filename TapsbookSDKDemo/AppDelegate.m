//
//  AppDelegate.m
//  TapsbookSDKDemo
//
//  Created by Xinrong Guo on 14-6-27.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoListViewController.h"
#import "DemoWelcomeViewController.h"
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
    
    [TBSDKConfiguration initializeWithConfiguratorClassName:@"SDKConfiguratorChina"];

    [[TBWeChatManager sharedInstance] setupWithApplication:application options:launchOptions];
    [[TBFacebookManager sharedInstance] setupWithApplication:application options:launchOptions];
    
//    [Fabric with:@[[Crashlytics class]]];
    
//    [TBSDKConfiguration initializeWithConfiguratorClassName:@"SDKConfigurator"];
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // iOS 8 Notifications
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
     
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    DemoWelcomeViewController *homeVC = [[DemoWelcomeViewController alloc] initWithNibName:@"DemoWelcomeViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options {
    
    return [self application:application handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url {
    BOOL result = NO;
    
    //handles alipay payment callback
    result |= [[TBSDKAlbumManager sharedInstance] processOrderWithPaymentResult:url];
    
    result |= [[TBWeChatManager sharedInstance] application:application openURL:url sourceApplication:nil annotation:nil];
    result |= [[TBFacebookManager sharedInstance] application:application openURL:url sourceApplication:nil annotation:nil];
    
    return result;
}
@end
