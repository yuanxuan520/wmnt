//
//  APPData.m
//  Manly
//
//  Created by yuanxuan on 2017/4/12.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import "APPData.h"

@implementation APPData
@synthesize severUrl;
+ (APPData *)sharedappData
{
    static APPData *sharedToolsInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedToolsInstance = [[self alloc] init];
    });
    return sharedToolsInstance;
}


@end
