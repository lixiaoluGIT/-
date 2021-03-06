//
//  YKBuyOrderVC.m
//  YK
//
//  Created by Macx on 2018/12/26.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBuyOrderVC.h"
#import "YKMineBagCell.h"
#import "YKMineCell.h"
#import "YKSuitCell.h"
#import "YKSMSCell.h"
#import "YKAddressVC.h"
#import "YKSuccessVC.h"
#import "YKAddressDetailCell.h"
#import "YKSuitEnsureCell.h"
#import "YKToBeVIPVC.h"
#import "YKUserAccountVC.h"

#import "YKBuyCashCell.h"
#import "YKBuyTypeCell.h"
#import "YKBuyProductCell.h"
#import "YKOrderSegementVC.h"

@interface YKBuyOrderVC ()<UITableViewDelegate,UITableViewDataSource,DXAlertViewDelegate>{
    BOOL isHadDefaultAddress;
    BOOL hadOnce;
    NSInteger cardType;
    NSInteger aleartId;
    
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)YKAddress *addressM;
@property (nonatomic,assign) payMethod payMethod;

@property (nonatomic,assign) BOOL hadAppear;
//@property (nonatomic,strong)YKOrder *order;
@end

@implementation YKBuyOrderVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //请求默认地址
    [self getDefaultAddress];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alipayres" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpaysuc" object:nil];
}
- (void)getDefaultAddress{
    if (self.addressM) {
        return;
    }
    [[YKAddressManager sharedManager]queryDetaultAddressOnResponse:^(NSDictionary *dic) {
        NSDictionary *address = [NSDictionary dictionaryWithDictionary:dic[@"data"]];
        
        if (address.allKeys.count==0) {
            isHadDefaultAddress = NO;//无默认地址
        }else {
            self.addressM = [YKAddress new];
            [_addressM ininWithDictionary:dic[@"data"]];
            isHadDefaultAddress = YES;//有默认地址
        }
        
        [self.tableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [NC addObserver:self selector:@selector(alipayResult:) name:@"alipayres" object:nil];
    [NC addObserver:self selector:@selector(wxpayresult:) name:@"wxpaysuc" object:nil];
    self.payMethod = 3;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"确认订单";
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-kSuitLength_H(50)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    [self creatbottumView];
}

- (void)creatbottumView{
    UIView *buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, MSH-kSuitLength_H(50), WIDHT, kSuitLength_H(50))];
    buttomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttomView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDHT/2, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [buttomView addSubview:line];
    
    UILabel *lable = [[UILabel alloc]init];
    lable.text = @"实付款：";
    lable.textColor = mainColor;
    lable.font = PingFangSC_Regular(14);
    [buttomView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@20);
        make.centerY.mas_equalTo(buttomView.mas_centerY);
    }];
    
    UILabel *lable2 = [[UILabel alloc]init];
     int p = [self.product[@"clothingPrice"] intValue] * 0.6;
    lable2.text = [NSString stringWithFormat:@"¥%d（免运费）",p];
    lable2.textColor = YKRedColor;
    lable2.font = PingFangSC_Regular(14);
    if (WIDHT==320) {
        lable2.font = PingFangSC_Regular(12);
    }
    [buttomView addSubview:lable2];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lable.mas_right);
        make.centerY.mas_equalTo(buttomView.mas_centerY);
    }];
    
    //付款按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = YKRedColor;
    [btn setTitle:@"立即支付" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font = PingFangSC_Medium(16);
    [btn addTarget:self action:@selector(toPay) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WIDHT/2);
        make.centerY.mas_equalTo(buttomView.mas_centerY);
        make.width.mas_equalTo(WIDHT/2);
        make.height.mas_equalTo(kSuitLength_H(50));
    }];
}

- (void)toPay{
    WeakSelf(weakSelf)
    if (!self.addressM) {
        [smartHUD alertText:kWindow alert:@"请添加收货地址" delay:1.0];
        return;
    }
    if (self.payMethod == 3) {
        [smartHUD alertText:kWindow alert:@"请选择支付方式" delay:1.0];
        return;
    }
    

//春节期间物流提示(2月13----2月23)
if ([steyHelper validateWithStartTime:@"2019-01-26" withExpireTime:@"2019-02-09"]) {
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"平台提示" message:@"小仙女，快递小哥回家过年了，现在下单2月10号以后才可以正常发货哦!" cancelBtnTitle:@"取消" otherBtnTitle:@"继续确认"];
    alertView.tag = 104;
    alertView.delegate = self;
    [alertView show];
    return;
}
 
    NSMutableArray *a = [NSMutableArray array];
    if (self.isFromOrder) {
         [a addObject:self.product[@"clothingStockId"]];
        
        //调起支付
        NSLog(@"调起支付");
        [[YKPayManager sharedManager]payWithPayMethod:self.payMethod orderNo:self.orderNo couponId:0 OnResponse:^(NSDictionary *dic) {
            
        }];
    }else {
         [a addObject:self.product[@"clothingStockDTOS"][0][@"clothingStockId"]];
        
        //创建订单
        [[YKOrderManager sharedManager]creatBuyOrderWithAddress:self.addressM  clothingIdList:a OnResponse:^(NSDictionary *dic) {
            
            if ([dic[@"status"] intValue] == 413) {//存在未付款订单
                [weakSelf showAleart];
                return ;
            }
            
           //调起支付
            NSLog(@"调起支付");
            
            [weakSelf pay:dic[@"orderNo"]];
        }];
    }
   
   
}

- (void)showAleart{
    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"温馨提示" message:@"您当前存在未支付订单，请先支付哦~" cancelBtnTitle:@"取消" otherBtnTitle:@"去支付"];
    aleart.delegate = self;
    aleart.tag = 102;
    [aleart show];
}
- (void)pay:(NSString *)orderId{
    [[YKPayManager sharedManager]payWithPayMethod:self.payMethod orderNo:orderId couponId:0 OnResponse:^(NSDictionary *dic) {
        
    }];
}

