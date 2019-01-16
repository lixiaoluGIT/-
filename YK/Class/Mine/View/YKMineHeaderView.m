//
//  YKMineHeaderView.m
//  YK
//
//  Created by edz on 2019/1/7.
//  Copyright © 2019 YK. All rights reserved.
//

#import "YKMineHeaderView.h"
@interface YKMineHeaderView()
//三个小红点
@property (nonatomic,strong)UILabel *l1;
@property (nonatomic,strong)UILabel *l2;
@property (nonatomic,strong)UILabel *l3;
//已登录的显示
@property (nonatomic,strong)UIImageView *headImage;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *set;
@property (nonatomic,strong)UIImageView *jiantou;

@property (nonatomic,strong)UILabel *vip;
@property (nonatomic,strong)UILabel *quanyi;
@property (nonatomic,strong)UIImageView *jiantou1;

@property (nonatomic,strong)UILabel *ye;
@property (nonatomic,strong)UILabel *yeDes;
@property (nonatomic,strong)UILabel *line;
@property (nonatomic,strong)UILabel *kj;
@property (nonatomic,strong)UILabel *kjDes;
//未登录的显示
@property (nonatomic,strong)UILabel *unLo;
@property (nonatomic,strong)UIImageView *unLojiantou;
@property (nonatomic,strong)UILabel *unLogin;
@property (nonatomic,strong)UIImageView *unLoginjiantou;

@property (nonatomic,strong)UIImageView *vipImage;
@end

@implementation YKMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        [self setUpUI];
        
    }
    return self;
}

