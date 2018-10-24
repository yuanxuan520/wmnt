//
//  YXNavigationController.m
//  Manly
//
//  Created by yuanxuan on 2017/4/13.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import "YXNavigationController.h"

@interface YXNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation YXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    self.navigationBar.barTintColor = UIColorHex(0xf9f9f9);
    self.navigationBar.tintColor = UIColorHex(0x666666);
    //    self.navigationBar.barStyle = UIBaselineAdjustmentNone;
    
    UIImageView *navUnderLine = [self findHairlineImageViewUnder:self.navigationBar];
    UIImageView *underLineView = [[UIImageView alloc] init];
    [underLineView setFrame:CGRectMake(0, 0, navUnderLine.bounds.size.width, navUnderLine.bounds.size.height)];
    underLineView.backgroundColor = UIColorHex(0xdfe5e9);
    [navUnderLine addSubview:underLineView];
    //    navUnderLine.backgroundColor = [UIColor colorFromHexRGB:@"dfe5e9"];
    //    navUnderLine.layer.backgroundColor = [UIColor colorFromHexRGB:@"dfe5e9"].CGColor;
    //    [navUnderLine setImage:[UIImage imageWithColor:[UIColor colorFromHexRGB:@"dfe5e9"]]];
    //    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor colorFromHexRGB:@"dfe5e9"]]];
    //    [self.navigationBar.layer setShadowColor:[UIColor colorFromHexRGB:@"dfe5e9"].cg]
    // Do any additional setup after loading the view.
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [super pushViewController:viewController animated:animated];
    self.interactivePopGestureRecognizer.enabled = NO;
    if (self.isNosliding) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.interactivePopGestureRecognizer.enabled = [self.viewControllers count] > 1 ;
    if (self.isNosliding) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.interactivePopGestureRecognizer.enabled = YES;
    if (self.isNosliding) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    return YES;
}

- (void)pressBackButton:(id)sender{
    [self popViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
