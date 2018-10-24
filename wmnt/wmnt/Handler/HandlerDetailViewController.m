//
//  HandlerDetailViewController.m
//  wmnt
//
//  Created by yuanxuan on 2018/10/8.
//  Copyright © 2018 wmnt. All rights reserved.
//

#import "HandlerDetailViewController.h"
#import "UIButton+WebCache.h"
#import "YBImageBrowser.h"
#import "TZImagePickerController.h"
#import "FileOperate.h"
#import "SelectUserViewController.h"
#import "SetPopTextView.h"
#import "SetPopNumTextView.h"
#define contentLeft 10

@interface HandlerDetailViewController ()<TZImagePickerControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableDictionary *orderDetailData;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *appointView;

@property (nonatomic, strong) UIView *statusView;

@property (nonatomic, strong) UIView *personView;

@property (nonatomic, strong) UIView *finishView;
@property (nonatomic, strong) NSMutableArray *curPicList;

@property (nonatomic, strong) UIToolbar *opratiosToolbar;

@property (nonatomic, strong) NSMutableArray *uploadPicURLList;
@property (nonatomic, assign) NSUInteger uploadPicCount;
@end

@implementation HandlerDetailViewController
@synthesize contentView,appointView,personView,finishView;
@synthesize opratiosToolbar;
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //  初始化
    [self initMainData];
    [self initMainMethod];
}
#pragma mark - 数据和页面初始化
// 初始化数据
- (void)initMainData
{
    self.orderDetailData = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.uploadPicURLList = [NSMutableArray arrayWithCapacity:0];
    self.uploadPicCount = 0;
}
// 初始化页面显示
- (void)initMainPage
{
    self.contentView = [[UIView alloc] init];
    [self.mainView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(self.mainView).with.insets(UIEdgeInsetsZero);
        make.width.equalTo(self.mainView);
    }];
    
    NSUInteger status = [self.orderDetailData[@"status"] integerValue];
    switch (status) {
        case 0: // 待接订单
        {
            [self initAppointView];
        }
            break;
        case 10: // 执行中订单
        {
            [self initAppointView];
            [self initPersonView];
            [self initFinishView];
        }
            break;
        case 20:
        {
            [self initAppointView];
            [self initPersonView];
            [self initFinishView];
        }
            break;
        case 30:
        {
            [self initAppointView];
        }
            break;
            
        default:
            break;
    }
    [self initOprationView];
}

