//
//  LoginViewController.m
//  Manly
//
//  Created by yuanxuan on 2017/4/13.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import "LoginViewController.h"
//#import "SeverurlView.h"
//#import "EYInputPopupView.h"
//#import "EYTextPopupView.h"



@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) UIView *tapbackView;
@property (nonatomic, strong) UITextField *phoneNumberField;
@property (nonatomic, strong) UITextField *passwordField;
@end

@implementation LoginViewController
@synthesize mainView,tapbackView,phoneNumberField,passwordField;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    NSString *currentusername = [USERDEFAULTS objectForKey:@"Account"];
    if (currentusername) {
        phoneNumberField.text = currentusername;
    }
}

- (void)dealloc
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [NOTIFICATIONCENTERDEFAULT addObserver:self selector:@selector(requestWXlogin:) name:@"WX_LOGIN" object:nil];
    
    mainView = [[UIScrollView alloc] initWithFrame:APPMainFrame];
    mainView.backgroundColor = [UIColor whiteColor];
    [mainView setContentSize:CGSizeMake(APPMainViewWidth, APPMainViewHeight*2)];
    mainView.scrollEnabled = NO;
    [self.view addSubview:mainView];
    
    UIImageView *backimgView = [[UIImageView alloc] initWithFrame:APPMainFrame];
    backimgView.image = [UIImage imageNamed:@"backgroud_img"];
    [self.mainView addSubview:backimgView];
    
    tapbackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, APPMainViewHeight*1.5)];
    tapbackView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapbackimgView:)];
    tap1.numberOfTapsRequired = 1;
    [tapbackView addGestureRecognizer:tap1];
    
    [mainView addSubview:tapbackView];
    
    UIImageView *iconimgView = [[UIImageView alloc] init];
    iconimgView.contentMode = UIViewContentModeScaleAspectFit;
    iconimgView.userInteractionEnabled = YES;
    iconimgView.image = [UIImage imageNamed:@"wmnt_logo"];
    [mainView addSubview:iconimgView];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSettingImgView:)];
    tap2.numberOfTapsRequired = 3;
    tap2.numberOfTouchesRequired = 2;
    [iconimgView addGestureRecognizer:tap2];
    
    [iconimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //约束
        make.width.mas_equalTo(APPMainViewWidth*0.9);
        //上边距
        make.top.mas_equalTo(60);
        // 添加左距
        make.left.mas_equalTo(APPMainViewWidth*0.1/2);
        // 添加右边距约束
        make.right.mas_equalTo(-APPMainViewWidth*0.1/2);
    }];
    
    //输入手机号
    phoneNumberField = [[UITextField alloc] init];
    phoneNumberField.placeholder = @"请输入账号";
    phoneNumberField.keyboardType = UIKeyboardTypeASCIICapable;
    phoneNumberField.delegate = self;
    phoneNumberField.tag = 102;
    phoneNumberField.returnKeyType = UIReturnKeyNext;
    [phoneNumberField setAutocorrectionType:UITextAutocorrectionTypeNo];
    //    phoneNumberField.backgroundColor = [UIColor grayColor];
    [phoneNumberField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumberField.font = SystemFont(17);
    
    
    [mainView addSubview:phoneNumberField];
    
    //Left
    UILabel *phoneNumberName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
    phoneNumberName.textColor = [UIColor colorFromHexRGB:@"333333"];
    phoneNumberName.textAlignment = NSTextAlignmentLeft;
    phoneNumberName.text = @"账号";
    phoneNumberName.font = SystemFont(17);
    UIView *plinepView = [[UIView alloc] initWithFrame:CGRectMake(46, 14, 0.5, 22)];
    plinepView.backgroundColor = [UIColor colorFromHexRGB:@"e6d6cd"];
    [phoneNumberName addSubview:plinepView];
    
    phoneNumberField.leftView = phoneNumberName;
    phoneNumberField.leftViewMode = UITextFieldViewModeAlways;
    phoneNumberField.text = @"";
    
    [phoneNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        //约束
        make.width.mas_equalTo(APPMainViewWidth*0.8);
        make.height.mas_equalTo(50);
        
        //上边距
        make.top.equalTo(iconimgView.mas_bottom).offset(10);
        
        // 添加左距
        make.left.mas_equalTo(APPMainViewWidth*0.2/2);
        // 添加右边距约束
        make.right.mas_equalTo(-APPMainViewWidth*0.2/2);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"e6d6cd"];
    [phoneNumberField addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        //约束
        make.width.equalTo(phoneNumberField);
        make.height.mas_equalTo(0.5);
        
        make.left.mas_equalTo(phoneNumberField);
        make.bottom.mas_equalTo(-0.5);
    }];
    
    //输入密码框
    passwordField = [[UITextField alloc] init];
    passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"请填写密码";
    passwordField.tag = 123456;
    passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    passwordField.delegate = self;
    passwordField.font = SystemFont(17);
    passwordField.returnKeyType = UIReturnKeyGo;
    //    passwordField.font = SystemFont(15);
    passwordField.text = @"";
    
    //Left
    UILabel *passwordName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
    passwordName.textColor = [UIColor colorFromHexRGB:@"333333"];
    passwordName.textAlignment = NSTextAlignmentLeft;
    passwordName.text = @"密码";
    passwordName.font = SystemFont(17);
    UIView *pslineView = [[UIView alloc] initWithFrame:CGRectMake(46, 14, 0.5, 22)];
    pslineView.backgroundColor = [UIColor colorFromHexRGB:@"e6d6cd"];
    [passwordName addSubview:pslineView];
    
    passwordField.leftView = passwordName;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    //Right
    UIButton *dhPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dhPwdBtn.frame = CGRectMake(0, 0, 50, 50);
    dhPwdBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    [dhPwdBtn setImage:[UIImage imageNamed:@"hide_pwd"] forState:UIControlStateNormal];
    [dhPwdBtn setImage:[UIImage imageNamed:@"display_pwd"] forState:UIControlStateSelected];
    [dhPwdBtn addTarget:self action:@selector(pwdTextSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    passwordField.rightView = dhPwdBtn;
    passwordField.rightViewMode = UITextFieldViewModeAlways;
    passwordField.text = @"111111";
    [mainView addSubview:passwordField];
    
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        //约束
        make.width.mas_equalTo(APPMainViewWidth*0.8);
        make.height.mas_equalTo(50);
        
        //上边距
        make.top.equalTo(phoneNumberField.mas_bottom).offset(5);
        
        // 添加左距
        make.left.mas_equalTo(APPMainViewWidth*0.2/2);
        // 添加右边距约束
        make.right.mas_equalTo(-APPMainViewWidth*0.2/2);
    }];
    
    UIView *pdlineView = [[UIView alloc] init];
    pdlineView.backgroundColor = [UIColor colorFromHexRGB:@"e6d6cd"];
    [passwordField addSubview:pdlineView];
    [pdlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        //约束
        make.width.equalTo(passwordField);
        make.height.mas_equalTo(0.5);
        
        make.left.mas_equalTo(passwordField);
        make.bottom.mas_equalTo(-0.5);
    }];
    
    //登录 button
    UIButton *login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    login.titleLabel.font = SystemFont(17);
    
    [login.layer setMasksToBounds:YES];
    [login.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    login.backgroundColor = [UIColor colorFromHexRGB:@"f39800"];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:login];
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        //约束
        make.width.mas_equalTo(APPMainViewWidth-80);
        make.height.mas_equalTo(44);
        
        //上边距
        make.top.equalTo(passwordField.mas_bottom).offset(30);
        
        // 添加左距
        make.left.mas_equalTo(40);
        // 添加右边距约束
        make.right.mas_equalTo(-40);
    }];
    
