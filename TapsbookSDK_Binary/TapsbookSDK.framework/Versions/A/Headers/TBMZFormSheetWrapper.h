//
//  TBMZFormSheetWrapper.h
//  TapsbookSDK
//
//  Created by Xinrong Guo on 10/21/15.
//  Copyright © 2015 tapsbook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MZFormSheetController/MZFormSheetController.h>
#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>

@interface TBMZFormSheetWrapper : NSObject

@property (nonatomic, assign) MZFormSheetTransitionStyle transitionStyle;
@property (assign, nonatomic) BOOL shouldDismissOnBackgroundViewTap;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) BOOL shouldCenterVertically;
@property (assign, nonatomic) CGSize presentedFormSheetSize;

//- (void)presentAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

- (void)present:(UIViewController * __nonnull)presentedViewController on:(UIViewController * __nonnull)presentingViewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;


@end
