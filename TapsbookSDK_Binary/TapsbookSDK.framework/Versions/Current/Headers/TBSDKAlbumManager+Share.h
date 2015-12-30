//
//  TBSDKAlbumManager+Share.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 14-5-22.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@interface TBSDKAlbumManager (Share)

- (void)shareSDKAlbum:(TBSDKAlbum *)sdkAlbum presentOnViewController:(UIViewController *)viewController completionBlock:(void (^)(BOOL success, NSError *error))completionBlock;

@end
