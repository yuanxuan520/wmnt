//
//  RequestData.m
//  Manly
//
//  Created by yuanxuan on 2017/4/12.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import "RequestData.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

@interface RequestData ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) AFURLSessionManager *urlManager;
@end


@implementation RequestData
@synthesize httpManager,urlManager;
@synthesize downloadQueueDict;
+ (RequestData *)shareRequestData{
    static RequestData *networking = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networking = [[self alloc] init];
        
        AFHTTPSessionManager *httphmanager = [AFHTTPSessionManager manager];
        httphmanager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        httphmanager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
        httphmanager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httphmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [httphmanager.requestSerializer setHTTPShouldHandleCookies:YES];
        //    multipart/form-data
        httphmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",nil];
        //https 支持
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
        //    securityPolicy.allowInvalidCertificates = YES;
        //validatesDomainName 是否需要验证域名，默认为YES；
        //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
        //    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
        //    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
        //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        //    // 是否允许,NO-- 不允许无效的证书
        //    [securityPolicy setAllowInvalidCertificates:YES];
        //    [securityPolicy setValidatesDomainName:NO];
        //    // 设置证书
        //    [securityPolicy setPinnedCertificates:certSet];
        //申明返回的结果是json类
        
        
        securityPolicy.validatesDomainName = YES;
        httphmanager.securityPolicy  = securityPolicy;
        
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *urlmanager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSMutableDictionary *dictinfo = [NSMutableDictionary dictionaryWithCapacity:0];
        
        
        networking.httpManager = httphmanager;
        networking.urlManager = urlmanager;
        networking.downloadQueueDict = dictinfo;
        
    });
    return networking;
}

#pragma mark - Login part
- (void)loginAFRequest:(NSString *)intefacePath userName:(NSString *)username password:(NSString *)password timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    
//  iOS Token
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *deviceToken = [kUserDefaults objectForKey:@"deviceToken"];

//    暂时不使用
    NSString *requestJson = [NSString stringWithFormat:@"{\"token\":\"%@\",\"account\":\"%@\",\"pwd\":\"%@\"}",deviceToken,username,password];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[APPData sharedappData].severUrl,intefacePath];
    NSDictionary *parameters = @{@"param" : requestJson};
    AFHTTPSessionManager *manage = [RequestData shareRequestData].httpManager;
    [manage POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"====curResquest:%@=====task.response:%@",task.currentRequest.allHTTPHeaderFields,response.allHeaderFields[@"Set-Cookie"]);
        if (response.allHeaderFields[@"Set-Cookie"]) {
            NSString *cookie = response.allHeaderFields[@"Set-Cookie"];
            [USERDEFAULTS setObject:cookie forKey:kUserDefaultsCookie];
            [USERDEFAULTS synchronize];
        }
        
        NSError *error = nil;
        //        NSString *jsonStr = responseObject;
        NSData *jsonData = responseObject;
        //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"json:%@",jsonData);
        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
        //        NSLog(@"%@",datastr);
        
        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        if(jsonData==nil){//接口请求发生异常，直接返回
            NSLog(@"登录发生错误!");
            return;
        }
        //
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //        NSLog(@"next:json%@",json);
        if (completionBlock) {
            completionBlock(json);
        }
        dispatch_group_leave(group_request);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
        if (failedBlock) {
            NSError *requestError = error;
            failedBlock(requestError);
        }
        dispatch_group_leave(group_request);
    }];
    
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}

#pragma mark - Use part
/**
 常用接口调用

 @param intefacePath 接口名
 @param jsondata 请求参数
 @param timeOutSeconds 超时时间
 @param completionBlock 成功的回调
 @param failedBlock 失败的回调
 */