// 初始化订单部分
- (void)initAppointView
{
    if (self.appointView == nil) {
        self.appointView = [[UIView alloc] init];
        self.appointView.backgroundColor = [UIColor whiteColor];
        self.appointView.layer.cornerRadius = 10;
        self.appointView.clipsToBounds = YES;
        [self.contentView addSubview:self.appointView];
    }else {
        [self.appointView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    }
    UILabel *typeLabel = [[UILabel alloc] init];
    UILabel *appointOrderNoLabel = [[UILabel alloc] init];
    UILabel *appointDateLabel = [[UILabel alloc] init];
    UILabel *appointAddressLabel = [[UILabel alloc] init];
    UILabel *appointNameLabel = [[UILabel alloc] init];
    UILabel *appointPhoneLabel = [[UILabel alloc] init];
    UILabel *appointTypeNameLabel = [[UILabel alloc] init];
    UILabel *orderFinishReasonLabel = [[UILabel alloc] init];

    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.borderColor = [UIColor colorFromHexRGB:@"ececec"].CGColor;
    topView.layer.borderWidth = .5f;
    [appointView addSubview:topView];
    
    appointOrderNoLabel.textColor = [UIColor colorFromHexRGB:@"555555"];
    appointOrderNoLabel.font = SystemFont(14);
    
    //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
    appointOrderNoLabel.textAlignment = NSTextAlignmentLeft;
    //        appointTypeNameLabel.numberOfLines = 2;
    [topView addSubview:appointOrderNoLabel];
    
    appointTypeNameLabel.textColor = [UIColor colorFromHexRGB:@"555555"];
    appointTypeNameLabel.font = SystemFont(14);
    
    //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
    appointTypeNameLabel.textAlignment = NSTextAlignmentLeft;
    //        appointTypeNameLabel.numberOfLines = 2;
    [topView addSubview:appointTypeNameLabel];
    
    
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.font = SystemFoldFont(12);
    typeLabel.layer.cornerRadius = 5;
    typeLabel.clipsToBounds = YES;
    typeLabel.backgroundColor = [UIColor colorFromHexRGB:@"67C23A"];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    //        appointTypeNameLabel.numberOfLines = 2;
    [topView addSubview:typeLabel];
    
    
    appointDateLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    appointDateLabel.font = SystemFont(13);
    //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
    appointDateLabel.textAlignment = NSTextAlignmentLeft;
    //        appointTypeNameLabel.numberOfLines = 2;
    [appointView addSubview:appointDateLabel];
    
    appointNameLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    appointNameLabel.font = SystemFont(13);
    //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
    appointNameLabel.textAlignment = NSTextAlignmentLeft;
    //        appointTypeNameLabel.numberOfLines = 2;
    [appointView addSubview:appointNameLabel];
    
    appointPhoneLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    appointPhoneLabel.font = SystemFont(13);
    //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
    appointPhoneLabel.textAlignment = NSTextAlignmentLeft;
    //        appointTypeNameLabel.numberOfLines = 2;
    [appointView addSubview:appointPhoneLabel];
    
    appointAddressLabel.textColor = [UIColor colorFromHexRGB:@"0a0a0a"];
    appointAddressLabel.font = SystemFont(13);
    appointAddressLabel.numberOfLines = 0;//多行显示，计算高度
    [appointView addSubview:appointAddressLabel];
    
    orderFinishReasonLabel.textColor = [UIColor colorFromHexRGB:@"0a0a0a"];
    orderFinishReasonLabel.font = SystemFont(13);
    orderFinishReasonLabel.numberOfLines = 0;//多行显示，计算高度
    
    [appointView addSubview:orderFinishReasonLabel];
    
//  设置数据部分
    
    appointOrderNoLabel.text = [NSString stringWithFormat:@"订单号：%@",self.orderDetailData[@"orderNo"]];
    
    appointTypeNameLabel.text = [NSString stringWithFormat:@"服务类型：%@",self.orderDetailData[@"appointTypeName"]];
    if ([self.orderDetailData[@"type"] integerValue] == 1) {
        typeLabel.text = @"正常";
        typeLabel.backgroundColor = [UIColor colorFromHexRGB:@"67C23A"];
    }else {
        typeLabel.text = @"紧急";
        typeLabel.backgroundColor = [UIColor colorFromHexRGB:@"F56C6C"];
    }
    appointDateLabel.text = [NSString stringWithFormat:@"预约时间：%@",self.orderDetailData[@"appointDate"]];
    
    appointNameLabel.text = [NSString stringWithFormat:@"预约人姓名：%@",self.orderDetailData[@"appointName"]];
    
    appointPhoneLabel.text = [NSString stringWithFormat:@"联系方式：%@",self.orderDetailData[@"appointPhone"]];
    
    appointAddressLabel.text = [NSString stringWithFormat:@"预约地址：%@",self.orderDetailData[@"appointAddress"]];
    
    NSString *orderFinishReason = self.orderDetailData[@"orderFinishReason"];
    if (!orderFinishReason) {
        orderFinishReason = @"-";
    }
    orderFinishReasonLabel.text = [NSString stringWithFormat:@"拒绝原因：%@",orderFinishReason];
    
    [appointOrderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(contentLeft);
        make.width.mas_equalTo(APPMainViewWidth);
        make.height.mas_equalTo(25);
    }];
    
    [appointTypeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(appointOrderNoLabel.mas_bottom);
        make.left.mas_equalTo(contentLeft);
        make.width.mas_equalTo(APPMainViewWidth);
        make.height.mas_equalTo(25);
    }];
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    [appointDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(5);
        make.left.mas_equalTo(contentLeft);
        make.width.mas_equalTo(APPMainViewWidth);
        make.height.mas_equalTo(20);
    }];
    //
    [appointNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(appointDateLabel.mas_bottom).offset(5);
        //self.appointNameLabel
        make.left.mas_equalTo(contentLeft);
        make.width.mas_equalTo(APPMainViewWidth);
        make.height.mas_equalTo(20);
    }];
    
    [appointPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(appointNameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(contentLeft);
        make.width.mas_equalTo(APPMainViewWidth);
        make.height.mas_equalTo(20);
    }];
    
    
    [appointAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(appointPhoneLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(contentLeft);
        make.right.mas_equalTo(-5);
//        make.bottom.equalTo(self.appointView).with.offset(-10);
    }];
    
    [orderFinishReasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(appointAddressLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(contentLeft);
        make.right.mas_equalTo(-5);
        make.bottom.equalTo(self.appointView).with.offset(-10);
    }];
    
    [self.appointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        CGFloat w = APPMainViewWidth - 10;
        make.width.mas_equalTo(w);
        make.bottom.mas_equalTo(orderFinishReasonLabel.mas_bottom).offset(10);
    }];
}

