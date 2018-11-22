//
//  HandlerViewController.m
//  wmnt
//
//  Created by yuanxuan on 2018/10/8.
//  Copyright © 2018 wmnt. All rights reserved.
//

#import "HandlerViewController.h"
//控制器
#import "HandlerDetailViewController.h"
#import "SearchHandlerViewController.h"

//控件视图
#import "PopoverView.h"
#import "MJRefresh.h"
#import "PendingTableViewCell.h"
#import "ImageTitleButton.h"
@interface HandlerViewController ()<UITableViewDelegate, UITableViewDataSource>
// 数据部分
@property (nonatomic, strong) NSMutableArray *mainDataList;
@property (nonatomic, assign) NSString *status;

// 视图部分
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *appointOrderBtn;
@property (nonatomic, strong) UIImageView *orderImgView;
@end

@implementation HandlerViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_appointOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - _appointOrderBtn.imageView.image.size.width, 0, _appointOrderBtn.imageView.image.size.width-16)];
    [_appointOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(8, _appointOrderBtn.titleLabel.bounds.size.width, 8, -_appointOrderBtn.titleLabel.bounds.size.width)];
    [self requestListData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//  初始化
    [self initMainData];
    [self initMainPage];
    [self initMainMethod];
}
#pragma mark - 数据和页面初始化
// 初始化数据
- (void)initMainData
{
    _status = @"0";
    _mainDataList = [NSMutableArray arrayWithCapacity:0];
}
// 初始化页面显示
- (void)initMainPage
{
    self.mainView.backgroundColor = [UIColor whiteColor];
//  选择订单状态
    _appointOrderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _appointOrderBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _appointOrderBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _appointOrderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _appointOrderBtn.frame = CGRectMake(0, 0, 180, 40);
    [_appointOrderBtn addTarget:self action:@selector(selectAppointOrder:) forControlEvents:UIControlEventTouchUpInside];
    _appointOrderBtn.titleLabel.font = SystemFoldFont(16);
    [_appointOrderBtn setTitle:@"待接受的订单" forState:UIControlStateNormal];
    [_appointOrderBtn setTitleColor:UIColorHex(0xf39802) forState:UIControlStateNormal];
    [_appointOrderBtn setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    [_appointOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - _appointOrderBtn.imageView.image.size.width, 0, _appointOrderBtn.imageView.image.size.width-16)];
    [_appointOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _appointOrderBtn.titleLabel.bounds.size.width, 0, -_appointOrderBtn.titleLabel.bounds.size.width)];
    
    
    _orderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _orderImgView.image = [UIImage imageNamed:@"wating-order"];
    [_appointOrderBtn addSubview:_orderImgView];
    
    self.navigationItem.titleView = _appointOrderBtn;

    [self addRightSearch];
    
//   订单列表
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, kTabbarRootBodyHeight) style:UITableViewStylePlain];
//    NSLog(@"%f",Height_TapBar);
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _mainTableView.separatorColor = [UIColor clearColor];
    [self.mainView addSubview:_mainTableView];
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.estimatedRowHeight = 140;//估算高度
    MJRefreshNormalHeader *reloadheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestListData)];
    [reloadheader setTitle:@"下拉刷新.." forState:MJRefreshStateIdle];
    [reloadheader setTitle:@"松开刷新.." forState:MJRefreshStatePulling];
    [reloadheader setTitle:@"正在刷新.." forState:MJRefreshStateRefreshing];
    [reloadheader setTitle:@"数据加载完毕" forState:MJRefreshStateWillRefresh];

    
    reloadheader.lastUpdatedTimeLabel.hidden = YES;
