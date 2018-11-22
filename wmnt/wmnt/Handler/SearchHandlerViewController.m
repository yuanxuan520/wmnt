//
//  SearchHandlerViewController.m
//  wmnt
//
//  Created by yuanxuan on 2018/11/13.
//  Copyright © 2018 wmnt. All rights reserved.
//

#import "SearchHandlerViewController.h"
//控制器
#import "HandlerDetailViewController.h"
//控件视图
#import "PopoverView.h"
#import "MJRefresh.h"
#import "PendingTableViewCell.h"
@interface SearchHandlerViewController ()<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>
// 数据部分
@property (nonatomic, strong) NSMutableArray *mainDataList;
@property (nonatomic, assign) NSString *status;

// 视图部分
@property (nonatomic, strong) UITableView *mainTableView;
// 搜索
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIBarButtonItem *cancelItem;
@end

@implementation SearchHandlerViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    
    //搜索
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldSearch:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth*0.75, 30.0f)];
    _searchTextField.placeholder = @"请输入关键字"; //默认显示的字
    UIImageView *leftimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    leftimg.frame = CGRectMake(0, 0, 36, 30);
    leftimg.contentMode = UIViewContentModeScaleAspectFit;
    _searchTextField.leftView = leftimg;
    _searchTextField.tintColor = [UIColor colorFromHexRGB:@"b327e0"];
    _searchTextField.font = SystemFont(15);
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    _searchTextField.delegate = self;
    _searchTextField.backgroundColor = [UIColor colorFromHexRGB:@"ffffff"];
    _searchTextField.layer.cornerRadius = 5;
    [_searchTextField addTarget:self action:@selector(textFieldSearch:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _searchTextField;
    [_searchTextField becomeFirstResponder];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancel.frame = CGRectMake(0, 0, 50, 40);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColorHex(0x979797) forState:UIControlStateNormal];
    cancel.titleLabel.font = SystemFont(14);
    [cancel addTarget:self action:@selector(cancelDismiss:) forControlEvents:UIControlEventTouchUpInside];
    _cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = 5;
    self.navigationItem.rightBarButtonItems = @[_cancelItem,fixedItem];
    
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


//初始化调用方法
- (void)initMainMethod
{
    [self requestListData];
}
#pragma mark - 按钮操作部分

- (void)cancelDismiss:(UIButton *)btn
{
    if ([_searchTextField isFirstResponder]) {
        [_searchTextField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)textFieldSearch:(NSNotification *)textfiled
{
    //    if ([_searchTextField.text length] > 0) {
    //        self.navigationItem.rightBarButtonItem = searchitem;
    //    }else{
    //        self.navigationItem.rightBarButtonItem = nil;
    //    }
    
    
    //    self.dataList = [DBoperate getSearchPlaces:_searchTextField.text];
    //    [placeTableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self requestGetdataListData:_searchTextField.text];
    [self requestListData];
    if ([_searchTextField isFirstResponder]) {
        [_searchTextField resignFirstResponder];
    }
    return YES;
}
#pragma mark - 接口请求部分

/**
 请求订单列表数据
 */
- (void)requestListData
{
    kSelfWeak;
    [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeClear];
    
    //    订单号： orderNo   手机号码： phone
    NSString *dJson = [NSString stringWithFormat:@"{\"status\":\"-1\",\"pageSize\":\"50\",\"pageNo\":\"0\",\"orderNo\":\"%@\",\"phone\":\"%@\"}",_searchTextField.text,_searchTextField.text];
    
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
