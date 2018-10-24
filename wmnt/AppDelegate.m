//
//  AppDelegate.m
//  wmnt
//
//  Created by yuanxuan on 2018/9/17.
//  Copyright © 2018年 wmnt. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreStatus.h"
#import <UserNotifications/UserNotifications.h>

#import "LoginViewController.h"
#import "HandlerViewController.h"
#import "ServerViewController.h"
#import "MeViewController.h"
@interface AppDelegate ()<CoreStatusProtocol>

@end

@implementation AppDelegate
@synthesize currentStatus;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *severurlstr = [[NSUserDefaults standardUserDefaults] objectForKey:SEVERURL];
    if (severurlstr == nil) {
        //设置服务器地址
        APPDATA.severUrl = kSeverURL;
    }else{
        APPDATA.severUrl = severurlstr;
    }
    
    //网络判断注册
    [self addCoreNetregister];
    
    //注册消息推送
    [self registerNotifiction];
    
    self.window = [[UIWindow alloc] initWithFrame:APPMainFrame];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //开启应用
    [self setupViewControllers];
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

#pragma mark - 自定义方法
- (void)registerNotifiction
{
    //注册通知
    if ([kApplication respondsToSelector:@selector(registerForRemoteNotifications)])//IOS8
    {
        //iOS8 - iOS10
        [kApplication registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        [kApplication registerForRemoteNotifications];
        
        //iOS10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
        [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
    }
    else{
        //    //iOS8以下
        [kApplication registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
}

///服务器推送
#pragma mark 注册推送通知之后
//在此接收设备令牌
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//  获取推送Token令牌
    NSString *currentDeviceToken = [[[[NSString stringWithFormat:@"%@", deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"push token is %@",currentDeviceToken);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:currentDeviceToken forKey:@"deviceToken"];
    [userDefaults synchronize];
    
    //上传给融云推送
//    NSString *token =
//    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
//                                                           withString:@""]
//      stringByReplacingOccurrencesOfString:@">"
//      withString:@""]
//     stringByReplacingOccurrencesOfString:@" "
//     withString:@""];
//
    
    //    剪切板
    //    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //    pasteboard.string = self.currentDeviceToken;
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.currentDeviceToken message:self.currentDeviceToken delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //    [alert show];
    //
    
}

#pragma mark 获取device token失败后
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error.localizedDescription);
    //    [self addDeviceToken:nil];
}

#pragma mark 接收到推送通知之后
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"receiveRemoteNotification,userInfo is %@",userInfo);
    //    NSString *msg = [self convertToJSONData:userInfo];
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
    //    [alert show];
    //    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //    pasteboard.string = msg;
    //推送 进入(工作功能)
//    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] boolValue];
//    if (isLogin) {
//        NSDictionary *func = [userInfo objectForKey:@"func"];
//        if (func) {
//            notifactionUserInfo = userInfo; //objectForKey:@"title"]
//            id noticeAlertTitle = [[notifactionUserInfo objectForKey:@"aps"] objectForKey:@"alert"];
//            NSString *alertTitle = @"";
//            if ([noticeAlertTitle isKindOfClass:[NSString class]]) {
//                alertTitle = noticeAlertTitle;
//            }else{
//                alertTitle = [[[notifactionUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
//            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertTitle delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
//            alert.tag = 22222;
//            [alert show];
//        }
//    }
}

#pragma mark - 网络判断
- (void)addCoreNetregister
{
    if ([CoreStatus isNetworkEnable]) {
        APPDATA.isNet = YES;
    }else{
        APPDATA.isNet = NO;
    }
    [CoreStatus beginNotiNetwork:self];
}

- (void)coreNetworkChangeNoti:(NSNotification *)noti{
    //因为这些是实时，所以每次的静态状态就是当前实时状态，你也可以从noti中取
    CoreNetWorkStatus currentNetStatus = [CoreStatus currentNetWorkStatus];
    
    switch (currentNetStatus) {
        case CoreNetWorkStatusNone:
        {
            APPDATA.isNet = NO;
//            [[NSNotificationCenter defaultCenter] postNotificationName:NETWORKNOTIFACTION object:nil];
        }
            break;
            
        default:
        {
            APPDATA.isNet = YES;
//            [[NSNotificationCenter defaultCenter] postNotificationName:NETWORKNOTIFACTION object:nil];
            
        }
            break;
    }
    
}
#pragma mark - 初始化功能
- (void)setupViewControllers {
    
    if ([kUserDefaults objectForKey:kUserDefaultsCookie] == nil) {
        [self jumpLoginPage];
    }else{
        [self jumpMainPage];
    }
}

- (void)jumpLoginPage
{
    //初始化登录
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    YXNavigationController *loginNavigationController = [[YXNavigationController alloc] initWithRootViewController:loginViewController];
    self.viewController = loginNavigationController;
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
}

- (void)jumpMainPage
{
    //初始化首页
    YXTabBarController *tabBarController = [[YXTabBarController alloc] init];
    tabBarController.tabBar.tintColor = [UIColor colorFromHexRGB:@"eeb244"];
    APPDATA.tabbarHeight = tabBarController.tabBar.frame.size.height;
//    NSString *deptid = [NSString stringWithFormat:@"%@",[kUserDefaults objectForKey:@"userInfo"][@"deptid"]];
//    if ([deptid isEqualToString:@"1"]) {//  管理人员
        // 首页
    HandlerViewController *handlerViewController = [[HandlerViewController alloc] init];
    handlerViewController.title = @"订单";
    handlerViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"订单" image:[UIImage imageNamed:@"activity"] selectedImage:[UIImage imageNamed:@"activity_select"]];
    [handlerViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
                                                              [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                                    forState:UIControlStateNormal];
    [handlerViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor colorFromHexRGB:@"eeb244"], NSForegroundColorAttributeName,
                                                              [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                                    forState:UIControlStateSelected];
    YXNavigationController *handlerNavViewController = [[YXNavigationController alloc]initWithRootViewController:handlerViewController];
    
    // 我的
    MeViewController *meViewController = [[MeViewController alloc] init];
    meViewController.title = @"我的";
    meViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"me"] selectedImage:[UIImage imageNamed:@"me_select"]];
    [meViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
                                                         [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                               forState:UIControlStateNormal];
    [meViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [UIColor colorFromHexRGB:@"eeb244"], NSForegroundColorAttributeName,
                                                         [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                               forState:UIControlStateSelected];
    YXNavigationController *meNavViewController = [[YXNavigationController alloc]initWithRootViewController:meViewController];
    
    tabBarController.viewControllers = @[handlerNavViewController, meNavViewController];
//    }else {// 服务人员
//        // 首页
//        ServerViewController *serverViewController = [[ServerViewController alloc] init];
//        serverViewController.title = @"订单";
//        serverViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"订单" image:[UIImage imageNamed:@"activity"] selectedImage:[UIImage imageNamed:@"activity_select"]];
//        [serverViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                               [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                                               [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                                     forState:UIControlStateNormal];
//        [serverViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                               [UIColor colorFromHexRGB:@"eeb244"], NSForegroundColorAttributeName,
//                                                               [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                                     forState:UIControlStateSelected];
//        YXNavigationController *serverNavViewController = [[YXNavigationController alloc]initWithRootViewController:serverViewController];
//
//        // 我的
//        MeViewController *meViewController = [[MeViewController alloc] init];
//        meViewController.title = @"我的";
//        meViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"me"] selectedImage:[UIImage imageNamed:@"me_select"]];
//        [meViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                 [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                                                 [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                                       forState:UIControlStateNormal];
//        [meViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                 [UIColor colorFromHexRGB:@"eeb244"], NSForegroundColorAttributeName,
//                                                                 [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                                       forState:UIControlStateSelected];
//        YXNavigationController *meNavViewController = [[YXNavigationController alloc]initWithRootViewController:meViewController];
//        tabBarController.viewControllers = @[serverNavViewController,  meNavViewController];
//    }
    self.viewController = tabBarController;
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
}

@end
