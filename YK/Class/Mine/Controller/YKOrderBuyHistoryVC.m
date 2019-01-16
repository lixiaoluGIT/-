//
//  YKOrderBuyHistoryVC.m
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//

#import "YKOrderBuyHistoryVC.h"
#import "CBHeaderChooseViewScrollView.h"
#import "YKBuyOrderCell.h"
#import "YKProductDetailVC.h"
#import "YKOrderDetailVC.h"
#import "YKBuyOrderVC.h"
#import "YKSMSInforVC.h"
#import "YKSelectPayView.h"

@interface YKOrderBuyHistoryVC ()<UITableViewDelegate,UITableViewDataSource,DXAlertViewDelegate>
{
    YKNoDataView *NoDataView;
    NSInteger seletedIndex;
    NSInteger currentOrderId;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *orderList;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)YKSelectPayView *payView;
@property (nonatomic,strong)NSString *orderId;
@end

@implementation YKOrderBuyHistoryVC

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [YKOrderManager sharedManager].selectIndex = 0;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.layer.shadowColor = [UIColor clearColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    self.navigationController.navigationBar.layer.shadowRadius = 2.f;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(2,0);
    
//    [self searchOrder:seletedIndex];
    if ([YKOrderManager sharedManager].selectIndex == 1) {//待付款
        seletedIndex = 1;
    }
    if ([YKOrderManager sharedManager].selectIndex == 2) {//待签收
        seletedIndex = 2;
    }
    
    [self searchOrder:seletedIndex];
}

- (NSArray *)orderList{
    if (!_orderList) {
        _orderList = [NSArray array];
    }
    return _orderList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NC addObserver:self selector:@selector(alipayResultCurrent:) name:@"alipayres" object:nil];
    [NC addObserver:self selector:@selector(wxpayresultCurrent:) name:@"wxpaysuc" object:nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.title = @"历史订单";
    
//    if ([YKOrderManager sharedManager].selectIndex == 1) {
//        seletedIndex = [YKOrderManager sharedManager].selectIndex ;
//    }
//
//    [self searchOrder:seletedIndex];
    if ([YKOrderManager sharedManager].selectIndex == 1) {
        seletedIndex = 1;
    }
    [self setButtons];
    [self creatPayView];
   
}

- (void)creatPayView{
    WeakSelf(weakSelf)
    _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor colorWithHexString:@"000000"];
    _backView.hidden = YES;
    _backView.alpha = 0.5;
    _backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(diss)];
    [_backView addGestureRecognizer:tap];
    [kWindow addSubview:_backView];
    _payView = [[NSBundle mainBundle] loadNibNamed:@"YKSelectPayView" owner:self options:nil][0];
    _payView.frame = CGRectMake(0, HEIGHT, WIDHT, 236);
    _payView.selectPayBlock = ^(payMethod payMethod){
   
        NSLog(@"调起支付");
        [[YKPayManager sharedManager]payWithPayMethod:payMethod orderNo:weakSelf.orderId couponId:0 OnResponse:^(NSDictionary *dic) {
            
        }];
        
    };
    _payView.cancleBlock = ^(void){
        [weakSelf diss];
    };
    [kWindow addSubview:_payView];
}

- (void)diss{
    WeakSelf(weakSelf)
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.payView.frame = CGRectMake(0, HEIGHT, WIDHT, 236);
        weakSelf.backView.alpha = 0;
    }completion:^(BOOL finished) {
        weakSelf.backView.hidden = YES;
        [weakSelf.backView removeFromSuperview];
        [weakSelf.payView removeFromSuperview];
    }];
}

- (void)setButtons{
    WeakSelf(weakSelf)
    NSArray *array=@[
                     @"全部",
                     @"待付款",
                     @"待发货",
                     @"待签收",
                     @"已完成",
                     @"已取消",
                    ];
    
    CBHeaderChooseViewScrollView*headerView=[[CBHeaderChooseViewScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, kSuitLength_H(50))];
    
    [self.view addSubview:headerView];
    
    [headerView setUpTitleArray:array titleColor:[UIColor colorWithHexString:@"999999"] titleSelectedColor:YKRedColor titleFontSize:kSuitLength_H(14)];
//    headerView.selectIndex = [YKOrderManager sharedManager].selectIndex;
    headerView.btnChooseClickReturn = ^(NSInteger x) {
        seletedIndex = x;
        [weakSelf searchOrder:seletedIndex];
    };
    
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSuitLength_H(50), WIDHT, HEIGHT-kSuitLength_H(150)) style:UITableViewStylePlain];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(kSuitLength_H(0), kSuitLength_H(50), WIDHT, HEIGHT-64-kSuitLength_H(50)-kSuitLength_H(38)) style:UITableViewStylePlain];
    if (HEIGHT==812) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(kSuitLength_H(0), kSuitLength_H(50), WIDHT, HEIGHT-104-kSuitLength_H(50)-kSuitLength_H(38)) style:UITableViewStylePlain];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.estimatedRowHeight = 140;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setShowsVerticalScrollIndicator:NO];
     [self.tableView registerClass:[YKBuyOrderCell class] forCellReuseIdentifier:@"cell"];
