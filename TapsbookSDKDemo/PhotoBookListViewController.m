//
//  PhotoBookListViewController.m
//  Swip
//
//  Created by z on 16-09-06.
//  Copyright (c) 2016 Ziqi Wu. All rights reserved.
//

#import "PhotoBookListViewController.h"
#import "PhotoBookListCell.h"
#import <TapsbookSDK/TapsbookSDK.h>

#import <Photos/Photos.h>
#import "MBProgressHUD.h"
#import "TZImagePickerController.h"

@interface PhotoBookListViewController()<UITableViewDataSource, UITableViewDelegate,TBSDKAlbumManagerDelegate, PhotoBookListCellDelegate, TZImagePickerControllerDelegate>

@property (strong, nonatomic) void (^tb_completionBlock)(NSArray *newImages);
@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, assign) ViewControllerMode mode;
@property (weak, nonatomic) IBOutlet UILabel *noBookLabel;

@end

@implementation PhotoBookListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"booklist-title", @"");
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
    [self reloadPhotoBooks];
         
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"nav-back"]
                                             style:UIBarButtonItemStylePlain
                                             target:self action:@selector(goBack)];
    
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
}

#pragma mark - PhotoListCellDelegate

- (void)didClickBuyAlbum:(TBSDKAlbum *)album {
    [[TBSDKAlbumManager sharedInstance] loadImagesOfSDKAlbum:album completionBlock:^(BOOL success, NSError *error) {
        
        if (success) {
            [self loadImagesAndOpenAlbum:album printDirectly:YES];
        }
        else {
            //handle error
        }
    }];
}

- (void)didClickAlbum:(TBSDKAlbum *)album {
    [[TBSDKAlbumManager sharedInstance] loadImagesOfSDKAlbum:album completionBlock:^(BOOL success, NSError *error) {
        
        if (success) {
            [self loadImagesAndOpenAlbum:album printDirectly:NO];
        }
        else {
            //handle error
        }
    }];
}

- (void)didClickDeleteAlbum:(TBSDKAlbum *)album {
    [self deleteSDKAlbum:album];
}


#pragma mark - Override
- (NSMutableArray *)albums
{
    if (!_albums) {
        _albums = [[NSMutableArray alloc] init];
    }
    return _albums;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.albums.count > 0) {
        self.noBookLabel.hidden = YES;
    }
    
    return [self.albums count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 358;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    PhotoBookListCell *cell = (PhotoBookListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [PhotoBookListCell createPhotoBookListCell];
    }
    cell.delegate = self;
    
    [cell configureCellWithAlbum:self.albums[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - Private
- (void)reloadPhotoBooks
{
    [self.albums removeAllObjects];
    TBSDKAlbumManager *manager = [TBSDKAlbumManager sharedInstance];
    manager.delegate = self;
    [manager allSDKAlbumsWithCompletionBlock:^(BOOL success, NSArray *sdkAlbums, NSError *error) {
        if (success) {
            [self.albums removeAllObjects];
            NSEnumerator * enu = [sdkAlbums reverseObjectEnumerator];
            TBSDKAlbum *a;
            while ((a = [enu nextObject])) {
                if (a.numberOfPages > 0) {
                    [self.albums addObject:a];
                }
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)deleteSDKAlbum:(TBSDKAlbum *)album {
    [[TBSDKAlbumManager sharedInstance] removeSDKAlbum:album];
    
    NSInteger index = [self.albums indexOfObject:album];
    NSIndexPath *removedBook = [NSIndexPath indexPathForRow:index inSection:0];
    [self.albums removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[removedBook] withRowAnimation:UITableViewRowAnimationFade];
    
    if (self.albums.count == 0) {
        self.noBookLabel.hidden = NO;
    }
}


//reload images if needed because user may clean cache
- (void)loadImagesAndOpenAlbum:(TBSDKAlbum*)album printDirectly:(BOOL)shouldPrintDirectly {
    NSArray *tbImages = album.images;
    
    //convert tbImages to PHAssets
    NSMutableArray *selectedAssets = [NSMutableArray new];
    if (tbImages.count==0) {
        return;
    } else {
        for (TBImage * tbImage in tbImages) {
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[tbImage.identifier] options:nil];
            [selectedAssets addObject:result.firstObject];
        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = NSLocalizedString(@"loader-reload", @"");
    hud.dimBackground = YES;
    [self convertAssetsToTBImages:selectedAssets];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hide:YES];
        [[TBSDKAlbumManager sharedInstance] openSDKAlbum:album presentOnViewController:self.navigationController shouldPrintDirectly:NO];
    });
}


#pragma mark - TBSDK

//handle the + (add photo) function of the SDK
- (UIViewController *)photoSelectionViewControllerInstanceForAlbumManager:(TBSDKAlbumManager *)albumManager withSDKAlbum:(TBSDKAlbum *)sdkAlbum existingTBImages:(NSArray *)existingTBImages maxPhotoCount:(NSInteger)maxPhotoCount allowMultiple:(BOOL)allowMultiple completionBlock:(void (^)(NSArray *))completionBlock
{
    self.mode = ViewControllerMode_AddPhoto;
    self.tb_completionBlock = completionBlock;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:20 delegate:self];
    imagePickerVc.autoDismiss = NO;
    imagePickerVc.allowPickingVideo = NO;
    return imagePickerVc;
}

- (void)albumManager:(TBSDKAlbumManager *)albumManager didFinishEditingSDKAlbum:(TBSDKAlbum *)sdkAlbum{
    //do some album clean up, e.g. clean up image cache if needed
    [self reloadPhotoBooks];
}

@end
