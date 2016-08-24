//
//  TBSocialManager.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 11/17/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kTBSocialUserID;
extern NSString * const kTBSocialUserNickName;
extern NSString * const kTBSocialUserUnionID;
extern NSString * const kTBSocialUserEmail;
extern NSString * const kTBSocialUserAvatar;

typedef NS_ENUM(NSInteger, TBSocialResultStatus) {
    TBSocialResultStatus_Success = 0,
    TBSocialResultStatus_Failed,
    TBSocialResultStatus_Canceled,
};

typedef void (^TBSocialManagerCompletionBlock)(TBSocialResultStatus status, NSDictionary *result, NSError *error);

@interface TBSocialManager : NSObject

+ (instancetype)sharedInstance;

- (void)setupWithApplication:(UIApplication *)application options:(NSDictionary *)options;

- (void)loginWithViewController:(UIViewController *)viewController completionBlock:(TBSocialManagerCompletionBlock)completionBlock;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
