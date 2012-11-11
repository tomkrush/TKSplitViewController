//
//  TKRevealViewController.m
//  TKSplitViewController
//
//  Created by Tom Krush on 11/11/12.
//  Copyright (c) 2012 Tom Krush. All rights reserved.
//

#import "TKSplitViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TKSplitViewController ()

- (UIViewController *)masterViewController;
- (UIViewController *)detailViewController;
- (void)drag:(UIPanGestureRecognizer *)gesture;

@end

@implementation TKSplitViewController

@synthesize viewControllers = _viewControllers;
@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize masterViewWidth;
@synthesize elasticity;

- (id)init
{
    if ( self = [super init] )
    {
        self.masterViewWidth = 320.0f;
        self.elasticity = 20.0f;
    }
    
    return self;
}

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if ( ! _panGestureRecognizer )
    {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        _panGestureRecognizer.maximumNumberOfTouches = 1;
    }
    
    return _panGestureRecognizer;
}

- (void)presentMasterViewController:(BOOL)animate
{
    self.masterViewController.view.hidden = NO;

    if ( animate )
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.detailViewController.view.frame;
            frame.origin.x = self.masterViewWidth;
            self.detailViewController.view.frame = frame;
        }];
    }
    else
    {
        CGRect frame = self.detailViewController.view.frame;
        frame.origin.x = self.masterViewWidth;
        self.detailViewController.view.frame = frame;
    }
}

- (void)dismissMasterViewController:(BOOL)animate
{
    self.masterViewController.view.hidden = NO;

    if ( animate )
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.detailViewController.view.frame;
            frame.origin.x = 0;
            self.detailViewController.view.frame = frame;
        }];
    }
    else
    {
        CGRect frame = self.detailViewController.view.frame;
        frame.origin.x = 0;
        self.detailViewController.view.frame = frame;
    }
}

- (void)drag:(UIPanGestureRecognizer *)gesture
{
    if ( [gesture numberOfTouches] == 1 )
    {
        CGPoint touch = [gesture locationOfTouch:0 inView:self.detailViewController.view];

        if ( gesture.state == UIGestureRecognizerStateBegan)
        {            
            _initialTouch = touch;
            _locked = NO;
            self.masterViewController.view.hidden = NO;
        }
        
        if ( gesture.state == UIGestureRecognizerStateChanged)
        {            
            CGFloat offset = self.detailViewController.view.frame.origin.x + (touch.x - _initialTouch.x);
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            
            _locked = NO;

            if ( offset >= (self.masterViewWidth / 2) )
            {
                _locked = YES;
                
                if ( offset >= (self.masterViewWidth + self.elasticity) )
                {
                    offset = (self.masterViewWidth + self.elasticity);
                }
            }
            else if ( offset <= 0 )
            {
                offset = 0;
            }
            
            CGRect frame = self.detailViewController.view.frame;
            frame.origin.x = offset;
            self.detailViewController.view.frame = frame;
            
            [CATransaction commit];
        }
    }
    
    if ( gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        if ( _locked == NO)
        {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.detailViewController.view.frame;
                frame.origin.x = 0;
                self.detailViewController.view.frame = frame;
            } completion:^(BOOL finished) {
                self.masterViewController.view.hidden = YES;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.detailViewController.view.frame;
                frame.origin.x = self.masterViewWidth;
                self.detailViewController.view.frame = frame;
            }];
        }
    }
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if ( [viewControllers count] != 2)
    {
        [NSException raise:@"Invalid view controller count" format:@"Must be supplied 2 view controllers. %d supplied", [viewControllers count]];
    }

    // Lets not do extra work shall we
    if ( [self.childViewControllers isEqualToArray:viewControllers] )
    {
        return;
    }
    
    if ( [self.childViewControllers count] )
    {
        for ( UIViewController *viewController in self.childViewControllers )
        {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    for ( UIViewController *viewController in viewControllers )
    {    
        [viewController willMoveToParentViewController:self];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }

    [self.view addSubview:self.masterViewController.view];
    self.masterViewController.view.hidden = YES;
    
    [self.view addSubview:self.detailViewController.view];
    

    self.detailViewController.view.layer.cornerRadius = 5.0;
    
    CALayer *layer = self.detailViewController.view.layer;
	layer.masksToBounds = NO;
	layer.shadowColor = [UIColor blackColor].CGColor;
	layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	layer.shadowOpacity = 1.0f;
	layer.shadowRadius = 3.0;
    
    [self.view setNeedsLayout];
}

- (UIViewController *)masterViewController
{
    if ( [self.childViewControllers count] == 2)
    {
        return [self.childViewControllers objectAtIndex:0];
    }

    return nil;
}

- (UIViewController *)detailViewController
{
    if ( [self.childViewControllers count] == 2)
    {
        return [self.childViewControllers objectAtIndex:1];
    }

    return nil;
}

- (void)viewDidLayoutSubviews
{
    self.masterViewController.view.frame = CGRectMake(0, 0, self.masterViewWidth, self.view.bounds.size.height);
    
    CGRect detailFrame = self.view.bounds;
    
    if ( _locked )
    {
        detailFrame.origin.x += self.masterViewWidth;
    }
    
    CALayer *layer = self.detailViewController.view.layer;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:layer.bounds cornerRadius:5.0];
	layer.shadowPath = shadowPath.CGPath;

    self.detailViewController.view.frame = detailFrame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view removeGestureRecognizer:self.panGestureRecognizer];
}

- (NSArray *)viewControllers
{
    return self.childViewControllers;
}

@end
