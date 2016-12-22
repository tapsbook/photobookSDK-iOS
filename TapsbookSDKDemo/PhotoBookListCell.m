//
//  WZPhotoBookListCell.m
//  Swip
//
//  Created by z on 16-09-06.
//  Copyright (c) 2016年 Ziqi Wu. All rights reserved.
//

#import "PhotoBookListCell.h"
#import <TapsbookSDK/TapsbookSDK.h>

@interface PhotoBookListCell () {
    
}

@end

@implementation PhotoBookListCell

+ (PhotoBookListCell *)createPhotoBookListCell
{
    PhotoBookListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoBookListCell" owner:self options:nil] lastObject];
    
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.buyButton setTitle:NSLocalizedString(@"booklist-buy", @"") forState:UIControlStateNormal];
    [self.productMoreButton setTitle:NSLocalizedString(@"booklist-delete", @"") forState:UIControlStateNormal];

    self.mainView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.mainView.layer.shadowOffset = CGSizeMake(0, 0);
    self.mainView.layer.shadowOpacity = 0.15;
    self.mainView.layer.shadowRadius = 6;
    
    UITapGestureRecognizer * singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAlbum)];
    singleTapGesture.numberOfTapsRequired = 1;
    [self.mainView addGestureRecognizer:singleTapGesture];
}

#pragma mark - handle events
- (void)didClickAlbum {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAlbum:)]) {
        [self.delegate didClickAlbum:self.album];
    }
}

- (IBAction)deleteAlbum:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDeleteAlbum:)]) {
        [self.delegate didClickDeleteAlbum:self.album];
    }
}

- (IBAction)didClickBuyButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBuyAlbum:)]) {
        [self.delegate didClickBuyAlbum:self.album];
    }
}


#pragma mark - UI updates

- (void)configureCellWithAlbum:(TBSDKAlbum *)album
{
    UIImage *image = [UIImage imageWithContentsOfFile:album.coverPageImagePath];
    self.albumCoverImageView.image = image;
    self.album = album;
}

@end
