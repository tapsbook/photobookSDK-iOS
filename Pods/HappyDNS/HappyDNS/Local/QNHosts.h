//
//  QNHosts.h
//  HappyDNS
//
//  Created by bailong on 15/6/23.
//  Copyright (c) 2015年 Qiniu Cloud Storage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNResolverDelegate.h"

@interface QNHosts : NSObject

- (NSArray *)query:(QNDomain *)domain networkInfo:(QNNetworkInfo *)netInfo;
- (void)put:(NSString *)domain ip:(NSString *)ip;
- (void)put:(NSString *)domain ip:(NSString *)ip provider:(int)provider;
- (instancetype)init;
@end
