//
//  YKOrderDetailVC.h
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//

#import "YKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface YKOrderDetailVC : YKBaseVC
@property (nonatomic,strong)NSArray *productArray;
@property (nonatomic,strong)NSString *orderId;//订单编号：查询订单信息
@end

NS_ASSUME_NONNULL_END
