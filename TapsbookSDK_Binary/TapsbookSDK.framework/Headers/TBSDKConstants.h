//
//  TBSDKConstants.h
//  AtomBook
//
//  Created by Xinrong Guo on 14-1-8.
//
//

///---------------------------------------------
/// @name UILocalNotification alertAction
///---------------------------------------------

/* When uploading is in progress and app enters background,
 * SDK will send a local notification to tell user to go back
 * to continue uploading
 *
 * You will recevie a local notification with this alertAction
 * Just do nothing for this alertAction
 */
extern NSString * const kTBSDKLocalNotificationActionKeepActivate;

///----------------------------------------------------------------------------------------------------------
/// @name SDK Regions, SDK will use these values to decide which cloud storage server to upload the images to
///----------------------------------------------------------------------------------------------------------

typedef NS_ENUM(NSInteger, TBSDKRegion) {
    TBSDKRegion_None = 0,
    TBSDKRegion_UnitedStates = 10,
    TBSDKRegion_China = 11,
    TBSDKRegion_Other = 1000,
};


///---------------------------------------
/// @name Checkout Info Keys
///---------------------------------------
extern NSString * const kTBSDKCheckoutInfoNumberOfPages;
extern NSString * const kTBSDKCheckoutInfoProductID;
extern NSString * const kTBSDKCheckoutInfoNumberOfPagesMin;
extern NSString * const kTBSDKCheckoutInfoNumberOfPagesMax;

extern NSString * const kTBSDKExternalCheckoutAlbumKey;
extern NSString * const kTBSDKExternalCheckoutAlbumStdPageCount;

extern NSString * const kTBSDKExternalCheckoutAlbumJSONDict;
extern NSString * const kTBSDKExternalCheckoutPageImagePathsForDebugging;


///---------------------------------------
/// @name Order Info Keys
///---------------------------------------
extern NSString * const kTBSDKOrderInfoUserEmail;
extern NSString * const kTBSDKOrderInfoTotalPrice;


///---------------------------------------
/// @name Basic Settings
///---------------------------------------
// 0
extern NSString * const kTBSDKBasics;
// 1
extern NSString * const kTBAppName;
extern NSString * const kTBAppKey;
extern NSString * const kTBAppSecret;
extern NSString * const kTBSupportedRegions;
extern NSString * const kTBMerchantKeys;
extern NSString * const kTBAppURLScheme;

// 2
extern NSString * const kTBMerchantKeyDefault;
// 1
extern NSString * const kTBStripeKeys;
// 2
extern NSString * const kTBStripeKeyDefault;

// 0
extern NSString * const kTBAppLogoPaths;
// 1
extern NSString * const kTBImageSizeS;
extern NSString * const kTBImageSizeL;
extern NSString * const kTBImageSizeXXL;

// 0
extern NSString * const kTBAWSS3;
// 1
extern NSString * const kTBAWSS3AppKey;
extern NSString * const kTBAWSS3AppSecret;
extern NSString * const kTBAWSS3BucketName;

// 0
extern NSString * const kTBBookGeneration;
// 1
extern NSString * const kTBTemplateDatabaseName;
extern NSString * const kTBDefaultThemeID;
extern NSString * const kTBUseSameBackgroundImageOnTheSameSpread;
extern NSString * const kTBMaxNumberofImagesPerPage;
extern NSString * const kTBMinNumberofImagesPerPage;
extern NSString * const kTBMaxNumberofImagesPerSpread;
extern NSString * const kTBMinNumberofImagesPerSpread;
extern NSString * const kTBAllowAddOrRemovePage;

// 0
extern NSString * const kTBBehaviorCustomization;
// 1
extern NSString * const kTBRemindUserToOrderWhenClosingBooks;
extern NSString * const kTBEnableAddingText;
extern NSString * const kTBEnablePhotoTray;
extern NSString * const kTBRequireBookTitle;
extern NSString * const kTBShowOptionsOfBuildingPagesManuallyOrAutomatically;
extern NSString * const kTBUseEmptyTemplateForPageWithNoContent;
extern NSString * const kTBLoadProductFromServerWhenPreparingLocalAlbum;
extern NSString * const kTBShowPhotoMenuByDefault;
extern NSString * const kTBPageVCMaxRecommandedTextLenth;

// 0
extern NSString * const kTBCheckoutCustomization;
// 1
extern NSString * const kTBNoCover;
extern NSString * const kTBSendAlbumJSONDictToHostingApp;
extern NSString * const kTBGeneratePageImagesToHostingApp;
extern NSString * const kTBProductSubType;
extern NSString * const kTBProductPreferredTheme;
extern NSString * const kTBProductPreferredSKU;
extern NSString * const kTBProductMaxPageCount;
extern NSString * const kTBProductMinPageCount;
extern NSString * const kTBProductMaxPhotoCount;
extern NSString * const kTBProductMinPhotoCount;
extern NSString * const kTBBookHasInsideCover;
extern NSString * const kTBPreferredUIDirection;
extern NSString * const kTBSendOrderInfoToHostingApp;
extern NSString * const kTBExternalCheckoutType;
extern NSString * const kTBPreferredPageTypeSpread;

