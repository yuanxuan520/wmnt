//
//  YXTabBarController.m
//  Manly
//
//  Created by yuanxuan on 2017/4/13.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import "YXTabBarController.h"

//#import "StudentViewController.h"
//#import "DiscoverViewController.h"
//#import "MeViewController.h"

@interface YXTabBarController ()

@end

@implementation YXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *tabUnderLine = [self findHairlineImageViewUnder:self.tabBar];
//    UIImageView *underLineView = [[UIImageView alloc] init];
//    [underLineView setFrame:CGRectMake(0, 0, tabUnderLine.bounds.size.width, tabUnderLine.bounds.size.height)];
//    underLineView.backgroundColor = [UIColor colorFromHexRGB:@"dcdcdc"];
//    [tabUnderLine addSubview:underLineView];
////    self.tabBar.barStyle = UIBarStyleBlack;
//     self.tabBarController.tabBar.translucent = YES;
////    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexRGB:@"fafafa"]]];
////    [self.tabBar setShadowImage:[UIImage imageWithColor:[UIColor colorFromHexRGB:@"dcdcdc"]]];
//    // Do any additional setup after loading the view.
//
//    NotificationCenterAdd(GET_TUTOR_STATE, @selector(returnTutorInformation:), nil);
//    NotificationCenterAdd(STUDENT_INVITE, @selector(studentInviteTutor:), nil);
//
//    //最近
//    ConversationListViewController *charsVC = [[ConversationListViewController alloc]init];
//    charsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Recents" image:[UIImage imageNamed:@"tab_Lately"] tag:0];
//    [charsVC.tabBarItem setImage:[UIImage imageNamed:@"tab_Lately"]];//普通图片
//    [charsVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_Lately_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];//选中图片
//
//    [charsVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                [UIColor colorFromHexRGB:TABNormalColor], NSForegroundColorAttributeName,
//                                                [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                      forState:UIControlStateNormal];
//    [charsVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                [UIColor colorFromHexRGB:TABSelectColor], NSForegroundColorAttributeName,
//                                                [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                      forState:UIControlStateSelected];
//    NavigationViewController *charsNav = [[NavigationViewController alloc] initWithRootViewController:charsVC];
//
//    //导师
//    StudentViewController *studentVC = [[StudentViewController alloc]init];
//    studentVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Students" image:[UIImage imageNamed:@"tab_Tutor"] tag:1];
//    [studentVC.tabBarItem setImage:[UIImage imageNamed:@"tab_Tutor"]];//普通图片
//    [studentVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_Tutor_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];//选中图片
//
//    [studentVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                [UIColor colorFromHexRGB:TABNormalColor], NSForegroundColorAttributeName,
//                                                [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                      forState:UIControlStateNormal];
//    [studentVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                [UIColor colorFromHexRGB:TABSelectColor], NSForegroundColorAttributeName,
//                                                [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                      forState:UIControlStateSelected];
//    NavigationViewController *studentNav = [[NavigationViewController alloc] initWithRootViewController:studentVC];
//
//    //发现
//    DiscoverViewController *discoverVC = [[DiscoverViewController alloc]init];
//    discoverVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Discovery" image:[UIImage imageNamed:@"tab_Discover"] tag:2];
//    [discoverVC.tabBarItem setImage:[UIImage imageNamed:@"tab_Discover"]];//普通图片
//    [discoverVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_Discover_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];//选中图片
//    [discoverVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                   [UIColor colorFromHexRGB:TABNormalColor], NSForegroundColorAttributeName,
//                                                   [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                         forState:UIControlStateNormal];
//    [discoverVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                   [UIColor colorFromHexRGB:TABSelectColor], NSForegroundColorAttributeName,
//                                                   [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                         forState:UIControlStateSelected];
//    YXNavigationController *discoverNav = [[YXNavigationController alloc] initWithRootViewController:discoverVC];
//
//    //我
//    MeViewController *meVC = [[MeViewController alloc]init];
//    meVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:[UIImage imageNamed:@"tab_Me"] tag:3];
//    [meVC.tabBarItem setImage:[UIImage imageNamed:@"tab_Me"]];//普通图片
//    [meVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_Me_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];//选中图片
//
//    [meVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                             [UIColor colorFromHexRGB:TABNormalColor], NSForegroundColorAttributeName,
//                                             [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                   forState:UIControlStateNormal];
//    [meVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                             [UIColor colorFromHexRGB:TABSelectColor], NSForegroundColorAttributeName,
//                                             [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                   forState:UIControlStateSelected];
//    NavigationViewController *meNav = [[NavigationViewController alloc] initWithRootViewController:meVC];
//
//
//    //    self.tabBar.translucent = NO;
//    //    self.edgesForExtendedLayout = UIRectEdgeNone;
//    //    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.viewControllers = @[charsNav,  studentNav, discoverNav, meNav];
}


- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    NSLog(@"view.subviews:%@",view.subviews);
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
