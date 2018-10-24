//
//  SubsctionSelectItemView.h
//  ParkProject
//
//  Created by yuanxuan on 2017/3/31.
//  Copyright © 2017年 yuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SubsctionSelectItemCallback)(NSMutableArray *dataInfoList);

@interface SubsctionSelectItemView : UIScrollView
- (void)setSubsctionSelectItemCallback:(SubsctionSelectItemCallback)callback;
- (void)buildFormDataList:(NSMutableArray *)dataList sectionTitleKey:(NSString *)titleKey subListKey:(NSString *)listKey subTitleKey:(NSString *)subTitleKey;
- (void)selectItemSection:(NSInteger)section row:(NSInteger)row;
@end
