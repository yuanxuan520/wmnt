#ifndef Common_Define_h
#define Common_Define_h

#import "Common_MarkWords.h"
#import "Common_Limit.h"
#import "Common_Categories.h"
#import "Common_GlobalKey.h"
#import "Common_Color.h"
#import "Common_Font.h"
#import "Common_Time.h"
#import "Common_API.h"

#import "APPData.h"
#import "RequestData.h"
#import "AppDelegate.h"
#import "YXViewController.h"
#import "YXNavigationController.h"
#import "YXTabBarController.h"
#import "Masonry.h"
#import "WSProgressHUD.h"
#import "WSProgressHUD+AutoDismiss.h"


#define kMyUserId @""   //暂时
/********************** 常用系统定义 ****************************/
#define Height_UITextField  44    //UITextField的统一高度  //待删除
#define Height_ButtomButton 44
#define ScreenWidth [UIScreen mainScreen].bounds.size.width //屏幕宽度
#define USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define APPMainFrame [UIScreen mainScreen].bounds
#define APPMainViewWidth  [UIScreen mainScreen].bounds.size.width
#define APPMainViewHeight [UIScreen mainScreen].bounds.size.height
#define APPNavBar (self.navigationController.navigationBar.frame.size.height)
#define APPStateBar ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define APPNavStateBar ([[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height)
//设置字体
#define SystemFont(s) [UIFont systemFontOfSize:s] //Avenir-Roman
#define SystemFoldFont(s) [UIFont boldSystemFontOfSize:s] //Avenir-Medium
#define CustomFont(s) [UIFont fontWithName:@"Avenir-Light" size:s] //Avenir-Roman
#define CustomFoldFont(s) [UIFont fontWithName:@"Avenir-Roman" size:s] //Avenir-Medium

/********************** 常用宏 ****************************/
#pragma mark - 常用宏

/// 判断无网络情况
#define GetNetworkStatusNotReachable ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable)

/// 当前版本号
#define GetCurrentVersion ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])

/// 当前app名称
#define GetAppName ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"])

/// 当前app delegate
#define GetAPPDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

/// 获取queue
#define GetMainQueue dispatch_get_main_queue()
#define GetGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

/// block self
#define kSelfWeak __weak typeof(self) weakSelf = self
#define kSelfStrong __strong __typeof__(weakSelf) strongSelf = weakSelf

// url
#define URLWithString(str)  [NSURL URLWithString:str]

// 文件路径获取
#define kFileEncryptUrl(name) [AboutAppModel fileUrlEncryptWithName:name]
#define kFileUrl(name) [AboutAppModel fileUrlWithName:name]

//方法简介
#define AddNotification(observer,sel,name,obj)  [NSNotificationCenter defaultCenter] addObserver:observer selector:sel name:name object:obj]
#define PostNotification(name,obj)              [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj]

/// Height/Width
#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height
#define kSearchBarHeight    45.0
#define kStatusBarHeight    [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavigationHeight   44.0
#define kMarginWidth        15.0    //内容到屏幕的边距
#define kLineHeight         50.0    //行高度
#define kAreaHeight         40.0    //模块的title栏高度
#define kLineTitleHeight    45.0    //行标题栏的高度
#define kAreaPaddingHeight  10.0    //块之间的间距
#define kTabbarRootBodyHeight   (kBodyHeight - Height_TapBar)
#define kTabbarHeight       APPDATA.tabbarHeight?:(ISiPhoneX ? 83 : 49)
#define kBodyHeight             ([UIScreen mainScreen].bounds.size.height - kNavigationHeight - kStatusBarHeight)
#define kScreenMutiple6 (iPhone6?1:(iPhone6plus?1.104:0.853))    //以iphone6尺寸为标准

static inline UIEdgeInsets UISafeAreaInsetsMake(UIView * view, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right){
    if (@available(iOS 11.0, *)) {
         return UIEdgeInsetsMake(view.safeAreaInsets.top + top, view.safeAreaInsets.left + left, view.safeAreaInsets.bottom + bottom, view.safeAreaInsets.right + right);
    }else{
        return UIEdgeInsetsMake(top, left, bottom, right);
    }
}

