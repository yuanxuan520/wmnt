//
//  APPData.h
//  Manly
//
//  Created by yuanxuan on 2017/4/12.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreStatus.h"

@interface APPData : NSObject
@property (nonatomic, assign) CGFloat tabbarHeight;
//当前网络状态
@property (nonatomic, assign) CoreNetWorkStatus netWorkStatus;
//iOS下载地址
@property (nonatomic, strong) NSString *appStoreuri;
//更新内容
@property (nonatomic, strong) NSString *appStoreUpdateContent;
//更新版本
@property (nonatomic, strong) NSString *appStoreUpdateVersion;
//是否有网络
@property (nonatomic, assign) BOOL isNet;
//是否为Wifi
@property (nonatomic, assign) BOOL isWifi;

@property (nonatomic, strong) NSString *severUrl;

@property (nonatomic, strong) NSString *updateURL;

@property (nonatomic , strong) NSString *userName;
@property (nonatomic , assign) BOOL isAutoLogin;
@property (nonatomic , assign) BOOL isLogin;
@property (nonatomic , assign) BOOL isPlayEar;
@property (nonatomic , assign) BOOL isSendMessageSound;
+ (APPData *)sharedappData;
@end
