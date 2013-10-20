//
//  TKRevealViewController.h
//  TKSplitViewController
//
//  Created by Tom Krush on 11/11/12.
//  Copyright (c) 2012 Tom Krush. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKSplitViewController : UIViewController {
    CGPoint _initialTouch;
    BOOL _locked;
    CGFloat _elasticity;
    CGFloat _masterViewWidth;
}

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) CGFloat elasticity;
@property (nonatomic) CGFloat masterViewWidth;
@property (nonatomic, readonly) UIView *statusBarView;
@property (weak) id delegate;

- (UIViewController *)masterViewController;
- (UIViewController *)detailViewController;

- (void)presentMasterViewController:(BOOL)animate;
- (void)dismissMasterViewController:(BOOL)animate;
- (BOOL)isMasterViewControllerPresented;

@end


@protocol TKSplitViewControllerDelegate <NSObject>

@optional

- (void)splitViewController:(TKSplitViewController *)splitViewController didPresentMasterViewController:(UIViewController *)masterViewController;
- (void)splitViewController:(TKSplitViewController *)splitViewController willPresentMasterViewController:(UIViewController *)masterViewController;

- (void)splitViewController:(TKSplitViewController *)splitViewController didDismissMasterViewController:(UIViewController *)masterViewController;
- (void)splitViewController:(TKSplitViewController *)splitViewController willDismissMasterViewController:(UIViewController *)masterViewController;

@end