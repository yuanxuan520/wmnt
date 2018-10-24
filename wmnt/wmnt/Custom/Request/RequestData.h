//
//  RequestData.h
//  Manly
//
//  Created by yuanxuan on 2017/4/12.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestData : NSObject
@property (nonatomic, strong) NSMutableDictionary *downloadQueueDict;

+(RequestData *)shareRequestData;

//无cookie GET请求
- (void)commonGETRequest:(NSString *)addressPath requestdata:(NSDictionary *)data timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

//无cookie 常用POST请求
- (void)commonRequest:(NSString *)intefacePath requestdata:(NSDictionary *)parameters timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

//json 字符串 常用POST请求
- (void)commonJsonRequest:(NSString *)intefacePath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

//用户登录使用
- (void)loginAFRequest:(NSString *)intefacePath userName:(NSString *)username password:(NSString *)password timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

//post请求
- (void)startAFRequest:(NSString *)intefacePath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

//获取文件list
- (void)getFileRequest:(NSString *)intefacePath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

//文件下载请求
- (void)downloadFileRequestid:(NSString *)idname ext:(NSString *)extname total:(int64_t)total timeOutSeconds:(NSTimeInterval)timeOutSeconds progress:(void (^)(CGFloat ))progressFloat completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

//管理普通下载
- (void)downloadFileRequestid:(NSString *)idname ext:(NSString *)extname total:(int64_t)total timeOutSeconds:(NSTimeInterval)timeOutSeconds currentProgress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

- (void)downloadFile:(NSString *)fileid filename:(NSString *)filename total:(int64_t)total timeOutSeconds:(NSTimeInterval)timeOutSeconds progress:(void (^)(CGFloat ))progressFloat completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;



- (void)downloadVideoFileRequestid:(NSString *)url filename:(NSString *)filename total:(int64_t)total timeOutSeconds:(NSTimeInterval)timeOutSeconds progress:(void (^)(CGFloat ))progressFloat completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

- (void)downloadfile;

//文件上传请求

- (void)uploadFileRequestFilePath:(NSString *)filepath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds progress:(void (^)(CGFloat ))progressFloat completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

//上传文件
- (void)uploadFile:(NSString *)filepath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds progress:(void (^)(CGFloat ))progressFloat completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;
@end
