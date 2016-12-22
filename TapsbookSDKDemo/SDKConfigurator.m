//
//  SDKConfigurator.m
//  TapsbookSDKDemo
//
//  Created by Xinrong Guo on 14-6-30.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import "SDKConfigurator.h"
#import <TapsbookSDK/TapsbookSDK.h>
#import <TapsbookSDK/TBProduct.h>

static NSString * const kTBS3AppKey = @"AKIAJYNE4PTKKS4FNDBA";
static NSString * const kTBS3AppSecret = @"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";
static NSString * const kTBAWSCognitoPoolID = @"";
#if DEBUG
static NSString * const kTBS3BucketNameDefault = @"tapstest";
#else
//USE CDN link
static NSString * const kTBS3BucketNameDefault = @"tapsbookapp";
#endif

@implementation SDKConfigurator

- (NSDictionary *)basicSettings {
    NSDictionary *settings = @{
                               kTBSDKBasics : @{
                                       kTBAppName : @"TBSDKDemo",             // (Required) Your app name, this name will show up in app UI messages
                                       kTBAppKey : @"",                       // (Required)
                                       kTBAppSecret : @"",                    // (Required)
                                       kTBAppURLScheme : @"TBSDKDemo",
                                       
                                       kTBSupportedRegions : @[               // (Optional) TBSDKRegions, customize the SDK to support multiple ship to regions (countries)
                                               // TBSDKRegions
                                               @(TBSDKRegion_UnitedStates),
                                               //@(TBSDKRegion_China),
                                               ],
                                       
                                       kTBMerchantKeys : @{                   // (Required) Your app keys that you setup from http://dashboard.tapsbook.com, Append a string prefix "test_[ACTUAL_KEY]" will connect to the test server
                                               // Region : merchantKey
#ifdef DEBUG
                                               @(TBSDKRegion_UnitedStates) : @"test_CLEEN_587a7f4ae3b2060a4822aadafb6f72fb",
#else
                                               @(TBSDKRegion_UnitedStates) : @"test_CLEEN_587a7f4ae3b2060a4822aadafb6f72fb",
#endif
                                               kTBMerchantKeyDefault : @"test_CLEEN_587a7f4ae3b2060a4822aadafb6f72fb",   // (Optional) The default key
                                               },
                                       kTBStripeKeys : @{                     // (Required) Stripe uses this key to create a charge token to make the charge on the tapsbook eCommerce server.
                                               // Region : stripeKey
                                               
#ifdef DEBUG
                                               kTBStripeKeyDefault : @"pk_test_d5alHjczpNGKCRL539vo14TL",
#else
                                               kTBStripeKeyDefault : @"pk_test_d5alHjczpNGKCRL539vo14TL",
#endif
                                               },
                                       },
                               
                               kTBAppLogoPaths : @{                         // (Optional) Your app logo that will be printed on the back cover, assuming the back cover has a design include the app logo
                                       //                                             kTBImageSizeS : [[NSBundle mainBundle] pathForResource:@"cleen-cover-logo-small" ofType:@"png"],
                                       //                                             kTBImageSizeL : [[NSBundle mainBundle] pathForResource:@"cleen-cover-logo-small" ofType:@"png"],
                                       //                                             kTBImageSizeXXL : [[NSBundle mainBundle] pathForResource:@"cleen-cover-logo" ofType:@"png"],
                                       },
                               
                               kTBAWSS3 : @{
                                       kTBAWSS3AppKey : kTBS3AppKey,                      // (Optional) Your AWS s3 cloud storage account, SDK will upload the rendered images to the AWS s3 location, you may need to set your own clean up policy to remove these images routinely
                                       kTBAWSS3AppSecret : kTBS3AppSecret,                // (Optional) Your AWS s3 cloud storage account secret
                                       kTBAWSS3BucketName : kTBS3BucketNameDefault,       // (Optional) AWS uses bucket name to organize your uploaded images, your images will be uploaded to this URL pattern
                                       },
                               
                               kTBBookGeneration : @{                       // (Optional)
                                       kTBTemplateDatabaseName : @"TBTemplate_MultiProduct_02_example.sqlite", // (Optional) The name of the template database
                                       kTBDefaultThemeID : @{              // (Optional)
                                               @(TBProductType_Photobook) : @200,
                                               @(TBProductType_Canvas) : @1000,
                                               },
                                       kTBUseSameBackgroundImageOnTheSameSpread : @{    // (Optional) Retrun YES is you want SDK's page generation use the same background image on the same spread
                                               @(TBProductType_Photobook) : @YES,
                                               @(TBProductType_Canvas) : @NO,
                                               @(TBProductType_Calendar) : @NO,
                                               @(TBProductType_Card) : @NO,
                                               },
                                       kTBMaxNumberofImagesPerPage : @{                 // (Optional)
                                               @(TBProductType_Photobook) : @2,
                                               @(TBProductType_Canvas) : @1,
                                               @(TBProductType_Calendar) : @1,
                                               @(TBProductType_Card) : @1,
                                               },
                                       kTBMinNumberofImagesPerPage : @{                 // (Optional)
                                               @(TBProductType_Photobook) : @1,
                                               @(TBProductType_Canvas) : @1,
                                               @(TBProductType_Calendar) : @1,
                                               @(TBProductType_Card) : @1,
                                               },
                                       kTBMaxNumberofImagesPerSpread : @{               // (Optional)
                                               @(TBProductType_Photobook) : @3,
                                               @(TBProductType_Canvas) : @1,
                                               @(TBProductType_Calendar) : @1,
                                               @(TBProductType_Card) : @1,
                                               },
                                       kTBMinNumberofImagesPerSpread : @{               // (Optional)
                                               @(TBProductType_Photobook) : @2,
                                               @(TBProductType_Canvas) : @1,
                                               @(TBProductType_Calendar) : @1,
                                               @(TBProductType_Card) : @1,
                                               },
                                       kTBAllowAddOrRemovePage : @{                     // (Optional)
                                               @(TBProductType_Photobook) : @YES,
                                               @(TBProductType_Canvas) : @NO,
                                               @(TBProductType_Calendar) : @NO,
                                               @(TBProductType_Card) : @NO,
                                               },
                                       },
                               
                               kTBBehaviorCustomization : @{
                                       kTBRemindUserToOrderWhenClosingBooks : @NO,      // (Optional) Whether to remind a user they will lose their work in progress if they close.
                                       kTBShowOptionsOfBuildingPagesManuallyOrAutomatically : @{  // (Optional)
                                               @(TBProductType_Photobook) : @NO,
                                               @(TBProductType_Canvas) : @NO,
                                               @(TBProductType_Calendar) : @NO,
                                               @(TBProductType_Card) : @NO,
                                               },
//                                       kTBShowPhotoMenuByDefault:@YES,
                                       
                                       kTBUseEmptyTemplateForPageWithNoContent : @NO,   // (Optional)
                                       
                                       kTBRequireBookTitle: @NO,
                                       
                                       kTBLoadProductFromServerWhenPreparingLocalAlbum : @(NO), // (Optional)
                                       },
                               
                               kTBCheckoutCustomization : @{                    // (Optional)
                                       kTBNoCover : @{                                  // (Optional) YES if you don't need a cover or the cover is not customizable
                                               @(TBProductType_Photobook) : @NO,
                                               @(TBProductType_Canvas) : @YES,
                                               @(TBProductType_Calendar) : @YES,
                                               @(TBProductType_Card) : @YES,
                                               },
                                       kTBSendAlbumJSONDictToHostingApp : @NO,          // (Optional) YES when you want to generate page image on your own.
                                       kTBGeneratePageImagesToHostingApp : @NO,          // (Optional) Helps you debug when kTBSendAlbumJSONDictToHostingApp is YES
                                       },
                               };
    
    return settings;
}


- (float)taxRateForCountry:(NSString *)country state:(NSString *)state city:(NSString *)city {
    float rate = 0;
    if ([country isEqualToString:@"United States"] && [state isEqualToString:@"North Carolina"]){
        rate = 0.0675;
    }
    return rate;
    
}

- (BOOL)canRearrangePageAtIndex:(NSInteger)index isSpread:(BOOL)isSpread {
    if (index < 2) {
        return NO;
    }
    else {
        return YES;
    }
}

- (NSDictionary *)colorSettins {
    NSDictionary *result = @{
                             kTBPageVCTopMenuOrderBookButtonColorNormal : [UIColor redColor],
                             };
    return result;
}

@end