// 0
extern NSString * const kTBSocial;
// 1
extern NSString * const kTBSocialWeixinAppID;
extern NSString * const kTBSocialWeixinAppSecret;
extern NSString * const kTBSocialAlipayPartnerID;
extern NSString * const kTBSocialAlipayAccountName;

// 0
extern NSString * const kTBHostingAppInfo;
// 1
extern NSString * const kTBHostingAppName;
extern NSString * const kTBHostingAppIconName;

///---------------------------------------
/// @name Color Customization
///---------------------------------------
// PageVCColor
extern NSString * const kTBPageVCBackgroundColor;
extern NSString * const kTBSDKMessageViewBackgroundColor;

extern NSString * const kTBPageVCPhotoListButtonUnsedPhotoCountLabelTextColor;
extern NSString * const kTBPageVCPhotoListButtonUnsedPhotoCountLabelBackgoundColor;

//Page view's top navigation menu
extern NSString * const kTBPageVCTopMenuBackgroundColor;

extern NSString * const kTBPageVCTopMenuExitButtonColorNormal;
extern NSString * const kTBPageVCTopMenuExitButtonColorHighlighted;

extern NSString * const kTBPageVCTopMenuOrderBookButtonColorNormal;
extern NSString * const kTBPageVCTopMenuOrderBookButtonColorHighlighted;

extern NSString * const kTBPageVCTopMenuOrderBookButtonBgColorNormal;
extern NSString * const kTBPageVCTopMenuOrderBookButtonBgColorHighlighted;

extern NSString * const kTBPageVCTopMenuEditPageButtonColorNormal;
extern NSString * const kTBPageVCTopMenuEditPageButtonColorHighlighted;
extern NSString * const kTBPageVCTopMenuEditPageButtonColorSelected;

extern NSString * const kTBPageVCBottomMenuButtonColorHighlighted;
extern NSString * const kTBPageVCBottomMenuButtonColorNormal;

extern NSString * const kTBPageVCTopMenuRearrangeButtonColorNormal;
extern NSString * const kTBPageVCTopMenuRearrangeButtonColorHighlighted;
extern NSString * const kTBPageVCTopMenuRearrangeButtonColorSelected;

extern NSString * const kTBPageVCTopMenuBuildModeDoneButtonColorNormal;
extern NSString * const kTBPageVCTopMenuBuildModeDoneButtonColorHighlighted;

//    PageView
extern NSString * const kTBPageVCCellHighlightBorderColor;
extern NSString * const kTBPageVCCellEditPopupBackgroundColorNormal;
extern NSString * const kTBPageVCCellEditPopupBackgroundColorHighlighted;

extern NSString * const kTBPageVCCellPageNumberColor;
extern NSString * const kTBPageVCCellRemovePageButtonColorNormal;
extern NSString * const kTBPageVCCellRemovePageButtonColorHighlighted;
extern NSString * const kTBPageVCCellAddPageButtonColorNormal;
extern NSString * const kTBPageVCCellAddPageButtonColorHighlighted;

//   Rearrange
extern NSString * const kTBPageVCRearrangeBackgroundColor;
extern NSString * const kTBPageVCRearrangePageNumberColor;
extern NSString * const kTBPageVCRearrangeMoveForbiddonOverlayColor;
extern NSString * const kTBPageVCRearrangeMoveForbiddonIconColor;

//   PhotoList
extern NSString * const kTBPageVCPhotoListBackgroundColor;
extern NSString * const kTBPageVCPhotoListCollectionViewBackgroundColor;
extern NSString * const kTBPageVCPhotoListAddNewPhotosButtonColorNormal;
extern NSString * const kTBPageVCPhotoListAddNewPhotosButtonColorHighlighted;
extern NSString * const kTBPageVCPhotoListResetPagesButtonColorNormal;
extern NSString * const kTBPageVCPhotoListResetPagesButtonColorHighlighted;
extern NSString * const kTBPageVCPhotoListCloseButtonColorNormal;
extern NSString * const kTBPageVCPhotoListCloseButtonColorHighlighted;
extern NSString * const kTBPageVCPhotoListPromtingMessageColor;

extern NSString * const kTBCheckoutVCButtonColor;

// Store user
extern NSString * const kTBSDKUserDidLoginNotification;
extern NSString * const kTBSDKUserDidLogoutNotification;
