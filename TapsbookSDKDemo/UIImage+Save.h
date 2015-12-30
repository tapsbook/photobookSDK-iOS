//
//  UIImage+Save.h
//  AtomBook
//
//  Created by Xinrong Guo on 13-10-22.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Save)

- (BOOL)hasAlphaValue;
- (NSData *)toDataWithCompressQuality:(float)quality;
- (BOOL)writeToFile:(NSString *)path withCompressQuality:(float)quality;

@end
