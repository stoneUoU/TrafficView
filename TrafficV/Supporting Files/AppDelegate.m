//
//  AppDelegate.m
//  TrafficV
//
//  Created by test on 2018/4/9.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import "AppDelegate.h"
#import "TrafficVC.h"


@interface AppDelegate ()
@end

static AppDelegate *_shareIns = nil;

@implementation AppDelegate
//单例模式
+(instancetype) shareIns
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _shareIns = [[super allocWithZone:NULL] init] ;
    }) ;

    return _shareIns ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [AppDelegate shareIns] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [AppDelegate shareIns] ;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController =  [[TrafficVC alloc] init];
    [NSThread sleepForTimeInterval:1.0];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //如何解决点击home键进入后台，程序进程被杀死后，画面卡住不动的bug
    //程序进入后台，发送通知给TrafficVC，将网络任务给取消
    _dictB(@{@"postN":@"Yes,进入后台"}, YES);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //STLog(@"applicationWillEnterForeground");
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"enterForeTai" object:@{@"enterForeTai":@YES}];
    //[AppDelegate getDictB](@{@"name":@"oooooo"}, YES);
    //程序进入后台，发送通知给TrafficVC，重新发送网络请求，这样便可以解决此bug,hahahhaha
    if ([_delegate respondsToSelector:@selector(toWakeUp:)]) {
        // 调用代理方法
        [_delegate toWakeUp:@{@"postN":@"Yes,进入前台"}];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //STLog(@"applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
