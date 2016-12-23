//
//  PhotoBookListViewController.h
//
//

#import <UIKit/UIKit.h>
#import "DemoBaseViewController.h"


@interface PhotoBookListViewController : DemoBaseViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *localAlbums;

@end
