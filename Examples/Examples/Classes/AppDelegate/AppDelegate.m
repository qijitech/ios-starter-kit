//
//  AppDelegate.m
//  Examples
//
//  Created by Hammer on 1/18/16.
//  Copyright © 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKNetworkConfig.h>
#import <FLEX/FLEXManager.h>
#import "AppDelegate.h"
#import "QJConfig.h"
#import "QJFeedsViewController.h"
#import "QJFeedsPageViewController.h"
#import "UIColor+QJ.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor qj_backgroundColor];

  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

  // init network config
  [SKNetworkConfig sharedInstance].baseUrl = kBaseURL;
  [SKNetworkConfig sharedInstance].accept = kBaseURL;
  [SKNetworkConfig sharedInstance].perPage = 5;

//  QJFeedsViewController *rootController = [QJFeedsViewController new];
  QJFeedsPageViewController *rootController = [QJFeedsPageViewController new];
  UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:rootController];
  self.window.rootViewController = navCtrl;
  [self.window makeKeyAndVisible];

  [self setupFLEXManager];

  return YES;
}

// 初始化debug工具
- (void)setupFLEXManager {
#ifdef DEBUG
  [[FLEXManager sharedManager] showExplorer];
#endif

}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