- (void)leftAction{
    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"确定要放弃付款吗？" message:@"您尚未完成支付，喜欢的商品可能会被抢空哦～" cancelBtnTitle:@"取消" otherBtnTitle:@"继续支付"];
    aleart.delegate = self;
    aleart.tag = 101;
    [aleart show];
    
}
- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag == 102) {
        if (buttonIndex==1) {
            //调到买衣订单未支付订单
            YKOrderSegementVC *seg = [[YKOrderSegementVC alloc]init];
            seg.isFromOther = YES;
            seg.type = 1;//到买衣
            [YKOrderManager sharedManager].selectIndex = 1;//到未支付订单
            seg.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:seg animated:YES];
        }else {
             [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag == 103) {
        
        //跳到买衣订单未支付订单
        YKOrderSegementVC *seg = [[YKOrderSegementVC alloc]init];
        seg.isFromOther = YES;
        seg.type = 1;//到买衣
        [YKOrderManager sharedManager].selectIndex = 2;//到待签收订单
        seg.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:seg animated:YES];
        
    }
    
    if (alertView.tag == 104) {
        NSMutableArray *a = [NSMutableArray array];
        if (self.isFromOrder) {
            [a addObject:self.product[@"clothingStockId"]];
            
            //调起支付
            NSLog(@"调起支付");
            [[YKPayManager sharedManager]payWithPayMethod:self.payMethod orderNo:self.orderNo couponId:0 OnResponse:^(NSDictionary *dic) {
                
            }];
        }else {
            [a addObject:self.product[@"clothingStockDTOS"][0][@"clothingStockId"]];
            
            //创建订单
            [[YKOrderManager sharedManager]creatBuyOrderWithAddress:self.addressM  clothingIdList:a OnResponse:^(NSDictionary *dic) {
                
                if ([dic[@"status"] intValue] == 413) {//存在未付款订单
                    [self showAleart];
                    return ;
                }
                
                //调起支付
                NSLog(@"调起支付");
                
                [self pay:dic[@"orderNo"]];
            }];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGFLOAT_MIN;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (isHadDefaultAddress) {
            return 105;
        }
        return 64;
    }
    if (indexPath.section==1) {
        return 128;
    }
    if (indexPath.section==2) {
        return 161;
    }
    return 169;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //如果没默认地址.
    if (indexPath.section==0) {
        if (isHadDefaultAddress) {
            static NSString *ID = @"cell";
            YKAddressDetailCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (mycell == nil) {
                mycell = [[NSBundle mainBundle] loadNibNamed:@"YKAddressDetailCell" owner:self options:nil][1];
            }
            mycell.backgroundColor = [UIColor whiteColor];
            mycell.address = self.addressM;
            mycell.selectionStyle = UITableViewCellSelectionStyleNone;
            return mycell;
        }
        static NSString *ID = @"cell";
        YKMineCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMineCell" owner:self options:nil][0];
            mycell.title.text = @"添加一个收获地址";
            mycell.image.image = [UIImage imageNamed:@"address"];
        }
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    }
    if (indexPath.section==1) {//商品
        YKBuyProductCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKBuyProductCell" owner:self options:nil][0];
        }
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        [mycell initWithDictionary:self.product sizeNum:_sizeNum];
        return mycell;
    }
    if (indexPath.section==2) {//支付方式
        YKBuyTypeCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKBuyTypeCell" owner:self options:nil][0];
        }
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        mycell.selectPayBlock = ^(payMethod payMethod) {
            self.payMethod = payMethod;
        };
        return mycell;
    }
    YKBuyCashCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
    if (mycell == nil) {
        mycell = [[NSBundle mainBundle] loadNibNamed:@"YKBuyCashCell" owner:self options:nil][0];
    }
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   
    int p =  [self.product[@"clothingPrice"] intValue] * 0.6;
    
    mycell.price = [NSString stringWithFormat:@"%d",p];
    return mycell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果没默认地址.添加地址
    if (indexPath.section==0) {
        YKAddressVC *address = [YKAddressVC new];
        address.selectAddressBlock = ^(YKAddress *address){
            isHadDefaultAddress = YES;
            self.addressM = address;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:address animated:YES];
    }
}

//支付宝支付结果
-(void)alipayResult:(NSNotification *)notify{
    
    NSDictionary *dict = [notify userInfo];
    if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
        if (!_hadAppear) {
            _hadAppear = YES;
            //完成付费
            DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"支付成功" message:@"该订单支付成功！" cancelBtnTitle:@"这个隐藏" otherBtnTitle:@"查看订单"];
            aleart.delegate = self;
            aleart.tag = 103;
            [aleart show];
        }
        
    }else if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"6001"]) {
        
        [smartHUD alertText:self.view alert:@"支付失败" delay:1.5];
        
    }else{
        
        
    }
}

//微信支付结果
-(void)wxpayresult:(NSNotification *)notify{
    
    NSDictionary *dict = [notify userInfo];
    
    if ([[dict objectForKey:@"codeid"]integerValue]==0) {
        
        if (!_hadAppear) {
            _hadAppear = YES;
            //完成付费
            DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"支付成功" message:@"该订单支付成功！" cancelBtnTitle:@"这个隐藏" otherBtnTitle:@"查看订单"];
            aleart.delegate = self;
            aleart.tag = 103;
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [smartHUD  Hide];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [aleart show];
                    
                });
                
            });
           
        }
      
        
    }else{
        
        [smartHUD alertText:self.view alert:@"支付失败" delay:1.5];
        
    }
}

@end
