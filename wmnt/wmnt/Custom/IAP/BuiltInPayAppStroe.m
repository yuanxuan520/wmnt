//
//  BuiltInPayAppStroe.m
//  BookSetting
//
//  Created by xuan yuan on 12-7-21.
//  Copyright (c) 2012年 武汉生物工程学院. All rights reserved.
//

#import "BuiltInPayAppStroe.h"

//https://www.cnblogs.com/wangboy91/p/7162335.html
//http://blog.csdn.net/yupu56/article/details/46907609

@implementation BuiltInPayAppStroe
+ (BuiltInPayAppStroe *)shareInstance
{
    static BuiltInPayAppStroe *builtInPayshareinstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        builtInPayshareinstance = [[BuiltInPayAppStroe alloc] init];
    });
    return builtInPayshareinstance;
    
}
- (id)init
{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

//1
-(void)buy:(int)type
{
    self.buyType = type;
    if ([SKPaymentQueue canMakePayments]) { //检测是否可以进行支付
        //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        [self RequestProductData];
        NSLog(@"允许程序内付费购买");
    }
    else
    {
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"警告"
                                                            message:@"没允许应用程序内购买"
                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        
        [alerView show];
        
    }
}

-(bool)CanMakePay
{
    return [SKPaymentQueue canMakePayments];
}
//2
-(void)RequestProductData    //请求产品数据
{
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    switch (self.buyType) {
        case IAPads:
            product=[[NSArray alloc] initWithObjects:ProductID_IAPads,nil];
            break;
        case IAPbook0:
            product=[[NSArray alloc] initWithObjects:ProductID_IAPbook0,nil];
            break;
        case IAPbook1:
            product=[[NSArray alloc] initWithObjects:ProductID_IAPbook1,nil];
            break;
        case IAPbook2:
            product=[[NSArray alloc] initWithObjects:ProductID_IAPbook2,nil];
            break;
            //        case IAP0p99:
            //            product=[[NSArray alloc] initWithObjects:ProductID_IAP0p99,nil];
            //            break;
        default:
            break;
    }
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start]; //开始发送请求
    [[NSNotificationCenter defaultCenter] postNotificationName:iAPloadbegin object:nil];
    
    //[activityIndicator startAnimating];//开始转进度条
}
//单个id恢复或者全部都恢复 //消耗品无法恢复.
- (void)restoreProduct//:(NSString *)productID
{
    //buyID = productID;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    [[NSNotificationCenter defaultCenter] postNotificationName:iAPloadbegin object:nil];
}

//使用id购买
- (void)idbuy:(NSString *)productID
{
    self.buyID = productID;
    if ([SKPaymentQueue canMakePayments]) { //检测是否可以进行支付
        //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        [self IDRequestProductData];
        NSLog(@"允许程序内付费购买");
    }
    else
    {
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"暂时不允许应用程序内购买"
                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        
        [alerView show];
    }
}

-(void)IDRequestProductData//请求产品数据
{
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    product= [NSArray arrayWithObjects:self.buyID,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate=self;
    [request start]; //开始发送请求
    [[NSNotificationCenter defaultCenter] postNotificationName:iAPloadbegin object:nil];
    //[activityIndicator startAnimating];//开始转进度条
}

//SKProductsRequestDelegate 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{    //已收到请求给出的响应
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品的数量:%d",[myProduct count]);
    // populate UI
    SKPayment *payment = nil;
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        if (self.productName) {
            self.productName = nil;
        }
        self.productName = [[NSString alloc] initWithFormat:@"%@",product.localizedTitle];
        NSLog(@"产品标题 %@" , self.productName);//产品的名称
        NSLog(@"产品描述信息: %@" , product.localizedDescription);//该产品的描述
        NSLog(@"价格: %@元" , product.price);                      //该产品在当地货币的成本
        NSLog(@"Product id: %@" , product.productIdentifier);   //苹果App Store产品字符串标识
        //        switch (buyType) {
        //            case IAP0p99:
        //            {
        payment  = [SKPayment paymentWithProduct:product];    //支付$0.99
        //            }
        //
        //            default:
        //                break;
        //        }
    }
    if (payment == nil) {//如果不存在该商品，弹出警告
        [[NSNotificationCenter defaultCenter] postNotificationName:iAPloadend object:nil];
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"没有您要购买的商品!～"
                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil];
        
        [alerView show];
        return;
    }
    NSLog(@"---------发送购买请求------------");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    //SKPaymentTransactionObserver 千万不要忘记绑定，代码如下：
    //----监听购买结果
    
}

