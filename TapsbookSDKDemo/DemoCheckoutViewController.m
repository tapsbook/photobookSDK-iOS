//
//  CheckoutViewController.m
//  TapsbookSDKDemo
//
//  Created by Xinrong Guo on 12/30/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import "DemoCheckoutViewController.h"
#import <TapsbookSDK/TapsbookSDK.h>

@interface DemoCheckoutViewController ()

@end

@implementation DemoCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleCheckoutButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[TBSDKAlbumManager sharedInstance] dismissTBSDKViewControllersAnimated:YES completion:nil];
    }];
}

@end
