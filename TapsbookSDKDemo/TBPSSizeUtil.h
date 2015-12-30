//
//  TBPSSizeUtil.h
//  Swip
//
//  Created by Xinrong Guo on 6/4/15.
//  Copyright (c) 2015 Ziqi Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TBPSImageSize) {
    TBPSImageSize_s = 0,
    TBPSImageSize_l = 2,
    TBPSImageSize_xxl = 4,
};

@interface TBPSSizeUtil : NSObject

+ (CGSize)sizeFromPSImageSize:(TBPSImageSize)imageSize;

+ (NSString *)stringOfSize:(TBPSImageSize)imageSize;
+ (NSString *)prefixStringOfSize:(TBPSImageSize)imageSize;
+ (NSString *)suffixStringOfSize:(TBPSImageSize)imageSize;

+ (CGSize)convertSize:(CGSize)originSize toSize:(CGSize)targetSize contentMode:(UIViewContentMode)contentMode;

@end
