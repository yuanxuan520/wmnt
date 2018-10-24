//
//  SeverurlView.h
//  ParkProject
//
//  Created by yuanxuan on 16/9/28.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"

typedef void(^selectSeverurlItem)(NSString *selectSeverurl);

@interface SeverurlView : UIScrollView
@property (strong, nonatomic) UIView *parentView;
- (void)showat:(UIView *)view select:(selectSeverurlItem )selectSeverurl;
@end
