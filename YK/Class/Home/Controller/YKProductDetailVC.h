//
//  YKProductDetailVC.h
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKProduct.h"

@interface YKProductDetailVC : YKBaseVC

@property (nonatomic,strong)YKProduct *product;
@property (nonatomic,strong)NSString *productId;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,assign)BOOL isFromShare;
@property (nonatomic,assign)BOOL isSP;

@property (nonatomic,assign)BOOL isNew;//是否是刚上新

@property (nonatomic,assign)BOOL canBuy;//是否可购买

@property (nonatomic,strong)NSDictionary *dic;//传过来的商品
@property (nonatomic,assign)BOOL hadSelectSize;;//是否从购买过来的，带着尺码

@property (nonatomic,strong)NSString *sizeNum;
@property (nonatomic,strong)NSString *sizeType;

@end
