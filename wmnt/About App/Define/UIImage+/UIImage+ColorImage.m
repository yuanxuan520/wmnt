//
//  UIImage+ColorImage.m
//  Manly
//
//  Created by yuanxuan on 2017/4/18.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import "UIImage+ColorImage.h"

@implementation UIImage (ColorImage)
+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return image;
}
@end
