//
//  UIViewController+TBMZFormSheetWrapper.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 10/21/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TBMZFormSheetWrapper)

- (void)tbmz_dismissViewControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
- (void)tbmz_changeFormSheetSize:(CGSize)size;

@end
