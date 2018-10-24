//
//  YXPlaceHolderTextView.h
//  Manly Student
//
//  Created by yuanxuan on 2017/7/7.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;//设置默认填充字
@property (nonatomic, retain) UIColor *placeholderColor;//以及颜色

-(void)textChanged:(NSNotification*)notification;
@end
