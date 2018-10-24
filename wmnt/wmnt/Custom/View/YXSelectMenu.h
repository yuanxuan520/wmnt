//
//  YXSelectMenu.h
//  ParkProject
//
//  Created by yuanxuan on 2017/2/4.
//  Copyright © 2017年 yuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YXSelectMenuItemSelectedCallback)(NSUInteger idx);

typedef enum : NSUInteger {
    kSelectLandscapeType = 1,  //横向
    kSelectlognitudinalType,   //纵向
} SelectMenuType;

@interface YXSelectMenu : UIView

// Include - <Name>  <Enable>  <Datadetail>
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, assign) SelectMenuType selectType;

// All the item's text color of the normal state
@property (strong, nonatomic) UIColor *itemColor;

// The selected item's text color
@property (strong, nonatomic) UIColor *itemSelectedColor;

// The slider color
@property (strong, nonatomic) UIColor *sliderColor;

- (void)createView;
// Add the callback deal when a slide bar item be selected
- (void)selectMenuItemSelectedCallback:(YXSelectMenuItemSelectedCallback)callback;

// Set the slide bar item at index to be selected
- (void)selectMenuItemAtIndex:(NSUInteger)index;

@end
