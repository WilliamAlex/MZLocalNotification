//
//  AppDelegate.m
//  text
//
//  Created by Alex William on 2019/2/19.
//  Copyright © 2019年 MoziTechnology. All rights reserved.
//

#import "AppDelegate.h"
#import "NSObject+NSLocalNotification.h"


#define LOCALNOTIFICATION_KEY             @"localNotificationKey"
@interface AppDelegate ()

@end

/*
 监听用户点击的通知时的几种情况:
 
 1, App处于前台: 这种情况不会有通知弹框到达, 但还是会调用相对应的代理方法.
 2, App并没有关闭: 但是一直处于后台情况, 这种情况用户点击通知信息后, 会直接跳到App前台,并调用相对应的方法didReceiveLocalNotification
 3, App的线程已经被杀死: 此时用户点击通知信息后,会启动app，启动完毕会调用AppDelegate的下面方法,application:didFinishLaunchingWithOptions:launchOptions参数通过UIApplicationLaunchOptionsLocalNotificationKey取
     出本地推送通知象
 */

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 注册本地通知信息
    //如果已经得到授权，就直接添加本地通知，否则申请询问授权
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
        [AppDelegate registerLocalNotification:10 badges:application.applicationState content:@"本地推送测试专用通道" key:LOCALNOTIFICATION_KEY];
   
    }else{
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
        
        UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:@"接收到本地通知" message:@"去设置授权" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
     NSLog(@"launchOptions: %@", launchOptions);
    
    return YES;
}

// 本地通知的代理方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:@"接收到本地通知" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    // 查看当前的状态出于(前台: 0)/(后台: 2)/(从后台进入前台: 1)
    NSLog(@"applicationState.rawValue: %zd", application.applicationState);
    
    // 执行响应操作
    // 如果当前App在前台,执行操作
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"执行前台对应的操作");
    } else if (application.applicationState == UIApplicationStateInactive) {
        // 后台进入前台
        NSLog(@"执行后台进入前台对应的操作");
        NSLog(@"*****%@", notification.userInfo);
    } else if (application.applicationState == UIApplicationStateBackground) {
        // 当前App在后台
        
        NSLog(@"执行后台对应的操作");
    }
}

//监听通知操作行为的点击
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    NSLog(@"监听通知操作行为的点击");
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

    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