// 初始化接单人员部分
- (void)initPersonView
{
    if (self.personView == nil) {
        self.personView = [[UIView alloc] init];
        self.personView.backgroundColor = [UIColor whiteColor];
        self.personView.layer.cornerRadius = 10;
        self.personView.clipsToBounds = YES;
        [self.contentView addSubview:self.personView];
        
    }else {
        [self.personView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    UILabel *serviceStaffNameLabel = [[UILabel alloc] init];
    UILabel *serviceStaffPhoneLabel = [[UILabel alloc] init];
    UILabel *staffMembersLabel = [[UILabel alloc] init];
    
    serviceStaffNameLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    serviceStaffNameLabel.font = SystemFont(13);
    //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
    serviceStaffNameLabel.textAlignment = NSTextAlignmentLeft;
    //        appointTypeNameLabel.numberOfLines = 2;
    [personView addSubview:serviceStaffNameLabel];
    
    serviceStaffPhoneLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    serviceStaffPhoneLabel.font = SystemFont(13);
    //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
    serviceStaffPhoneLabel.textAlignment = NSTextAlignmentLeft;
    //        appointTypeNameLabel.numberOfLines = 2;
    [personView addSubview:serviceStaffPhoneLabel];
    
    staffMembersLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    staffMembersLabel.font = SystemFont(13);
    //        appointTypeNameLabel.layer.backgroundColor = [UIColor colorFromHexRGB:@"fe943e"].CGColor;
    staffMembersLabel.textAlignment = NSTextAlignmentLeft;
    staffMembersLabel.numberOfLines = 0;
    [personView addSubview:staffMembersLabel];
    
    serviceStaffNameLabel.text = [NSString stringWithFormat:@"带队人姓名：%@",self.orderDetailData[@"serviceStaffName"]];
    serviceStaffPhoneLabel.text = [NSString stringWithFormat:@"带队人电话：%@",self.orderDetailData[@"serviceStaffPhone"]];
    
    
    NSMutableString *staffMembersStr = [NSMutableString stringWithCapacity:0];
    NSMutableArray *staffMembers = self.orderDetailData[@"staffMembers"];
    for (int i = 0; i < staffMembers.count; i++) {
        NSDictionary *personInfo = staffMembers[i];
        NSString *personStr = [NSString stringWithFormat:@"%@(%@)",personInfo[@"name"],personInfo[@"phone"]];
        if (i == 0) {
            [staffMembersStr appendString:personStr];
        }else {
            [staffMembersStr appendString:@"、"];
            [staffMembersStr appendString:personStr];
        }
    }
    if ([staffMembersStr isEqualToString:@""]) {
        [staffMembersStr appendString:@" - "];
    }
    staffMembersLabel.text = [NSString stringWithFormat:@"其他分派人员：%@",staffMembersStr];
    
    [serviceStaffNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(contentLeft);
        make.width.mas_equalTo(APPMainViewWidth);
        make.height.mas_equalTo(25);
    }];
    
    
    [serviceStaffPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(serviceStaffNameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(contentLeft);
        make.width.mas_equalTo(APPMainViewWidth);
        make.height.mas_equalTo(25);
    }];
    
    [staffMembersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(serviceStaffPhoneLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(contentLeft);
        make.right.mas_equalTo(-5);
        make.bottom.equalTo(self.personView).with.offset(-10);
    }];
    
    [self.personView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.appointView.mas_bottom).offset(10);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        //        make.edges.mas_equalTo(self.mainView);
        CGFloat w = APPMainViewWidth - 10;
        make.width.mas_equalTo(w);
//        make.leading.mas_equalTo(self.appointView.mas_trailing);
//        make.height.mas_equalTo(1000);
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(staffMembersLabel.mas_bottom).offset(10);
    }];
}