//    UIButton *retrievePassword = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [retrievePassword.titleLabel setFont:CustomFoldFont(16)];
//    [retrievePassword setTitle:@"找回密码" forState:UIControlStateNormal];
//    [retrievePassword setTitleColor:[UIColor colorFromHexRGB:@"b327e0"] forState:UIControlStateNormal];
//    [retrievePassword addTarget:self action:@selector(enterRetrieveView:) forControlEvents:UIControlEventTouchUpInside];
//    [mainView addSubview:retrievePassword];
//    retrievePassword.hidden = YES;
//
//    //    retrievePassword.hidden = YES;
//    [retrievePassword mas_makeConstraints:^(MASConstraintMaker *make) {
//        //约束
//        make.width.mas_equalTo(APPMainViewWidth-200);
//        make.height.mas_equalTo(44);
//
//        //上边距
//        make.top.equalTo(login.mas_bottom).offset(15);
//
//        // 添加左距
//        make.left.mas_equalTo(100);
//        // 添加右边距约束
//        make.right.mas_equalTo(-100);
//    }];
    
    //创建账户
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerBtn.titleLabel setFont:SystemFont(18)];
    [registerBtn setTitle:@"创建帐户" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorFromHexRGB:@"b327e0"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(enterRegisterView:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:registerBtn];
    registerBtn.hidden = YES;
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(mainView.mas_centerX);
        //上边距
        make.bottom.mas_equalTo(APPMainViewHeight-85);
    }];
}

- (void)pwdTextSwitch:(UIButton *)sender {
    
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    if (!sender.selected) { // 按下去了就是明文
        NSString *tempPwdStr = self.passwordField.text;
        self.passwordField.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordField.secureTextEntry = NO;
        self.passwordField.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.passwordField.text;
        self.passwordField.text = @"";
        self.passwordField.secureTextEntry = YES;
        self.passwordField.text = tempPwdStr;
    }
    sender.selected = !sender.selected;
}