- (void)startAFRequest:(NSString *)intefacePath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[APPData sharedappData].severUrl,intefacePath];
    NSDictionary *parameters = nil;
    if (jsondata != nil) {
        parameters = @{@"param" : jsondata};
    }
    //    NSLog(@"%@",parameters);
    
    AFHTTPSessionManager *manage = [RequestData shareRequestData].httpManager;
    manage.requestSerializer.timeoutInterval = timeOutSeconds;
    //    multipart/form-data
    
    id cookieStr = [USERDEFAULTS objectForKey:kUserDefaultsCookie];
    if (cookieStr && [cookieStr isKindOfClass:[NSString class]]) {
        [manage.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Set-Cookie"];
    }
//
//    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",nil];
//
//    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie]];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    [manage POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//        NSLog(@"====curResquest:%@=====task.response:%@",task.currentRequest.allHTTPHeaderFields,response.allHeaderFields[@"Set-Cookie"]);
//        if (response.allHeaderFields[@"Set-Cookie"]) {
//            NSString *cookie = response.allHeaderFields[@"Set-Cookie"];
//            [USERDEFAULTS setObject:cookie forKey:kUserDefaultsCookie];
//            [USERDEFAULTS synchronize];
//        }
//
        //        NSString *jsonStr = responseObject;
        if (responseObject == nil) {
            if (completionBlock) {
                completionBlock(nil);
            }
        }else{
            NSData *jsonData = responseObject;
            //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            //        NSLog(@"json:%@",jsonData);
            NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
            //        NSLog(@"%@",datastr);
            if (datastr == nil) {
                datastr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            }
            NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
            if(jsonData==nil){//接口请求发生异常，直接返回
                return;
            }
            //
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //                NSLog(@"next:json%@",json);
            if (json == nil) {
//                [WSProgressHUD showShimmeringString:@"code:404" maskType:WSProgressHUDMaskTypeDefault];
//                [WSProgressHUD autoDismiss:1];
            }else{
//                int code = [[json objectForKey:@"result"] intValue];
//                if (code == 100 || code == 102) {
//
//                    [APPDATA imlogout];
//                    [WSProgressHUD showShimmeringString:[json objectForKey:@"msg"] maskType:WSProgressHUDMaskTypeDefault];
//                    [WSProgressHUD autoDismiss:3];
//                    return;
//                }
            }
            if (completionBlock) {
                completionBlock(json);
            }
        }
        
        dispatch_group_leave(group_request);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@",error.userInfo);
                NSData *jsonData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
//                [responseObject dataUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"json:%@",jsonData);
                NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
        
        if (failedBlock) {
            NSError *requestError = error;
            failedBlock(requestError);
        }
        dispatch_group_leave(group_request);
    }];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
    
    //    NSString *password = nil;//123456
    //    password = [self sha1: [self md5:password]];
    //    NSString *dJson = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",username,password];//wap/token
    
    
    
    //    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    
    
    
}
#pragma mark - Download Part
- (void)getFileRequest:(NSString *)intefacePath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[APPData sharedappData].severUrl,intefacePath];
    NSDictionary *parameters = nil;
    //    NSString *parametersJson = [jsondata stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (jsondata != nil) {
        parameters = @{@"search" : jsondata};
    }
    //    NSLog(@"%@",parameters);
    AFHTTPSessionManager *manage = [RequestData shareRequestData].httpManager;
    //申明返回的结果是json类型
    manage.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    //申明请求的数据是json类型
    manage.requestSerializer.timeoutInterval = timeOutSeconds;
    //    multipart/form-data
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",nil];
    
//    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie]];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [manage POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        //        NSString *jsonStr = responseObject;
        NSData *jsonData = responseObject;
        //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"json:%@",jsonData);
        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
        //        NSLog(@"%@",datastr);
        
        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        if(jsonData==nil){//接口请求发生异常，直接返回
            return;
        }
        //
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //                NSLog(@"next:json%@",json);
        if (completionBlock) {
            completionBlock(json);
        }
        dispatch_group_leave(group_request);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //                NSLog(@"%@",error.userInfo);
        //        NSData *jsonData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"json:%@",jsonData);
        //        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
        
        if (failedBlock) {
            NSError *requestError = error;
            failedBlock(requestError);
        }
        dispatch_group_leave(group_request);
    }];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
    
    //    NSString *password = nil;//123456
    //    password = [self sha1: [self md5:password]];
    //    NSString *dJson = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",username,password];//wap/token
    //    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
}

//普通下载
- (void)downloadFileRequestid:(NSString *)idname ext:(NSString *)extname total:(int64_t)total timeOutSeconds:(NSTimeInterval)timeOutSeconds progress:(void (^)(CGFloat ))progressFloat completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    
    
