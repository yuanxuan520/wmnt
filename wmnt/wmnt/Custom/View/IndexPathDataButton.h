//
//  IndexPathDataButton.h
//  ParkProject
//
//  Created by yuanxuan on 2017/3/31.
//  Copyright © 2017年 yuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexPathDataButton : UIButton
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) NSDictionary *curInfoData;
@property (nonatomic, assign) BOOL isCustom;
- (void)setSelectImg;
@end
