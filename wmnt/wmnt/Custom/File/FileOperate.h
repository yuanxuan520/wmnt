//
//  FileOperate.h
//  Manly
//
//  Created by yuanxuan on 2017/4/12.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOperate : NSObject
- (void)createDir;
- (void)createDATADir;
- (void)createDirName:(NSString *)dirName;
- (void)createDownloadDirName:(NSString *)dirName;
- (NSString *)getDirName:(NSString *)dirName fileName:(NSString *)filename;
- (BOOL)deleteFile:(NSString *)filename;
- (BOOL)deleteFilePath:(NSString *)filePath;
- (BOOL)isFilePath:(NSString *)filePath;
@end