//    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie]];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    AFURLSessionManager *manager = [RequestData shareRequestData].urlManager;
    
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    //    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    //    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    // 是否允许,NO-- 不允许无效的证书
    //    [securityPolicy setAllowInvalidCertificates:YES];
    //    [securityPolicy setValidatesDomainName:NO];
    
    
    // 设置证书
    //    [securityPolicy setPinnedCertificates:certSet];
    //    manager.securityPolicy = securityPolicy;
    //
    
    //http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5783255631aa63828cc5e26b&view=
    //http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5783255631aa63828cc5e26b&view=
    //    NSString *idjsonStr = [NSString stringWithFormat:@"{\"search\":{\"EQ_OBJECT_ID\":\"%@\",\"ORDER_CREATE_TIME\":\"DESC\"}}",idname];
    //    NSString *downloadfilepath = [[NSString stringWithFormat:@"%@storage/getObject?sourceQc=%@",severurl,idjsonStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    NSString *downloadfilepath = [NSString stringWithFormat:@"http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5785df8731aa6334903cebf9&view="];
    NSString *downloadfilepath = [[NSString stringWithFormat:@"%@storage/getObject?objectId=%@&view=",[APPData sharedappData].severUrl,idname]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:downloadfilepath parameters:nil error:nil];;
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%lld",downloadProgress.completedUnitCount);
        CGFloat dataprogress = 1.0 * downloadProgress.completedUnitCount / total;
        //        NSLog(@"%lf",dataprogress);
        if (progressFloat) {
            progressFloat(dataprogress);
        }
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //保存路径
        
        NSArray *aArray = [[response suggestedFilename] componentsSeparatedByString:@"."];
        NSString *filename = [NSString stringWithFormat:@"%@.%@",idname,[aArray lastObject]];
        
        //        NSLog(@"%@",targetPath);
        NSString *dirName = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"FileData"];
        
        return [[[documentsDirectoryURL URLByAppendingPathComponent:@"FileData"] URLByAppendingPathComponent:dirName] URLByAppendingPathComponent:filename];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //        NSLog(@"File downloaded to: %@", filePath);
        //        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        //        NSLog(@" http response : %ld",httpResponse.statusCode);
        
        if (filePath == nil) {
            if (failedBlock) {
                failedBlock(error);
            }
            //失败后删除文件当前文件 请求超时
            
        }else{
            if (completionBlock) {
                completionBlock(filePath.absoluteString);
            }
        }
        
        dispatch_group_leave(group_request);
    }];
    [downloadTask resume];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}
//管理普通下载
- (void)downloadFileRequestid:(NSString *)idname ext:(NSString *)extname total:(int64_t)total timeOutSeconds:(NSTimeInterval)timeOutSeconds currentProgress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    
    
//    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie]];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    AFURLSessionManager *manager = [RequestData shareRequestData].urlManager;
    
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    //    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    //    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    // 是否允许,NO-- 不允许无效的证书
    //    [securityPolicy setAllowInvalidCertificates:YES];
    //    [securityPolicy setValidatesDomainName:NO];
    
    
    // 设置证书
    //    [securityPolicy setPinnedCertificates:certSet];
    //    manager.securityPolicy = securityPolicy;
    //
    
    //http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5783255631aa63828cc5e26b&view=
    //http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5783255631aa63828cc5e26b&view=
    //    NSString *idjsonStr = [NSString stringWithFormat:@"{\"search\":{\"EQ_OBJECT_ID\":\"%@\",\"ORDER_CREATE_TIME\":\"DESC\"}}",idname];
    //    NSString *downloadfilepath = [[NSString stringWithFormat:@"%@storage/getObject?sourceQc=%@",severurl,idjsonStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    NSString *downloadfilepath = [NSString stringWithFormat:@"http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5785df8731aa6334903cebf9&view="];
    NSString *downloadfilepath = [[NSString stringWithFormat:@"%@storage/getObject?objectId=%@&view=",[APPData sharedappData].severUrl,idname] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:downloadfilepath parameters:nil error:nil];;
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%lld",downloadProgress.completedUnitCount);
        //        CGFloat dataprogress = 1.0 * downloadProgress.completedUnitCount / total;
        //        NSLog(@"%lf",dataprogress);
        if (downloadProgressBlock) {
            downloadProgressBlock(downloadProgress);
        }
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //保存路径
        
        NSArray *aArray = [[response suggestedFilename] componentsSeparatedByString:@"."];
        NSString *filename = [NSString stringWithFormat:@"%@.%@",idname,[aArray lastObject]];
        
        //        NSLog(@"%@",targetPath);
        NSString *dirName = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"FileData"];
        return [[[documentsDirectoryURL URLByAppendingPathComponent:@"FileData"] URLByAppendingPathComponent:dirName] URLByAppendingPathComponent:filename];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //        NSLog(@"File downloaded to: %@", filePath);
        //        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        //        NSLog(@" http response : %ld",httpResponse.statusCode);
        
        if (filePath == nil) {
            if (failedBlock) {
                failedBlock(error);
            }
            //失败后删除文件当前文件 请求超时
            
        }else{
            if (completionBlock) {
                completionBlock(filePath.absoluteString);
            }
        }
        
        dispatch_group_leave(group_request);
    }];
    [downloadTask resume];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}


