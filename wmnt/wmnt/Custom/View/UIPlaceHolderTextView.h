//
//  UIPlaceHolderTextView.h
//  人锋视频
//
//  Created by 袁轩 on 13-7-25.
//  Copyright (c) 2013年 袁轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;//设置默认填充字
@property (nonatomic, retain) UIColor *placeholderColor;//以及颜色

-(void)textChanged:(NSNotification*)notification;

@end