// 初始化完成情况部分
- (void)initFinishView
{
    if (self.finishView == nil) {
        self.finishView = [[UIView alloc] init];
        self.finishView.backgroundColor = [UIColor whiteColor];
        self.finishView.layer.cornerRadius = 10;
        self.finishView.clipsToBounds = YES;
        [self.contentView addSubview:self.finishView];
    }else {
        [self.finishView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    UILabel *receiveTimeLabel = [[UILabel alloc] init];
    UILabel *finishTimeLabel = [[UILabel alloc] init];
    UILabel *rechargeAmtLabel = [[UILabel alloc] init];
    UILabel *finishPictureLabel = [[UILabel alloc] init];
    UIView *finishPictureView = [[UIView alloc] init];
    
    receiveTimeLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    receiveTimeLabel.font = SystemFont(14);
    receiveTimeLabel.textAlignment = NSTextAlignmentLeft;
    [finishView addSubview:receiveTimeLabel];
    
    finishTimeLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    finishTimeLabel.font = SystemFont(14);
    finishTimeLabel.textAlignment = NSTextAlignmentLeft;
    [finishView addSubview:finishTimeLabel];
    
    rechargeAmtLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    rechargeAmtLabel.font = SystemFont(14);
    rechargeAmtLabel.textAlignment = NSTextAlignmentLeft;
    [finishView addSubview:rechargeAmtLabel];
    
    finishPictureLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
    finishPictureLabel.font = SystemFont(14);
    finishPictureLabel.textAlignment = NSTextAlignmentLeft;
    [finishView addSubview:finishPictureLabel];
    
    [finishView addSubview:finishPictureView];
    
    receiveTimeLabel.text = [NSString stringWithFormat:@"服务接单时间：%@",self.orderDetailData[@"receiveTime"]];
    
    //   设置数据
    finishTimeLabel.text = [NSString stringWithFormat:@"服务完成时间：%@",self.orderDetailData[@"finishTime"]];
    
    NSString *rechargeAmt = self.orderDetailData[@"rechargeAmt"];
    if (!rechargeAmt) {
        rechargeAmt = @" - ";
    }else {
        rechargeAmt = [NSString stringWithFormat:@"%@ 元",rechargeAmt];
    }
    rechargeAmtLabel.text = [NSString stringWithFormat:@"交易金额：%@",rechargeAmt];
    
    [receiveTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(contentLeft);
        make.width.mas_equalTo(APPMainViewWidth);
        make.height.mas_equalTo(25);
    }];
    
    [finishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(receiveTimeLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(contentLeft);
        make.width.mas_equalTo(APPMainViewWidth);
        make.height.mas_equalTo(20);
    }];
    //
    [rechargeAmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(finishTimeLabel.mas_bottom).offset(5);
        //self.appointNameLabel
        make.left.mas_equalTo(contentLeft);
        make.width.mas_equalTo(APPMainViewWidth);
        make.height.mas_equalTo(20);
    }];
    
    [finishPictureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rechargeAmtLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(contentLeft);
        make.width.mas_equalTo(APPMainViewWidth);
        make.height.mas_equalTo(20);
    }];
    
    NSLog(@"finishPicture=====%@",self.orderDetailData[@"finishPicture"]);
    NSString *finishPic = self.orderDetailData[@"finishPicture"];
    if (!self.curPicList) {
        self.curPicList = [NSMutableArray arrayWithCapacity:0];
    }else {
        [self.curPicList removeAllObjects];
    }
    
    NSMutableArray *picList = nil;
    if (finishPic) {
        finishPic = [finishPic stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        picList = [NSMutableArray arrayWithArray:[finishPic componentsSeparatedByString:@","]];
        if (picList.count > 1) {
            [picList removeLastObject];
        }
        finishPic = @"";
    }else {
        picList = [NSMutableArray array];
        finishPic = @" - ";
    }
    finishPictureLabel.text = [NSString stringWithFormat:@"服务完成照片：%@",finishPic];
    // 为该容器添加宫格View
    UIButton *lastPicBtn = nil;
    NSUInteger lineNum = 3;
    for (int i = 0; i < picList.count; i++) {
        UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imgURL = [NSString stringWithFormat:@"http://www.weimao.ink/picture/%@.jpg",picList[i]];
        picBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        picBtn.clipsToBounds = YES;
        picBtn.tag = i;
        [picBtn addTarget:self action:@selector(tapImg:) forControlEvents:UIControlEventTouchUpInside];
        [picBtn sd_setImageWithURL:[NSURL URLWithString:imgURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loadingImg"] options:SDWebImageHandleCookies|SDWebImageRetryFailed  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
        YBImageBrowseCellData *data = [YBImageBrowseCellData new];
        data.url = [NSURL URLWithString:imgURL];
        data.sourceObject = picBtn;
        [self.curPicList addObject:data];
//        label.text = [NSString stringWithFormat:@"~%d~",i];
        [finishPictureView addSubview:picBtn];
        [picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                //计算距离顶部的公式 60 = 上一个距离顶部的高度 + UIlabel的高度
            float colTop = (i/lineNum*10 + i/lineNum * 100.0f );
            make.top.mas_equalTo(colTop);
            make.height.mas_equalTo(100.0f);
            make.width.mas_equalTo(100.0f);
            if (i%lineNum == 0) {
                make.left.offset(0);
            }else{
                //当时中间列的时候 在上一个UIlabel的右边 添加20个 距离 并且设置等高
                make.left.equalTo(lastPicBtn.mas_right).offset(10.0f);
            }
        }];
        lastPicBtn = picBtn;
    }
    if (lastPicBtn) {
        [finishPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(finishPictureLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(contentLeft);
            make.width.mas_equalTo(APPMainViewWidth);
            make.bottom.mas_equalTo(lastPicBtn.mas_bottom);
        }];
    }else {
        [finishPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(finishPictureLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(contentLeft);
            make.width.mas_equalTo(APPMainViewWidth);
        }];
    }
    
    
    [self.finishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.personView.mas_bottom).offset(10);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        //        make.edges.mas_equalTo(self.mainView);
        CGFloat w = APPMainViewWidth - 10;
        make.width.mas_equalTo(w);
//        make.leading.mas_equalTo(self.personView.mas_trailing);

        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(finishPictureView.mas_bottom).offset(10);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.finishView.mas_bottom).offset(10);
    }];
}

