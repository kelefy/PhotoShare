//
//  AppDelegate.m
//  PhotoShare
//
//  Created by kongfanyi on 16/7/13.
//  Copyright © 2016年 dd. All rights reserved.
//

#import "AppDelegate.h"
#import <TuSDKGeeV1/TuSDKGeeV1.h>
#import "RootViewController.h"

#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "UIColor+Viking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化TuSDK
    [TuSDK initSdkWithAppKey:@"965d5c64fe0ceaf7-02-7lryp1"];
    //调试日志
    [TuSDK setLogLevel:lsqLogLevelDEBUG];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    RootViewController *rootVc = [RootViewController new];
    // 初始化根控制器
    self.window.rootViewController = [[TuSDKICNavigationController alloc]initWithRootViewController:rootVc];
    [self.window makeKeyAndVisible];
    
    
    //初始化PGYSDK
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"c9e20899c0461bbd1d4d33212ba26425"];
    [[PgyManager sharedPgyManager] setThemeColor:[UIColor viking]];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"c9e20899c0461bbd1d4d33212ba26425"];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    
    return YES;
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

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
////    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    if (result == FALSE) {
//        //调用其他SDK，例如支付宝SDK等
//    }
//    return result;
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return  [UMSocialSnsService handleOpenURL:url];
//}

@end