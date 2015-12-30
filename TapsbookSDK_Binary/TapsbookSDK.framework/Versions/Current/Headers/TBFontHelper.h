//
//  TBFontHelper.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 14-8-28.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBFontHelper : NSObject

@property (readonly, nonatomic) NSArray *fontNames;
@property (readonly, nonatomic) NSArray *fontsForPage;

+ (instancetype)sharedInstance;
- (void)prepareSDKFonts;

@end