//    [reloadheader ]
    _mainTableView.mj_header = reloadheader;
    
    // 注册cell
    [_mainTableView registerClass:[PendingTableViewCell class] forCellReuseIdentifier:@"PendingTableViewCell"];
    [self addNoDataView:_mainTableView];
}
- (void)addRightSearch
{
    ImageTitleButton *imgTitleButton = [[ImageTitleButton alloc] initWithStyle:EImageLeftTitleRightLeft maggin:UIEdgeInsetsMake(0, 5, 0, 5)];
    imgTitleButton.clipsToBounds = YES;
    imgTitleButton.layer.cornerRadius = 5;
    imgTitleButton.frame = CGRectMake(0, 0, 50, 30);
    imgTitleButton.backgroundColor = [UIColor colorFromHexRGB:@"ffffff"];
    [imgTitleButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    imgTitleButton.titleLabel.font = SystemFont(15);
    [imgTitleButton setTitleColor:[UIColor colorFromHexRGB:@"979797"] forState:UIControlStateNormal];
    [imgTitleButton addTarget:self action:@selector(searchOrder:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:imgTitleButton];
    [self.navigationItem setRightBarButtonItem:barbtn];
    //    [self.navigationItem setTitleView:imgTitleButton];
}
//初始化调用方法
- (void)initMainMethod
{
    [self requestListData];
}
#pragma mark - 按钮操作部分

- (void)selectAppointOrder:(UIButton *)btn
{
    kSelfWeak;
    [_appointOrderBtn setImage:[UIImage imageNamed:@"arrows_up"] forState:UIControlStateNormal];
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.arrowStyle = PopoverViewArrowStyleTriangle;
    popoverView.showShade = YES;
    [popoverView setHidePopoverView:^{
        [weakSelf.appointOrderBtn setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    }];
    
    PopoverAction *action1 = [PopoverAction actionWithImage:[UIImage imageNamed:@"orderNo"] title:@"待接受的订单" handler:^(PopoverAction *action) {
        weakSelf.status = @"0";
        [weakSelf.appointOrderBtn setTitle:action.title forState:UIControlStateNormal];
        [weakSelf requestListData];
        [weakSelf.appointOrderBtn setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    }];
    PopoverAction *action2 = [PopoverAction actionWithImage:[UIImage imageNamed:@"order-waiting"] title:@"进行中的订单" handler:^(PopoverAction *action) {
        weakSelf.status = @"10";
        [weakSelf.appointOrderBtn setTitle:action.title forState:UIControlStateNormal];
        [weakSelf requestListData];
        [weakSelf.appointOrderBtn setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    }];
    PopoverAction *action3 = [PopoverAction actionWithImage:[UIImage imageNamed:@"order-agree"] title:@"已完成的订单" handler:^(PopoverAction *action) {
        weakSelf.status = @"20";
        [weakSelf.appointOrderBtn setTitle:action.title forState:UIControlStateNormal];
        [weakSelf requestListData];
        [weakSelf.appointOrderBtn setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    }];
    PopoverAction *action4 = [PopoverAction actionWithImage:[UIImage imageNamed:@"order-end"] title:@"已结束的订单" handler:^(PopoverAction *action) {
        weakSelf.status = @"30";
        [weakSelf.appointOrderBtn setTitle:action.title forState:UIControlStateNormal];
        [weakSelf requestListData];
        [weakSelf.appointOrderBtn setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
    }];
    [popoverView showToView:btn withActions:@[action1,action2,action3,action4]];
}


- (void)searchOrder:(UIButton *)btn
{
    SearchHandlerViewController *searchHandlerViewController = [[SearchHandlerViewController alloc] init];
    searchHandlerViewController.hidesBottomBarWhenPushed = YES;
    [searchHandlerViewController.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:searchHandlerViewController animated:NO];
}
#pragma mark - 接口请求部分

/**
 请求订单列表数据
 */
- (void)requestListData
{
    kSelfWeak;
    [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeClear];
    
    NSString *dJson = [NSString stringWithFormat:@"{\"status\":\"%@\",\"pageSize\":\"50\",\"pageNo\":\"0\"}",_status];
    
    RequestData *requestData = [[RequestData alloc] init];
    [requestData startAFRequest:API_AppointOrderList
                    requestdata:dJson
                 timeOutSeconds:10
                completionBlock:^(NSDictionary *json) {
                    NSLog(@"%@",json[@"msg"]);
//                    NSLog(@"%@",json);
                    if ([weakSelf.mainTableView.mj_header isRefreshing]) {
                        [weakSelf.mainTableView.mj_header endRefreshing];
                    }
                    [WSProgressHUD dismiss];
                    if ([json[@"param"] isKindOfClass:[NSArray class]]) {
                        if (weakSelf.mainDataList) {
                            weakSelf.mainDataList = nil;
                        }
                        NSArray *dataList = json[@"param"];
                        weakSelf.mainDataList = [NSMutableArray arrayWithArray:dataList];
                        [weakSelf.mainTableView reloadData];
                        if (_mainDataList.count == 0) {
                            self.noDataView.hidden = NO;
                        }else {
                            self.noDataView.hidden = YES;
                        }
                    }else {
                        [WSProgressHUD showShimmeringString:json[@"msg"] maskType:WSProgressHUDMaskTypeDefault];
                        [WSProgressHUD autoDismiss:1];
                    }
                }
                    failedBlock:^(NSError *error) {
                        [WSProgressHUD showShimmeringString:@"网络请求失败" maskType:WSProgressHUDMaskTypeDefault];
                        [WSProgressHUD autoDismiss:1];
                    }];
    
    
}
#pragma mark - 委托代理部分
#pragma mark    ----  TableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_mainDataList.count > 0) {
        return [_mainDataList count];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = [self.mainDataList objectAtIndex:indexPath.row];

    HandlerDetailViewController *handlerDetailViewController = [[HandlerDetailViewController alloc] init];
    handlerDetailViewController.title = @"订单详情";
    handlerDetailViewController.orderNo = info[@"orderNo"];
    handlerDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:handlerDetailViewController animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PendingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PendingTableViewCell" forIndexPath:indexPath];
    NSDictionary *info = [self.mainDataList objectAtIndex:indexPath.row];
    cell.appointOrderNoLabel.text = [NSString stringWithFormat:@"订单号：%@",info[@"orderNo"]];

    cell.appointTypeNameLabel.text = [NSString stringWithFormat:@"预约类型：%@",info[@"appointTypeName"]];
    if ([info[@"type"] integerValue] == 1) {
        [cell.typeImgBtn setImage:nil forState:UIControlStateNormal];
    }else {
        [cell.typeImgBtn setImage:[UIImage imageNamed:@"urgency"] forState:UIControlStateNormal];
    }
    cell.appointDateLabel.text = [NSString stringWithFormat:@"预约时间：%@",info[@"appointDate"]];

    cell.appointNameLabel.text = [NSString stringWithFormat:@"名称：%@",info[@"appointName"]];

    cell.appointPhoneLabel.text = [NSString stringWithFormat:@"手机号：%@",info[@"appointPhone"]];

    cell.appointAddressLabel.text = [NSString stringWithFormat:@"地址：%@",info[@"appointAddress"]];

    [cell layoutIfNeeded];
    return cell;
}
@end