- (void)downloadFile:(NSString *)fileid filename:(NSString *)filename total:(int64_t)total timeOutSeconds:(NSTimeInterval)timeOutSeconds progress:(void (^)(CGFloat ))progressFloat completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    
    
//    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie]];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    AFURLSessionManager *manager = [RequestData shareRequestData].urlManager;;
    //http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5783255631aa63828cc5e26b&view=
    //http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5783255631aa63828cc5e26b&view=
    
    
    //是饥饿中正师级
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    //    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    //    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    // 是否允许,NO-- 不允许无效的证书
    //    [securityPolicy setAllowInvalidCertificates:YES];
    //    [securityPolicy setValidatesDomainName:NO];
    
    // 设置证书
    //    [securityPolicy setPinnedCertificates:certSet];
    //    manager.securityPolicy = securityPolicy;
    //
    
    NSString *downloadfilepath = [[NSString stringWithFormat:@"%@storage/getObject?objectId=%@&view=",[APPData sharedappData].severUrl,fileid] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    NSString *downloadfilepath = [NSString stringWithFormat:@"%@%@",severurl,url];
    //    NSString *downloadfilepath = [NSString stringWithFormat:@"http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5785df8731aa6334903cebf9&view="];
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:downloadfilepath parameters:nil error:nil];;
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%lld",downloadProgress.completedUnitCount);
        CGFloat dataprogress = 1.0 * downloadProgress.completedUnitCount / total;
        //        NSLog(@"%lf",dataprogress);
        if (progressFloat) {
            progressFloat(dataprogress);
        }
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //保存路径
        
        NSArray *aArray = [[response suggestedFilename] componentsSeparatedByString:@"."];
        NSString *onefilename = [NSString stringWithFormat:@"%@.%@",filename,[aArray lastObject]];
        //        NSLog(@"targetPath:%@",targetPath);
        NSString *dirName = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"FileData"];
        //        NSLog(@"targetPath-1:%@",[[[documentsDirectoryURL URLByAppendingPathComponent:KLCDATA] URLByAppendingPathComponent:dirName] URLByAppendingPathComponent:filename]);
        return [[[documentsDirectoryURL URLByAppendingPathComponent:@"FileData"] URLByAppendingPathComponent:dirName] URLByAppendingPathComponent:onefilename];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (filePath == nil) {
            if (failedBlock) {
                failedBlock(error);
            }
        }else{
            if (completionBlock) {
                completionBlock(filePath.absoluteString);
            }
        }
        
        dispatch_group_leave(group_request);
    }];
    [downloadTask resume];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}

//下载视频文件
- (void)downloadVideoFileRequestid:(NSString *)urlid filename:(NSString *)filename total:(int64_t)total timeOutSeconds:(NSTimeInterval)timeOutSeconds progress:(void (^)(CGFloat ))progressFloat completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    
    
