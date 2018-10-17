//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/BabyPigAnimation
//
//  AppDelegate.m
//  BabyPigAnimation
//
//  Created by 高军 on 2018/3/27.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "StudyViewController.h"
#import "ImagePickerController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    ViewController *vc = [[ViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.title = @"动画";
    

    StudyViewController *studyVC1 = [[StudyViewController alloc] init];
    UINavigationController *naVC1 = [[UINavigationController alloc] initWithRootViewController:studyVC1];
    
    studyVC1.title = @"动画学习";
//    UINavigationController *naVC1 = [[UINavigationController alloc] initWithRootViewController:[StudyViewController alloc] init];
    
    
    ImagePickerController *imagePickVC = [[ImagePickerController alloc] init];
    UINavigationController *navc2 = [[UINavigationController alloc] initWithRootViewController:imagePickVC];
    imagePickVC.title = @"相册选择";
    
    
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    tabBarVC.viewControllers = @[nav,naVC1, navc2];
    
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    
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
