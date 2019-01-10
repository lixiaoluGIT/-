//
//  YKOrderManager.h
//  YK
//
//  Created by LXL on 2017/12/12.
//  Copyright © 2017年 YK. All rights reserved.
//

#define receiveSection @"0"
#define backSection @"1"
#define hadBackSection @"2"

typedef enum : NSInteger {
    totalBag = 0,//全部
    toReceive = 1,//待签收
    toBack = 2,//待归还
    hadBack = 3,//已归还
}suitBagStatus;


//租衣和买衣所有的订单状态
typedef enum : NSInteger {
    
    //租衣订单状态
//    ReceiveStatus = 1,//待签收
//    backStatus = 2,//待归还
//    HadBackStatus = 3,//已归还
    
    //买衣订单状态
    ToPayStatus = 1,//待支付
    ToStartStatus = 2,//待发货
    ToReceiveStatus = 3,//待签收
    CompletionStatus = 4,//已完成
    CanceldStatus = 5,//已取消
    
}orderStatus;

#import <Foundation/Foundation.h>

@interface YKOrderManager : NSObject

@property (nonatomic,strong)NSMutableArray *totalOrderList;//全部衣袋的数据源(数组套数组结构)
@property (nonatomic,strong)NSMutableArray *sectionArray;//存储有哪几组数据(0:待签收;1:待归还;2:已归还)
@property (nonatomic,strong)NSString *orderNo;//订单号:(待签收,待归还只有一种)
@property (nonatomic,strong)NSString *ID;//订单ID
@property (nonatomic,strong)NSString *SMSStatus;//物流状态
@property (nonatomic,assign)BOOL isOnRoad;//订单是否发货
@property (nonatomic,strong)NSString *sfOrderId;

+ (YKOrderManager *)sharedManager;

//提交订单
- (void)releaseOrderWithAddress:(YKAddress *)address
                       shoppingCartIdList:(NSMutableArray *)shoppingCartIdList
                       cardType:(NSInteger)cardType
                             OnResponse:(void (^)(NSDictionary *dic))onResponse;

/*!
 查询订单
 订单状态码
 0 - 全部 1 - 待发货 2 - 待签收 3 - 待归还 4 - 质检中 41 - 通过 42 - 未通过 5 - 已归还 6 - 已取  7 - 已删除
 
 订单状态:0，1:待配货，2:待发货，3:待签收，4:待归还，5:已归还，6:已取消，7:已删除，8:已入库
 */
- (void)searchOrderWithOrderStatus:(NSInteger)status OnResponse:(void (^)(NSMutableArray *array))onResponse;

//查询物流信息(顺丰)
- (void)searchForSMSInforWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSArray *array))onResponse;

//查询物流信息(中通)
- (void)searchForZTSMSInforWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSArray *array))onResponse;

//确认收货
- (void)ensureReceiveWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSDictionary *dic))onResponse;

//模拟归还>>>>>>>>>>>测试用2018053179302
- (void)toReceiveWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSDictionary *dic))onResponse;

//预约归还
- (void)orderReceiveWithOrderNo:(NSString *)orderNo addressId:(NSString *)addressId time:(NSString *)time OnResponse:(void (^)(NSDictionary *dic))onResponse;

//查询待归还是否返件
- (void)queryReceiveOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSDictionary *dic))onResponse;

//生成sf(后台生成,前台不用)
- (void)creatSfOrderWithOrderNum:(NSString *)orderNum OnResponse:(void (^)(NSDictionary *dic))onResponse;

- (void)clear;

//查询历史订单(新接口)
- (void)searchBeHistoryOrderWithOrderStatus:(NSInteger)status OnResponse:(void (^)(NSDictionary *dic))onResponse;
- (void)searchHistoryOrderWithOrderStatus:(NSInteger)status OnResponse:(void (^)(NSArray *array))onResponse;

//购买衣物，创建订单
- (void)creatBuyOrderWithAddress:(YKAddress *)address clothingIdList:(NSArray *)clothingIdList OnResponse:(void (^)(NSArray *array))onResponse;

//查询购买历史订单（0-全部 1-待付款 2-待发货 3-待签收 4-已完成 5-已取消）
- (void)searchBuyOrderWithOrderStatus:(NSInteger)orderState OnResponse:(void (^)(NSArray *array))onResponse;

//取消买衣订单(1-取消订单 2-确认收货)
- (void)cancleBuyOrderWithOrderId:(NSInteger)orderId type:(NSInteger)type OnResponse:(void (^)(NSArray *array))onResponse;

//订单详情
@end
