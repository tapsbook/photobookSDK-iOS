//
//  WAGImageData.h
//  QuickPrintsSDK
//
//  Created by Walgreens on 13/03/12.
/*
 * Copyright 2012 Walgreen Co. All rights reserved *
 * Licensed under the Walgreens Developer Program and Portal Terms of Use and API License Agreement, Version 1.0 (the “Terms of Use”)
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at https://developer.walgreens.com/page/terms-use
 *
 * This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing  permissions and limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

#define UploadStateInQueue @"UploadStateInQueue"  // In queue, waiting for uploading
#define UploadStateUploading @"UploadStateUploading"  // Uploading starts
#define UploadStateSuccess @"UploadStateSuccess"    // Successfully uploaded
#define UploadStateFailed @"UploadStateFailed"      // Upload failed (No Network or other)
#define UploadStateCancelled @"UploadStateCancelled"  // Cancelled the uploading process



@interface WAGImageData : NSObject{
    
    NSString    *uploadState;  // State of the uploading image
    UIImage     *imgSource;    // If the image is of NSData , the value will be set to nil once it is uploaded to server because of memory issue. further modifiaction can be done using the image key
    
    ALAsset     *imgAsset;  // Local image reference
    NSString    *imageKey;  // Image key is to map with Image data object.
    NSString    *fileName; // filename of the image data.
}
@property (nonatomic, strong) NSString  *fileName;
@property (nonatomic, strong) NSString  *uploadState;
@property (nonatomic, strong) UIImage   *imgSource;
@property (nonatomic, strong) ALAsset   *imgAsset;
@property (nonatomic, strong) NSString  *imageKey;

@property (nonatomic, strong) NSData  *imageData;

@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) BOOL isDuplicate;


-(NSString*)getTheFinalURL:(id)ID;
-(NSString*)setTheFinalURL:(NSString*)URL WithID:(id)ID;


@end
