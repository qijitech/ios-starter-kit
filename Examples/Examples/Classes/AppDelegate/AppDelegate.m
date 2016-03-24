//
//  AppDelegate.m
//  Examples
//
//  Created by Hammer on 1/18/16.
//  Copyright © 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKNetworkConfig.h>
#import "AppDelegate.h"
#import "Profile.h"
#import "KeyFeedViewController.h"
#import "FetchedKeyFeedViewController.h"
#import "FetchedPageFeedViewController.h"
#import "PageFeedViewController.h"
#import "MasonryViewController.h"
#import "TestViewController.h"
#import "AuthController.h"

//#if DEBUG
#import <FLEX/FLEXManager.h>
#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
//#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor grayColor];


    // init network config
    [SKNetworkConfig sharedInstance].baseUrl = kBaseURL;
    [SKNetworkConfig sharedInstance].accept = kBaseURL;

//    AuthController *controller = [[AuthController alloc] init];
//    FetchedKeyFeedViewController *controller = [[FetchedKeyFeedViewController alloc] init];
//    FetchedPageFeedViewController *controller = [[FetchedPageFeedViewController alloc] init];
//    KeyFeedViewController *controller = [[KeyFeedViewController alloc] init];
    PageFeedViewController *controller = [[PageFeedViewController alloc] init];
//    MasonryViewController *controller = [[MasonryViewController alloc] init];
//    TestViewController *controller = [[TestViewController alloc] init];

    UINavigationController *rootController = [UINavigationController new];
    [rootController addChildViewController:controller];

    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];

    [self setupFLEXManager];

#ifdef DEBUG
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    [[AFNetworkActivityLogger sharedLogger] startLogging];
#endif

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