// 初始化操作按钮
- (void)initOprationView
{
    if (self.opratiosToolbar == nil) {
        self.opratiosToolbar = [[UIToolbar alloc] init];
        self.opratiosToolbar.backgroundColor = [UIColor whiteColor];
        self.opratiosToolbar.userInteractionEnabled = YES;
        [self.view addSubview:self.opratiosToolbar];
        [self.opratiosToolbar layoutIfNeeded];
        [self.opratiosToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(Height_TapBar);
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
    }else {
        [self.opratiosToolbar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.opratiosToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(Height_TapBar);
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
    }
    
    NSUInteger role = [self.orderDetailData[@"role"] integerValue];
    // role 1 工作人员 2 带队人员 3 管理人员
    NSUInteger status = [self.orderDetailData[@"status"] integerValue];
    switch (role) {
//        case 1:
//        {
//            self.opratiosToolbar.hidden = YES;
//        }
//            break;
        case 3: //3 管理人员
        {
            if (status == 0) {
                //接受按钮
                UIButton *acceptBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                acceptBtn.titleLabel.font = SystemFont(14);
                acceptBtn.userInteractionEnabled = YES;
                [acceptBtn setTitle:@"接受订单" forState:UIControlStateNormal];
                acceptBtn.clipsToBounds = YES;
                acceptBtn.backgroundColor = [UIColor colorFromHexRGB:@"67C23A"];
                acceptBtn.layer.cornerRadius = 5;
                [acceptBtn addTarget:self action:@selector(acceptOrder:) forControlEvents:UIControlEventTouchUpInside];
                [acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.opratiosToolbar addSubview:acceptBtn];
                [acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(5);
                    make.right.mas_equalTo(-20);
                    make.width.mas_equalTo(100);
                    make.height.mas_equalTo(40);
                }];
                
                //拒绝按钮
                UIButton *refuseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                refuseBtn.titleLabel.font = SystemFont(14);
                refuseBtn.userInteractionEnabled = YES;
                [refuseBtn setTitle:@"拒绝订单" forState:UIControlStateNormal];
                //                refuseBtn.clipsToBounds = YES;
                refuseBtn.backgroundColor = [UIColor colorFromHexRGB:@"F56C6C"];
                refuseBtn.layer.cornerRadius = 5;
                [refuseBtn addTarget:self action:@selector(refuseOrder:) forControlEvents:UIControlEventTouchUpInside];
                [refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.opratiosToolbar addSubview:refuseBtn];
                [refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(5);
                    make.right.mas_equalTo(acceptBtn.mas_left).offset(-20);
                    make.width.mas_equalTo(100);
                    make.height.mas_equalTo(40);
                }];
            }else {
                self.opratiosToolbar.hidden = YES;
            }
        }
            break;
        case 2: // 2 带队人员
        {
            if (status == 0) {
                //接受按钮
                UIButton *affirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                affirmBtn.titleLabel.font = SystemFont(14);
                affirmBtn.userInteractionEnabled = YES;
                [affirmBtn setTitle:@"确认订单" forState:UIControlStateNormal];
                affirmBtn.clipsToBounds = YES;
                affirmBtn.backgroundColor = [UIColor colorFromHexRGB:@"67C23A"];
                affirmBtn.layer.cornerRadius = 5;
                [affirmBtn addTarget:self action:@selector(affirmOrder:) forControlEvents:UIControlEventTouchUpInside];
                [affirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.opratiosToolbar addSubview:affirmBtn];
                [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(5);
                    make.centerX.mas_equalTo(self.opratiosToolbar.mas_centerX);
                    make.width.mas_equalTo(100);
                    make.height.mas_equalTo(40);
                }];
                
            } else if (status == 10) {
                //接受按钮
                UIButton *uploadImgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                uploadImgBtn.titleLabel.font = SystemFont(14);
                uploadImgBtn.userInteractionEnabled = YES;
                [uploadImgBtn setTitle:@"上传照片" forState:UIControlStateNormal];
                uploadImgBtn.clipsToBounds = YES;
                uploadImgBtn.backgroundColor = [UIColor colorFromHexRGB:@"67C23A"];
                uploadImgBtn.layer.cornerRadius = 5;
                [uploadImgBtn addTarget:self action:@selector(uploadOrderImg:) forControlEvents:UIControlEventTouchUpInside];
                [uploadImgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.opratiosToolbar addSubview:uploadImgBtn];
                [uploadImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(5);
                    make.right.mas_equalTo(-20);
                    make.width.mas_equalTo(100);
                    make.height.mas_equalTo(40);
                }];
                
                //拒绝按钮
                UIButton *finishOrderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                finishOrderBtn.titleLabel.font = SystemFont(14);
                finishOrderBtn.userInteractionEnabled = YES;
                [finishOrderBtn setTitle:@"完成订单" forState:UIControlStateNormal];
                finishOrderBtn.backgroundColor = [UIColor colorFromHexRGB:@"409EFF"];
                finishOrderBtn.layer.cornerRadius = 5;
                [finishOrderBtn addTarget:self action:@selector(finishOrder:) forControlEvents:UIControlEventTouchUpInside];
                [finishOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.opratiosToolbar addSubview:finishOrderBtn];
                [finishOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(5);
                    make.right.mas_equalTo(uploadImgBtn.mas_left).offset(-20);
                    make.width.mas_equalTo(100);
                    make.height.mas_equalTo(40);
                }];
            }else {
               self.opratiosToolbar.hidden = YES;
            }
        }
            break;
        default:
            self.opratiosToolbar.hidden = YES;
            break;
    }
    if (self.opratiosToolbar.hidden) {
        [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
            make.height.equalTo(self.view);
        }];
    }else {
        [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
            make.height.equalTo(self.view).offset(-Height_TapBar);
        }];
    }
    
}

