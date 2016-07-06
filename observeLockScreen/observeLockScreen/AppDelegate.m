//
//  AppDelegate.m
//  observeLockScreen
//
//  Created by 李根 on 16/7/5.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "AppDelegate.h"
#import <notify.h>

#define NotificationLock CFSTR("com.apple.springboard.lockcomplete")
#define NotificationChange CFSTR("com.apple.springboard.lockstate")
#define NotificationPwdUI CFSTR("com.apple.springboard.hasBlankedScreen")

@interface AppDelegate ()
//@property(nonatomic, assign)uint64_t previousStatus;    //  之前状态
@property(nonatomic, assign)uint64_t currentStatus; //  当前状态

@end

@implementation AppDelegate
{
    BOOL i;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenLockStateChanged, NotificationLock, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    
    
    
    return YES;
}

- (void)test:(id)sender {
    NSLog(@"so~");
}

//static void screenLockStateChanged(CFNotificationCenterRef center,void* observer,CFStringRef name,const void* object,CFDictionaryRef userInfo)
//
//{
//    
//    NSString* lockstate = (__bridge NSString*)name;
//    
//    if ([lockstate isEqualToString:(__bridge  NSString*)NotificationLock]) {
//        
//        NSLog(@"locked.");
//        
//    } else {
//        
//        NSLog(@"lock state changed.");
//        
//    }
//    
//}


#pragma mark    - 监控锁屏状态
static void setScreenStateCb()

{
    
    uint64_t locked;
    
    __block int token = 0;
    
    notify_register_dispatch("com.apple.springboard.lockstate",&token,dispatch_get_main_queue(),^(int t){
        
    });
    
    notify_get_state(token, &locked);
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *currentStatus = [userDef objectForKey:@"currentStatus"];
    if ([currentStatus isEqualToString:@"1"] && locked == 0) {
        NSLog(@"I am here, everything has!");
    }
    else {
        
    }
    
    if (locked == 0) {
//        NSLog(@"解锁状态");
        [userDef setObject:@"0" forKey:@"currentStatus"];
    }
    else if (locked == 1) {
//        NSLog(@"锁屏状态");
        [userDef setObject:@"1" forKey:@"currentStatus"];
    }
    else {};
    [userDef synchronize];
    
//    NSLog(@"_____%d",(int)locked);
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    while (YES) {
        setScreenStateCb();
        sleep(1);
    }


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
