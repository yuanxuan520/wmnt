//
//  TipContentView.m
//  ParkProject
//
//  Created by yuanxuan on 16/9/25.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "TipContentView.h"

@implementation TipContentView
@synthesize imgView,titleLabel;

+ (TipContentView *)showView:(UIView *)view addContentImg:(NSString *)imgName title:(NSString *)title
{
    TipContentView *contentView = [[TipContentView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth*0.4, APPMainViewWidth*0.4)];
    contentView.imgView.image = [UIImage imageNamed:imgName];
    contentView.titleLabel.text = title;
    contentView.center = CGPointMake(APPMainViewWidth/2, (APPMainViewHeight-100)/2);
    [view addSubview:contentView];
    return contentView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width*0.6)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = [UIImage imageNamed:@"content_null"];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width*0.6, frame.size.width, frame.size.height*0.4)];
        titleLabel.font = CustomFont(16);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorFromHexRGB:@"999999"];
        [self addSubview:imgView];
        [self addSubview:titleLabel];
        
    }
    return self;
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
