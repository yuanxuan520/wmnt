//
//  SelectPersonViewController.m
//  wmnt
//
//  Created by yuanxuan on 2018/10/22.
//  Copyright © 2018 wmnt. All rights reserved.
//

#import "SelectUserViewController.h"
#import "MJRefresh.h"

#import "SelectUserTableViewCell.h"
@interface SelectUserViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSUInteger selectUserCount;
@property (nonatomic, strong) NSMutableArray *selectUserList;

@property (nonatomic, strong) UITableView *userTableView;

@property (nonatomic, strong) NSMutableArray *userDataList;

@property (nonatomic, strong) UILabel *selectlabel;
@property (nonatomic, strong) UIView *bommonView;
@property (nonatomic, strong) UIButton *selectbtn;
@end

@implementation SelectUserViewController
@synthesize selectUserCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    //  初始化
    [self initMainData];
    [self initMainPage];
    [self initMainMethod];
    // Do any additional setup after loading the view.
}
#pragma mark - 数据和页面初始化
// 初始化数据
- (void)initMainData
{
    _userDataList = [NSMutableArray arrayWithCapacity:0];
}
// 初始化页面显示
- (void)initMainPage
{
    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelbtn.frame = CGRectMake(0, 0, 44, 44);
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelbtn addTarget:self action:@selector(cancelSelectUser:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelbtn];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    //   订单列表
    _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, kTabbarRootBodyHeight) style:UITableViewStylePlain];
    //    NSLog(@"%f",Height_TapBar);
    _userTableView.delegate = self;
    _userTableView.dataSource = self;
    _userTableView.backgroundColor = [UIColor clearColor];
    _userTableView.tableFooterView = [UIView new];
    _userTableView.separatorInset = UIEdgeInsetsZero;
    if ([_userTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_userTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_userTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_userTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _userTableView.separatorColor = UIColorHex(0xefefef);
    [self.mainView addSubview:_userTableView];
    _userTableView.rowHeight = UITableViewAutomaticDimension;
    _userTableView.estimatedRowHeight = 140;//估算高度
    MJRefreshNormalHeader *reloadheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestListData)];
    [reloadheader setTitle:@"下拉刷新.." forState:MJRefreshStateIdle];
    [reloadheader setTitle:@"松开刷新.." forState:MJRefreshStatePulling];
    [reloadheader setTitle:@"正在刷新.." forState:MJRefreshStateRefreshing];
    [reloadheader setTitle:@"数据加载完毕" forState:MJRefreshStateWillRefresh];
    reloadheader.lastUpdatedTimeLabel.hidden = YES;
    _userTableView.mj_header = reloadheader;
    
    // 注册cell
    [_userTableView registerClass:[SelectUserTableViewCell class] forCellReuseIdentifier:@"SelectUserTableViewCell"];
    
}

//初始化调用方法
- (void)initMainMethod
{
    [self requestListData];
}
#pragma mark - 按钮操作部分
// 取消选择
- (void)cancelSelectUser:(UIButton *)btn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
// 选择用户
- (void)selectUser:(UIButton *)btn
{
    if (self.userMultiSelect) {
        self.userMultiSelect(self.selectUserList);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 接口请求部分

/**
 请求订单列表数据
 */
- (void)requestListData
{
    kSelfWeak;
    [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeClear];
//    NSString *dJson = [NSString stringWithFormat:@"{\"status\":\"%@\",\"pageSize\":\"10\",\"pageNo\":\"0\"}",@"1"];
    RequestData *requestData = [[RequestData alloc] init];
    [requestData startAFRequest:API_StaffPersonList
                    requestdata:nil
                 timeOutSeconds:10
                completionBlock:^(NSDictionary *json) {
                    NSLog(@"%@",json[@"msg"]);
                    if ([weakSelf.userTableView.mj_header isRefreshing]) {
                        [weakSelf.userTableView.mj_header endRefreshing];
                    }
                    [WSProgressHUD dismiss];
                    if ([json[@"param"] isKindOfClass:[NSArray class]]) {
                        NSArray *dataList = json[@"param"];
                        weakSelf.userDataList = [NSMutableArray arrayWithArray:dataList];
                        [weakSelf.userTableView reloadData];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userDataList count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"rzTableView";
    SelectUserTableViewCell *cell = (SelectUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[SelectUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    }
    
    NSDictionary *dictdata = [self.userDataList objectAtIndex:indexPath.row];
    if ([self.selectUserList containsObject:dictdata]) {
        cell.userSelectImg.image = [UIImage imageNamed:@"duoxuanselect"];  //默认
    }else{
        cell.userSelectImg.image = [UIImage imageNamed:@"duoxuan"];
    }
    
    cell.userNameLabel.text = [[self.userDataList objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dictdata = [self.userDataList objectAtIndex:indexPath.row];
    if ([self.selectUserList containsObject:dictdata]) {
        [self.selectUserList removeObject:dictdata];
        selectUserCount = selectUserCount - 1;
    }else{
        [self.selectUserList addObject:dictdata];
        selectUserCount = selectUserCount + 1;
    }
    
    NSString *percountstr = [NSString stringWithFormat:@"已选择:%ld人",(unsigned long)selectUserCount];
    _selectlabel.text = percountstr;
    [tableView reloadData];
    
    if (selectUserCount == 0) {
        _selectbtn.enabled = NO;
    }else{
        _selectbtn.enabled = YES;
    }
    
}


- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@synthesize description;

@end