//    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie]];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    AFURLSessionManager *manager = [RequestData shareRequestData].urlManager;;
    //http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5783255631aa63828cc5e26b&view=
    //http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5783255631aa63828cc5e26b&view=
    
    
    //是饥饿中正师级
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    //    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    //    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    // 是否允许,NO-- 不允许无效的证书
    //    [securityPolicy setAllowInvalidCertificates:YES];
    //    [securityPolicy setValidatesDomainName:NO];
    
    // 设置证书
    //    [securityPolicy setPinnedCertificates:certSet];
    //    manager.securityPolicy = securityPolicy;
    //
    
    NSString *downloadfilepath = [[NSString stringWithFormat:@"%@storage/getObject?objectId=%@&view=",[APPData sharedappData].severUrl,urlid] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    NSString *downloadfilepath = [NSString stringWithFormat:@"%@%@",severurl,url];
    //    NSString *downloadfilepath = [NSString stringWithFormat:@"http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5785df8731aa6334903cebf9&view="];
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:downloadfilepath parameters:nil error:nil];;
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%lld",downloadProgress.completedUnitCount);
        CGFloat dataprogress = 1.0 * downloadProgress.completedUnitCount / total;
        //                NSLog(@"%lf",dataprogress);
        if (progressFloat) {
            progressFloat(dataprogress);
        }
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //保存路径
        
        //        NSArray *aArray = [[response suggestedFilename] componentsSeparatedByString:@"."];
        //        NSString *onefilename = [NSString stringWithFormat:@"%@.%@",filename,[aArray lastObject]];
        NSLog(@"%@",[response suggestedFilename]);
        
        return [[documentsDirectoryURL URLByAppendingPathComponent:@"XJVideo"] URLByAppendingPathComponent:filename];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (filePath == nil) {
            if (failedBlock) {
                failedBlock(error);
            }
        }else{
            if (completionBlock) {
                completionBlock(filePath.absoluteString);
            }
        }
        
        dispatch_group_leave(group_request);
    }];
    [downloadTask resume];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}



//文件下载
- (void)downloadfile
{
    //无进度跟踪
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //storage/getObject?objectId=5782195231aa6315680df0a6&view=
    //    NSURL *URL = [NSURL URLWithString:@"http://bos.wenku.bdimg.com/v1/wenku18//4192e3fa9613350c60da7954e341968e?responseContentDisposition=attachment%3B%20filename%3D%22%CA%D4%BE%ED%B4%FA%BA%C50.pdf%22&responseContentType=application%2Foctet-stream&responseCacheControl=no-cache&authorization=bce-auth-v1%2Ffa1126e91489401fa7cc85045ce7179e%2F2016-07-11T14%3A29%3A17Z%2F3600%2Fhost%2F9090ee5d7bfa97310602be6c9e6d857e17db37bc51e6e746ae364e22a0bcb8d1&token=9dc82640d9e34f11e3088022bc2c4306219eac19519055615274bd3d040449ed&expire=2016-07-11T15:29:17Z"];
    
    NSString *URLString = @"http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5785df8731aa6334903cebf9&view=";
    //    NSURL *URL = [NSURL URLWithString:@"http://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=http%3A%2F%2Fwww.jlonline.com%2Fuploads%2Fallimg%2F151103%2F133522O20-0.jpg&thumburl=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fh%253D200%2Fsign%3D5a188e1c2f381f3081198aa999014c67%2F242dd42a2834349bc70cd2a1ceea15ce36d3be88.jpg"];
    
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"kkkk%lld",downloadProgress.completedUnitCount);
        //        NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}

#pragma mark - Upload part

- (void)uploadFileRequestFilePath:(NSString *)filepath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds progress:(void (^)(CGFloat ))progressFloat completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    
    NSDictionary *parameters = nil;
    if (jsondata != nil) {
        parameters = @{@"params" : jsondata};
    }
    
    
