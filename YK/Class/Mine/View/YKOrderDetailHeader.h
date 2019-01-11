//
//  YKOrderDetailHeader.h
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKOrderDetail.h"
#import "YKBuyOrderCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YKOrderDetailHeader : UIView

@property (nonatomic,strong)NSArray *productArray;

- (void)initWithDic:(NSDictionary *)dic;

@property (nonatomic,copy)void (^btnActionBlock)(BtnActionType actionType);//按钮1的点击回调

@property (nonatomic,strong)YKOrderDetail *orderDetail;

@end

NS_ASSUME_NONNULL_END
