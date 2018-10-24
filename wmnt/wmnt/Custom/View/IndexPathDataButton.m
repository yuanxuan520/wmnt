//
//  IndexPathDataButton.m
//  ParkProj￼ect
//
//  Created by yuanxuan on 2017/3/31.
//  Copyright © 2017年 yuanxuan. All rights reserved.
//

#import "IndexPathDataButton.h"

@implementation IndexPathDataButton
@synthesize isCustom;
- (void)setSelectImg
{
    if (self.isCustom) {
        [self setImage:[UIImage imageNamed:@"ea_no_selected"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"ea_selected"] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"ea_selected"] forState:UIControlStateSelected];
    }else{
//        [self setBackgroundImage:[APPTools imageWithColor:[UIColor colorFromHexRGB:@"40affc"] size:self.bounds.size] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [self setBackgroundImage:[APPTools imageWithColor:[UIColor colorFromHexRGB:@"40affc"] size:self.bounds.size] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [self setTitleColor:[UIColor colorFromHexRGB:@"888888"] forState:UIControlStateNormal];
//        [self setBackgroundImage:[APPTools imageWithColor:[UIColor whiteColor] size:self.bounds.size] forState:UIControlStateNormal];

    }
    
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.isCustom) {
        CGRect imageRect = self.imageView.frame;
        imageRect.origin.x = 0;
        imageRect.origin.y = 0;
        imageRect.size = CGSizeMake(self.frame.size.height, self.frame.size.height);
        self.imageView.frame = imageRect;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        
        CGRect titleRect = self.titleLabel.frame;
        titleRect.origin.x = self.frame.size.height;
        titleRect.origin.y = 0 ;
        titleRect.size = CGSizeMake(self.frame.size.width-self.frame.size.height, self.frame.size.height);
        self.titleLabel.frame = titleRect;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
