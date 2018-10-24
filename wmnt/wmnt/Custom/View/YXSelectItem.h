//
//  YXSelectItem.h
//  ParkProject
//
//  Created by yuanxuan on 2017/2/6.
//  Copyright © 2017年 yuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXSelectItemDelegate;

@interface YXSelectItem : UIButton
@property (weak, nonatomic) id<YXSelectItemDelegate> delegate;

- (void)setItemTitle:(NSString *)title;
- (void)setItemTitleFont:(CGFloat)fontSize;
- (void)setItemTitleColor:(UIColor *)color;
- (void)setItemSelectedTileFont:(CGFloat)fontSize;
- (void)setItemSelectedTitleColor:(UIColor *)color;
- (void)setItemDisableTitleColor:(UIColor *)color;

+ (CGFloat)widthForTitle:(NSString *)title;
- (NSString *)getitemTitle;
@end

@protocol YXSelectItemDelegate <NSObject>

- (void)selectItemSelected:(YXSelectItem *)item;
@end
