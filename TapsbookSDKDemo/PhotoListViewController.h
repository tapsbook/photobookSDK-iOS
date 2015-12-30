//
//  PhotoListViewController.h
//  TapsbookSDKDemo
//
//  Created by Xinrong Guo on 14-6-27.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhotoListViewControllerMode) {
    PhotoListViewControllerMode_CreateAlbum,
    PhotoListViewControllerMode_AddPhoto,
};

@interface PhotoListViewController : UIViewController

@property (assign, nonatomic) PhotoListViewControllerMode mode;

@end