//弹出设置项
- (void)tapSettingImgView:(UITapGestureRecognizer *)tap
{
//    [EYInputPopupView popViewWithTitle:@"请输入密码.." contentText:nil
//                                  type:EYInputPopupView_Type_single_line_text
//                              maxLeght:10
//                          keyboardType:UIKeyboardTypeDefault
//                           cancelBlock:^{
//
//                           } confirmBlock:^(UIView *view, NSString *text) {
//                               if ([[text lowercaseString] isEqualToString:@"manly"]) {
//                                   SeverurlView *severurlView = [[SeverurlView alloc] init];
//                                   [severurlView showat:self.view select:^(NSString *selectSeverurl) {
//                                   }];
//                               }
//                           } dismissBlock:^{
//                               //                               NSLog(@"....");
//                           }];
}

- (void)tapbackimgView:(UITapGestureRecognizer *)tap
{
    [phoneNumberField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void)login:(UIButton *)btn
{
    [phoneNumberField resignFirstResponder];
    [passwordField resignFirstResponder];
    [USERDEFAULTS setObject:phoneNumberField.text forKey:@"Account"];
    [USERDEFAULTS synchronize];
    if (phoneNumberField.text.length < 1) {
        [WSProgressHUD showShimmeringString:@"账号不能为空.." maskType:WSProgressHUDMaskTypeBlack];
        [WSProgressHUD autoDismiss:1.5];
        return;
    }
    
    if (passwordField.text.length < 1) {
        [WSProgressHUD showShimmeringString:@"密码不能为空.." maskType:WSProgressHUDMaskTypeBlack];
        [WSProgressHUD autoDismiss:1.5];
        return;
    }
    
    [WSProgressHUD showWithStatus:@"正在登录.." maskType:WSProgressHUDMaskTypeBlack];
    RequestData *requestData = [[RequestData alloc] init];///wap/token //login/mobileVerify
    [requestData loginAFRequest:API_Login userName:phoneNumberField.text password:passwordField.text timeOutSeconds:30 completionBlock:^(NSDictionary *json) {
        NSLog(@"%@",json[@"msg"]);
        if (json == nil) {
            [WSProgressHUD showShimmeringString:@"登录失败" maskType:WSProgressHUDMaskTypeClear maskWithout:WSProgressHUDMaskWithoutDefault];
            [WSProgressHUD autoDismiss:1.5];
            return;
        }

        if ([[json objectForKey:@"code"] integerValue] == 1001) {
            [self loginSuccess:json];
        }else{
            [WSProgressHUD showShimmeringString:@"登录失败" maskType:WSProgressHUDMaskTypeClear maskWithout:WSProgressHUDMaskWithoutDefault];
            [WSProgressHUD autoDismiss:1.5];
        }
    } failedBlock:^(NSError *error) {
        NSLog(@"失败");
        [WSProgressHUD showShimmeringString:@"登录失败" maskType:WSProgressHUDMaskTypeClear maskWithout:WSProgressHUDMaskWithoutDefault];
        [WSProgressHUD autoDismiss:1.5];
        //弹出提示框   是否是重新登录还是咋地
    }];
}

- (void)loginSuccess:(NSDictionary *)info
{
    NSDictionary *userInfo = [info objectForKey:@"param"];
    [USERDEFAULTS setObject:userInfo forKey:@"userInfo"];
    [USERDEFAULTS synchronize];
    AppDelegate* appDelagete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelagete jumpMainPage];
    [WSProgressHUD showShimmeringString:@"登录成功" maskType:WSProgressHUDMaskTypeClear];
    [WSProgressHUD autoDismiss:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    //保健
    if (textField.tag == 102) {
        [textField resignFirstResponder];
        [passwordField becomeFirstResponder];
    }else if(textField.tag == 123456){
        [textField resignFirstResponder];
        [self login:nil];
    }
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    NSInteger movementDistance = textField.frame.origin.y-100; // tweak as needed
    
    if (up) {
        [mainView setContentOffset:CGPointMake(0, movementDistance) animated:YES];
    }else{
        [mainView setContentOffset:CGPointMake(0, 0) animated:YES];
        //        //        [mainView setContentSize:CGSizeMake(PPMainViewWidth, PPMainViewHeight)];
    }
    //    createView.frame = CGRectOffset(createView.frame, 0, movement);
    
    //    [UIView commitAnimations];
    
}

- (void)enterMainUI
{
//    [[AppDelegate sharedAppDelegate] enterMainUI];
//    [[IMAPlatform sharedInstance] configOnLoginSucc:_loginParam];
}
@end
