//
//  TBSDKUser.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 12/1/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBSDKUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *referralCode;
@property (assign, nonatomic) BOOL referralUsed;

+ (TBSDKUser *)currentUser;

@end
