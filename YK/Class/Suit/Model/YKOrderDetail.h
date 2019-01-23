//
//  YKOrderDetail.h
//  YK
//
//  Created by edz on 2019/1/10.
//  Copyright © 2019 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

//订单详情模型
@interface YKOrderDetail : NSObject
@property (nonatomic,strong)NSString *createTime;//下单时间
@property (nonatomic,strong)NSString *sendTime;//发货时间
@property (nonatomic,assign)BOOL isOnRoad;//是否已发货
@property (nonatomic,strong)NSString *orderNo;//订单编号
@property (nonatomic,strong)NSString *consignee;//联系人
@property (nonatomic,strong)NSString *contactNumber;//联系电话
@property (nonatomic,strong)NSString *address;//详细地址
@property (nonatomic,strong)NSArray *productList;//用户商品列表
@property (nonatomic,strong)NSString *orderType;//订单类型（1-租衣 2-买衣）
@property (nonatomic,strong)NSString *orderState;//订单状态
@property (nonatomic,strong)NSString *orderStatus;//租衣订单状态
@property (nonatomic,strong)NSString *orderAmount;//订单总价
@property (nonatomic,strong)NSArray *recommentProductList;//推荐商品列表

- (void)initWithDictionary:(NSDictionary *)dic;
@end


