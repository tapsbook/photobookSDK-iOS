//
//  SDKConfiguratorCustomCheckout.m
//  TapsbookSDKDemo
//
//  Created by yoda on 12/26/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import "SDKConfiguratorCustomCheckout.h"
#import <TapsbookSDK/TapsbookSDK.h>

extern NSString * const kTBSendAlbumKeyToHostingAppWhenCheckout;
extern NSString * const kTBUseExternalPrintProductInfo;
extern NSString * const kTBUseExternalCheckout;

@implementation SDKConfiguratorCustomCheckout

- (NSDictionary *)basicSettings {
    NSMutableDictionary * settings = [[super basicSettings] mutableCopy];
    
    NSDictionary * checkout = @{
                                kTBNoCover : @{                                  // (Optional) YES if you don't need a cover or the cover is not customizable
                                        @(TBProductType_Photobook) : @NO,
                                        @(TBProductType_Canvas) : @YES,
                                        @(TBProductType_Calendar) : @YES,
                                        @(TBProductType_Card) : @YES,
                                        },
                                kTBSendAlbumJSONDictToHostingApp : @YES,          // (Optional) YES when you want to generate page image on your own.
                                kTBGeneratePageImagesInDebugMode : @NO,          // (Optional) Helps you debug when kTBSendAlbumJSONDictToHostingApp is YES
                                kTBSendAlbumKeyToHostingAppWhenCheckout : @NO,
                                kTBUseExternalPrintProductInfo : @NO,
                                kTBUseExternalCheckout : @YES,
                                kTBSendOrderInfoToHostingApp : @YES,
                                };
    
    [settings setObject:checkout forKey:kTBCheckoutCustomization];
    
    return settings;
}


@end
