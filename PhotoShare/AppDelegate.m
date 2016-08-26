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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化TuSDK
    [TuSDK initSdkWithAppKey:@"dcac44cbea40b62a-00-m54up1"];
    //调试日志
    [TuSDK setLogLevel:lsqLogLevelDEBUG];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    RootViewController *rootVc = [RootViewController new];
    // 初始化根控制器
    self.window.rootViewController = [[TuSDKICNavigationController alloc]initWithRootViewController:rootVc];
    [self.window makeKeyAndVisible];
    
    return YES;
    
    //初始化友盟ShareSDK
    //    [UMSocialData setAppKey:@"57861cdfe0f55a1107003adf"];
    
    //分享到line，只能分享纯文本消息或者纯图片消息
    //    [UMSocialLineHandler openLineShare:UMSocialLineMessageTypeImage];
    //Instagram
    //    [UMSocialInstagramHandler openInstagramWithScale:NO paddingColor:[UIColor blackColor]];
    //设置微信AppId、appSecret，分享url
    //    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    //    [UMSocialQQHandler setQQWithAppId:@"1105498423" appKey:@"enkvbkYjV15Th2uO" url:@"http://img1.imgtn.bdimg.com/it/u=133570051,1582450962&fm=21&gp=0.jpg"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    //    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"532748952"
    //                                              secret:@"ec5ed105e6a0f581698fff749e10b65e"
    //                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //分享到whatsapp，只能分享纯文本消息或者纯图片消息
    //    [UMSocialWhatsappHandler openWhatsapp:UMSocialWhatsappMessageTypeImage];
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
