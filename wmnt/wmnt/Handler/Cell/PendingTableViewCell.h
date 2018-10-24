//
//  PendingTableViewCell.h
//  wmnt
//
//  Created by yuanxuan on 2018/10/10.
//  Copyright © 2018 wmnt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PendingTableViewCell : UITableViewCell
@property(nonatomic,strong) UIView  *showContentView;
@property(nonatomic,strong) UILabel *appointOrderNoLabel;
@property(nonatomic,strong) UILabel *appointTypeNameLabel; //预约的服务类型名称
@property(nonatomic,strong) UILabel *typeLabel; //预约订单等级 （正常、紧急）
@property(nonatomic,strong) UILabel *appointDateLabel;  //预约时间
@property(nonatomic,strong) UILabel *appointAddressLabel;  //预约人详细地址
@property(nonatomic,strong) UILabel *appointNameLabel; //预约人名字
@property(nonatomic,strong) UILabel *appointPhoneLabel; //预约人手机号
//@property(nonatomic,strong) UIImageView *eaaImgView;        //图标
@end

NS_ASSUME_NONNULL_END
