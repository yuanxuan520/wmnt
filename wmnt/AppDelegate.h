//
//  AppDelegate.h
//  wmnt
//
//  Created by yuanxuan on 2018/9/17.
//  Copyright © 2018年 wmnt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *viewController;
// 进入到登录
- (void)jumpLoginPage;
// 进入到首页
- (void)jumpMainPage;
@end