//    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie]];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    AFURLSessionManager *manager = [RequestData shareRequestData].urlManager;
//    NSString *cookieStr = [USERDEFAULTS objectForKey:kUserDefaultsCookie];
//    [manage.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",nil];
    
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    //    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    //    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    // 是否允许,NO-- 不允许无效的证书
    //    [securityPolicy setAllowInvalidCertificates:YES];
    //    [securityPolicy setValidatesDomainName:NO];
    
    
    // 设置证书
    //    [securityPolicy setPinnedCertificates:certSet];
    //    manager.securityPolicy = securityPolicy;
    //
    //    NSString *idjsonStr = [NSString stringWithFormat:@"{\"search\":{\"EQ_BIZ_FORM_ID\":\"%@\",\"ORDER_CREATE_TIME\":\"DESC\"}}",idname];
    //http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5783255631aa63828cc5e26b&view=
    //http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5783255631aa63828cc5e26b&view=
    
    NSString *uploadURL = [[NSString stringWithFormat:@"%@storage/putObject",[APPData sharedappData].severUrl] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    NSString *downloadfilepath = [NSString stringWithFormat:@"http://120.24.208.166:8080/topflames-oa/storage/getObject?objectId=5785df8731aa6334903cebf9&view="];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:uploadURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filepath] name:@"Filedata" error:nil];
    } error:nil];
    //    [formData appendPartWithFileURL:filePath name:@"Filedata" error:nil];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //                          [progressView setProgress:uploadProgress.fractionCompleted];
                          if (progressFloat) {
                              progressFloat(uploadProgress.fractionCompleted);
                          }
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      if (error) {
                          if (failedBlock) {
                              failedBlock(error);
                          }
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          if (completionBlock) {
                              completionBlock(responseObject);
                          }
                      }
                      dispatch_group_leave(group_request);
                  }];
    
    [uploadTask resume];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}

- (void)uploadFile:(NSString *)filepath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds progress:(void (^)(CGFloat ))progressFloat completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    
    NSDictionary *parameters = nil;
    if (jsondata != nil) {
        parameters = @{@"param":jsondata};
    }
    
    AFHTTPSessionManager *manage = [RequestData shareRequestData].httpManager;
    NSString *uploadURL = [[NSString stringWithFormat:@"%@app/picture/upload",[APPData sharedappData].severUrl] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    id cookieStr = [USERDEFAULTS objectForKey:kUserDefaultsCookie];
    if (cookieStr && [cookieStr isKindOfClass:[NSString class]]) {
        [manage.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Set-Cookie"];
    }
    [manage POST:uploadURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filepath] name:@"picture" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            if (progressFloat) {
                progressFloat(uploadProgress.fractionCompleted);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        NSData *jsonData = responseObject;
        //        NSLog(@"json:%@",jsonData);
        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
        if (datastr == nil) {
            datastr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        }
        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        if(jsonData==nil){//接口请求发生异常，直接返回
            return;
        }
        //
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (completionBlock) {
            completionBlock(json);
        }
        dispatch_group_leave(group_request);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(error);
        }
        dispatch_group_leave(group_request);
    }];
    
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}

#pragma mark - Commont Request part
- (void)commonGETRequest:(NSString *)addressPath requestdata:(NSDictionary *)data timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    
    //    NSLog(@"%@",parameters);
    
    AFHTTPSessionManager *manage = [RequestData shareRequestData].httpManager;
    //申明返回的结果是json类型
    //    manage.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    //    manage.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    //    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    //申明请求的数据是json类型
    
    //https 支持
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    //    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = YES;
    manage.securityPolicy  = securityPolicy;
    
    manage.requestSerializer.timeoutInterval = timeOutSeconds;
    //    multipart/form-data
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",nil];
    [manage GET:addressPath parameters:data progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        //        NSString *jsonStr = responseObject;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (completionBlock) {
                completionBlock(responseObject);
            }
        }else{
            NSData *jsonData = responseObject;
            //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            //        NSLog(@"json:%@",jsonData);
            NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
            //        NSLog(@"%@",datastr);
            if (datastr == nil) {
                datastr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
            }
            NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
            if(jsonData==nil){//接口请求发生异常，直接返回
                return;
            }
            //
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //                NSLog(@"next:json%@",json);
            if (completionBlock) {
                completionBlock(json);
            }
        }
        
        dispatch_group_leave(group_request);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            NSLog(@"%@",error.userInfo);
            NSData *jsonData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSLog(@"json:%@",jsonData);
            NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
            NSLog(@"json:%@",datastr);
            
            NSError *requestError = error;
            failedBlock(requestError);
        }
        dispatch_group_leave(group_request);
    }];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}

