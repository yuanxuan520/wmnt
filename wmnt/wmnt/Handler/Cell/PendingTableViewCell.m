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
@synthesize showContentView,appointTypeNameLabel,typeImgBtn,appointDateLabel,appointAddressLabel,appointNameLabel,appointPhoneLabel,appointOrderNoLabel;
@synthesize topView;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        topView = [[UIView alloc] init];
        
        UILabel *appointOrderNoTitle = [[UILabel alloc] init];
        appointOrderNoTitle.textColor = [UIColor colorFromHexRGB:@"555555"];
        appointOrderNoTitle.font = SystemFont(14);
        
        appointOrderNoLabel = [[UILabel alloc] init];
        appointTypeNameLabel = [[UILabel alloc] init];
        
        typeImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        appointDateLabel = [[UILabel alloc] init];
        appointAddressLabel = [[UILabel alloc] init];
        appointNameLabel = [[UILabel alloc] init];
        appointPhoneLabel = [[UILabel alloc] init];
        
        showContentView = [[UIView alloc] init];
        showContentView.backgroundColor = [UIColor whiteColor];
//        showContentView.layer.cornerRadius = 10;
        showContentView.layer.borderColor = UIColorHex(0xe2e2e5).CGColor;
        showContentView.layer.borderWidth = 1;
        showContentView.layer.shadowRadius = 5;
        showContentView.layer.shadowOffset = CGSizeMake(0, 0);
        showContentView.layer.shadowOpacity = 0.2;
        showContentView.layer.shadowColor = UIColorHex(0xaaaaaa).CGColor;
//        showContentView.clipsToBounds = YES;
        [self.contentView addSubview:showContentView];
        
//        eaaImgView.contentMode = UIViewContentModeScaleAspectFit;
//        eaaImgView.image = [UIImage imageNamed:@"ppimg_shenpi"];
        
        topView.backgroundColor = [UIColor whiteColor];
//        topView.layer.cornerRadius = 10;
//        topView.layer.borderColor = [UIColor colorFromHexRGB:@"d9d9d9"].CGColor;
//        topView.layer.borderWidth = 0.5;
        [self.showContentView addSubview:topView];
        
        

        appointOrderNoLabel.textColor = [UIColor colorFromHexRGB:@"303033"];
        appointOrderNoLabel.font = SystemFoldFont(14);
        
        //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
        appointOrderNoLabel.textAlignment = NSTextAlignmentLeft;
        //        appointTypeNameLabel.numberOfLines = 2;
        [self.topView addSubview:appointOrderNoLabel];
        
        appointTypeNameLabel.textColor = [UIColor colorFromHexRGB:@"303033"];
        appointTypeNameLabel.font = SystemFoldFont(14);
        
//        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
        appointTypeNameLabel.textAlignment = NSTextAlignmentLeft;
//        appointTypeNameLabel.numberOfLines = 2;
        [self.topView addSubview:appointTypeNameLabel];
        
        
