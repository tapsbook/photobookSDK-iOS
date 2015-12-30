//
//  ALAssetRepresentation+Helper.m
//  TapsbookSDKDemo
//
//  Created by Xinrong Guo on 14-6-27.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import "ALAssetRepresentation+Helper.h"

@implementation ALAssetRepresentation (Helper)

- (NSString *)photoId {
    /*
     The API doesn't provide any method to get a unique identifier from an ALAsset object
     But the [[ALAsset defaultRepresentation] url] method, according to Apple's documentation,
     returns a "persistent URL uniquely identifying the representation."
     
     This URL looks like : assets-library://asset/asset.JPG?id=BFFEB67F-0212-4CB3-844A-D14C0A3FA69F&ext=JPG
     I assume that the string "BFFEB67F-0212-4CB3-844A-D14C0A3FA69F" is unique.
     Let's retrieve it and use it as photoId
     */
    NSString * assetsURLString = [[self url] absoluteString];
    
    // let's retrieve the id in two times.
    // First, let's truncate the string to something similar to : BFFEB67F-0212-4CB3-844A-D14C0A3FA69F&ext=JPG
    NSString * firstDelimiter = @"id=";
    NSRange rangeOfFirstDelimiter = [assetsURLString rangeOfString:firstDelimiter];
    if ( rangeOfFirstDelimiter.location == NSNotFound ) {
    	// if, for some reason, the delimiter was not found, let's return an empty string
        return @"";
    }
    NSUInteger indexOfFirstCharacterOfId = rangeOfFirstDelimiter.location + rangeOfFirstDelimiter.length;
    assetsURLString = [assetsURLString substringFromIndex:indexOfFirstCharacterOfId];
    
    // Now, let's get the substring until the "&ext=???" part
    NSString * secondDelimiter = @"&ext";
    NSRange rangeOfSecondDelimiter = [assetsURLString rangeOfString:secondDelimiter];
    NSUInteger indexOfSecondDelimiter = rangeOfSecondDelimiter.location;
    if ( indexOfSecondDelimiter == NSNotFound ){
     	// if, for some reason, the delimiter was not found, let's return an empty string
        return @"";
    }
    
    NSString * photoId = [assetsURLString substringToIndex:indexOfSecondDelimiter];
    
    return photoId;
}

@end
