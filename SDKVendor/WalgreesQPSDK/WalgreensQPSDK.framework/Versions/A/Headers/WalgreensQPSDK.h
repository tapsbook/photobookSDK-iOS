//
//  WalgreensQPSDK.h
//  WalgreensQPSDK
//
/*
 * Copyright Walgreen Co. All rights reserved *
 * Licensed under the Walgreens Developer Program and Portal Terms of Use and API License Agreement.
 * You may not use this file except in compliance with the License.
 * A copy of the API License Agreement can be found on https://developer.walgreens.com.
 *
 * This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing  permissions and limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WAGImageData.h"



/**
 * These are the Success and Failure blocks for Authentication success and failure response
 */
typedef void (^SuccessBlockForNativeApp)(NSString *);
typedef void (^ErrorBlockForNativeApp)(NSError *);

@protocol WAGCheckoutDelegate <NSObject>

@required

/**
 *  These are the delegate methods for authentication success/failure responce
 */
-(void) initSuccessResponse:(NSString*)response;
-(void) didInitFailWithError:(NSError *)error;


/**
 *  These are the delegate methods for image upload success/failure responce
 */
-(void) imageuploadSuccessWithImageData:(WAGImageData *)imageData;
-(void) imageuploadErrorWithImageData:(WAGImageData *)imageData  Error:(NSError *)error;


/**
 *  These are the delegate methods for cartPoster service success/failure responce
 */
-(void) cartPosterSuccessResponse:(NSString*)response;
-(void) didCartPostFailWithError:(NSError *)error;

/**
 *  This will be called when there is any service exception
 */
-(void) didServiceFailWithError:(NSError*)error;

@optional

/**
 *   These are the delegate methods for get the image upload info 
 */
-(void) didFinishBatch;
-(void) getUploadProgress:(float)progress;

@end

@interface WalgreensQPSDK : NSObject <CLLocationManagerDelegate> {
	id <WAGCheckoutDelegate>   __weak delegate;
	CLLocationManager       *locationManager;
	NSString                *cartPosterUrl;
    BOOL                    authenticationStatus;
    
    SuccessBlockForNativeApp successBlockForNativeApplication;
    ErrorBlockForNativeApp errorBlockForNativeApplication;
}

@property(nonatomic, weak) id <WAGCheckoutDelegate> delegate;
@property(nonatomic, strong) NSString               *cartPosterUrl;
@property(nonatomic, assign) BOOL                   authenticationStatus;


/**
 *  Initilize the CheckoutContext class with affliated id , api key and walgreens webservice environment 
 *  Environment = 0 is for staging 
 *  Environment = 1 is for production 
 */
-(id) initWithAffliateId:(NSString*)affIdStr
                  apiKey:(NSString*)apiKey
             environment:(NSInteger)envtype
              appVersion:(NSString*)version __attribute__((deprecated("Use block based callbacks instead delegates")));

/**
 *  Initilize the CheckoutContext class with affliated id, api key, Success and failure blocks and walgreens webservice environment 
 *  Environment = 0 is for staging 
 *  Environment = 1 is for production 
 */
-(id) initWithAffliateId:(NSString*)affIdStr
                  apiKey:(NSString*)apiKey
             environment:(NSInteger)envtype
              appVersion:(NSString*)version
                 success:(void (^)(NSString *string))success
                 failure:(void (^)(NSError *error))failure ;

/**
 *  Initilize the CheckoutContext class with affliated id , api key and walgreens webservice url 
 *  Environment = 0 is for staging 
 *  Environment = 1 is for production 
 */
-(id) initWithAffliateId:( NSString*)affIdStr
                  apiKey:(NSString*)apiKey
              serviceUrl:(NSString*)urlStr
             environment:(NSInteger)envtype
              appVersion:(NSString*)version __attribute__((deprecated("Use block based callbacks instead delegates")));
/**
 *  Initilize the CheckoutContext class with affliated id , api key , Success and failure blocks and walgreens webservice url 
 *  Environment = 0 is for staging 
 *  Environment = 1 is for production 
 */
-(id) initWithAffliateId:( NSString*)affIdStr
                  apiKey:(NSString*)apiKey
              serviceUrl:(NSString*)urlStr
             environment:(NSInteger)envtype
              appVersion:(NSString*)version
                 success:(void (^)(NSString *string))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  initilize the CheckoutContext class with affliated id , api key and walgreens webservice environment 
 *  Environment = 0 is for staging 
 *  Environment = 1 is for production 
 */
