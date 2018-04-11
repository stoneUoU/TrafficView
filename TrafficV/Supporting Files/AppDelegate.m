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
    [self setPing];
    //网络变化
    [GLobalRealReachability startNotifier];
    [self setNetNotice];
    [NSThread sleepForTimeInterval:2.0];
    return YES;
}

//是否能ping通:
-(void) setPing{
    self.pingTester = [[STPingTester alloc] initWithHostName:@"http://www.baidu.com"];//@"http://192.168.1.1:8080/?action=snapshot"];//
    self.pingTester.delegate = self;
    [self.pingTester startPing];
}

-(void) setNetNotice{
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status == RealStatusNotReachable)
    {
        STLog(@"1111");
        keychainStore[@"ifnetUse"] = @"unUseable";
    }
    if (status == RealStatusViaWiFi)
    {
        STLog(@"2222");
        keychainStore[@"ifnetUse"] = @"Useable";
    }

    if (status == RealStatusViaWWAN)
    {
        STLog(@"3333");
        keychainStore[@"ifnetUse"] = @"Useable";
    }
}

- (void)networkChanged:(NSNotification *)notification
{
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];


    if (status == RealStatusNotReachable)
    {
        keychainStore[@"ifnetUse"] = @"unUseable";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"netChange" object:self userInfo:@{@"ifnetUse":@"unUseable"}];
    }

    if (status == RealStatusViaWiFi)
    {
        keychainStore[@"ifnetUse"] = @"Useable";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"netChange" object:self userInfo:@{@"ifnetUse":@"Useable"}];
    }

    if (status == RealStatusViaWWAN)
    {
        keychainStore[@"ifnetUse"] = @"Useable";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"netChange" object:self userInfo:@{@"ifnetUse":@"Useable"}];
    }

    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];

    if (status == RealStatusViaWWAN)
    {
        if (accessType == WWANType2G)
        {
            STLog(@"RealReachabilityStatus2G");
        }
        else if (accessType == WWANType3G)
        {
            STLog(@"RealReachabilityStatus3G");
        }
        else if (accessType == WWANType4G)
        {
            STLog(@"RealReachabilityStatus4G");
        }
    }
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
    //STLog(@"applicationWillEnterForeground");
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"enterForeTai" object:@{@"enterForeTai":@YES}];
    //_dictB(@{@"name":@"oooooo"}, YES);
    //[AppDelegate getDictB](@{@"name":@"oooooo"}, YES);

    if ([_delegate respondsToSelector:@selector(toWakeUp:)]) {
        // 调用代理方法并传入红色
        [_delegate toWakeUp:@{@"num":@109}];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //STLog(@"applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - STPingDelegate
- (void) didPingSucccessWithTime:(float)time withError:(NSError *)error
{
    if(!error)
    {
        STLog(@"拼得通");
        [UICKeyChainStore keyChainStore][@"orPingNet"] = @"YES";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"orPingNet" object:@{@"orPingNet":@YES}];
    }else{
        STLog(@"拼不通");
        [UICKeyChainStore keyChainStore][@"orPingNet"] = @"NO";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"orPingNet" object:@{@"orPingNet":@NO}];
    }
}


@end
