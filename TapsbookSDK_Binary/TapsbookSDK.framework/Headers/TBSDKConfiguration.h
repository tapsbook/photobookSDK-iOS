//
//  TBSDKConfiguration.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 14-6-11.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TapsbookSDK/TBSDKConstants.h>
#import <TapsbookSDK/TBImage.h>

typedef NS_ENUM(NSInteger, TBExternalCheckoutType) {
    TBExternalCheckoutType_1 = 1,
    TBExternalCheckoutType_2 = 2,
    TBExternalCheckoutType_3 = 3,
};

@protocol TBSDKConfiguratorProtocol;

@interface TBSDKConfiguration : NSObject

+ (instancetype)sharedInstance;

+ (void)initializeWithConfigurator:(id<TBSDKConfiguratorProtocol>)configurator;
+ (void)initializeWithConfiguratorClassName:(NSString*)className;

@property (readonly, nonatomic) id<TBSDKConfiguratorProtocol>configurator;

@end

/**
 TBSDKConfiguratorProtocol is the one-stop shop containing methods needed to customize the SDK for your app need, including the production workflow (whether to use your own checkout process), the produt template DB name, and the SDK look and feel (colors of the UI elements). 
 
 To start, you need to create a class that adopts TBSDKConfiguratorProtocol, 
 
    @interface MyTBSDKConfigurator : NSObject <TBSDKConfiguratorProtocol>
 
 then in your app delegate, load the configuration as the following
 
    [TBSDKConfiguration initializeWithConfiguratorClassName:@"MySDKConfigurator"];
*/
@protocol TBSDKConfiguratorProtocol <NSObject>

@required

///---------------------------------------
/// @name Required settings
///---------------------------------------

/** Return a dictionary that resets the SDK configurations for product creation
 *  Refer to the provided sample code
 *  Use the keys in TBSDKConstants.h
 */

- (NSDictionary *)basicSettings;

///---------------------------------------
/// @name Checkout Basic
///---------------------------------------

/** Return a tax rate (e.g. 0.05 for 5%) for the given country/state/city combination
 *  Default: 0
 */
- (float)taxRateForCountry:(NSString *)country state:(NSString *)state city:(NSString *)city;

/** Return YES if your app provide print product info, otherwise return NO, SDK will provide all the print feature
 *  Default: NO
 */

@optional

/** Rearrange
 *  To control wether a page is moveable in rearrange view
 *
 *  Default: YES
 */
- (BOOL)canRearrangePageAtIndex:(NSInteger)index isSpread:(BOOL)isSpread;


/** Color
 *  Use the keys in TBSDKConstants.h
 */
- (NSDictionary *)colorSettings;

@end
