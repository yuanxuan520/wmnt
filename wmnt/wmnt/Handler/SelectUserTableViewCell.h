//
//  SelectUserTableViewCell.h
//  wmnt
//
//  Created by yuanxuan on 2018/10/22.
//  Copyright © 2018 wmnt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectUserTableViewCell : UITableViewCell
@property(nonatomic,strong) UIView *allcontentView;
@property(nonatomic,strong) UILabel *userNameLabel;    //用户名
@property(nonatomic,strong) UILabel *userTypeLabel;    //选择人员类型
@property(nonatomic,strong) UIButton *userIconView;    //用户头像
@property(nonatomic,strong) UIImageView *userSelectImg;
@end

