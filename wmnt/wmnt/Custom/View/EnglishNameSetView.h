//
//  EnglishNameSetView.h
//  Manly Student
//
//  Created by yuanxuan on 2018/4/23.
//  Copyright © 2018年 topflames. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIImage+ImageEffects.h"

typedef void(^SetFirstLastName)(NSString *firstName, NSString *lastName);


@interface EnglishNameSetView : UIScrollView
- (void)show:(UIView *)view setFirstLastName:(SetFirstLastName )setName;
@end