//初始化调用方法
- (void)initMainMethod
{
    [self requestDetailData];
}
#pragma mark - 按钮操作部分
// 管理人员部分
- (void)tapImg:(UIButton *)btn
{
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = self.curPicList;
    browser.currentIndex = btn.tag;
    [browser show];
}

//接受订单
- (void)acceptOrder:(UIButton *)btn
{
    kSelfWeak;
    SelectUserViewController *selectUserViewController = [[SelectUserViewController alloc] init];
    selectUserViewController.title = @"分配服务人员";
    selectUserViewController.userMultiSelect = ^(NSMutableArray *selectedlist) {
        [weakSelf requestStaffAssignData:selectedlist];
    };
    YXNavigationController *navViewController = [[YXNavigationController alloc]initWithRootViewController:selectUserViewController];
    [self presentViewController:navViewController animated:YES completion:^{
        
    }];
}

//拒绝订单
- (void)refuseOrder:(UIButton *)btn
{
    kSelfWeak;
    SetPopTextView *setPopTextView = [[SetPopTextView alloc] init];
    [setPopTextView show:self.view.window setTitle:@"请填写拒绝原因" setSetText:^(NSString *notice) {
        [weakSelf requestAppointOrderRefuseData:notice];
    }];
}

// 服务人员部分
// 确认订单
- (void)affirmOrder:(UIButton *)btn
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认要接单么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self requestAppointStaffAffirmData];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
// 上传图片
- (void)uploadOrderImg:(UIButton *)btn
{
    [self.uploadPicURLList removeAllObjects];
    self.uploadPicCount = 0;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        //        NSLog(@"%@",photos);
        for (int i = 0 ; i < photos.count ; i++) {
            UIImage *orienTationImage = [self fixOrientation:[photos objectAtIndex:i]];
            [self saveImg:orienTationImage forindex:i];
        }
        [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeClear];
        [self requestUploadImg];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// 服务完成
- (void)finishOrder:(UIButton *)btn
{
    kSelfWeak;
    SetPopNumTextView *setPopNumTextView = [[SetPopNumTextView alloc] init];
    [setPopNumTextView show:self.view.window setTitle:@"请输入完成订单金额:" setSetNumText:^(NSString *numText) {
        NSUInteger rechargeAmt = [numText integerValue];
        [weakSelf requestAppointOrderFinishData:rechargeAmt];
    }];
}

//// 其他操作
- (NSString *)findSavePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *imgPath = [docDir stringByAppendingPathComponent:@"OrderFinishImg"];
    return imgPath;
}

- (BOOL)saveImg:(UIImage *)img forindex:(NSInteger)index
{
    NSData *data;
    data = UIImageJPEGRepresentation(img, 0.1);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithString:[self findSavePath]];         //将图片存储到本地documents
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    NSDate *currentdate = [NSDate date];
    [dateformatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *imgfilestr = [dateformatter stringFromDate:currentdate];
    NSString *imagename = [NSString stringWithFormat:@"/image_%@.jpg",imgfilestr];
    if ([fileManager createFileAtPath:[filePath stringByAppendingString:imagename] contents:data attributes:nil]) {
        [self.uploadPicURLList addObject:[filePath stringByAppendingString:imagename]];

        return YES;
    }else{
        return NO;
    }
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)finishUploadPic
{
    kSelfWeak;
    int64_t sec = (int64_t)(2 * NSEC_PER_SEC);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec), dispatch_get_main_queue(), ^{
        [weakSelf requestDetailData];
    });
}

