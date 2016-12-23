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
                                
                                // Only set YES to ONE of the following
                                // option 2, generate album pages and use your own checkout UI
                                kTBUseExternalCheckout : @NO,
                                
                                // option 2, generate album JSON for 1 book
                                kTBSendAlbumKeyToHostingAppWhenCheckout : @NO,
                                
                                // option 3, generate album JSON for all books in a shopping cart
                                kTBSendAlbumJSONDictToHostingApp : @NO,
                                kTBSendOrderInfoToHostingApp : @NO,
                                };
    
    [settings setObject:checkout forKey:kTBCheckoutCustomization];
    
    return settings;
}


@end
