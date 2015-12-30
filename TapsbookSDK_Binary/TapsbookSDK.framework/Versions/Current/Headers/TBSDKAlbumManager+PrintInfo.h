//
//  TBSDKAlbumManager+PrintInfo.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 9/22/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@interface TBSDKAlbumManager (PrintInfo)

- (void)loadPrintInfosForThemeID:(long long)themeID completionBlock:(void (^)(NSArray *result, NSError *error))completionBlock;

@end