- (void)finishBack
{
    kSelfWeak;
    int64_t sec = (int64_t)(2 * NSEC_PER_SEC);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - 接口请求部分

/**
 请求订单详情数据
 */
- (void)requestDetailData
{
    kSelfWeak;
    [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeClear];
    
    NSString *dJson = [NSString stringWithFormat:@"{\"orderNo\":\"%@\"}",self.orderNo];
    
    RequestData *requestData = [[RequestData alloc] init];
    [requestData startAFRequest:API_AppointOrderDetail
                    requestdata:dJson
                 timeOutSeconds:10
                completionBlock:^(NSDictionary *json) {
                    NSLog(@"%@",json[@"msg"]);
                    [WSProgressHUD dismiss];
                    if ([json[@"param"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *data = json[@"param"];
                        weakSelf.orderDetailData = [NSMutableDictionary dictionaryWithDictionary:data];
                        [self initMainPage];
                    }else {
                        [WSProgressHUD showShimmeringString:json[@"msg"] maskType:WSProgressHUDMaskTypeDefault];
                        [WSProgressHUD autoDismiss:2];
                    }
                }
                    failedBlock:^(NSError *error) {
                        [WSProgressHUD showShimmeringString:@"网络请求失败" maskType:WSProgressHUDMaskTypeDefault];
                        [WSProgressHUD autoDismiss:1];
                    }];
}

/**
 请求分配人员
 */
- (void)requestStaffAssignData:(NSArray *)userList
{
    kSelfWeak;
    [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeClear];
    NSString *leader = [userList firstObject][@"account"];
    NSMutableArray *users = [NSMutableArray arrayWithArray:userList];
    [users removeObjectAtIndex:0];
    NSMutableString *usersAccounts = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < users.count; i++) {
        if (i == 0) {
            [usersAccounts appendString:users[i][@"account"]];
        }else {
            [usersAccounts appendString:@","];
            [usersAccounts appendString:users[i][@"account"]];
        }
    }
    NSString *dJson = [NSString stringWithFormat:@"{\"leader\":\"%@\",\"member\":\"%@\",\"orderNo\":\"%@\"}",leader,usersAccounts,self.orderNo];
    RequestData *requestData = [[RequestData alloc] init];
    [requestData startAFRequest:API_StaffAssign
                    requestdata:dJson
                 timeOutSeconds:10
                completionBlock:^(NSDictionary *json) {
                    NSUInteger code = [json[@"code"] integerValue];
                    switch (code) {
                        case 1001:
                        {
                            [WSProgressHUD showShimmeringString:@"人员已分配" maskType:WSProgressHUDMaskTypeDefault];
                            [WSProgressHUD autoDismiss:2];
                            [weakSelf finishBack];
                        }
                            break;
                        default:
                        {
                            [WSProgressHUD showShimmeringString:json[@"msg"] maskType:WSProgressHUDMaskTypeDefault];
                            [WSProgressHUD autoDismiss:2];
                        }
                            break;
                    }
                }
                    failedBlock:^(NSError *error) {
                        [WSProgressHUD showShimmeringString:@"网络请求失败" maskType:WSProgressHUDMaskTypeDefault];
                        [WSProgressHUD autoDismiss:2];
                    }];
}

/**
 请求拒绝订单
 */
- (void)requestAppointOrderRefuseData:(NSString *)refuseReason
{
    kSelfWeak;
    [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeClear];
    NSString *dJson = [NSString stringWithFormat:@"{\"reason\":\"%@\",\"orderNo\":\"%@\"}",refuseReason,self.orderNo];
    RequestData *requestData = [[RequestData alloc] init];
    [requestData startAFRequest:API_AppointOrderRefuse
                    requestdata:dJson
                 timeOutSeconds:10
                completionBlock:^(NSDictionary *json) {
                    NSUInteger code = [json[@"code"] integerValue];
                    switch (code) {
                        case 1001:
                        {
                            [WSProgressHUD showShimmeringString:@"订单已拒绝" maskType:WSProgressHUDMaskTypeDefault];
                            [WSProgressHUD autoDismiss:2];
                            [weakSelf finishBack];
                        }
                            break;
                        default:
                        {
                            [WSProgressHUD showShimmeringString:json[@"msg"] maskType:WSProgressHUDMaskTypeDefault];
                            [WSProgressHUD autoDismiss:1];
                        }
                            break;
                    }
                }
                    failedBlock:^(NSError *error) {
                        [WSProgressHUD showShimmeringString:@"网络请求失败" maskType:WSProgressHUDMaskTypeDefault];
                        [WSProgressHUD autoDismiss:1];
                    }];
}

////////// 服务人员
/**
 确认订单
 */
- (void)requestAppointStaffAffirmData
{
    kSelfWeak;
    [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeClear];
    NSString *dJson = [NSString stringWithFormat:@"{\"orderNo\":\"%@\"}",self.orderNo];
    RequestData *requestData = [[RequestData alloc] init];
    [requestData startAFRequest:API_AppointStaffAffirm
                    requestdata:dJson
                 timeOutSeconds:10
                completionBlock:^(NSDictionary *json) {
                    NSUInteger code = [json[@"code"] integerValue];
                    switch (code) {
                        case 1001:
                        {
                            [WSProgressHUD showShimmeringString:@"订单已确认" maskType:WSProgressHUDMaskTypeDefault];
                            [WSProgressHUD autoDismiss:2];
                            [weakSelf finishBack];
//                            [weakSelf requestDetailData];
                        }
                            break;
                        default:
                        {
                            [WSProgressHUD showShimmeringString:json[@"msg"] maskType:WSProgressHUDMaskTypeDefault];
                            [WSProgressHUD autoDismiss:1];
                        }
                            break;
                    }
                }
                    failedBlock:^(NSError *error) {
                        [WSProgressHUD showShimmeringString:@"网络请求失败" maskType:WSProgressHUDMaskTypeDefault];
                        [WSProgressHUD autoDismiss:1];
                    }];
}

/**
 上传图片
 */
- (void)requestUploadImg
{
    kSelfWeak;
    NSString *dJson = [NSString stringWithFormat:@"{\"orderNo\":\"%@\"}",self.orderNo];
    RequestData *requestData = [[RequestData alloc] init];
    NSString *url = [self.uploadPicURLList objectAtIndex:self.uploadPicCount];
    NSString *uploadMsg = [NSString stringWithFormat:@"正在上传(%ld/%ld)",self.uploadPicCount+1,self.uploadPicURLList.count];
    [requestData uploadFile:url requestdata:dJson timeOutSeconds:10 progress:^(CGFloat progress) {
        [WSProgressHUD showProgress:progress status:uploadMsg maskType:WSProgressHUDMaskTypeBlack];
    } completionBlock:^(NSDictionary *json) {
        NSUInteger code = [json[@"code"] integerValue];
        switch (code) {
            case 1001:
            {
                self.uploadPicCount++;
                if (self.uploadPicCount < self.uploadPicURLList.count) {
                    [weakSelf requestUploadImg];
                }else {
                    [WSProgressHUD showShimmeringString:@"照片上传完成" maskType:WSProgressHUDMaskTypeBlack];
                    [WSProgressHUD autoDismiss:2];
                    [self finishUploadPic];
                    [weakSelf requestDetailData];
                }
                FileOperate *fileop = [[FileOperate alloc] init];
                [fileop deleteFilePath:url];
            }
                break;
            default:
            {
                [WSProgressHUD showShimmeringString:json[@"msg"] maskType:WSProgressHUDMaskTypeDefault];
                [WSProgressHUD autoDismiss:2];
            }
                break;
        }
    } failedBlock:^(NSError *error) {
        [WSProgressHUD showShimmeringString:@"upload image fail." maskType:WSProgressHUDMaskTypeBlack];
        [WSProgressHUD autoDismiss:1.5];
    }];
}

/**
 完成订单
 */
- (void)requestAppointOrderFinishData:(NSUInteger)rechargeAmt
{
    kSelfWeak;
    [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeClear];
    NSString *dJson = [NSString stringWithFormat:@"{\"rechargeAmt\":\"%ld\",\"orderNo\":\"%@\"}",rechargeAmt,self.orderNo];
    RequestData *requestData = [[RequestData alloc] init];
    [requestData startAFRequest:API_AppointOrderFinish
                    requestdata:dJson
                 timeOutSeconds:10
                completionBlock:^(NSDictionary *json) {
                    NSUInteger code = [json[@"code"] integerValue];
                    switch (code) {
                        case 1001:
                        {
                            [WSProgressHUD showShimmeringString:@"完成订单" maskType:WSProgressHUDMaskTypeDefault];
                            [WSProgressHUD autoDismiss:2];
                            [weakSelf finishBack];
                        }
                            break;
                        default:
                        {
                            [WSProgressHUD showShimmeringString:json[@"msg"] maskType:WSProgressHUDMaskTypeDefault];
                            [WSProgressHUD autoDismiss:2];
                        }
                            break;
                    }
                }
                    failedBlock:^(NSError *error) {
                        [WSProgressHUD showShimmeringString:@"网络请求失败" maskType:WSProgressHUDMaskTypeDefault];
                        [WSProgressHUD autoDismiss:2];
                    }];
}





@end
