//
//  PendingTableViewCell.m
//  wmnt
//
//  Created by yuanxuan on 2018/10/10.
//  Copyright © 2018 wmnt. All rights reserved.
//

#import "PendingTableViewCell.h"

@interface PendingTableViewCell()
@property(nonatomic,strong) UIView  *topView;

@end
@implementation PendingTableViewCell
@synthesize showContentView,appointTypeNameLabel,typeLabel,appointDateLabel,appointAddressLabel,appointNameLabel,appointPhoneLabel,appointOrderNoLabel;
@synthesize topView;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        topView = [[UIView alloc] init];
        appointOrderNoLabel = [[UILabel alloc] init];
        appointTypeNameLabel = [[UILabel alloc] init];
        
        typeLabel = [[UILabel alloc] init];
        appointDateLabel = [[UILabel alloc] init];
        appointAddressLabel = [[UILabel alloc] init];
        appointNameLabel = [[UILabel alloc] init];
        appointPhoneLabel = [[UILabel alloc] init];
        
        showContentView = [[UIView alloc] init];
        showContentView.backgroundColor = [UIColor whiteColor];
        showContentView.layer.cornerRadius = 10;
        showContentView.clipsToBounds = YES;
        [self.contentView addSubview:showContentView];
        
//        eaaImgView.contentMode = UIViewContentModeScaleAspectFit;
//        eaaImgView.image = [UIImage imageNamed:@"ppimg_shenpi"];
        
        topView.backgroundColor = [UIColor whiteColor];
        topView.layer.borderColor = [UIColor colorFromHexRGB:@"ececec"].CGColor;
        topView.layer.borderWidth = .5f;
        [self.showContentView addSubview:topView];
        
        

        appointOrderNoLabel.textColor = [UIColor colorFromHexRGB:@"555555"];
        appointOrderNoLabel.font = SystemFont(14);
        
        //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
        appointOrderNoLabel.textAlignment = NSTextAlignmentLeft;
        //        appointTypeNameLabel.numberOfLines = 2;
        [self.topView addSubview:appointOrderNoLabel];
        
        appointTypeNameLabel.textColor = [UIColor colorFromHexRGB:@"555555"];
        appointTypeNameLabel.font = SystemFont(14);
        
//        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
        appointTypeNameLabel.textAlignment = NSTextAlignmentLeft;
//        appointTypeNameLabel.numberOfLines = 2;
        [self.topView addSubview:appointTypeNameLabel];
        
        
        typeLabel.textColor = [UIColor whiteColor];
        typeLabel.font = SystemFoldFont(12);
        typeLabel.layer.cornerRadius = 5;
        typeLabel.clipsToBounds = YES;
        typeLabel.textAlignment = NSTextAlignmentCenter;
        //        appointTypeNameLabel.numberOfLines = 2;
        [self.topView addSubview:typeLabel];
        
        
        appointDateLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
        appointDateLabel.font = SystemFont(13);
        //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
        appointDateLabel.textAlignment = NSTextAlignmentLeft;
        //        appointTypeNameLabel.numberOfLines = 2;
        [self.showContentView addSubview:appointDateLabel];
        
        appointNameLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
        appointNameLabel.font = SystemFont(13);
        //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
        appointNameLabel.textAlignment = NSTextAlignmentLeft;
        //        appointTypeNameLabel.numberOfLines = 2;
        [self.showContentView addSubview:appointNameLabel];
        
        appointPhoneLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
        appointPhoneLabel.font = SystemFont(13);
        //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
        appointPhoneLabel.textAlignment = NSTextAlignmentLeft;
        //        appointTypeNameLabel.numberOfLines = 2;
        [self.showContentView addSubview:appointPhoneLabel];
        
        appointAddressLabel.textColor = [UIColor colorFromHexRGB:@"0a0a0a"];
        appointAddressLabel.font = SystemFont(13);
        appointAddressLabel.numberOfLines = 0;//多行显示，计算高度
        [self.showContentView addSubview:appointAddressLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.showContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.left.offset(5);
            make.right.offset(-5);
            make.bottom.offset(-5);
            //        make.height.mas_greaterThanOrEqualTo(120);
        }];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.showContentView);
            make.height.mas_equalTo(60);
        }];
        
        [self.appointOrderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(self.showContentView);
            make.height.mas_equalTo(25);
        }];
        
        [self.appointTypeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.appointOrderNoLabel.mas_bottom);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(self.showContentView);
            make.height.mas_equalTo(25);
        }];
        
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(35);
        }];
        
        [self.appointDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).offset(5);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(self.showContentView);
            make.height.mas_equalTo(20);
        }];
        //
        [self.appointNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.appointDateLabel.mas_bottom).offset(5);
            //self.appointNameLabel
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(20);
        }];
        
        [self.appointPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.appointDateLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(self.appointNameLabel.mas_right);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(20);
        }];
        
        [self.appointAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.appointNameLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-5);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            
        }];
    }
    return self;
}

// 设置内容
//- (void)setContent:()

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//
//}


@end
