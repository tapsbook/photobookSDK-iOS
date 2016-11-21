//
//  PhotoCell.h
//  TapsbookSDKDemo
//
//  Created by Xinrong Guo on 14-6-27.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)setImageAlreadyUsed:(BOOL)used;

@end
