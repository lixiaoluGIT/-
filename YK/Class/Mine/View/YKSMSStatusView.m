//
//  YKSMSStatusView.m
//  YK
//
//  Created by LXL on 2017/12/1.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSMSStatusView.h"

@interface YKSMSStatusView()
@property (weak, nonatomic) IBOutlet UILabel *smsStatus;
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *smsDes;

@end
@implementation YKSMSStatusView

- (void)awakeFromNib {
    [super awakeFromNib];
    _orderId.font = PingFangSC_Regular(kSuitLength_H(14));
    _phone.font = PingFangSC_Regular(kSuitLength_H(14));
    _smsStatus.font = PingFangSC_Regular(kSuitLength_H(14));
    _smsDes.font = PingFangSC_Regular(kSuitLength_H(14));
}

- (void)initWithOrderId:(NSString *)orderId orderStatus:(NSString *)orderStatus phone:(NSString *)phone{
    _smsStatus.text = orderStatus;
    if (orderId.length == 0) {
        _orderId.text = @"未查到订单号";
    }else {
        _orderId.text = [NSString stringWithFormat:@"物流单号：%@",orderId];
    }https://appapi.koofang.com/api/1hand/filters
    _phone.text = [NSString stringWithFormat:@"客服电话：%@",phone];

}
@end
