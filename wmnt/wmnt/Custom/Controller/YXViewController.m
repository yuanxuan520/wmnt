//
//  YXViewController.m
//  Manly
//
//  Created by yuanxuan on 2017/4/13.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import "YXViewController.h"

@interface YXViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YXViewController
@synthesize mainView,isHideBack,titleLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    if (self.navigationController.viewControllers.count>1 && !isHideBack) {
        UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        backButton.titleLabel.font = SystemFont(16);
        backButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        backButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        backButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) { //针对iOS11 位置修改
            backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
        }
        backButton.frame = CGRectMake(0, 0, 90, 40);
        [backButton setImage:[UIImage imageNamed:@"nav_back_img"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"nav_back_img_highted"] forState:UIControlStateHighlighted];
        UIViewController *lastViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        [backButton setTitle:lastViewController.title forState:UIControlStateNormal];
        if (self.backTitle) {
            [backButton setTitle:self.backTitle forState:UIControlStateNormal];
            CGSize titleSize = GetWTextSizeFoldFont(self.backTitle, 40, 16);
            if (titleSize.width+40 > 110) {
                backButton.frame = CGRectMake(0, 0, 110, 40);
                
            }else{
                backButton.frame = CGRectMake(0, 0, titleSize.width+40, 40);
            }
        }else{
            [backButton setTitle:lastViewController.title forState:UIControlStateNormal];
            CGSize titleSize = GetWTextSizeFoldFont(lastViewController.title, 40, 16);
            if (titleSize.width+40 > 90) {
                backButton.frame = CGRectMake(0, 0, 110, 40);
                
            }else{
                backButton.frame = CGRectMake(0, 0, titleSize.width+40, 40);
            }
        }
        [backButton setTitleColor:[UIColor colorFromHexRGB:@"666666"] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor colorFromHexRGB:@"888888"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(pressBackButton:) forControlEvents:UIControlEventTouchUpInside];
        //            viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>10.4)) {
            UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            // 设置边框距离，个人习惯设为-16，可以根据需要调节
            fixedItem.width = -16;
            self.navigationItem.leftBarButtonItems = @[fixedItem, leftItem];
        }else {
//            self.navigationItem.leftBarButtonItems = @[leftItem];
        }
        
    }
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    titleLabel.font = SystemFont(16);
    titleLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    NSString *titleText = @"";
    if (self.title != nil) {
        titleText = self.title;
    }
    titleLabel.text = titleText;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"ececec"];
    self.mainView = [[UIScrollView alloc] init];
    self.mainView.backgroundColor = [UIColor colorFromHexRGB:@"ececec"];
    self.mainView.scrollEnabled = YES;
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
//    self.manlyLoadView = [[YXLoadView alloc] initWithFrame:CGRectMake(0, 0, 280, 110)];
//    self.manlyLoadView.center = CGPointMake(APPMainViewWidth/2, APPNoNavHeight/2-50);
//    //    self.manlyLoadView.backgroundColor = [UIColor clearColor];
//    manlyLoadView.hidden = YES;
//    [self.view addSubview:self.manlyLoadView];
    // Do any additional setup after loading the view.
}

- (void)pressBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMainView
{
    __weak typeof(self) ws = self;
    self.mainView.alpha = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            ws.mainView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    });
    
}

- (void)hideMainView
{
    self.mainView.alpha = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            self.mainView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    });
    
}


- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
}

- (void)setNavTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addNoDataView:(UIView *)view
{
    self.noDataView = [TipContentView showView:view addContentImg:@"empty" title:@"暂无内容"];
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
