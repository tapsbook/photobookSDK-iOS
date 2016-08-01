//
//  TBSDKAlbumManager+Coupon.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 3/9/16.
//  Copyright © 2016 tapsbook. All rights reserved.
//

#import <TapsbookSDK/TapsbookSDK.h>

@protocol TBCouponListViewControllerProtocol <NSObject>

@property (strong, nonatomic) void (^didSelectObjectBlock)(id object);

@end

@interface TBSDKAlbumManager (Coupon)

- (void)addCouponCode:(NSString *)couponCode completion:(void (^)(BOOL valid, BOOL alreadyExisted, NSDictionary *info, NSError *error))completion;
- (void)addReferralCode:(NSString *)referralCode completion:(void (^)(BOOL valid, BOOL alreadyExisted, NSDictionary *info, NSError *error))completion;

- (UIViewController<TBCouponListViewControllerProtocol> *)couponListViewController;

- (void)applyCouponToNextCreatedAlbum:(NSDictionary *)coupon;
- (void)clearCoupon;

@end
