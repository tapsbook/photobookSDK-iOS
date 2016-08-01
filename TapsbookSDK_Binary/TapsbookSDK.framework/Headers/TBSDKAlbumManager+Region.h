//
//  TBSDKAlbumManager+Region.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 4/14/15.
//  Copyright (c) 2015 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@interface TBSDKAlbumManager (Region)

- (TBSDKRegion)currentRegion;

- (BOOL)isCurrentRegionValid;

- (BOOL)isRegionValid:(TBSDKRegion)region;

- (NSString*)localizedCurrentRegion;

- (void)setRegion:(TBSDKRegion)region alertIfChanging:(BOOL)shouldAlert withCompletionBlock:(void (^)(TBSDKRegion selectedRegion))completionBlock;

- (void)showRegionSelectionViewOnViewController:(UIViewController *)viewController completionBlock:(void (^)(TBSDKRegion selectedRegion))completionBlock;

- (void)showRegionSelectionViewOnViewController:(UIViewController *)viewController passthroughIfAlreadySelected:(BOOL)passthroughIfAlreadySelected completionBlock:(void (^)(TBSDKRegion selectedRegion))completionBlock;

@end
