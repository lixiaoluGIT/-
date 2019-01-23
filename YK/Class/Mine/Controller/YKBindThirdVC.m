//
//  YKBindThirdVC.m
//  YK
//
//  Created by edz on 2019/1/4.
//  Copyright © 2019 YK. All rights reserved.
//

#import "YKBindThirdVC.h"

@interface YKBindThirdVC ()<DXAlertViewDelegate>
{
    BOOL isLogining;
}
@end

@implementation YKBindThirdVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
//     [UD setBool:NO forKey:@"wxisLogining"];
//     [UD setBool:NO forKey:@"qqisLogining"];
    isLogining  = NO;
    [self.view removeAllSubviews];
    [self setUpUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:@"wechatDidLoginNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TencentDidLoginNotification:) name:@"TencentDidLoginNotification" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.title = @"绑定信息";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"333333"];
    title.font = PingFangSC_Medium(15);
    self.navigationItem.titleView = title;
    
//    [self setUpUI];
}

- (void)leftAction{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpUI{
    for (int i=0; i<2; i++) {
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.frame = CGRectMake(0,BarH + kSuitLength_H(76)*i, WIDHT, kSuitLength_H(76));
        [self.view addSubview:backView];
        
        UIImageView *image = [[UIImageView alloc]init];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = kSuitLength_H(46)/2;
        
        
        [backView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSuitLength_H(20));
            make.top.mas_equalTo(kSuitLength_H(15));
            make.width.height.mas_equalTo(kSuitLength_H(46));
        }];
        
        UILabel *name = [[UILabel alloc]init];
        name.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.nickname];
        name.textColor = mainColor;
        name.font = PingFangSC_Regular(kSuitLength_H(14));
        [backView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(image.mas_centerY);
            make.left.mas_equalTo(image.mas_right).offset(kSuitLength_H(11));
        }];
        
        
        
        UIImageView *rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
        [backView addSubview:rightImage];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(20));
            make.centerY.mas_equalTo(backView.mas_centerY);
        }];
        
        UILabel *actionLable = [[UILabel alloc]init];
        actionLable.text = @"去绑定";
        actionLable.textColor = mainColor;
        actionLable.font = PingFangSC_Medium(kSuitLength_H(14));
        [backView addSubview:actionLable];
        [actionLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(backView.mas_centerY);
            make.right.mas_equalTo(rightImage.mas_left).offset(-kSuitLength_H(7));
        }];
        
        if (i==0) {
            [image sd_setImageWithURL:[NSURL URLWithString:[YKUserManager sharedManager].user.WXimageUrl] placeholderImage:[UIImage imageNamed:@"Group 9"]];
            
            if ([YKUserManager sharedManager].user.isBingWX) {
                name.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.WXNickName];
                actionLable.text = @"去解绑";
            }else {
                name.text = @"微信账号绑定";
                actionLable.text = @"去绑定";
            }
        }
        
        if (i==1) {
            [image sd_setImageWithURL:[NSURL URLWithString:[YKUserManager sharedManager].user.QQimageUrl] placeholderImage:[UIImage imageNamed:@"Group 10"]];
            
            if ([YKUserManager sharedManager].user.isBindQQ) {
                name.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.QQNickName];
                actionLable.text = @"去解绑";
            }else {
                name.text = @"QQ账号绑定";
                actionLable.text = @"去绑定";
            }
        }
        
        [backView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            isLogining = NO;
            if (i==0) {
                if ([YKUserManager sharedManager].user.isBingWX) {
                    //去解绑微信
                    NSLog(@"1");
                    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"确定要与昵称为%@的微信账号解除绑定吗？",[YKUserManager sharedManager].user.WXNickName] cancelBtnTitle:@"否" otherBtnTitle:@"是"];
                    aleart.tag = 2;
                    aleart.delegate = self;
                    [aleart show];
                }else {
                    //去绑定微信
                      isLogining = NO;
                    NSLog(@"2");
                    [[YKUserManager sharedManager]loginByWeChatOnResponse:^(NSDictionary *dic) {
                        
                    }];
                }
            }
            
            if (i==1) {
                if ([YKUserManager sharedManager].user.isBindQQ) {
                    //去解绑QQ
                    
                    NSLog(@"3");
                    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"确定要与昵称为%@的qq账号解除绑定吗？",[YKUserManager sharedManager].user.QQNickName] cancelBtnTitle:@"否" otherBtnTitle:@"是"];
                    aleart.tag = 1;
                    aleart.delegate = self;
                    [aleart show];
                }else {
                     isLogining = NO;
                    //去绑定QQ
                    [[YKUserManager sharedManager]loginByTencentOnResponse:^(NSDictionary *dic) {
                        
                    }];
                    NSLog(@"4");
                }
            }
            
        }];
        [backView addGestureRecognizer:tap];
    }
}

//接收微信登录的通知
- (void)wechatDidLoginNotification:(NSNotification *)notify{
    if (isLogining) {
        return;
    }
    isLogining = YES;
     [UD setBool:YES forKey:@"wxisLogining"];
    NSDictionary *dict = [notify userInfo];
    NSLog(@"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    [[YKUserManager sharedManager]getWechatAccessTokenWithCode:dict[@"code"] OnResponse:^(NSDictionary *dic) {
//        isLogining = NO;
        
        [self.view removeAllSubviews];
        [self setUpUI];
        
    }];
};

//接收qq登录成功的通知
- (void)TencentDidLoginNotification:(NSNotification *)notify{
    BOOL i = [UD boolForKey:@"qqisLogining"];
    if (isLogining) {
        return;
    }
    [UD setBool:YES forKey:@"qqisLogining"];
    isLogining = YES;
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:notify.userInfo];
    [[YKUserManager sharedManager]loginSuccessByTencentDic:dic[@"code"] OnResponse:^(NSDictionary *dic) {
        
        [self.view removeAllSubviews];
        [self setUpUI];
      
    }];
}

- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex   {
    if (buttonIndex==1) {
        [[YKUserManager sharedManager]exitWeChatByTencentType:alertView.tag OnResponse:^(NSDictionary *dic) {
              isLogining = NO;
            [self.view removeAllSubviews];
            [self setUpUI];
        }];
    }
}

- (void)dealloc{
    [NC removeObserver:self name:@"wechatDidLoginNotification" object:nil];
    [NC removeObserver:self name:@"TencentDidLoginNotification" object:nil];
}


@end
