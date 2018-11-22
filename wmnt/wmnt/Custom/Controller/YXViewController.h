//
//  YXViewController.h
//  Manly
//
//  Created by yuanxuan on 2017/4/13.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipContentView.h"

@interface YXViewController : UIViewController
@property (nonatomic, strong) NSString *backTitle;
@property (nonatomic, assign) BOOL isHideBack;
@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) TipContentView *noDataView;
//显示添加没内容页面
- (void)addNoDataView:(UIView *)view;
@end
