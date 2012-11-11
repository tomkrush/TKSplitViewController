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
}

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end
