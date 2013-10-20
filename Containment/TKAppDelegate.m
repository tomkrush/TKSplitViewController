//
//  TKAppDelegate.m
//  TKSplitViewController
//
//  Created by Tom Krush on 11/11/12.
//  Copyright (c) 2012 Tom Krush. All rights reserved.
//

#import "TKAppDelegate.h"
#import "TKSampleMasterViewController.h"
#import "TKSampleDetailViewController.h"

@implementation TKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    TKSplitViewController *splitViewController = [[TKSplitViewController alloc] init];
    splitViewController.delegate = self;
    
    UIViewController *testController = [[TKSampleMasterViewController alloc] init];
    UIViewController *testController2 = [[TKSampleMasterViewController alloc] init];
    
    UINavigationController *masterViewController = [[UINavigationController alloc] initWithRootViewController:testController];
    [masterViewController pushViewController:testController2 animated:NO];
    
    masterViewController.view.backgroundColor = [UIColor grayColor];
    
    UIViewController *detailViewController = [[TKSampleDetailViewController alloc] init];
    detailViewController.view.backgroundColor = [UIColor whiteColor];
    
    splitViewController.viewControllers = @[masterViewController, detailViewController];
    
    self.window.rootViewController = splitViewController;
    
    return YES;
}

- (void)splitViewController:(TKSplitViewController *)splitViewController didPresentMasterViewController:(UIViewController *)masterViewController
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];

    splitViewController.detailViewController.view.backgroundColor = color;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