//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
//        NSLog(@"%ld",transaction.transactionState);
//        NSLog(@"%@",transaction.transactionIdentifier);
//        NSLog(@"%@",transaction.payment.productIdentifier);
//        NSLog(@"%@",receiptData);

//        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
//        NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
////        NSLog(@"%@",transaction.transactionReceipt);
//        NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//        NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
            {
                [self completeTransaction:transaction];
                NSLog(@"-----交易完成 --------");//获得购买名称
            }
                break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                [self failedTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品，本次交易恢复用户以前购买的内容
                [self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
                
                break;
            case SKPaymentTransactionStatePurchasing://商品添加进列表,正在处理
                NSLog(@"-----商品添加进列表,正在处理--------");
                
                break;
            default:
                break;
        }
    }
}
//交易完成
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    NSLog(@"%@",transaction.payment.productIdentifier);
    if ([product length] > 0) {
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    // Remove the transaction from the payment queue.
    // 保存票据 传给服务器
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    //        NSLog(@"%@",transaction.transactionReceipt);
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    
//    APPDATA.iapReceiptData = receiptString;
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    //[activityIndicator stopAnimating];//停止转动
    [[NSNotificationCenter defaultCenter] postNotificationName:iAPloadend object:nil];//加载完成
    [[NSNotificationCenter defaultCenter] postNotificationName:iAPfinished object:product];//购买完成
}

//交易失败
- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    NSString *product = transaction.payment.productIdentifier;
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:iAPloadend object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:iAPBuyFailed object:product];//购买完成
    
}

//交易恢复处理
- (void)restoreTransaction: (SKPaymentTransaction *)transaction
{
        NSLog(@"-----completeTransaction--------");
        // Your application should implement these two methods.
        NSString *product = transaction.payment.productIdentifier;
        NSLog(@"%@",transaction.payment.productIdentifier);
        if ([product length] > 0) {
            NSArray *tt = [product componentsSeparatedByString:@"."];
            NSString *bookid = [tt lastObject];
            if ([bookid length] > 0) {
                [self recordTransaction:bookid];
                [self provideContent:bookid];
            }
        }
        
        // Remove the transaction from the payment queue.
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        //[activityIndicator stopAnimating];//停止转动
        [[NSNotificationCenter defaultCenter] postNotificationName:iAPloadend object:nil];//加载完成
        [[NSNotificationCenter defaultCenter] postNotificationName:iAPfinished object:product];//购买完成
//        if ([product isEqualToString:ProductID_IAPads]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVEADS" object:nil];
//        }
    //}
}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
    NSLog(@"%@",product);
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
    NSLog(@"%@",product);
}

//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"发生错误" message:@"错误了"
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:iAPloadend object:nil];//加载完成
}

- (void)requestProUpgradeProductData
{
    NSLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}


//恢复完成
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    NSLog(@"++++++paymentQueueRestoreCompleted+++++++++++");
    UIAlertView *alerView3 =  [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"恭喜，您已恢复以前所有购买的内容!~"
                                                        delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
    
    [alerView3 show];
}


//恢复失败
-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
    [[NSNotificationCenter defaultCenter] postNotificationName:iAPloadend object:nil];
}

- (NSString *)writeplistPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"payment.plist"];
    return fullPathToFile;
}

-(void)dealloc    
{
        self.productName = nil;
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
}
@end
