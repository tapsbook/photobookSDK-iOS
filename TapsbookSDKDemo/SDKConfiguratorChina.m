//
//  SDKConfiguratorChina.m
//  TapsbookSDKDemo
//
//  Created by yoda on 12/8/16.
//  Copyright © 2016 tapsbook. All rights reserved.
//

#import "SDKConfiguratorChina.h"
#import <TapsbookSDK/TapsbookSDK.h>

extern NSString * const kTBSendAlbumKeyToHostingAppWhenCheckout;
extern NSString * const kTBUseExternalPrintProductInfo;
extern NSString * const kTBUseExternalCheckout;
extern NSString * const kTBSocialAlipayPartnerID;
extern NSString * const kTBSocialAlipayAccountName;

@implementation SDKConfiguratorChina

- (NSDictionary *)basicSettings {
    NSMutableDictionary * settings = [[super basicSettings] mutableCopy];
    
    NSDictionary * base = @{
                            kTBAppName : @"TBSDKDemo",             // (Required) Your app name, this name will show up in app UI messages
                            kTBAppKey : @"",                       // (Required)
                            kTBAppSecret : @"",                    // (Required)
                            kTBAppURLScheme : @"TBSDKDemo",
                            
                            kTBSupportedRegions : @[
                                    @(TBSDKRegion_China),
                                    ],
                            
                            kTBMerchantKeys : @{                   // (Required) Your app keys that you setup from https://dashboard.shiyi.co, A string prefix "test_[ACTUAL_KEY]" will connect to the test server http://search.tapsbook.com
                                    // Region : merchantKey
                                    @(TBSDKRegion_China) : @"live_yaopai_c9781afbad6c80b0d6130e2edaacf3aa",
                                    kTBMerchantKeyDefault : @"live_yaopai_c9781afbad6c80b0d6130e2edaacf3aa",
                                    },
                            kTBStripeKeys : @{                     // (Required) Stripe uses this key to create a charge token to make the charge on the tapsbook eCommerce server.
                                    kTBStripeKeyDefault : @"pk_test_d5alHjczpNGKCRL539vo14TL",
                                    },
                            };
    
    NSDictionary * checkout = @{
                                kTBNoCover : @{                                  // (Optional) YES if you don't need a cover or the cover is not customizable
                                        @(TBProductType_Photobook) : @NO,
                                        @(TBProductType_Canvas) : @YES,
                                        @(TBProductType_Calendar) : @YES,
                                        @(TBProductType_Card) : @YES,
                                        },
                                
                                // Only set YES to ONE of the following
                                // option 1, generate album pages and use your own checkout UI
                                kTBUseExternalCheckout : @NO,
                                
                                // option 2, generate album JSON for 1 book
                                kTBSendAlbumKeyToHostingAppWhenCheckout : @NO,
                                
                                // option 3, generate album JSON for all books in a shopping cart
                                kTBSendAlbumJSONDictToHostingApp : @NO,
                                kTBSendOrderInfoToHostingApp : @NO,
                                };
    
    // To support Wechat payment,
    //   you must add your wechat APPID as urlscheme in order to make the wechat callback find your app
    // To support Alipay payment,
    //   you must make sure kTBAppURLScheme property was setup correctly.
    NSDictionary * socialPayment = @{
                                     kTBSocialAlipayPartnerID : @"123456",
                                     kTBSocialAlipayAccountName: @"abc@abc.com",
                                     kTBSocialWeixinAppID : @"wx123456",
                                     kTBSocialWeixinAppSecret : @"123456",
                                     };
    
    [settings setObject:base forKey:kTBSDKBasics];
    [settings setObject:checkout forKey:kTBCheckoutCustomization];
//    [settings setObject:socialPayment forKey:kTBSocial];
    
    return settings;
}

@end
