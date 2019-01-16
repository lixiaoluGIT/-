//
//  YKOrderDetail.m
//  YK
//
//  Created by edz on 2019/1/10.
//  Copyright © 2019 YK. All rights reserved.
//

#import "YKOrderDetail.h"
@implementation YKOrderDetail
- (void)initWithDictionary:(NSDictionary *)dic{
    if (dic.allKeys.count==0) {
        return;
    }
    self.createTime = [NSString stringWithFormat:@"下单时间：%@",dic[@"createTime"]];
    self.orderNo = [NSString stringWithFormat:@"%@",dic[@"orderNo"]];
    self.consignee = [NSString stringWithFormat:@"%@",dic[@"addressVo"][@"consignee"]];
    self.contactNumber = [NSString stringWithFormat:@"%@",dic[@"addressVo"][@"contactNumber"]];
    self.address = [NSString stringWithFormat:@"%@%@",dic[@"addressVo"][@"region"],dic[@"addressVo"][@"detailedAddress"]];
    self.productList = [NSArray arrayWithArray:dic[@"orderDetailsVoList"]];
    self.orderType = [NSString stringWithFormat:@"%@",dic[@"orderType"]];
    self.orderState = [NSString stringWithFormat:@"%@",dic[@"orderState"]];
    self.orderStatus = [NSString stringWithFormat:@"%@",dic[@"orderStatus"]];
    self.orderAmount = [NSString stringWithFormat:@"%@",dic[@"orderAmount"]];
    self.recommentProductList = [NSArray arrayWithArray:dic[@"clothingVoList"]];
    
    if ([dic[@"sendTime"] isEqual:[NSNull null]]) {
        self.isOnRoad = NO;//未发货 
    }else {
        self.isOnRoad = YES;//已发货
    }
}

@end
