//
//  UIImage+Save.m
//  AtomBook
//
//  Created by Xinrong Guo on 13-10-22.
//
//

#import "UIImage+Save.h"

@implementation UIImage (Save)

- (BOOL)hasAlphaValue {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    
    return (alphaInfo != kCGImageAlphaNoneSkipLast &&
            alphaInfo != kCGImageAlphaNone &&
            alphaInfo != kCGImageAlphaNoneSkipFirst);
}

- (NSData *)toDataWithCompressQuality:(float)quality {
    NSData *data;
    if ([self hasAlphaValue]) {
        data = UIImagePNGRepresentation(self);
    }
    else {
        data = UIImageJPEGRepresentation(self, quality);
    }
    return data;
}

- (BOOL)writeToFile:(NSString *)path withCompressQuality:(float)quality {
    NSData *data = [self toDataWithCompressQuality:quality];
    
//    NSString *dirPath = [path stringByDeletingLastPathComponent];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    
    return [data writeToFile:path atomically:YES];
}

@end
