//
//  YKBuyOrderCell.h
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//
//按钮的点击类型
typedef enum : NSInteger {
    //买衣
    cancleOrder = 1,//取消订单
    paySoon = 2,//立即支付
    toScanSMSInfor = 3,//查看物流
    ensureReceive = 4,//确认收货
    buyAgain = 5,//再次购买
    contractBusiness = 6,//联系商家
    deleteOrder = 7,//删除订单
    
    //租衣
    UserEnsureReceive = 8,//租衣确认收货
    UsertoScanSMSInfor = 9,//租衣查看物流（与买衣一个动作）
    UserOrderBack = 10,//租衣预约归还
    
}BtnActionType;

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKBuyOrderCell : UITableViewCell

@property (nonatomic,assign)orderStatus orderStatus;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *clothingId;
@property (nonatomic,strong)NSString *clothingName;
@property (nonatomic,strong)NSDictionary *dic;
- (void)initWithDic:(NSDictionary *)dic;
//到订单详情
@property (nonatomic,copy)void (^toDetail)(NSString *orderId);
//按钮的点击事件
@property (nonatomic,copy)void (^btnActionBlock)(BtnActionType actionType,NSString *orderId,NSString *clothingId,NSString *clothingName);
@end

NS_ASSUME_NONNULL_END
