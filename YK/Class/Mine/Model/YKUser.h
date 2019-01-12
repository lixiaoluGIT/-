//
//  YKUser.h
//  YK
//
//  Created by LXL on 2017/12/4.
//  Copyright © 2017年 YK. All rights reserved.
//

//用户推荐尺码大小(以腰围为标准)
//60-68 XS
//68-71 S
//71-75 M
//75-79 L
//79-84 XL
//84-89 XXL
//89-93 XXXL
//93-97 XXXXL
typedef enum : NSInteger {
    XS = 0,//XS
    S = 1,//S
    M = 2,//M
    L = 3,//L
    XL = 4,//XL
    XXL = 5,//XXL
    XXXL = 6,//XXXL
    XXXXL = 7,//XXXXL
    Null = 8//没有上传尺码
}UserSize;

#import <Foundation/Foundation.h>

@interface YKUser : NSObject

//用户信息

@property (nonatomic,strong)NSString *rongToken;//融云token
@property (nonatomic,strong)NSString *userId;//用户Id
@property (nonatomic,strong)NSString *nickname;//用户昵称
@property (nonatomic,strong)NSString *photo;//用户头像url
@property (nonatomic,strong)NSString *gender;//用户性别
@property (nonatomic,strong)NSString *phone;//用户手机号
//会员卡押金信息
@property (nonatomic,strong)NSString *cardNum;//会员卡号
@property (nonatomic,strong)NSString *cardType;//会员卡类型 1季卡2月卡3年卡4体验卡5助力卡6加时卡7兑换卡
@property (nonatomic,strong)NSString *depositEffective;//押金状态 0>未交,不是VIP,1>有效,2>退还中,3>无效
@property (nonatomic,strong)NSString *effective;//会员卡状态 1>使用中,2>已过期,3>无押金,4>未开通
@property (nonatomic,strong)NSString *validity;//会员剩余天数
@property (nonatomic,strong)NSString *isShare;//是否分享过 (0,1)
@property (nonatomic,strong)NSString *inviteCode;//我的邀请码
//学校信息
@property (nonatomic,strong)NSString *colledgeId;//学校Id
@property (nonatomic,strong)NSString *colledgeName;//学校名
//是否付费
@property (nonatomic,strong)NSString *isNewUser;//0未付费。1已付费

//
@property (nonatomic,assign)BOOL isBingWX;
@property (nonatomic,assign)BOOL isBindQQ;

@property (nonatomic,strong)NSString *WXimageUrl;
@property (nonatomic,strong)NSString *WXNickName;

@property (nonatomic,strong)NSString *QQimageUrl;
@property (nonatomic,strong)NSString *QQNickName;

@property (nonatomic,strong)NSString *toQianshouNum;//待签收
@property (nonatomic,strong)NSString *toReceiveNum;//待归还
@property (nonatomic,strong)NSString *toPayNum;//待付款
@property (nonatomic,strong)NSString *balance;//余额
@property (nonatomic,strong)NSString *couponsNumber;//卡券数量

//根据计算得出用户尺码
@property (nonatomic,assign)UserSize userSize;//用户的尺码大小

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