//        typeLabel.textColor = [UIColor whiteColor];
//        typeLabel.font = SystemFoldFont(12);
//        typeLabel.layer.cornerRadius = 5;
//        typeLabel.clipsToBounds = YES;
//        typeLabel.textAlignment = NSTextAlignmentCenter;
        //        appointTypeNameLabel.numberOfLines = 2;
        [self.topView addSubview:typeImgBtn];
        
        appointDateLabel.textColor = [UIColor colorFromHexRGB:@"1b1b1b"];
        appointDateLabel.font = CustomFont(13);
        //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
        appointDateLabel.textAlignment = NSTextAlignmentLeft;
        //        appointTypeNameLabel.numberOfLines = 2;
        [self.showContentView addSubview:appointDateLabel];
        
        appointNameLabel.textColor = [UIColor colorFromHexRGB:@"1b1b1b"];
        appointNameLabel.font = CustomFont(13);
        //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
        appointNameLabel.textAlignment = NSTextAlignmentLeft;
        //        appointTypeNameLabel.numberOfLines = 2;
        [self.showContentView addSubview:appointNameLabel];
        
        appointPhoneLabel.textColor = [UIColor colorFromHexRGB:@"1b1b1b"];
        appointPhoneLabel.font = CustomFont(13);
        //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
        appointPhoneLabel.textAlignment = NSTextAlignmentLeft;
        //        appointTypeNameLabel.numberOfLines = 2;
        [self.showContentView addSubview:appointPhoneLabel];
        
        appointAddressLabel.textColor = [UIColor colorFromHexRGB:@"1b1b1b"];
        appointAddressLabel.font = CustomFont(13);
        appointAddressLabel.numberOfLines = 0;//多行显示，计算高度
        [self.showContentView addSubview:appointAddressLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.showContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(10);
            make.right.offset(-10);
            make.bottom.offset(-5);
            //        make.height.mas_greaterThanOrEqualTo(120);
        }];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.showContentView);
            make.height.mas_equalTo(60);
        }];
        
        UIImageView *lineView = [[UIImageView alloc] init];
        [lineView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"xuxian"]]];
        [self.showContentView addSubview:lineView];
        
        
//        UIButton *appointOrderNoImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [appointOrderNoImgBtn setImage:[UIImage imageNamed:@"orderNo"] forState:UIControlStateNormal];
//        appointOrderNoImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [appointOrderNoImgBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//        [appointOrderNoImgBtn setUserInteractionEnabled:NO];
//        [self.showContentView addSubview:appointOrderNoImgBtn];
//        [appointOrderNoImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(5);
//            make.left.mas_equalTo(10);
//            make.width.mas_equalTo(25);
//            make.height.mas_equalTo(25);
//        }];
        
        [self.appointOrderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-40);
            make.height.mas_equalTo(25);
        }];
        
        [self.appointTypeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.appointOrderNoLabel.mas_bottom);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-40);
            make.height.mas_equalTo(25);
        }];
        
        [self.typeImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(0.5);
        }];
        
        
        UIButton *appointDateImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [appointDateImgBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
        appointDateImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [appointDateImgBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        [appointDateImgBtn setUserInteractionEnabled:NO];
        [self.showContentView addSubview:appointDateImgBtn];
        
        [appointDateImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).offset(10);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
        [self.appointDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).offset(10);
            make.left.mas_equalTo(appointDateImgBtn.mas_right).offset(2);
            make.width.mas_equalTo(self.showContentView);
            make.height.mas_equalTo(20);
        }];
        
        UIButton *appointNameImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [appointNameImgBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
        appointNameImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [appointNameImgBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 4, 4, 4)];
        [appointNameImgBtn setUserInteractionEnabled:NO];
        [self.showContentView addSubview:appointNameImgBtn];
        
        [appointNameImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.appointDateLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
        [self.appointNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.appointDateLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(appointNameImgBtn.mas_right).offset(2);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(20);
        }];
        UIButton *appointPhoneImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [appointPhoneImgBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        appointPhoneImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [appointPhoneImgBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        [appointPhoneImgBtn setUserInteractionEnabled:NO];
        [self.showContentView addSubview:appointPhoneImgBtn];
        [appointPhoneImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.appointDateLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(self.appointNameLabel.mas_right).offset(2);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
        
        [self.appointPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.appointDateLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(appointPhoneImgBtn.mas_right);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(20);
        }];
        
        UIButton *appointAddressImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [appointAddressImgBtn setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
        appointAddressImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [appointAddressImgBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 4, 4, 4)];
        [appointAddressImgBtn setUserInteractionEnabled:NO];
        [self.showContentView addSubview:appointAddressImgBtn];
        [appointAddressImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.appointNameLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        [self.appointAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.appointNameLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(appointAddressImgBtn.mas_right).offset(2);
            make.right.mas_equalTo(-10);
            make.bottom.equalTo(self.contentView).with.offset(-20);
            
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
