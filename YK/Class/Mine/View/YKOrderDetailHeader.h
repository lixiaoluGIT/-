//
//  YKOrderDetailHeader.h
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKOrderDetailHeader : UIView

@property (nonatomic,strong)NSArray *productArray;

- (void)initWithDic:(NSDictionary *)dic;

@property (nonatomic,copy)void (^btn1ActionBlock)(void);//按钮1的点击回调
@property (nonatomic,copy)void (^btn2ActionBlock)(void);//按钮2的点击回调
@property (nonatomic,copy)void (^btn3ActionBlock)(void);//按钮3的点击回调

@end

NS_ASSUME_NONNULL_END