//布局
- (void)setUpUI{
    
    self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    //红色背景
    UIView *backView1 = [[UIView alloc]init];
    backView1.backgroundColor = YKRedColor;
    [self addSubview:backView1];
    [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-100000);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(100000);
    }];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = YKRedColor;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(kSuitLength_H(220));
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 1;
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(220));
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    
    //touxiang
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"touxianghuancun"];
    image.backgroundColor = [UIColor whiteColor];
    image.layer.masksToBounds = YES;
    image.layer.cornerRadius = kSuitLength_H(68)/2;
    [backView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSuitLength_H(50));
        make.left.mas_equalTo(kSuitLength_H(16));
        make.width.height.mas_equalTo(kSuitLength_H(68));
    }];
    self.headImage = image;
    
    
    //yonghuming
    UILabel *name = [[UILabel alloc]init];
    name.text = @"用户名";
    name.font = PingFangSC_Medium(kSuitLength_H(16));
    name.textColor = [UIColor whiteColor];
    [backView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(image.mas_top).offset(kSuitLength_H(10));
        make.left.mas_equalTo(image.mas_right).offset(kSuitLength_H(14));
    }];
    self.name = name;
    
    //genggai shezhi
    UILabel *set = [[UILabel alloc]init];
    set.text = @"更改用户信息";
    set.font = PingFangSC_Regular(kSuitLength_H(12));
    set.textColor = [UIColor whiteColor];
    [backView addSubview:set];
    [set mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(name.mas_bottom).offset(kSuitLength_H(9));
        make.left.mas_equalTo(image.mas_right).offset(kSuitLength_H(14));
    }];
    self.set = set;
    
    //jiantou
    UIImageView *jiantou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:    @"白右-2 copy 4"]];
    [backView addSubview:jiantou];
    [jiantou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(set.mas_centerY);
        make.left.mas_equalTo(set.mas_right).offset(kSuitLength_H(5));
    }];
    self.jiantou = jiantou;
    
    //genggai shezhi
    UILabel *unLo = [[UILabel alloc]init];
    unLo.text = @"立即登录";
    unLo.font = PingFangSC_Medium(kSuitLength_H(14));
    unLo.textColor = [UIColor whiteColor];
    [backView addSubview:unLo];
    [unLo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(image.mas_centerY);
        make.left.mas_equalTo(image.mas_right).offset(kSuitLength_H(14));
    }];
    self.unLo = unLo;
    
    //jiantou
    UIImageView *jiantou4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:    @"白右-2 copy 4"]];
    [backView addSubview:jiantou4];
    [jiantou4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(unLo.mas_centerY);
        make.left.mas_equalTo(unLo.mas_right).offset(kSuitLength_H(5));
    }];
    self.unLojiantou  = jiantou4;
    
    //you bian banyuan
    UIView *rightView = [[UIView alloc]init];
    [backView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(image.mas_centerY);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kSuitLength_H(115));
        make.height.mas_equalTo(kSuitLength_H(50));
    }];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    btn2.frame = CGRectMake(0, 0, kSuitLength_H(125), kSuitLength_H(50));
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:btn2];
    
    //beijingtu
    UIImageView *i = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Rectangle 10"]];
    [rightView addSubview:i];
    [i mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kSuitLength_H(0));
        make.width.mas_equalTo(rightView.mas_width);
        make.height.mas_equalTo(rightView.mas_height);
    }];
    
    //huangguantu
    UIImageView *i2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"会员"]];
    [rightView addSubview:i2];
    [i2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(11));
        make.centerY.mas_equalTo(rightView.mas_centerY);
    }];
    self.vipImage = i2;
    
    //huiyuanzhonglei
    UILabel *cardType = [[UILabel alloc]init];
    cardType.text = @"月卡会员";
    cardType.font = PingFangSC_Regular(kSuitLength_H(14));
    cardType.textColor = mainColor;
    [rightView addSubview:cardType];
    [cardType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(i2.mas_right).offset(kSuitLength_H(6));
        make.top.mas_equalTo(kSuitLength_H(6));
    }];
    self.vip = cardType;
    //zhuanshuquanyi
    UILabel *zs = [[UILabel alloc]init];
    zs.text = @"专属权益";
    zs.font = PingFangSC_Regular(kSuitLength_H(12));
    zs.textColor = mainColor;
    [rightView addSubview:zs];
    [zs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(i2.mas_right).offset(kSuitLength_H(6));
        make.top.mas_equalTo(cardType.mas_bottom);
    }];
    self.quanyi = zs;
    
    //jianou 2
    UIImageView *jiantou2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:    @"右-2 尺码详情"]];
    [rightView addSubview:jiantou2];
    [jiantou2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(zs.mas_centerY);
        make.left.mas_equalTo(zs.mas_right).offset(kSuitLength_H(5));
    }];
    self.jiantou1  = jiantou2;
    
    //未登录文字
    UILabel *unLogin = [[UILabel alloc]init];
    unLogin.text = @"成为会员";
    unLogin.font = PingFangSC_Regular(kSuitLength_H(12));
    unLogin.textColor = mainColor;
    [rightView addSubview:unLogin];
    [unLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(i2.mas_right).offset(kSuitLength_H(6));
        make.centerY.mas_equalTo(i2.mas_centerY);
    }];
    self.unLogin = unLogin;
    
    //jianou 2
    UIImageView *jiantou3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:    @"右-2 尺码详情"]];
    [rightView addSubview:jiantou3];
    [jiantou3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(unLogin.mas_centerY);
        make.left.mas_equalTo(unLogin.mas_right).offset(kSuitLength_H(5));
    }];
    self.unLoginjiantou = jiantou3;
    
    //yuer
    UILabel *ye = [[UILabel alloc]init];
    ye.text = [YKUserManager sharedManager].user.balance;;
    ye.font = PingFangSC_Semibold(kSuitLength_H(14));
    ye.textColor = [UIColor whiteColor];
    ye.textAlignment = NSTextAlignmentCenter;
    ye.frame = CGRectMake(0, kSuitLength_H(136), WIDHT/2, kSuitLength_H(20));
    [backView addSubview:ye];
    self.ye = ye;

    //yuer
    UILabel *yeDes = [[UILabel alloc]init];
    yeDes.text = @"余额";
    yeDes.font = PingFangSC_Semibold(kSuitLength_H(14));
    yeDes.textColor = [UIColor whiteColor];
    yeDes.textAlignment = NSTextAlignmentCenter;
    yeDes.frame = CGRectMake(0, ye.bottom + kSuitLength_H(2), WIDHT/2, kSuitLength_H(20));
    [backView addSubview:yeDes];
    self.yeDes = yeDes;
    
    //xian
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor whiteColor];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(image.mas_bottom).offset(kSuitLength_H(29));
        make.centerX.mas_equalTo(backView.centerX);
        make.height.mas_equalTo(kSuitLength_H(18));
        make.width.mas_equalTo(@1);
    }];
    self.line = line;
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.tag = 3;
//    btn3.backgroundColor = [UIColor greenColor];
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn3.frame = CGRectMake(0, kSuitLength_H(136), WIDHT/2, kSuitLength_H(50));
    [backView addSubview:btn3];
    
    //yuer
    UILabel *kj = [[UILabel alloc]init];
    kj.text = [YKUserManager sharedManager].user.couponsNumber;
    kj.font = PingFangSC_Semibold(kSuitLength_H(14));
    kj.textColor = [UIColor whiteColor];
    kj.textAlignment = NSTextAlignmentCenter;
    kj.frame = CGRectMake(WIDHT/2, kSuitLength_H(136), WIDHT/2, kSuitLength_H(20));
    [backView addSubview:kj];
    self.kj = kj;

    //yuer
    UILabel *kjDes = [[UILabel alloc]init];
    kjDes.text = @"卡券";
    kjDes.font = PingFangSC_Semibold(kSuitLength_H(14));
    kjDes.textColor = [UIColor whiteColor];
    kjDes.textAlignment = NSTextAlignmentCenter;
    kjDes.frame = CGRectMake(WIDHT/2,kj.bottom + kSuitLength_H(2), WIDHT/2, kSuitLength_H(20));
    [backView addSubview:kjDes];
    self.kjDes = kjDes;
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.tag = 4;
//    btn4.backgroundColor = [UIColor greenColor];
     [btn4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn4.frame = CGRectMake(WIDHT/2, kSuitLength_H(136), WIDHT/2, kSuitLength_H(50));
    [backView addSubview:btn4];

    //wode dingdan
    UIView *orderView = [[UIView alloc]init];
    orderView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    orderView.layer.masksToBounds = NO;
    orderView.layer.cornerRadius = 6;
    orderView.frame = CGRectMake(kSuitLength_H(16),kSuitLength_H(194), WIDHT-kSuitLength_H(16)*2,kSuitLength_H(114));
    [self addSubview:orderView];
    orderView.layer.shadowColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    orderView.layer.shadowOpacity = 0.5f;
    orderView.layer.shadowRadius = 4.f;
    orderView.layer.shadowOffset = CGSizeMake(2,2);
    
    UILabel *orderLable = [[UILabel alloc]init];
    orderLable.text = @"我的订单";
    orderLable.textColor = mainColor;
    orderLable.font = PingFangSC_Medium(kSuitLength_H(14));
    [orderView addSubview:orderLable];
    [orderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(14));
        make.top.mas_equalTo(kSuitLength_H(11));
    }];

    NSArray *images = [NSArray array];
    images = @[@"全部订单",@"待付款-1",@"待签收",@"待归还"];
    NSArray *titles = [NSArray array];
    titles = @[@"全部订单",@"待付款",@"待签收",@"待归还"];
    for (int i=0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(orderView.frame.size.width/4*i, kSuitLength_H(49), orderView.frame.size.width/4, orderView.frame.size.width/4/3*2);
        btn.backgroundColor = [UIColor whiteColor];
         [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        [orderView addSubview:btn];
        
        if (i==1||i==2||i==3) {
            UILabel *l = [[UILabel alloc]init];
            l.frame = CGRectMake(btn.frame.size.width-kSuitLength_H(25), -(kSuitLength_H(11/2)), kSuitLength_H(11), kSuitLength_H(11));
            l.backgroundColor = YKRedColor;
            l.textColor = [UIColor whiteColor];
            //            l.text = [NSString stringWithFormat:@"%d",i];
            if (i==1) {
                l.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.toPayNum];
                if ([[YKUserManager sharedManager].user.toPayNum intValue] == 0) {
                    l.hidden = YES;
                }
                self.l1 = l;
            }
            if (i==2) {
                l.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.toQianshouNum];
                if ([[YKUserManager sharedManager].user.toQianshouNum intValue] == 0) {
                    l.hidden = YES;
                }
                self.l2 = l;
            }
            if (i==3) {
                l.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.toReceiveNum];
                if ([[YKUserManager sharedManager].user.toReceiveNum intValue] == 0) {
                    l.hidden = YES;
                }
                self.l3 = l;
            }
            l.layer.masksToBounds = YES;
            l.layer.cornerRadius=kSuitLength_H(11)/2;
            
            l.textAlignment = NSTextAlignmentCenter;
            l.font = PingFangSC_Regular(kSuitLength_H(7));
            
            
            [btn addSubview:l];
            
            if ([Token length] == 0) {
                l.hidden = YES;
            }
        }

        UIImageView *image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:images[i]];
        [btn addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn.mas_centerX);
            make.top.mas_equalTo(0);
        }];
        
        UILabel *title = [[UILabel alloc]init];
        title.text = titles[i];
        title.textColor = mainColor;
        title.font = PingFangSC_Regular(kSuitLength_H(13));
        [btn addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(image.mas_bottom).offset(kSuitLength_H(10));
            make.centerX.mas_equalTo(btn.mas_centerX);
        }];
        
    }
    
    //邀请好友图片
    UIImageView *invitImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"立即邀请-3"]];
    invitImage.frame = CGRectMake(kSuitLength_H(16), orderView.bottom + kSuitLength_H(10), WIDHT-kSuitLength_H(16)*2, kSuitLength_H(82));
    invitImage.layer.shadowColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    invitImage.layer.shadowOpacity = 0.5f;
    invitImage.layer.shadowRadius = 4.f;
    invitImage.layer.shadowOffset = CGSizeMake(2,2);
    [self addSubview:invitImage];
    
    UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteBtn.frame = CGRectMake(kSuitLength_H(16), orderView.bottom + kSuitLength_H(10), WIDHT-kSuitLength_H(16)*2, kSuitLength_H(82));
    inviteBtn.tag = 400;
    [inviteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:inviteBtn];
    //我的福利
    UIView *flView = [[UIView alloc]init];
    flView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    flView.layer.masksToBounds = NO;
    flView.layer.cornerRadius = 6;
    flView.frame = CGRectMake(kSuitLength_H(16),invitImage.bottom + kSuitLength_H(10), WIDHT-kSuitLength_H(16)*2,kSuitLength_H(114));
    [self addSubview:flView];
    flView.layer.shadowColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    flView.layer.shadowOpacity = 0.5f;
    flView.layer.shadowRadius = 4.f;
    flView.layer.shadowOffset = CGSizeMake(2,2);
 
    
    UILabel *flLable = [[UILabel alloc]init];
    flLable.text = @"我的福利";
    flLable.textColor = mainColor;
    flLable.font = PingFangSC_Medium(kSuitLength_H(14));
    [flView addSubview:flLable];
    [flLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(14));
        make.top.mas_equalTo(kSuitLength_H(11));
    }];
    
    NSArray *images2 = [NSArray array];
    images2 = @[@"兑换卡",@"可购买",@"资金账户"];
    NSArray *titles2 = [NSArray array];
    titles2 = @[@"兑换卡",@"可购买",@"资金账户"];
    for (int i=0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(flView.frame.size.width/4*i, kSuitLength_H(49), flView.frame.size.width/4, flView.frame.size.width/4/3*2);
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 200+i;
        [flView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:images2[i]];
        [btn addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn.mas_centerX);
            make.top.mas_equalTo(0);
        }];
        
        UILabel *title = [[UILabel alloc]init];
        title.text = titles2[i];
        title.textColor = mainColor;
        title.font = PingFangSC_Regular(kSuitLength_H(13));
        [btn addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(image.mas_bottom).offset(kSuitLength_H(10));
            make.centerX.mas_equalTo(btn.mas_centerX);
        }];
        
    }
    
    //我的服务
    UIView *serviceView = [[UIView alloc]init];
    serviceView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    serviceView.layer.masksToBounds = NO;
    serviceView.layer.cornerRadius = 6;
    serviceView.frame = CGRectMake(kSuitLength_H(16),flView.bottom + kSuitLength_H(10), WIDHT-kSuitLength_H(16)*2,kSuitLength_H(114));
    [self addSubview:serviceView];
    serviceView.layer.shadowColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    serviceView.layer.shadowOpacity = 0.5f;
    serviceView.layer.shadowRadius = 4.f;
    serviceView.layer.shadowOffset = CGSizeMake(2,2);
 
    UILabel *serviceLable = [[UILabel alloc]init];
    serviceLable.text = @"我的服务";
    serviceLable.textColor = mainColor;
    serviceLable.font = PingFangSC_Medium(kSuitLength_H(14));
    [serviceView addSubview:serviceLable];
    [serviceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(14));
        make.top.mas_equalTo(kSuitLength_H(11));
    }];
    
    NSArray *images3 = [NSArray array];
    images3 = @[@"客服",@"地址",@"常见问题",@"设置"];
    NSArray *titles3 = [NSArray array];
    titles3 = @[@"联系客服",@"我的地址",@"常见问题",@"设置"];
    for (int i=0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(flView.frame.size.width/4*i, kSuitLength_H(49), flView.frame.size.width/4, flView.frame.size.width/4/3*2);
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 300+i;
        [serviceView addSubview:btn];
        
         [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:images3[i]];
        [btn addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn.mas_centerX);
            make.top.mas_equalTo(0);
        }];
        
        UILabel *title = [[UILabel alloc]init];
        title.text = titles3[i];
        title.textColor = mainColor;
        title.font = PingFangSC_Regular(kSuitLength_H(13));
        [btn addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(image.mas_bottom).offset(kSuitLength_H(10));
            make.centerX.mas_equalTo(btn.mas_centerX);
        }];
        
    }
    
}

