//
//  TipContentView.h
//  ParkProject
//
//  Created by yuanxuan on 16/9/25.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipContentView : UIView
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
+ (TipContentView *)showView:(UIView *)view addContentImg:(NSString *)imgName title:(NSString *)title;
@end
