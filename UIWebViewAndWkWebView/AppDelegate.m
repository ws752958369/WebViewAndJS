//
//  AppDelegate.m
//  UIWebViewAndWkWebView
//
//  Created by wangsheng on 2019/3/4.
//  Copyright © 2019 wangsheng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //scheme://host:port/path
    NSString *urlPath = @"https://www.baidu.com:8080/component/index.js?username=1&pwd=2&page=index.js";
    NSURL *url = [NSURL URLWithString:urlPath];
    
    if ([urlPath.lastPathComponent isEqualToString:@"index.js"]) {
        NSLog(@"%@",url.URLByDeletingLastPathComponent);
    }
    
    NSRange range = [urlPath rangeOfString:@"index.js"];
    if (range.location != NSNotFound) {
        NSLog(@"range:%@",NSStringFromRange(range));
    }
    
    
    NSLog(@"--------------url scheme-----------------");
    
    NSLog(@"scheme:%@",url.scheme);
    NSLog(@"host:%@",url.host);
    NSLog(@"port:%@",url.port);
    NSLog(@"path:%@",url.path);
    NSLog(@"pathExtension:%@",url.pathExtension);
    NSLog(@"pathComponents:%@",url.pathComponents);
    NSLog(@"lastPathComponent:%@",url.lastPathComponent);
    
    NSLog(@"--------------url scheme-----------------");
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