-(id) initWithAffliateId:(NSString*)affIdStr
                  apiKey:(NSString*)apiKey
             environment:(NSInteger)envtype
              appVersion:(NSString*)version
          ProductGroupID:(NSString *)productGroupID
             PublisherID:(NSString *)publisherID __attribute__((deprecated("Use block based callbacks instead delegates")));

/**
 *  Initilize the CheckoutContext class with affliated id , api key, Success and failure blocks and walgreens webservice environment 
 *  Environment = 0 is for staging 
 *  Environment = 1 is for production 
 */
-(id) initWithAffliateId:(NSString*)affIdStr
                  apiKey:(NSString*)apiKey
             environment:(NSInteger)envtype
              appVersion:(NSString*)version
          ProductGroupID:(NSString *)productGroupID
             PublisherID:(NSString *)publisherID
                 success:(void (^)(NSString *string))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  This will set the user info into the sdk 
 */
-(void)setUserInfoWith:(NSString *)firstName LastName:(NSString *)lastName Email:(NSString *)email PhoneNo:(NSString *)phoneNo;

/**
 *  This will upload the image into Cloud server and generate the image url 
  The input parameter is generic type , the input data can be assert data or NSData  
 */

-(void) upload:(id)arg __attribute__((deprecated("Use block based callbacks instead delegates")));

/**
 *   Upload method uploads the images into Cloud server and generate the uploaded image url 
 *   The input parameter is generic type , the input data can be assert data or NSData  
 *   Success block 
 *   Failure block 
 */
-(void)upload:(id)arg progressBlock:(void (^)(float))progress successBlock:(void (^)(WAGImageData *))success failureBlock:(void (^)(WAGImageData *, NSError *))failure;

/**
 *  Upload method uploads the images into Cloud server and generate the uploaded image url 
 *  The input parameters are generic type and unique filename, the input data can be assert data or NSData  
 */
-(void) upload:(id)arg filename:(id)fileName __attribute__((deprecated("Use block based callbacks instead delegates")));

/**
 *  Upload method uploads the images into Cloud server and generate the uploaded image url 
 *  The input parameters are generic type and unique filename, the input data can be assert data or NSData  
 *  Success block 
 *  Failure block 
 */
-(void) upload:(id)arg filename:(id)fileName progressBlock:(void (^) (float) )progress successBlock:(void(^)(WAGImageData *imgData))success failureBlock:(void(^)(WAGImageData *imgData, NSError *error))failure;

/* This method can cancel the image upload process */
-(void) cancelImageUpload;

/* This will clear the images from the queue  */
-(void) removeImageFromQueueWithAsset:(ALAsset *)asset;

/**
 *  This api will return the imaximum upload image count...
 */
-(NSInteger) getMaximumImageUploadCount;

/**
 *  This api will return the imaximum upload image count...
 */
-(NSInteger) uploadedImageCount;

/**
 *  This will be clear the uploaded image queue 
 */
-(void) clearImageQueue;

/**
 *  This will be return the image upload status 
 */
-(BOOL) inProgress;

/**
 *  This will call the cartPoster to get the checkout url...
 */
-(void) postCart __attribute__((deprecated("Use block based callbacks instead delegates")));

/**
 *  This will call the cartPoster to get the checkout url with blocks
 *  Success block 
 *  Failure block 
 */
-(void) postCart:(void (^)(NSString *string))success
         failure:(void (^)(NSError *error))failure;
/**
 *  This will add urls into image queue 
 */
-(void) addImageUrl:(NSString*)imgUrl;

/**
 *  Set PreferredStore number or address using this api 
 */
-(void) setPreferredStore:(NSString*)preStore_;

/**
 *   Set iOS device type using this api  Ex: iphone
 */
-(void) setDeviceType:(NSString*) devType;

/**
 *   Get the QP sdk version number using this api
 */
-(NSString*) getSdkVersionInfo;

/**
 *   Set the coupon Code using this api
 */
-(void) setCouponCode:(NSString*)couponCode;

/**
 *   This will Disable the Image Compression. By default Image compression is enabled
 */
-(void) disableImageCompression:(BOOL)isDisabled;
/**
 *   This will Remove FB/Instagram image url into the Queue...
 */
-(void) removeImageFromQueueWithUrl:(NSString *)imgUrl;
/**
 *   Set the Aff Notes using this api
 */
-(void) setAffNotes:(NSString*)affNotes;

@end

