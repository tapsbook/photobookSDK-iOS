//
//  PhotoCell.m
//  TapsbookSDKDemo
//
//  Created by Xinrong Guo on 14-6-27.
//  Copyright (c) 2014年 tapsbook. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageOverlayView;

@end

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageOverlayView.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.checkMarkImageView.hidden = !selected;
}

- (void)setImageAlreadyUsed:(BOOL)used {
    self.imageOverlayView.hidden = !used;
    self.checkMarkImageView.hidden = !used;
}


@end