//    self.tableView.bottom = self.view.bottom;
    [self.view addSubview:self.tableView];
    
    if (WIDHT!=320) {
        NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
        [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"暂无订单111"] statusDes:@"暂无订单" hiddenBtn:YES actionTitle:@"" actionBlock:^{
            
        }];
    }
    NoDataView.frame = CGRectMake(0, HEIGHT/4, WIDHT,HEIGHT-212);
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    NoDataView.backgroundColor = self.view.backgroundColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:NoDataView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf(weakSelf)
    YKBuyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    [cell initWithDic:self.orderList[indexPath.row]];
    cell.dic = self.orderList[indexPath.row];
    //按钮的点击
    cell.btnActionBlock = ^(BtnActionType actionType,NSString *orderId,NSString *clothingId,NSString *clothingName) {
        currentOrderId = [orderId intValue];
        self.orderId = orderId;
        switch (actionType) {
            case cancleOrder://取消订单
                [weakSelf cancleOrder:orderId];
                break;
            case paySoon://立即支付
                [self toPay:self.orderList[indexPath.row]];
                break;
            case toScanSMSInfor://查看物流
                [self scanSMSInfor:orderId];
                break;
            case ensureReceive://确认收货
                [weakSelf ensureRecevie:weakSelf.orderId];
                break;
            case buyAgain://再次购买
                [weakSelf toProductDetailclothingId:clothingId title:clothingName];
                break;
                
            default:
                break;
        }
    };
    
    //到订单详情
    cell.toDetail = ^(NSString * _Nonnull orderId) {
        YKOrderDetailVC *order = [[YKOrderDetailVC alloc]init];
        order.orderId = orderId;
        [self.navigationController pushViewController:order animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSuitLength_H(183)+10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //到商品详情
    YKBuyOrderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    YKProductDetailVC  *detail = [[YKProductDetailVC alloc]init];
    detail.canBuy = YES;
    detail.productId = cell.clothingId;
    detail.titleStr = cell.clothingName;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)searchOrder:(NSInteger)orderState{
    [YKOrderManager sharedManager].selectIndex = 0;
    [[YKOrderManager sharedManager]searchBuyOrderWithOrderStatus:orderState OnResponse:^(NSArray *array) {
//         array=(NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
        NSLog(@"订单状态===%ld",(long)orderState);
        if (array.count==0) {//无订单
            self.tableView.hidden = YES;
            NoDataView.hidden = NO;
        }else {
            self.tableView.hidden = NO;
            NoDataView.hidden = YES;
            self.orderList = [NSArray arrayWithArray:array];
            [self.tableView reloadData];
        }
    }];
}

- (void)cancleOrder:(NSString *)orderId{
    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"温馨提示" message:@"确定要取消当前未支付订单吗？" cancelBtnTitle:@"再等等" otherBtnTitle:@"取消"];
    aleart.tag = 101;
    aleart.delegate = self;
    [aleart show];
}

- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView.tag == 101) {//取消订单
            [[YKOrderManager sharedManager]cancleBuyOrderWithOrderId:self.orderId type:1 OnResponse:^(NSArray *array) {
                [self searchOrder:seletedIndex];
            }];
        }
        
        if (alertView.tag == 102) {//确认收货
            [[YKOrderManager sharedManager]cancleBuyOrderWithOrderId:self.orderId type:2 OnResponse:^(NSArray *array) {
                [self searchOrder:seletedIndex];
            }];
        }
    }
}

- (void)toProductDetailclothingId:(NSString *)clothingId title:(NSString *)title{
    YKProductDetailVC  *detail = [[YKProductDetailVC alloc]init];
    detail.canBuy = YES;
    detail.productId = clothingId;
    detail.titleS = title;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)toPay:(NSDictionary *)dic{
    [self creatPayView];
    //弹出选择支付方式
    WeakSelf(weakSelf)
    weakSelf.backView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.payView.frame = CGRectMake(0, HEIGHT-236, WIDHT, 236);
        weakSelf.backView.alpha = 0.5;
    }completion:^(BOOL finished) {
        
    }];
}

//查看物流
- (void)scanSMSInfor:(NSString *)orderId{
    YKSMSInforVC *sms = [YKSMSInforVC new];
    sms.isFromeSF = YES;
    sms.orderNo = orderId;
    [self.navigationController pushViewController:sms animated:YES];
}

//确认收货
- (void)ensureRecevie:(NSString *)orderId{
    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"温馨提示" message:@"您是否确认已收到衣袋？" cancelBtnTitle:@"还没收到" otherBtnTitle:@"已签收"];
    aleart.tag = 102;
    aleart.delegate = self;
    [aleart show];
}

//支付宝支付结果
-(void)alipayResultCurrent:(NSNotification *)notify{
    
    NSDictionary *dict = [notify userInfo];
    if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
        [smartHUD alertText:self.view alert:@"支付成功" delay:1.5];
         [self diss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [smartHUD  Hide];
           
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self searchOrder:seletedIndex];
                
            });
            
        });
        
        
    }else if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"6001"]) {
        
        [smartHUD alertText:self.view alert:@"支付失败" delay:1.5];
        
    }else{
        
        
    }
}

//微信支付结果
-(void)wxpayresultCurrent:(NSNotification *)notify{
    
    NSDictionary *dict = [notify userInfo];
    
    if ([[dict objectForKey:@"codeid"]integerValue]==0) {
        [smartHUD alertText:self.view alert:@"支付成功" delay:1.5];
        [self diss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [smartHUD  Hide];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self searchOrder:seletedIndex];
                
            });
            
        });
        
    }else{
        
        [smartHUD alertText:self.view alert:@"支付失败" delay:1.5];
        
    }
}
@end
