//
//  TBSDKAlbumManager+Remote.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 14-7-22.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@interface TBSDKAlbumManager (Remote)

- (BOOL)openRemoteAlbumWithUUID:(NSString *)uuid presentOnViewController:(UIViewController *)viewController;

@end
