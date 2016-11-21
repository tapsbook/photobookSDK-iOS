//
//  WZPhotoBookListCell.h
//  Swip
//
//  Created by z on 16-09-06.
//  Copyright (c) 2016年 Ziqi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBSDKAlbum;


@protocol PhotoBookListCellDelegate <NSObject>

@optional
- (void)didClickAlbum:(TBSDKAlbum *)album;   //edit
- (void)didClickDeleteAlbum:(TBSDKAlbum *)album; //delete
- (void)didClickBuyAlbum:(TBSDKAlbum *)album; //buy
@end

@interface PhotoBookListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumCoverImageView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;  //buy
@property (weak, nonatomic) IBOutlet UIButton *productMoreButton;  //delete

@property (weak, nonatomic) TBSDKAlbum * album;
@property (nonatomic, weak) id<PhotoBookListCellDelegate>   delegate;

+ (PhotoBookListCell *)createPhotoBookListCell;
- (void)configureCellWithAlbum:(TBSDKAlbum *)album;
@end


