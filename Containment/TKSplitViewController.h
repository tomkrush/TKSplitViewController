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

- (void)presentMasterViewController:(BOOL)animate;
- (void)dismissMasterViewController:(BOOL)animate;

@end