- (void)commonJsonRequest:(NSString *)intefacePath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",APPDATA.severUrl,intefacePath];
    NSDictionary *parameters = nil;
    if (jsondata != nil) {
        parameters = @{@"params" : jsondata};
    }
    //    NSLog(@"%@",parameters);
    
    AFHTTPSessionManager *manage = [RequestData shareRequestData].httpManager;
    //申明返回的结果是json类型
    manage.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    //申明请求的数据是json类型
    manage.requestSerializer.timeoutInterval = timeOutSeconds;
    //    multipart/form-data
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",nil];
    
    
    //    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie]];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [manage POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        //        NSString *jsonStr = responseObject;
        NSData *jsonData = responseObject;
        //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"json:%@",jsonData);
        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"%@",datastr);
        if (datastr == nil) {
            datastr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
        }
        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        if(jsonData==nil){//接口请求发生异常，直接返回
            return;
        }
        //
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //                NSLog(@"next:json%@",json);
        if (completionBlock) {
            completionBlock(json);
        }
        dispatch_group_leave(group_request);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //                NSLog(@"%@",error.userInfo);
        //        NSData *jsonData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"json:%@",jsonData);
        //        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (failedBlock) {
            NSError *requestError = error;
            failedBlock(requestError);
        }
        dispatch_group_leave(group_request);
    }];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}

- (void)commonRequest:(NSString *)intefacePath requestdata:(NSDictionary *)parameters timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    NSString *urlString = [NSString stringWithFormat:@"%@",intefacePath];
    //    NSDictionary *parameters = nil;
    //    if (jsondata != nil) {
    //        parameters = @{@"params" : jsondata};
    //    }
    //    NSLog(@"%@",parameters);
    
    AFHTTPSessionManager *manage = [RequestData shareRequestData].httpManager;
    //申明返回的结果是json类型
    
    //https 支持
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    //    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //    securityPolicy.validatesDomainName = YES;
    //    manage.securityPolicy  = securityPolicy;
    
    
    
    manage.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.requestSerializer = [AFJSONRequestSerializer serializer];
    manage.responseSerializer = [AFJSONResponseSerializer serializer];
    //    //申明请求的数据是json类型
    manage.requestSerializer.timeoutInterval = timeOutSeconds;
    
    //    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil]; //@"text/plain",@"text/html",
    
    //    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie]];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [manage POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        //        NSString *jsonStr = responseObject;
        //        NSData *jsonData = responseObject;
        //        //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //        //        NSLog(@"json:%@",jsonData);
        //        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
        //        //        NSLog(@"%@",datastr);
        //        if (datastr == nil) {
        //            datastr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        //
        //        }
        //        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        //        if(jsonData==nil){//接口请求发生异常，直接返回
        //            return;
        //        }
        //        //
        NSDictionary *json = responseObject;
        //                NSLog(@"next:json%@",json);
        if (completionBlock) {
            completionBlock(json);
        }
        dispatch_group_leave(group_request);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //                NSLog(@"%@",error.userInfo);
        //        NSData *jsonData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"json:%@",jsonData);
        //        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
        
        if (failedBlock) {
            NSError *requestError = error;
            failedBlock(requestError);
        }
        dispatch_group_leave(group_request);
    }];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}


- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)sha1:(NSString *)srcString{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i =0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}


//1.获取登陆请求成功后保存的cookies:
+ (NSString *)cookieValueWithKey:(NSString *)key
{
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    if ([sharedHTTPCookieStorage cookieAcceptPolicy] != NSHTTPCookieAcceptPolicyAlways) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    }
    
    NSArray         *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:@"http://192...."]];
    NSEnumerator    *enumerator = [cookies objectEnumerator];
    NSHTTPCookie    *cookie;
    while (cookie = [enumerator nextObject]) {
        if ([[cookie name] isEqualToString:key]) {
            return [NSString stringWithString:[[cookie value] stringByRemovingPercentEncoding]];
        }
    }
    
    return nil;
}

//2.删除cookies (key所对应的cookies) ///因为cookies保存在NSHTTPCookieStorage.cookies中.这里删除它里边的元素即可.
+ (void)deleteCookieWithKey:(NSString *)key
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    
    for (NSHTTPCookie *cookie in cookies) {
        if ([[cookie name] isEqualToString:key]) {
            [cookieJar deleteCookie:cookie];
        }
    }
}

@end