- (void)setUser:(YKUser *)user{
    _user = user;
    
    if ([Token length] == 0) {//未登录
        self.l1.hidden = YES;
        self.l2.hidden = YES;
        self.l3.hidden = YES;
        self.name.hidden = YES;
        self.set.hidden = YES;
        self.jiantou.hidden = YES;
        self.quanyi.hidden = YES;
        self.vip.hidden = YES;
        self.jiantou1.hidden = YES;
        self.ye.hidden = YES;
        self.yeDes.hidden = YES;
        self.line.hidden = YES;
        self.kj.hidden = YES;
        self.kjDes.hidden = YES;
        self.kjDes.hidden = YES;
        self.unLo.hidden = NO;
        self.unLojiantou.hidden = NO;
        self.unLogin.hidden = NO;
        self.unLoginjiantou.hidden = NO;
        self.vipImage.image = [UIImage imageNamed:@"不是会员"];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"touxianghuancun"]];
    }else {//已登录
        self.l1.hidden = NO;
        self.l2.hidden = NO;
        self.l3.hidden = NO;
        self.name.hidden = NO;
        self.set.hidden = NO;
        self.jiantou.hidden = NO;
        self.quanyi.hidden = NO;
        self.vip.hidden = NO;
        self.jiantou1.hidden = NO;
        self.ye.hidden = NO;
        self.yeDes.hidden = NO;
        self.line.hidden = NO;
        self.kj.hidden = NO;
        self.kjDes.hidden = NO;
        self.unLo.hidden = YES;
        self.unLojiantou.hidden = YES;
        self.unLogin.hidden = YES;
        self.unLoginjiantou.hidden = YES;
        self.l1.text =  [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.toPayNum];
        self.l2.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.toQianshouNum];
        self.l3.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.toReceiveNum];
        if ([[YKUserManager sharedManager].user.toPayNum intValue] == 0) {
            self.l1.hidden = YES;
        }
        if ([[YKUserManager sharedManager].user.toQianshouNum intValue] == 0) {
            self.l2.hidden = YES;
        }
        if ([[YKUserManager sharedManager].user.toReceiveNum intValue] == 0) {
            self.l3.hidden = YES;
        }
        
        self.name.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.nickname];
        
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"touxianghuancun"]];
        
        self.VIPStatus = [user.effective integerValue];
        self.ye.text = [YKUserManager sharedManager].user.balance;
        self.kj.text = [YKUserManager sharedManager].user.couponsNumber;
       
        if ([user.cardType intValue] == 0) {
            self.quanyi.hidden = YES;
            self.vip.hidden = YES;
            self.jiantou1.hidden = YES;
            self.unLogin.hidden = NO;
            self.unLoginjiantou.hidden = NO;
        }
        
        if ([user.cardType intValue] == 1) {
//            [_vipBtn setTitle:@"月卡会员" forState:UIControlStateNormal];
//            _cardImage.image = [UIImage imageNamed:@"月卡"];
            self.vip.text = @"月卡会员";
        }
        
        if ([user.cardType intValue] == 2) {
//            [_vipBtn setTitle:@"季卡会员" forState:UIControlStateNormal];
//            _cardImage.image = [UIImage imageNamed:@"季卡-1"];
            self.vip.text = @"季卡会员";
        }
        
        if ([user.cardType intValue] == 3) {
//            [_vipBtn setTitle:@"年卡会员" forState:UIControlStateNormal];
//            _cardImage.image = [UIImage imageNamed:@"年卡-1"];
             self.vip.text = @"年卡会员";
        }
        
        if ([user.cardType intValue] == 4) {
//            [_vipBtn setTitle:@"体验卡" forState:UIControlStateNormal];
//            _cardImage.image = [UIImage imageNamed:@"个人中心000"];
             self.vip.text = @"体验卡";
        }
        
        if ([user.cardType intValue] == 7) {
//            [_vipBtn setTitle:@"兑换卡" forState:UIControlStateNormal];
//            _cardImage.image = [UIImage imageNamed:@"月卡"];
             self.vip.text = @"兑换卡";
        }
        
        if ([user.effective intValue] != 4) {//会员状态,已开通
            self.vipImage.image = [UIImage imageNamed:@"会员"];
        }else {//未开通
             self.vipImage.image = [UIImage imageNamed:@"不是会员"];
            self.quanyi.hidden = YES;
            self.vip.hidden = YES;
            self.jiantou1.hidden = YES;
            self.unLogin.hidden = NO;
            self.unLoginjiantou.hidden = NO;
            
        }
    }
}

- (void)btnClick:(UIButton *)btn{
    if (self.btnClickBlock) {
        self.btnClickBlock(btn.tag,self.VIPStatus);
    }
}
@end