static inline UIEdgeInsets UISafeAreaInsets(UIView * view){
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

/// System判断
#define ISiPod      [[[UIDevice currentDevice] model] isEqual:@"iPod touch"]
#define ISiPhone    [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define ISiPad      [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define ISiPhone4   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhone5   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)) : NO)

#define ISiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// end
#define ISIOS(num) ([[[UIDevice currentDevice] systemVersion] floatValue] >= num) // IOSX的系统

#define UIInterfaceOrientationIsPortrait(orientation)  ((orientation) == UIInterfaceOrientationPortrait || (orientation) == UIInterfaceOrientationPortraitUpsideDown)
#define UIInterfaceOrientationIsLandscape(orientation) ((orientation) == UIInterfaceOrientationLandscapeLeft || (orientation) == UIInterfaceOrientationLandscapeRight)

#define INTERFACEPortrait self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
#define INTERFACELandscape self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight

//new

#define UI_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define UI_IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREENSIZE_IS_35  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define SCREENSIZE_IS_40  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define SCREENSIZE_IS_47  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define SCREENSIZE_IS_55  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0)

//判断iPHoneXr
#define SCREENSIZE_IS_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

//判断iPHoneX、iPHoneXs
#define SCREENSIZE_IS_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define SCREENSIZE_IS_XS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

//判断iPhoneXs Max
#define SCREENSIZE_IS_XS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

//状态栏、导航栏、标签栏高度
#define Height_NavContentBar 44.0f

#define Height_StatusBar (IS_IPhoneX_All ? 44.0 : 20.0)

#define Height_NavBar (IS_IPhoneX_All ? 88.0 : 64.0)

#define Height_TopBar (Height_StatusBar + Height_NavBar)

#define Height_TapBar (IS_IPhoneX_All ? 83.0 : 49.0)

#define SCREEN_HEIGHTL [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTHL [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#ifndef __OPTIMIZE__
//#define NSLog(...) NSLog(__VA_ARGS__)
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define DLog(...)
#define NSLog(...) {}
#endif

#define SLog(fmt, ...) [Util showLogformat:(fmt), ## __VA_ARGS__]

/********************** 数值 ****************************/
/// 数值转字符串
#define kIntToString(intValue) ([NSString stringWithFormat:@"%@", @(intValue)])
#define kNumberToString(NumberValue) ([NSString stringWithFormat:@"%@", NumberValue])
#define StrToInt(str) [str integerValue]
#define StrToDouble(str) [str doubleValue]
#define DoubleStringFormat(str) [NSString stringWithFormat:@"%.2f", [str doubleValue]]
#define NSStringFromNumber(num) [@(num) stringValue]
#define kDoubleToString(num) [[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", num]] stringValue]


/********************** 标识 ****************************/

#pragma mark - 标识

#define IQKeyboardDistanceFromTextField 50


#define firstCategoryWidth (AutoWHGetWidth(70))

#define SaveObjToUserDefaults(obj,key)  [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key]

#define SaveBOOLToUserDefaults(bool,key)  [[NSUserDefaults standardUserDefaults] setBool:bool forKey:key]
#define GetBoolFromUserDefaults(key)      [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define synUserDefaults                   [[NSUserDefaults standardUserDefaults] synchronize]


// 定义是否打开指定app
#define CanOpenAppURL(urlScheme) [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlScheme]]

// 定义开发指定app
#define OpenAppURL(urlScheme) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]]

//----------方法简写-------
#define kApplication        [UIApplication sharedApplication]
#define kAppDelegate        ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define kKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define APPDATA [APPData sharedappData]
#define USERDEFAULTS [NSUserDefaults standardUserDefaults]

#define SEVERURL  @"SEVERURL"
#define kSeverURL @"http://www.weimao.ink/"
//#define kSeverURL @"http://123.56.22.22/"
#define kUserDefaultsCookie @"kUserDefaultsCookie"
//登录刷新
#define LOGINSUCCESSNOTIFACTION @"LOGINSUCCESSNOTIFACTION"
#define LOGOUTNOTIFACTION @"LOGOUTNOTIFACTION"
#endif /* Common_Define_h */
