//
//  PhotoListViewController.h
//  TapsbookSDKDemo
//
//  Created by Xinrong Guo on 14-6-27.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapsbookSDK/TapsbookSDK.h>

typedef NS_ENUM(NSInteger, PhotoListViewControllerMode) {
    PhotoListViewControllerMode_CreateAlbum,
    PhotoListViewControllerMode_AddPhoto,
};

@interface PhotoListViewController : UIViewController

@property (assign, nonatomic) PhotoListViewControllerMode mode;
@property (strong, nonatomic) TBSDKAlbum *sdkAlbum;
@property (strong, nonatomic) NSArray *existingTBImages;
@property (strong, nonatomic) void (^tb_completionBlock)(NSArray *newImages);

@end
