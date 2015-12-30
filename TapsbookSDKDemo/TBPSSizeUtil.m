//
//  TBPSSizeUtil.m
//  Swip
//
//  Created by Xinrong Guo on 6/4/15.
//  Copyright (c) 2015 Ziqi Wu. All rights reserved.
//

#import "TBPSSizeUtil.h"

@implementation TBPSSizeUtil

+ (CGSize)sizeFromPSImageSize:(TBPSImageSize)imageSize {
    CGSize size;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat maxScreenDim = MAX(screenSize.width, screenSize.height) * 0.6;
    
    if (TBPSImageSize_xxl == imageSize) {
        size = CGSizeMake(10000, 10000);
    }
    else if (TBPSImageSize_l == imageSize) {
        size = CGSizeMake(maxScreenDim * scale, maxScreenDim * scale);
    }
    else {
        size = CGSizeMake(100 * scale, 100 * scale);
    }
    
    return size;
}

+ (NSString *)stringOfSize:(TBPSImageSize)imageSize {
    static NSString *xxlString = @"xxl";
    static NSString *lString = @"l";
    static NSString *sString = @"s";
    
    NSString *result;
    
    if (TBPSImageSize_xxl == imageSize) {
        result = xxlString;
    }
    else if (TBPSImageSize_l == imageSize) {
        result = lString;
    }
    else {
        result = sString;
    }
    
    return result;
}

+ (NSString *)prefixStringOfSize:(TBPSImageSize)imageSize {
    static NSString *xxlPrefix = @"xxl_";
    static NSString *lPrefix = @"l_";
    static NSString *sPrefix = @"s_";
    
    NSString *result;
    
    if (TBPSImageSize_xxl == imageSize) {
        result = xxlPrefix;
    }
    else if (TBPSImageSize_l == imageSize) {
        result = lPrefix;
    }
    else {
        result = sPrefix;
    }
    
    return result;
}

+ (NSString *)suffixStringOfSize:(TBPSImageSize)imageSize {
    static NSString *xxlSuffix = @"_xxl";
    static NSString *lSuffix = @"_l";
    static NSString *sSuffix = @"_s";
    
    NSString *result;
    
    if (TBPSImageSize_xxl == imageSize) {
        result = xxlSuffix;
    }
    else if (TBPSImageSize_l == imageSize) {
        result = lSuffix;
    }
    else {
        result = sSuffix;
    }
    
    return result;
}

+ (CGSize)convertSize:(CGSize)originSize toSize:(CGSize)targetSize contentMode:(UIViewContentMode)contentMode {
    CGFloat horizontalRatio = targetSize.width / originSize.width;
    CGFloat verticalRatio = targetSize.height / originSize.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %zd", contentMode];
    }
    
    CGSize newSize = CGSizeMake(originSize.width * ratio, originSize.height * ratio);
    
    return newSize;
}

@end
