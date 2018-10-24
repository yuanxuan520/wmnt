//
//  BuiltInPayAppStroe.h
//  BookSetting
//
//  Created by xuan yuan on 12-7-21.
//  Copyright (c) 2012年 武汉生物工程学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#define iAPfinished @"BUYFINISHED"
#define iAPBuyFailed @"BUYFAILED"
#define iAPloadbegin @"IAPLOADBEGIN"
#define iAPloadend @"IAPLOADEND"

#define ProductID_IAPads @"com.removeAds"//$0.99
#define ProductID_IAPbook0 @"com.magazine00"//$0.99
#define ProductID_IAPbook1 @"com.magazine01"//$0.99
#define ProductID_IAPbook2 @"com.magazine02"//$0.99

#define IAPads          10
#define IAPbook0        11
#define IAPbook1        12
#define IAPbook2        13

@interface BuiltInPayAppStroe : NSObject<SKPaymentTransactionObserver,SKProductsRequestDelegate,SKRequestDelegate>
@property (nonatomic, assign) int buyType;
@property (nonatomic, strong) NSString *buyID;
@property (nonatomic, strong) NSString *productName;
+ (BuiltInPayAppStroe *)shareInstance;
- (void)restoreProduct;
//- (void)restoreProduct:(NSString *)productID;
-(void)buy:(int)type;
- (void)idbuy:(NSString *)productID;
- (void)RequestProductData;
- (void)IDRequestProductData;
- (NSString *)writeplistPath;
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
@end
