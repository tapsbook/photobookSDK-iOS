//
//  PhotoBookListViewController.h
//
//

#import <UIKit/UIKit.h>

@interface PhotoBookListViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *localAlbums;

@end
