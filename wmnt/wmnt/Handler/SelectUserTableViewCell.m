//
//  SelectUserTableViewCell.m
//  wmnt
//
//  Created by yuanxuan on 2018/10/22.
//  Copyright © 2018 wmnt. All rights reserved.
//

#import "SelectUserTableViewCell.h"

@implementation SelectUserTableViewCell
@synthesize allcontentView,userIconView,userTypeLabel,userNameLabel,userSelectImg;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.allcontentView = [[UIView alloc] init];
        self.userNameLabel = [[UILabel alloc] init];
        self.userTypeLabel = [[UILabel alloc] init];
        self.userIconView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.userSelectImg = [[UIImageView alloc] init];
        //        progressView.hidden = no;
        
        self.allcontentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.allcontentView];
        
        // 头像
        
        // 内容
        self.userNameLabel.textColor = [UIColor colorFromHexRGB:@"0a0a0a"];
        //    CGSize wdtitleSize = [fileTitleLabel.text boundingRectWithSize:CGSizeMake(mainViewWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFont(11)} context:nil].size;
        self.userNameLabel.font = SystemFont(15);
        self.userNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.allcontentView addSubview:self.userNameLabel];
        
        
        self.userTypeLabel.textColor = [UIColor colorFromHexRGB:@"67C23A"];
        self.userTypeLabel.font = SystemFont(13);
        self.userTypeLabel.textAlignment = NSTextAlignmentRight;
        [self.allcontentView addSubview:self.userTypeLabel];
        
        
        // 标题
        self.userIconView.userInteractionEnabled = NO;
        [self.userIconView setImage:[UIImage imageNamed:@"default_img"] forState:UIControlStateNormal];
        [self.userIconView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.userIconView.titleLabel.font = SystemFont(12);
        self.userIconView.layer.cornerRadius = 15;
        self.userIconView.clipsToBounds = YES;
        [self.allcontentView addSubview:self.userIconView];
        self.userSelectImg.layer.cornerRadius = 20;
        [self.allcontentView addSubview:self.userSelectImg];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.allcontentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.userIconView.frame = CGRectMake(60, 15, 30, 30);
    self.userNameLabel.frame = CGRectMake(100, 0, self.frame.size.width-100, 60);
    self.userTypeLabel.frame = CGRectMake(self.frame.size.width-120, 0, 100, 60);
    self.userSelectImg.frame = CGRectMake(10, 10, 40, 40);
}

@end
