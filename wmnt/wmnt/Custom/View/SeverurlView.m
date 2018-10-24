//
//  SeverurlView.m
//  ParkProject
//
//  Created by yuanxuan on 16/9/28.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "SeverurlView.h"
#import "MJRefresh.h"
#import "APPData.h"

#define SURLFONTSIZE 15

@interface SeverurlView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, copy) selectSeverurlItem selectSeverurlwithitem;
//当前本地地址显示:
@property (nonatomic, strong) UILabel *localAddressLabel;

//手动输入地址
@property (nonatomic, strong) UITextField *testAddressTextField;
@property (nonatomic, strong) UIButton *selectTestAddressBtn;

//其他地址
@property (strong, nonatomic) UIVisualEffectView *backView;
@property (strong, nonatomic) UITableView *severurlTableView;
@property (strong, nonatomic) NSMutableArray *severurlList;
@property (strong, nonatomic) UIImageView *selectView;

@end

@implementation SeverurlView
@synthesize localAddressLabel,selectTestAddressBtn,testAddressTextField;
@synthesize backView,severurlTableView,severurlList;
- (void)showat:(UIView *)view select:(selectSeverurlItem )selectSeverurl
{
    self.frame = view.frame;
    self.alpha = 0.0f;
    self.parentView = view;
    self.selectSeverurlwithitem = selectSeverurl;
    [self createView];
    
    [self.parentView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)createView
{
    self.selectView = [[UIImageView alloc] init];
    self.selectView.frame = CGRectMake(0, 0, 50, 50);
    self.selectView.image = [UIImage imageNamed:@"pp_severurl_select"];
    self.severurlList = [NSMutableArray arrayWithCapacity:0];
    
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    backView = [[UIVisualEffectView alloc] initWithEffect:blur];
    backView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:backView];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(self.bounds.size.width-50, 20, 50, 44);
    backbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    backbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backbtn setImage:[UIImage imageNamed:@"pp_zs_close"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    [self addSubview:backbtn];
    
    self.localAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, APPMainViewWidth-40, 60)];
    localAddressLabel.textColor = [UIColor whiteColor];
    localAddressLabel.textAlignment = NSTextAlignmentLeft;
    localAddressLabel.numberOfLines = 2;
    localAddressLabel.text = [NSString stringWithFormat:@"当前服务器地址:\n%@",[APPData sharedappData].severUrl];
    localAddressLabel.font = SystemFont(SURLFONTSIZE);
    [self addSubview:localAddressLabel];
    
    UILabel *manualInputLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(localAddressLabel.frame)+10, APPMainViewWidth-40, 30)];
    manualInputLabel.textColor = [UIColor whiteColor];
    manualInputLabel.textAlignment = NSTextAlignmentLeft;
    manualInputLabel.text = @"手动输入测试地址:";
    manualInputLabel.font = SystemFont(SURLFONTSIZE);
    [self addSubview:manualInputLabel];
    
    self.testAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(manualInputLabel.frame), APPMainViewWidth-40, 40)];
    testAddressTextField.placeholder = @"请输入服务器测试地址";
    UIColor * color = [UIColor colorWithWhite:1 alpha:0.8];
    [testAddressTextField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    testAddressTextField.textColor = [UIColor whiteColor];
    testAddressTextField.text = @"http://192.168.0.0:8080/topflames-oa/";
    testAddressTextField.keyboardType = UIKeyboardTypeASCIICapable;
    testAddressTextField.delegate = self;
    testAddressTextField.tag = 102;
    testAddressTextField.returnKeyType = UIReturnKeyDone;
    [testAddressTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [testAddressTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    testAddressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    testAddressTextField.font = SystemFont(SURLFONTSIZE);
    [self addSubview:testAddressTextField];

    UIView *talineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(testAddressTextField.frame)-0.5, CGRectGetWidth(testAddressTextField.frame), 0.5)];
    talineView.backgroundColor = [UIColor whiteColor];
    [testAddressTextField addSubview:talineView];
    
    self.selectTestAddressBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectTestAddressBtn.frame = CGRectMake(APPMainViewWidth-70, CGRectGetMaxY(testAddressTextField.frame)+5, 60, 40);
    [selectTestAddressBtn setTitle:@"确定" forState:UIControlStateNormal];
    [selectTestAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectTestAddressBtn addTarget:self action:@selector(selectTestAddress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectTestAddressBtn];
    
    UILabel *selecturlLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(selectTestAddressBtn.frame)+10, APPMainViewWidth-40, 30)];
    selecturlLabel.textColor = [UIColor whiteColor];
    selecturlLabel.textAlignment = NSTextAlignmentLeft;
    selecturlLabel.text = @"选择服务器地址:";
    selecturlLabel.font = SystemFont(SURLFONTSIZE);
    [self addSubview:selecturlLabel];
    
    severurlTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(selecturlLabel.frame)+10, APPMainViewWidth-10, APPMainViewHeight-CGRectGetMaxY(selecturlLabel.frame)-40) style:UITableViewStylePlain];
    severurlTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    severurlTableView.layer.borderWidth = 0.5;

    severurlTableView.delegate = self;
    severurlTableView.dataSource = self;
    severurlTableView.backgroundColor = [UIColor clearColor];
    severurlTableView.separatorInset = UIEdgeInsetsZero;
    if ([severurlTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [severurlTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([severurlTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [severurlTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    severurlTableView.separatorColor = [UIColor whiteColor];
    [self addSubview:severurlTableView];
    
//    MJRefreshNormalHeader *updateheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requsetAddress)];//@selector(loadMylogList)
//    updateheader.lastUpdatedTimeLabel.hidden = YES;
//    severurlTableView.mj_header = updateheader;
    
    [self loadLocalData];

}

- (void)closeView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.severurlList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"settingSeverurlTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = SystemFont(SURLFONTSIZE);
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.font = SystemFont(SURLFONTSIZE);

    }
    NSDictionary *info = [self.severurlList objectAtIndex:indexPath.row];
    if ([[info objectForKey:@"surl"] isEqualToString:[APPData sharedappData].severUrl]) {
        cell.accessoryView = self.selectView;
    }else{
        cell.accessoryView = nil;
    }
    cell.textLabel.text = [info objectForKey:@"surl"];
    cell.detailTextLabel.text = [info objectForKey:@"stitle"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = [self.severurlList objectAtIndex:indexPath.row];
    NSString *surl = [info objectForKey:@"surl"];
    [self selectSEVERURL:surl];
    [tableView reloadData];
}

//选择服务器地址
- (void)selectSEVERURL:(NSString *)surl
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SEVERURL];
    [[NSUserDefaults standardUserDefaults] setObject:surl forKey:SEVERURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [APPData sharedappData].severUrl = surl;
    localAddressLabel.text = [NSString stringWithFormat:@"当前服务器地址:\n%@",[APPData sharedappData].severUrl];
}

- (void)selectTestAddress
{
    [self selectSEVERURL:self.testAddressTextField.text];
    [severurlTableView reloadData];
}

//- (void)requsetAddress
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        RequestData *requestData = [[RequestData alloc] init];
//        [requestData startAFRequest:@"wap/global/conf"
//                        requestdata:nil
//                     timeOutSeconds:30
//                    completionBlock:^(NSDictionary *json) {
//                     [severurlTableView.mj_header endRefreshing];
//                     [self.severurlList removeAllObjects];
//                     NSDictionary *infoDictionary =[[NSBundle mainBundle]infoDictionary];
//                     NSString *dsurl = severurl;
//                     NSString *dsname = [NSString stringWithFormat:@"%@ - %@",@"应用默认地址",[infoDictionary objectForKey:@"CFBundleDisplayName"]];
//                     NSDictionary *doaInfo = [NSDictionary dictionaryWithObjectsAndKeys:dsurl,@"surl",dsname,@"stitle", nil];
//                     [self.severurlList addObject:doaInfo];
//
//                     if ([[json objectForKey:@"Rows"] isKindOfClass:[NSArray class]]) {
//                         NSMutableArray *rows = [NSMutableArray arrayWithArray:[json objectForKey:@"Rows"]];
//                         for (int i = 0; i < [rows count]; i++) {
//                             NSDictionary *rowInfo = [rows objectAtIndex:i];
//                             if ([[rowInfo objectForKey:@"confPkg"] isEqualToString:@"com.topflames.oa.app.server.url"]) {
//                                 NSString *surl = [rowInfo objectForKey:@"confVal"];
//                                 NSString *sname = [rowInfo objectForKey:@"confDesc"];
//                                 if ([surl isEqualToString:severurl]) {
//
//                                 }else{
//                                     NSDictionary *oaInfo = [NSDictionary dictionaryWithObjectsAndKeys:surl,@"surl",sname,@"stitle", nil];
//                                     [self.severurlList addObject:oaInfo];
//                                 }
//                             }
//                         }
//                     }else{
//                         [WSProgressHUD showShimmeringString:@"配置数据返回错误." maskType:WSProgressHUDMaskTypeClear maskWithout:WSProgressHUDMaskWithoutDefault];
//                         [WSProgressHUD autoDismiss:1.5];
//                     }
//                     [severurlTableView reloadData];
//                 }
//                     failedBlock:^(NSError *error) {
//                         [self.severurlList removeAllObjects];
////                         NSString *dsurl = severurl;
////                         NSString *dsname = @"应用默认地址";
////                         NSDictionary *doaInfo = [NSDictionary dictionaryWithObjectsAndKeys:dsurl,@"surl",dsname,@"stitle", nil];
////                         [self.severurlList addObject:doaInfo];
//                         NSDictionary *djsoa = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://120.76.84.43:80/djsoa/",@"surl",@"【客户服务器：岱家山正式（发版默认）】",@"stitle", nil];
//                         [self.severurlList addObject:djsoa];
//
//                         NSDictionary *djsoa_dev = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://120.76.84.43/djsoa-dev/",@"surl",@"【客户服务器：岱家山开发调试】",@"stitle", nil];
//                         [self.severurlList addObject:djsoa_dev];
//
//                         NSDictionary *djsoa_yc = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://112.2.53.122:8088/ycjqoa/",@"surl",@"【客户服务器：盐城正式（发版默认）】",@"stitle", nil];
//                         [self.severurlList addObject:djsoa_yc];
//
//                         NSDictionary *djsoa_yc_dev = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://112.2.53.122:8088/ycjqoa-dev/",@"surl",@"【客户服务器：盐城开发调试】",@"stitle", nil];
//                         [self.severurlList addObject:djsoa_yc_dev];
//
//                         NSDictionary *djsoa_lkt = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://61.183.117.126:8088/lktoa/",@"surl",@"【客户服务器：临空投正式（发版默认）】",@"stitle", nil];
//                         [self.severurlList addObject:djsoa_lkt];
//
//                         NSDictionary *djsoa_lkt_dev = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://61.183.117.126:8088/lktoa-dev/",@"surl",@"【客户服务器：临空投开发调试】",@"stitle", nil];
//                         [self.severurlList addObject:djsoa_lkt_dev];
//
//                         NSDictionary *tfoa_dev = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://120.24.208.166:8080/tfoa-dev/",@"surl",@"【驼峰服务器：开发调试】",@"stitle", nil];
//                         [self.severurlList addObject:tfoa_dev];
//                        [severurlTableView reloadData];
//
//                         //显示暂无数据图
//                        [severurlTableView.mj_header endRefreshing];
//                         [WSProgressHUD showShimmeringString:@"请求配置数据失败，请重试." maskType:WSProgressHUDMaskTypeClear maskWithout:WSProgressHUDMaskWithoutDefault];
//                         [WSProgressHUD autoDismiss:1.5];
//                     }];
//    });
//    //得到自己当前的下属
////    NSString *dJson = [NSString stringWithFormat:@"{\"userId\":\"%@\"}",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
//
//}

- (void)loadLocalData
{
    [self.severurlList removeAllObjects];
    //                         NSString *dsurl = severurl;
    //                         NSString *dsname = @"应用默认地址";
    //                         NSDictionary *doaInfo = [NSDictionary dictionaryWithObjectsAndKeys:dsurl,@"surl",dsname,@"stitle", nil];
    //                         [self.severurlList addObject:doaInfo];
    NSDictionary *djsoa = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"https://manlyenglish.com/manly-mgmt/",@"surl",@"【Manly：正式服务器】",@"stitle", nil];
    [self.severurlList addObject:djsoa];
    
    NSDictionary *djsoa_dev = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"https://manlyenglish.com/manly-mgmt-dev/",@"surl",@"【Manly：测试服务器】",@"stitle", nil];
    [self.severurlList addObject:djsoa_dev];
    
    [severurlTableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    //保健
    [textField resignFirstResponder];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
