//
//  NSObject+NSLocalNotification.m
//  text
//
//  Created by Alex William on 2019/2/19.
//  Copyright © 2019年 MoziTechnology. All rights reserved.
//

#import "NSObject+NSLocalNotification.h"
#import "AppDelegate.h"

#define DEVICE_iOS_8    [UIDevice currentDevice].systemVersion.floatValue >= 8.0
#define DEVICE_iOS_9    [UIDevice currentDevice].systemVersion.floatValue >= 9.0
@implementation NSObject (NSLocalNotification)

/// 注册通知

+ (void)registerLocalNotification:(NSInteger)time
                           badges:(NSInteger)badges
                          content:(NSString *)content
                              key:(NSString *)key {
    
    // 创建一个本地通知
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    // 设置触发通知的时间, 需要使用时间戳
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:time];
    notification.fireDate = fireDate;
    
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    // 设置重复的间隔
    notification.repeatInterval = 0;// 是一个枚举
    
    // 通知内容
    notification.alertBody =  content;
    
    //应用程序右上角 角标
    notification.applicationIconBadgeNumber = badges;
    notification.alertAction = @"打开应用吧";
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:content forKey:key];
    
    notification.userInfo = userDict;
    
    //选择使用 哪个操作组
    notification.category = @"select";
    
    //请求本地通知 授权
    [self getRequestWithLocalNotificationSleep:notification];
}

// 授权
- (void)getRequestWithLocalNotificationSleep:(UILocalNotification *)notification
{
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
#warning 注册完之后如果不删除，下次会继续存在，即使从模拟器卸载掉也会保留
    
    //删除之前的通知
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}

/// 取消通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    if (localNotifications) {
        
        for (UILocalNotification *notification in localNotifications) {
            NSDictionary *userInfo = notification.userInfo;
            if (userInfo) {
                // 根据设置通知参数时指定的key来获取通知参数
                NSString *info = userInfo[key];
                
                // 如果找到需要取消的通知，则取消
                if ([info isEqualToString:key]) {
                    if (notification) {
                        [[UIApplication sharedApplication] cancelLocalNotification:notification];
                    }
                    break;
                }
            }
        }
    }
}



@end


